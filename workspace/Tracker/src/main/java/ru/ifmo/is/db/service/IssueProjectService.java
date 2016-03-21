package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.IssueProject;

public interface IssueProjectService {
	public IssueProject selectByCode(String code);
	
	public List<IssueProject> selectAll();

	public List<IssueProject> selectAvailable(String username);
}
