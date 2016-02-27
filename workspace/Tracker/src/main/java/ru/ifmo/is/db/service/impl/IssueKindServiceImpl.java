package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.IssueKind;
import ru.ifmo.is.db.repository.IssueKindRepository;
import ru.ifmo.is.db.service.IssueKindService;

@Service
public class IssueKindServiceImpl implements IssueKindService {
	@Autowired
	private IssueKindRepository issueKindRepository;

	@Override
	public List<IssueKind> selectAll() {
		return issueKindRepository.findAll();
	}

}
