package ru.ifmo.is.db.service;

import java.util.List;

import ru.ifmo.is.db.entity.Comment;

public interface CommentService {
	public List<Comment> selectByOpenedIssue(Long issue);
}
