package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.IssueProjectTransition;
import ru.ifmo.is.db.repository.IssueProjectTransitionRepository;
import ru.ifmo.is.db.service.IssueProjectTransitionService;

@Service
public class IssueProjectTransitionServiceImpl implements
		IssueProjectTransitionService {
	@Autowired
	private IssueProjectTransitionRepository issueProjectTransitionRepository;

	@Override
	public List<IssueProjectTransition> selectAvailable(Long issue,
			String username) {
		return issueProjectTransitionRepository.findAvailable(issue, username);
	}
}
