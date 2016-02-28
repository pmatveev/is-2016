package ru.ifmo.is.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ru.ifmo.is.db.entity.Officer;

public interface OfficerRepository  extends JpaRepository<Officer, Long> {
}
