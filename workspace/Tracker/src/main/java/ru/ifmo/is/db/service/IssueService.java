package ru.ifmo.is.db.service;

import org.springframework.data.domain.Page;

import ru.ifmo.is.db.entity.Issue;

public interface IssueService {
	public Issue selectByIdt(String idt);
	
	public Page<Issue> selectLike(
			int from,
			int num,
			String idt, 
			String summary, 
			String project,
			String kind, 
			String status, 
			String creator, 
			String assignee,
			String createdOrder,
			String updatedOrder);
}
