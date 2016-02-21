package ru.ifmo.is.servlet;

import java.io.IOException;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.LogManager;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

@SuppressWarnings("serial")
public class IssueServlet extends HttpServlet {
	// servlet IDT
	public static final String SERVLET_IDT = "/Tracker/issue";

	// pages
	public static final String ISSUE_DETAILS = "/pages/issue.jsp";
	public static final String ISSUE_CREATE = "/pages/createIssue.jsp";

	// services
	public static final String ISSUE_UPDATE_WEBSERVICE = "updateIssueService";
	public static final String ISSUE_SELECT_WEBSERVICE = "selectIssueService";
	public static final String ISSUE_CREATE_WEBSERVICE = "createIssueService";

	// in GET parameters
	public static final String ISSUE_GET_KEY_PARM = "issue";
	public static final String ISSUE_GET_BY_KEY = "byKey";
	public static final String ISSUE_GET_BY_SUMM = "bySumm";
	public static final String ISSUE_GET_BY_KIND = "byKind";
	public static final String ISSUE_GET_BY_STATUS = "byStatus";
	public static final String ISSUE_GET_BY_REPORTER = "byReporter";
	public static final String ISSUE_GET_BY_ASSIGNEE = "byAssignee";
	public static final String ISSUE_GET_BY_CREATED = "byCreated";
	public static final String ISSUE_GET_BY_UPDATED = "byUpdated";
	public static final String RETURN_URL = "returnURL";

	// in POST parameters
	public static final String ISSUE_SET_PROJECT = "issueProjectSet";
	public static final String ISSUE_SET_KIND = "issueKindSet";
	public static final String ISSUE_SET_STATUS = "issueStatusSet";
	public static final String ISSUE_SET_ASSIGNEE = "issueAssigneeSet";
	public static final String ISSUE_SET_SUMMARY = "issueSummarySet";
	public static final String ISSUE_SET_DESCRIPTION = "issueDescrSet";
	public static final String ISSUE_SET_RESOLUTION = "issueResSet";
	public static final String ISSUE_ADD_COMMENT = "issueAddComment";
	
	// out parameters
	public static final String ISSUE_ERROR = "issueError";

	public static String nvl(String a) {
		return a == null ? "" : a;
	}

	public static String getReturnAddress(HttpServletRequest request) {
		String searchReturnURL = request.getParameter(IssueServlet.RETURN_URL);
		if (searchReturnURL == null) {
			searchReturnURL = "/Tracker" + LoginServlet.INDEX_PAGE;
		}
		return searchReturnURL;
	}

	private void createIssueReturn(HttpServletRequest request,
			HttpServletResponse response, String errMsg) throws IOException {
		request.getSession().setAttribute(ISSUE_ERROR, errMsg);
		request.getSession().setAttribute(ISSUE_SET_PROJECT,
				request.getParameter(ISSUE_SET_PROJECT));
		request.getSession().setAttribute(ISSUE_SET_KIND,
				request.getParameter(ISSUE_SET_KIND));
		request.getSession().setAttribute(ISSUE_SET_SUMMARY,
				request.getParameter(ISSUE_SET_SUMMARY));
		request.getSession().setAttribute(ISSUE_SET_DESCRIPTION,
				request.getParameter(ISSUE_SET_DESCRIPTION));
		
		response.sendRedirect("/Tracker" + ISSUE_CREATE);
	}
	
	private void createIssue(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String creator = (String) request.
				getAttribute(LoginServlet.LOGIN_AUTH_USERNAME);
		String project = request.getParameter(ISSUE_SET_PROJECT);
		String kind = request.getParameter(ISSUE_SET_KIND);
		String summary = request.getParameter(ISSUE_SET_SUMMARY);
		String description = request.getParameter(ISSUE_SET_DESCRIPTION);
		Object[] res = null;
		
		try {
			res = new StatementExecutor().call(
					"? = call new_issue(?, ?, ?, ?, ?)", 
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, creator),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, project),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, kind),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, summary),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, description));
		} catch (IOException e) {
			LogManager.log(e);
			createIssueReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}
		
		if (res.length == 0 || res[0] == null || !(res[0] instanceof String)) {
			createIssueReturn(request, response, "Service failed: no response from DB");
			return;			
		}
		
		String message = (String) res[0];
		if (message.startsWith("E:")) {
			createIssueReturn(request, response, message.substring(2));
			return;				
		}
		
		response.sendRedirect("/Tracker" + ISSUE_DETAILS + "?"
				+ ISSUE_GET_KEY_PARM + "=" + message.substring(2));		
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
