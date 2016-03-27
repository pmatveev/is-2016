package ru.ifmo.is.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.IssueManager;
import ru.ifmo.is.manager.LogManager;

@SuppressWarnings("serial")
public class IssueServlet extends HttpServlet {
	// servlet IDT
	public static final String SERVLET_IDT = "/Tracker/issue";

	// pages
	public static final String ISSUE_DETAILS = "/pages/issue.jsp";
	public static final String ISSUE_CREATE = "/pages/createIssue.jsp";

	// services
	public static final String ISSUE_UPDATE_WEBSERVICE = "updateIssueService";
	public static final String ISSUE_COMMENT_WEBSERVICE = "commentIssueService";
	public static final String ISSUE_SELECT_WEBSERVICE = "selectIssueService";
	public static final String ISSUE_CREATE_WEBSERVICE = "createIssueService";

	// in GET parameters
	public static final String ISSUE_GET_KEY_PARM = "issue";
	public static final String ISSUE_GET_START_FROM = "startFrom";
	public static final int ISSUE_GET_PAGE_NUMBER = 5;
	public static final String ISSUE_GET_BY_KEY = "byKey";
	public static final String ISSUE_GET_BY_PROJECT = "byProject";
	public static final String ISSUE_GET_BY_SUMM = "bySumm";
	public static final String ISSUE_GET_BY_KIND = "byKind";
	public static final String ISSUE_GET_BY_STATUS = "byStatus";
	public static final String ISSUE_GET_BY_REPORTER = "byReporter";
	public static final String ISSUE_GET_BY_ASSIGNEE = "byAssignee";
	public static final String ISSUE_GET_BY_CREATED = "byCreated";
	public static final String ISSUE_GET_BY_UPDATED = "byUpdated";

	// in POST parameters
	public static final String ISSUE_SET_PROJECT = "issueProjectSet";
	public static final String ISSUE_SET_KIND = "issueKindSet";
	public static final String ISSUE_SET_STATUS = "issueStatusSet";
	public static final String ISSUE_SET_ASSIGNEE = "issueAssigneeSet";
	public static final String ISSUE_SET_SUMMARY = "issueSummarySet";
	public static final String ISSUE_SET_DESCRIPTION = "issueDescrSet";
	public static final String ISSUE_SET_RESOLUTION = "issueResSet";
	public static final String ISSUE_ADD_COMMENT = "issueAddComment";
	public static final String ISSUE_STATUS_TRANSITION = "issueStatusTransition";
	public static final String ISSUE_PROJECT_TRANSITION = "issueProjectTransition";
	
	// out parameters
	public static final String ISSUE_ERROR = "issueError";

	private void createIssueReturn(HttpServletRequest request,
			HttpServletResponse response, String errMsg) throws IOException {
		request.getSession().setAttribute(ISSUE_CREATE_WEBSERVICE, "error");
		request.getSession().setAttribute(ISSUE_ERROR, errMsg);
		request.getSession().setAttribute(ISSUE_SET_PROJECT,
				request.getParameter(ISSUE_SET_PROJECT));
		request.getSession().setAttribute(ISSUE_SET_KIND,
				request.getParameter(ISSUE_SET_KIND));
		request.getSession().setAttribute(ISSUE_SET_SUMMARY,
				request.getParameter(ISSUE_SET_SUMMARY));
		request.getSession().setAttribute(ISSUE_SET_DESCRIPTION,
				request.getParameter(ISSUE_SET_DESCRIPTION));
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void createIssue(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String creator = (String) request.
				getAttribute(LoginServlet.LOGIN_AUTH_USERNAME);
		String project = request.getParameter(ISSUE_SET_PROJECT);
		String kind = request.getParameter(ISSUE_SET_KIND);
		String summary = request.getParameter(ISSUE_SET_SUMMARY);
		String description = request.getParameter(ISSUE_SET_DESCRIPTION);
		
		String message = null;
		
		try {
			message = new IssueManager().createIssue(creator, project, kind,
					summary, description);
		} catch (IOException e) {
			LogManager.log(e);
			createIssueReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}
		
		if (message == null) {
			createIssueReturn(request, response, "Service failed: no response from DB");
			return;			
		}
		
		if (message.startsWith("E:")) {
			createIssueReturn(request, response, message.substring(2));
			return;				
		}
		
		response.sendRedirect("/Tracker" + ISSUE_DETAILS + "?"
				+ ISSUE_GET_KEY_PARM + "=" + message.substring(2));		
	}


	private void addCommentReturn(HttpServletRequest request,
			HttpServletResponse response, String errMsg) throws IOException {
		request.getSession().setAttribute(ISSUE_COMMENT_WEBSERVICE, "error");
		request.getSession().setAttribute(ISSUE_ADD_COMMENT, 
				request.getParameter(ISSUE_ADD_COMMENT));
		request.getSession().setAttribute(ISSUE_ERROR, errMsg);
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void addComment(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String creator = (String) request.
				getAttribute(LoginServlet.LOGIN_AUTH_USERNAME);
		String idt = request.getParameter(ISSUE_GET_KEY_PARM);
		String comment = request.getParameter(ISSUE_ADD_COMMENT);
		
		String message = null;
		
		try {
			message = new IssueManager().addIssueComment(creator, idt, comment);
		} catch (IOException e) {
			LogManager.log(e);
			addCommentReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}
		
		if (message == null) {
			addCommentReturn(request, response, "Service failed: no response from DB");
			return;			
		}
		
		if (message.startsWith("E:")) {
			addCommentReturn(request, response, message.substring(2));
			return;				
		}
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void issueStatusTransitReturn(HttpServletRequest request, 
			HttpServletResponse response, String errMsg)
			throws ServletException, IOException {
		request.getSession().setAttribute(ISSUE_UPDATE_WEBSERVICE, "error");
		request.getSession().setAttribute(ISSUE_STATUS_TRANSITION, 
				request.getParameter(ISSUE_STATUS_TRANSITION));
		request.getSession().setAttribute(ISSUE_ERROR, errMsg);
		request.getSession().setAttribute(ISSUE_SET_SUMMARY, 
				request.getParameter(ISSUE_SET_SUMMARY));
		request.getSession().setAttribute(ISSUE_SET_ASSIGNEE, 
				request.getParameter(ISSUE_SET_ASSIGNEE));
		request.getSession().setAttribute(ISSUE_SET_KIND, 
				request.getParameter(ISSUE_SET_KIND));
		request.getSession().setAttribute(ISSUE_SET_DESCRIPTION, 
				request.getParameter(ISSUE_SET_DESCRIPTION));
		request.getSession().setAttribute(ISSUE_SET_RESOLUTION, 
				request.getParameter(ISSUE_SET_RESOLUTION));
		request.getSession().setAttribute(ISSUE_ADD_COMMENT, 
				request.getParameter(ISSUE_ADD_COMMENT));
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void issueStatusTransit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String user = (String) request.
				getAttribute(LoginServlet.LOGIN_AUTH_USERNAME);
		String idt = request.getParameter(ISSUE_GET_KEY_PARM);
		String transition = request.getParameter(ISSUE_STATUS_TRANSITION);
		String summary = request.getParameter(ISSUE_SET_SUMMARY);
		String assignee = request.getParameter(ISSUE_SET_ASSIGNEE);
		String kind = request.getParameter(ISSUE_SET_KIND);
		String descr = request.getParameter(ISSUE_SET_DESCRIPTION);
		String resol = request.getParameter(ISSUE_SET_RESOLUTION);
		String comment = request.getParameter(ISSUE_ADD_COMMENT);
		
		String message = null;
		
		try {
			message = new IssueManager().issueStatusTransit(
					user, 
					idt, 
					transition, 
					summary, 
					assignee, 
					kind, 
					descr, 
					resol, 
					comment);
		} catch (IOException e) {
			LogManager.log(e);
			issueStatusTransitReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}
		
		if (message == null) {
			issueStatusTransitReturn(request, response, "Service failed: no response from DB");
			return;			
		}
		
		if (message.startsWith("E:")) {
			issueStatusTransitReturn(request, response, message.substring(2));
			return;				
		}
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void issueProjectTransitReturn(HttpServletRequest request, 
			HttpServletResponse response, String errMsg)
			throws ServletException, IOException {
		request.getSession().setAttribute(ISSUE_UPDATE_WEBSERVICE, "error");
		request.getSession().setAttribute(ISSUE_PROJECT_TRANSITION, 
				request.getParameter(ISSUE_PROJECT_TRANSITION));
		request.getSession().setAttribute(ISSUE_ERROR, errMsg);
		request.getSession().setAttribute(ISSUE_ADD_COMMENT, 
				request.getParameter(ISSUE_ADD_COMMENT));
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void issueProjectTransit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String user = (String) request.
				getAttribute(LoginServlet.LOGIN_AUTH_USERNAME);
		String idt = request.getParameter(ISSUE_GET_KEY_PARM);
		String transition = request.getParameter(ISSUE_PROJECT_TRANSITION);
		String comment = request.getParameter(ISSUE_ADD_COMMENT);
		
		String message = null;
		
		try {
			message = new IssueManager().issueProjectTransit(user, idt, transition, comment);
		} catch (IOException e) {
			LogManager.log(e);
			issueProjectTransitReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}
		
		if (message == null) {
			issueProjectTransitReturn(request, response, "Service failed: no response from DB");
			return;			
		}
		
		if (message.startsWith("E:")) {
			issueProjectTransitReturn(request, response, message.substring(2));
			return;				
		}

		request.getSession().setAttribute(ISSUE_ERROR, "New identifier is " + (message).substring(2));
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("POST IssueServlet", request);

		// verify login information
		if (!new AuthenticationManager().verify(request, response)) {
			return;
		}
		
		if (request.getParameter(ISSUE_CREATE_WEBSERVICE) != null) {
			createIssue(request, response);
			return;
		}
		
		if (request.getParameter(ISSUE_COMMENT_WEBSERVICE) != null) {
			addComment(request, response);
			return;
		}
		
		if (request.getParameter(ISSUE_UPDATE_WEBSERVICE) != null) {
			// status or project transition
			if (request.getParameter(ISSUE_STATUS_TRANSITION) != null) {
				issueStatusTransit(request, response);
				return;
			}

			if (request.getParameter(ISSUE_PROJECT_TRANSITION) != null) {
				issueProjectTransit(request, response);
				return;
			}
		}
		
		String toIssue = request.getParameter(ISSUE_GET_KEY_PARM);
		if (toIssue == null) {
			// redirect to index
			response.sendRedirect("/Tracker" + LoginServlet.INDEX_PAGE);
		} else {
			response.sendRedirect("/Tracker" + ISSUE_DETAILS + "?"
					+ ISSUE_GET_KEY_PARM + "=" + toIssue);
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("GET IssueServlet", request);

		String toIssue = request.getParameter(ISSUE_GET_KEY_PARM);
		if (toIssue == null) {
			response.sendRedirect("/Tracker" + LoginServlet.INDEX_PAGE);
		} else {
			response.sendRedirect("/Tracker" + ISSUE_DETAILS + "?"
					+ ISSUE_GET_KEY_PARM + "=" + toIssue);
		}
	}
}
