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

	// in GET parameters
	public static final String ISSUE_GET_KEY_PARM = "issue";
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("POST LoginServlet", request);
		
		// TODO
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("GET LoginServlet", request);

		String toIssue = request.getParameter(ISSUE_GET_KEY_PARM);
		if (toIssue == null) {
			// redirect to index
			response.sendRedirect("/Tracker" + LoginServlet.INDEX_PAGE);
		} else {
			response.sendRedirect("/Tracker" + ISSUE_DETAILS + "?"
					+ ISSUE_GET_KEY_PARM + "=" + toIssue);
		}
	}
}
