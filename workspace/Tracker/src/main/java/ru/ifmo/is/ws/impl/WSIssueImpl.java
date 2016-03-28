package ru.ifmo.is.ws.impl;

import java.util.List;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

import ru.ifmo.is.db.entity.Comment;
import ru.ifmo.is.db.entity.Issue;
import ru.ifmo.is.db.entity.IssueProject;
import ru.ifmo.is.db.entity.IssueProjectTransition;
import ru.ifmo.is.db.entity.IssueStatusTransition;
import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.IssueManager;
import ru.ifmo.is.manager.ProjectManager;
import ru.ifmo.is.manager.util.AuthenticationInfo;
import ru.ifmo.is.ws.WSIssue;
import ru.ifmo.is.ws.util.CommentListWrapper;
import ru.ifmo.is.ws.util.ConnectionInfo;
import ru.ifmo.is.ws.util.IssuePageWrapper;
import ru.ifmo.is.ws.util.IssueProjectListWrapper;
import ru.ifmo.is.ws.util.IssueProjectTransitionListWrapper;
import ru.ifmo.is.ws.util.IssueStatusTransitionListWrapper;
import ru.ifmo.is.ws.util.IssueWrapper;
import ru.ifmo.is.ws.util.WSResponse;

@WebService(endpointInterface = "ru.ifmo.is.ws.WSIssue")
public class WSIssueImpl implements WSIssue {
	@Override
	@WebMethod(operationName = "getLike")
	public WSResponse<IssuePageWrapper> getLike(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "from") int from, @WebParam(name = "num") int num,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "summary") String summary,
			@WebParam(name = "project") String project,
			@WebParam(name = "kind") String kind,
			@WebParam(name = "status") String status,
			@WebParam(name = "creator") String creator,
			@WebParam(name = "assignee") String assignee,
			@WebParam(name = "createdOrder") String createdOrder,
			@WebParam(name = "updatedOrder") String updatedOrder) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<IssuePageWrapper>(
						"Authentication failed", null);
			}

			IssuePageWrapper wrapped = new IssuePageWrapper(
					new IssueManager().selectIssuesLike(from, num, idt,
							summary, project, kind, status, creator, assignee,
							createdOrder, updatedOrder));

			return new WSResponse<IssuePageWrapper>(null, wrapped);
		} catch (Throwable e) {
			return new WSResponse<IssuePageWrapper>(e.getMessage(), null);
		}
	}
	
	@Override
	@WebMethod(operationName = "get")
	public WSResponse<IssueWrapper> get(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<IssueWrapper>("Authentication failed",
						null);
			}

			Issue issue = new IssueManager().selectIssueByIdt(idt);

			if (issue == null) {
				return new WSResponse<IssueWrapper>("Issue " + idt
						+ " not found", null);
			}

			return new WSResponse<IssueWrapper>(null, new IssueWrapper(issue));
		} catch (Throwable e) {
			return new WSResponse<IssueWrapper>(e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "getComments")
	public WSResponse<CommentListWrapper> getComments(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "issue-id") Long id) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<CommentListWrapper>(
						"Authentication failed", null);
			}

			List<Comment> comments = new IssueManager()
					.selectCommentsByIssueId(id);

			return new WSResponse<CommentListWrapper>(null, new CommentListWrapper(comments));
		} catch (Throwable e) {
			return new WSResponse<CommentListWrapper>(e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "getAvailableStatusTransitions")
	public WSResponse<IssueStatusTransitionListWrapper> getStatusTransitionsAvailable(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "issue-id") Long id) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<IssueStatusTransitionListWrapper>(
						"Authentication failed", null);
			}

			List<IssueStatusTransition> transitions = new IssueManager()
					.selectStatusTransitionsAvailable(id, auth.getUsername());

			return new WSResponse<IssueStatusTransitionListWrapper>(null,
					new IssueStatusTransitionListWrapper(transitions));
		} catch (Throwable e) {
			return new WSResponse<IssueStatusTransitionListWrapper>(
					e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "getAvailableProjectTransitions")
	public WSResponse<IssueProjectTransitionListWrapper> getProjectTransitionsAvailable(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "issue-id") Long id) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<IssueProjectTransitionListWrapper>(
						"Authentication failed", null);
			}

			List<IssueProjectTransition> transitions = new IssueManager()
					.selectProjectTransitionsAvailable(id, auth.getUsername());

			return new WSResponse<IssueProjectTransitionListWrapper>(null, 
					new IssueProjectTransitionListWrapper(transitions));
		} catch (Throwable e) {
			return new WSResponse<IssueProjectTransitionListWrapper>(
					e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "getAvailableProjects")
	public WSResponse<IssueProjectListWrapper> getProjectsAvailable(
			@WebParam(name = "connection") ConnectionInfo connection) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<IssueProjectListWrapper>(
						"Authentication failed", null);
			}

			List<IssueProject> projects = new ProjectManager()
					.selectAvailableProjects(auth.getUsername());
			
			return new WSResponse<IssueProjectListWrapper>(null, 
					new IssueProjectListWrapper(projects));
		} catch (Throwable e) {
			return new WSResponse<IssueProjectListWrapper>(e.getMessage(), null);
		}
	}	
	
	@Override
	@WebMethod(operationName = "create")
	public WSResponse<String> create(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "creator") String creator,
			@WebParam(name = "project") String project,
			@WebParam(name = "kind") String kind,
			@WebParam(name = "summary") String summary,
			@WebParam(name = "description") String description) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<String>("Authentication failed", null);
			}

			String res = new IssueManager().createIssue(creator, project, kind,
					summary, description);

			if (res == null) {
				return new WSResponse<String>(
						"Service failed: no response from DB", null);
			}

			if (res.startsWith("E:")) {
				return new WSResponse<String>(res.substring(2), null);
			}

			return new WSResponse<String>(null, res.substring(2));
		} catch (Throwable e) {
			return new WSResponse<String>(e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "addIssueComment")
	public WSResponse<Void> addComment(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "comment") String comment) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<Void>("Authentication failed", null);
			}

			String res = new IssueManager().addIssueComment(auth.getUsername(),
					idt, comment);

			if (res == null) {
				return new WSResponse<Void>(
						"Service failed: no response from DB", null);
			}

			if (res.startsWith("E:")) {
				return new WSResponse<Void>(res.substring(2), null);
			}

			return new WSResponse<Void>(null, null);
		} catch (Throwable e) {
			return new WSResponse<Void>(e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "transitIssue")
	public WSResponse<Void> issueStatusTransit(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "transition") String transition,
			@WebParam(name = "summary") String summary,
			@WebParam(name = "assignee") String assignee,
			@WebParam(name = "kind") String kind,
			@WebParam(name = "description") String descr,
			@WebParam(name = "resolution") String resol,
			@WebParam(name = "comment") String comment) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<Void>("Authentication failed", null);
			}

			String res = new IssueManager().issueStatusTransit(
					auth.getUsername(), idt, transition, summary, assignee,
					kind, descr, resol, comment);

			if (res == null) {
				return new WSResponse<Void>(
						"Service failed: no response from DB", null);
			}

			if (res.startsWith("E:")) {
				return new WSResponse<Void>(res.substring(2), null);
			}

			return new WSResponse<Void>(null, null);			
		} catch (Throwable e) {
			return new WSResponse<Void>(e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "moveIssue")
	public WSResponse<String> issueProjectTransit(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "transition") String transition,
			@WebParam(name = "comment") String comment) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());

			if (auth == null) {
				return new WSResponse<String>("Authentication failed", null);
			}
			
			String res = new IssueManager().issueProjectTransit(
					auth.getUsername(), idt, transition, comment);
			
			if (res == null) {
				return new WSResponse<String>(
						"Service failed: no response from DB", null);
			}

			if (res.startsWith("E:")) {
				return new WSResponse<String>(res.substring(2), null);
			}
			
			return new WSResponse<String>(null, res.substring(2));
		} catch (Throwable e) {
			return new WSResponse<String>(e.getMessage(), null);
		}
	}
}
