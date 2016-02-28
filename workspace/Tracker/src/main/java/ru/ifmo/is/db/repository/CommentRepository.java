package ru.ifmo.is.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ru.ifmo.is.db.entity.Comment;

public interface CommentRepository extends JpaRepository<Comment, Long> {
	@Query(value = "select * from issue_comments "
			+ "where issue_id = :issue_id order by date_created asc", 
			nativeQuery = true)
	public List<Comment> findByOpenedIssue(@Param("issue_id") Long issue);
}
