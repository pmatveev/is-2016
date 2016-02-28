package ru.ifmo.is.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ru.ifmo.is.db.entity.Issue;

public interface IssueRepository extends JpaRepository<Issue, Long>, JpaSpecificationExecutor<Issue> {
	@Query(value = "select * from issue where id = get_issue_by_idt(:idt)",
			nativeQuery = true)
	Issue findActiveByIdt(@Param("idt") String idt);
}
