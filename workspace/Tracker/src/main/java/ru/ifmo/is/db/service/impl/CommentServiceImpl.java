package ru.ifmo.is.db.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ru.ifmo.is.db.entity.Comment;
import ru.ifmo.is.db.repository.CommentRepository;
import ru.ifmo.is.db.service.CommentService;

@Service
public class CommentServiceImpl implements CommentService {
	@Autowired
	private CommentRepository commentRepository;

	@Override
	public List<Comment> selectByOpenedIssue(Long issue) {
		return commentRepository.findByOpenedIssue(issue);
	}

}
