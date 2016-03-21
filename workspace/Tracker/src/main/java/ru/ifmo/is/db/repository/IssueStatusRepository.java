package ru.ifmo.is.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ru.ifmo.is.db.entity.IssueStatus;

public interface IssueStatusRepository extends JpaRepository<IssueStatus, Long> {
	@Query(value = "select distinct s.* " +
			"from issue_status s, issue i, issue_project p " +
			"where p.code = :project_code " +
			"and p.is_active = true " +
			"and i.project = p.id " +
			"and i.active = true " +
			"and s.id = i.status " +
			"order by s.name asc",
			nativeQuery = true)
	public List<IssueStatus> findUsedByProject(@Param("project_code") String code);
	
	@Query(value = "select distinct s.* " +
			"from issue_status s, project_transition pt, issue_project p " +
			"where p.code = :project_code " +
			"and p.is_active = true " +
			"and pt.project_to = p.id " +
			"and pt.is_active = true " +
			"and s.id = pt.status_to " +
			"order by s.name asc",
			nativeQuery = true)
	public List<IssueStatus> findIncByProject(@Param("project_code") String code);
	
	@Query(value = "select * from project_statuses " +
			"where project_for = :project_code", 
			nativeQuery = true)
	public List<IssueStatus> findAvailableByProject(@Param("project_code") String code);
}
