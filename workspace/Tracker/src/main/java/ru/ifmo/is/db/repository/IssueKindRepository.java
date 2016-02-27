package ru.ifmo.is.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ru.ifmo.is.db.entity.IssueKind;

public interface IssueKindRepository extends JpaRepository<IssueKind, Long>{
}
