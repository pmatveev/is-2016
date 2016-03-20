package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ru.ifmo.is.db.entity.Officer;
import ru.ifmo.is.db.entity.OfficerGroup;
import ru.ifmo.is.db.repository.OfficerGroupRepository;
import ru.ifmo.is.db.service.OfficerGroupService;

@Service
public class OfficerGroupServiceImpl implements OfficerGroupService {
	@Autowired
	private OfficerGroupRepository officerGroupRepository;

	@Transactional(readOnly = true)
	@Override
	public List<OfficerGroup> selectAll() {
		List<OfficerGroup> res = officerGroupRepository.findAll();
		
		for (OfficerGroup g : res) {
			Hibernate.initialize(g.getGrants());
			for (Officer o : g.getOfficers()) {
				Hibernate.initialize(o.getGrants());
			}
		}
		
		return res;
	}
}
