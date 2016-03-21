package ru.ifmo.is.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ru.ifmo.is.db.entity.OfficerGroup;

public interface OfficerGroupRepository  extends JpaRepository<OfficerGroup, Long> {
}
