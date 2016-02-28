package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.Officer;

public interface OfficerService {
	public List<Officer> selectAll();
}
