package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ru.ifmo.is.db.entity.IssueProject;
import ru.ifmo.is.db.repository.IssueProjectRepository;
import ru.ifmo.is.db.service.IssueProjectService;

@Service
public class IssueProjectServiceImpl implements IssueProjectService {
	@Autowired
	private IssueProjectRepository issueProjectRepository;

	@Override
	@Transactional(readOnly = true)
	public IssueProject selectByCode(String code) {
		IssueProject p = issueProjectRepository.findByCode(code);
		if (p != null) {
			Hibernate.initialize(p.getOwner());
			Hibernate.initialize(p.getStartStatus());
		}
		return p;
	}

	@Override
	public List<IssueProject> selectAll() {
		return issueProjectRepository.findAll(new Sort(new Order(Direction.ASC,
				"name")));
	}

	@Override
	@Transactional(readOnly = true)
	public List<IssueProject> selectAvailable(String username) {
		List<IssueProject> projects = issueProjectRepository
				.findAvailable(username);

		for (IssueProject p : projects) {
			Hibernate.initialize(p.getOwner());
			Hibernate.initialize(p.getStartStatus());
		}

		return projects;
	}
}
