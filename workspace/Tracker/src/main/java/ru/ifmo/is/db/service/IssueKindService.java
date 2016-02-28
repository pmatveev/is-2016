package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.IssueKind;

public interface IssueKindService {
	public List<IssueKind> selectAll();
}
