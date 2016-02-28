package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.Officer;
import ru.ifmo.is.db.repository.OfficerRepository;
import ru.ifmo.is.db.service.OfficerService;

@Service
public class OfficerServiceImpl implements OfficerService {
	@Autowired
	private OfficerRepository officerRepository;

	@Override
	public List<Officer> selectAll() {
		return officerRepository.findAll(new Sort(new Order(Direction.ASC,
				"credentials")));
	}
}
