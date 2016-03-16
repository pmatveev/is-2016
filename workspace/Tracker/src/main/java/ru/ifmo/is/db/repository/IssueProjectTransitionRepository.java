package ru.ifmo.is.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ru.ifmo.is.db.entity.IssueProjectTransition;

public interface IssueProjectTransitionRepository extends
		JpaRepository<IssueProjectTransition, Long> {
	@Query(value = "select * from issue_project_transitions_available "
			+ "where issue_for = :issue_id "
			+ "and available_for_code = :username", nativeQuery = true)
	public List<IssueProjectTransition> findAvailable(
			@Param("issue_id") Long issue, @Param("username") String username);
}