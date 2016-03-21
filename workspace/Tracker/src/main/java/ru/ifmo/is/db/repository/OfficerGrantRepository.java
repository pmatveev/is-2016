package ru.ifmo.is.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ru.ifmo.is.db.entity.OfficerGrant;

public interface OfficerGrantRepository extends JpaRepository<OfficerGrant, Long> {
}
