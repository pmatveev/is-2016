package ru.ifmo.is.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ru.ifmo.is.db.entity.IssueStatus;

public interface IssueStatusRepository extends JpaRepository<IssueStatus, Long> {
}
