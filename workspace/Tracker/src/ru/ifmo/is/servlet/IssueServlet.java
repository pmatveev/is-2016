package ru.ifmo.is.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("POST LoginServlet", request);

		// TODO
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
		LogManager.log("GET LoginServlet", request);

		String toIssue = request.getParameter(ISSUE_GET_KEY_PARM);
		if (toIssue == null) {
			response.sendRedirect("/Tracker" + LoginServlet.INDEX_PAGE);
		} else {
			response.sendRedirect("/Tracker" + ISSUE_DETAILS + "?"
					+ ISSUE_GET_KEY_PARM + "=" + toIssue);
		}
	}
}
