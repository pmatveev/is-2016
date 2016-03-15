package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.IssueStatus;

public interface IssueStatusService {
	public List<IssueStatus> selectAll();
	
	public List<IssueStatus> selectUsedByProject(String code);
}
