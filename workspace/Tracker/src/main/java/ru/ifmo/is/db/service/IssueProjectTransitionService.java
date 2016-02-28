package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.IssueProjectTransition;

public interface IssueProjectTransitionService {
	public List<IssueProjectTransition> selectAvailable(Long issue, String username);
}
