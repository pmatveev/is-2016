package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.IssueStatusTransition;
import ru.ifmo.is.db.repository.IssueStatusTransitionRepository;
import ru.ifmo.is.db.service.IssueStatusTransitionService;

@Service
public class IssueStatusTransitionServiceImpl implements
		IssueStatusTransitionService {
	@Autowired
	private IssueStatusTransitionRepository issueStatusTransitionRepository;

	@Override
	public List<IssueStatusTransition> selectAvailable(Long issue,
			String username) {
		return issueStatusTransitionRepository.findAvailable(issue, username);
	}
}
