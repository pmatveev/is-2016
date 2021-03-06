package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.IssueStatus;
import ru.ifmo.is.db.repository.IssueStatusRepository;
import ru.ifmo.is.db.service.IssueStatusService;

@Service
public class IssueStatusServiceImpl implements IssueStatusService {
	@Autowired
	private IssueStatusRepository issueStatusRepository;

	@Override
	public List<IssueStatus> selectAll() {
		return issueStatusRepository.findAll(new Sort(new Order(Direction.ASC,
				"name")));
	}

	@Override
	public List<IssueStatus> selectUsedByProject(String code) {
		return issueStatusRepository.findUsedByProject(code);
	}

	@Override
	public List<IssueStatus> selectIncByProject(String code) {
		return issueStatusRepository.findIncByProject(code);
	}

	@Override
	public List<IssueStatus> selectAvailableByProject(String code) {
		return issueStatusRepository.findAvailableByProject(code);
	}

}
