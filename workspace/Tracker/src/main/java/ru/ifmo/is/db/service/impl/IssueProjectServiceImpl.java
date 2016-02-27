package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ru.ifmo.is.db.entity.IssueProject;
import ru.ifmo.is.db.repository.IssueProjectRepository;
import ru.ifmo.is.db.service.IssueProjectService;

@Service
@Transactional
public class IssueProjectServiceImpl implements IssueProjectService {
	@Autowired
	IssueProjectRepository issueProjectRepository;

	@Override
	public List<IssueProject> selectAll() {
		return issueProjectRepository.findAll();
	}

	@Override
	public List<IssueProject> selectAvailable(String username) {
		List<IssueProject> projects = issueProjectRepository.findAvailable(username);
		
		for (IssueProject p : projects) {
			Hibernate.initialize(p.getOwner());
			Hibernate.initialize(p.getStartStatus());
		}
		
		return projects;
	}
}
