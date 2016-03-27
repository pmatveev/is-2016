package ru.ifmo.is.manager;

import java.io.IOException;
import java.sql.Types;
import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.data.domain.Page;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.db.entity.Comment;
import ru.ifmo.is.db.entity.Issue;
import ru.ifmo.is.db.entity.IssueProjectTransition;
import ru.ifmo.is.db.entity.IssueStatusTransition;
import ru.ifmo.is.db.service.CommentService;
import ru.ifmo.is.db.service.IssueProjectTransitionService;
import ru.ifmo.is.db.service.IssueService;
import ru.ifmo.is.db.service.IssueStatusTransitionService;
import ru.ifmo.is.db.util.Context;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

public class IssueManager {
	private ApplicationContext ctx;
	
	public IssueManager() {
		ctx = Context.getContext();
	}
	
	public Page<Issue> selectIssuesLike(
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
	
	public Issue selectIssueByIdt(String idt) {
		return ctx.getBean(IssueService.class).selectByIdt(idt);
	}
	
	public List<Comment> selectCommentsByIssueId(Long id) {
		return ctx.getBean(CommentService.class).selectByOpenedIssue(id);
	}

	public List<IssueStatusTransition> selectStatusTransitionsAvailable(
			Long id, String username) {
		return ctx.getBean(IssueStatusTransitionService.class).selectAvailable(
				id, username);
	}

	public List<IssueProjectTransition> selectProjectTransitionsAvailable(
			Long id, String username) {
		return ctx.getBean(IssueProjectTransitionService.class).selectAvailable(
				id, username);
	}
	
	public String createIssue(String creator, String project, String kind,
			String summary, String description) throws IOException {
		Object[] res = new StatementExecutor().call(
				"call new_issue(?, ?, ?, ?, ?, ?)",
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, creator),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, project),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, kind),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, summary),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, description), 
				new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR));
		if (res.length > 0 && res[0] != null && res[0] instanceof String) {
			return (String) res[0];
		}
		return null;
	}

	public String addIssueComment(String creator, String idt, String comment)
			throws IOException {
		Object[] res = new StatementExecutor().call(
				"? = call add_issue_comment(?, ?, ?)",  
				new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, creator),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, idt),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, comment));
		if (res.length > 0 && res[0] != null && res[0] instanceof String) {
			return (String) res[0];
		}
		return null;
	}
	
	public String issueStatusTransit(
			String user,
			String idt,
			String transition,
			String summary,
			String assignee,
			String kind,
			String descr,
			String resol,
			String comment) throws IOException {
		Object[] res = new StatementExecutor().call(
				"call transit_issue(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",  
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, user),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, idt),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, transition),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, summary),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, assignee),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, kind),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, descr),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, resol),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, comment),
				new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR));
		if (res.length > 0 && res[0] != null && res[0] instanceof String) {
			return (String) res[0];
		}
		return null;		
	}
	
	public String issueProjectTransit(String user, String idt,
			String transition, String comment) throws IOException {
		Object[] res = new StatementExecutor().call(
				"call move_issue(?, ?, ?, ?, ?)",  
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, user),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, idt),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, transition),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, comment),
				new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR));
		if (res.length > 0 && res[0] != null && res[0] instanceof String) {
			return (String) res[0];
		}
		return null;	
	}
}
