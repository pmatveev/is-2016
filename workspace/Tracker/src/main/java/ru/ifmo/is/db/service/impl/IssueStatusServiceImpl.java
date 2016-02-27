package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
		return issueStatusRepository.findAll();
	}

}
