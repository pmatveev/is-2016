package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.OfficerGrant;
import ru.ifmo.is.db.repository.OfficerGrantRepository;
import ru.ifmo.is.db.service.OfficerGrantService;

@Service
public class OfficerGrantServiceImpl implements OfficerGrantService {
	@Autowired
	private OfficerGrantRepository officerGrantRepository;

	@Override
	public List<OfficerGrant> selectAll() {
		return officerGrantRepository.findAll(new Sort(new Order(Direction.ASC,
				"name")));
	}
}
