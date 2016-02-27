package ru.ifmo.is.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ru.ifmo.is.db.entity.IssueProject;

public interface IssueProjectRepository extends
		JpaRepository<IssueProject, Long> {
	@Query(value = "select pa.* from projects_available pa where available_for_code = :username",
			nativeQuery = true)
	List<IssueProject> findAvailable(@Param("username") String username);
}
