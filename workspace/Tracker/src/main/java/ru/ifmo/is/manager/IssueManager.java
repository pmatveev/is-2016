package ru.ifmo.is.manager;

import org.springframework.context.ApplicationContext;
import org.springframework.data.domain.Page;

import ru.ifmo.is.db.entity.Issue;
import ru.ifmo.is.db.service.IssueService;
import ru.ifmo.is.db.util.Context;

public class IssueManager {
	private ApplicationContext ctx;
	
	public IssueManager() {
		ctx = Context.getContext();
	}
	
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
			String updatedOrder) {
		IssueService issueService = ctx.getBean(IssueService.class);
		return issueService.selectLike(from, num, idt, summary, project, kind,
				status, creator, assignee, createdOrder, updatedOrder);
	}
}
