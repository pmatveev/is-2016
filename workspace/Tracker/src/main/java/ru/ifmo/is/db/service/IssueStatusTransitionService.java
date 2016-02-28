package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.IssueStatusTransition;

public interface IssueStatusTransitionService {
	public List<IssueStatusTransition> selectAvailable(Long issue, String username);
}
