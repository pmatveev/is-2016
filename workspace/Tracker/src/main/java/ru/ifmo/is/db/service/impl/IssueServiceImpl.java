package ru.ifmo.is.db.service.impl;

import java.util.LinkedList;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.Issue;
import ru.ifmo.is.db.entity.IssueKind;
import ru.ifmo.is.db.entity.IssueProject;
import ru.ifmo.is.db.entity.IssueStatus;
import ru.ifmo.is.db.entity.Officer;
import ru.ifmo.is.db.repository.IssueRepository;
import ru.ifmo.is.db.service.IssueService;

@Service
public class IssueServiceImpl implements IssueService {
	@Autowired
	private IssueRepository issueRepository;
	
	public Issue selectByIdt(String idt) {
		return issueRepository.findActiveByIdt(idt);
	}
	
	private String getLikeParm(String parm) {
		if (parm == null || "".equals(parm)) {
			return null;
		} else {
			return "%" + parm.replace("_", "\\_").replace("%", "\\%") + "%";
		}
	}
	
	private Specification<Issue> createSpecification(
			String idt, 
			String summary, 
			String project,
			String kind, 
			String status, 
			String creator, 
			String assignee) {
		final String idtLike = getLikeParm(idt);
		final String summaryLike = getLikeParm(summary);
		final String projectEq = "".equals(project) ? null : project;
		final String kindEq = "".equals(kind) ? null : kind;
		final String statusEq = "".equals(status) ? null : status;
		final String creatorLike = getLikeParm(creator);
		final String assigneeLike = getLikeParm(assignee);
		
		return new Specification<Issue>() {
			@Override
			public Predicate toPredicate(Root<Issue> root, CriteriaQuery<?> query,
					CriteriaBuilder cb) {
				List<Predicate> predicates = new LinkedList<Predicate>();

				if (idtLike != null) {
					predicates.add(cb.like(root.<String>get("idt"), idtLike));
				}
				if (summaryLike != null) {
					predicates.add(cb.like(root.<String>get("summary"), summaryLike));
				}
				if (projectEq != null) {
					predicates.add(cb.equal(root.<IssueProject>get("project").<String>get("code"), projectEq));
				}
				if (kindEq != null) {
					predicates.add(cb.equal(root.<IssueKind>get("kind").<String>get("code"), kindEq));
				}
				if (statusEq != null) {
					predicates.add(cb.equal(root.<IssueStatus>get("status").<String>get("code"), statusEq));
				}
				if (creatorLike != null) {
					predicates.add(cb.like(root.<Officer>get("creator").<String>get("credentials"), creatorLike));
				}
				if (assigneeLike != null) {
					predicates.add(cb.like(root.<Officer>get("assignee").<String>get("credentials"), assigneeLike));
				}
				predicates.add(cb.equal(root.<Boolean>get("active"), true));

				return cb.and(predicates.toArray(new Predicate[0]));
			}
		};
	}
	
	private Pageable createPageRequest(
			int from, 
			int num,
			String createdOrder, 
			String updatedOrder) {
		Sort sort = new Sort(new Order(Direction.ASC, "prevIssue"));
		Sort created = null;
		Sort updated = null;
		if (createdOrder != null && !"".equals(createdOrder)) {
			created = new Sort(new Order(Direction.fromString(createdOrder
					.substring(1)), "dateCreated"));
		}
		if (updatedOrder != null && !"".equals(updatedOrder)) {
			updated = new Sort(new Order(Direction.fromString(updatedOrder
					.substring(1)), "dateUpdated"));
		}
		
		if (created != null && updated != null && createdOrder.charAt(0) == '2'
				&& updatedOrder.charAt(0) == '1') {
			sort = updated.and(created).and(sort);
		} else {
			if (updated != null) {
				sort = updated.and(sort);
			}
			if (created != null) {
				sort = created.and(sort);
			}
		}
		return new PageRequest(from, num, sort);
	}
	
	public Page<Issue> selectLike(
			int from,
			int num,
			String idt, 
			String summary, 
			String project,
			String kind, 
			String status, 
			String creator, 
			String assignee,
			String createdOrder,
			String updatedOrder) {
		return issueRepository.findAll(
				createSpecification(
						idt, 
						summary, 
						project, 
						kind, 
						status, 
						creator, 
						assignee), 
				createPageRequest(
						from, 
						num, 
						createdOrder, 
						updatedOrder));
	}
}
