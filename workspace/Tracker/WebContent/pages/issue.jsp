<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	LogManager.log("GET issue.jsp", request);

	String issueKey = (String) request
			.getParameter(Issue.ISSUE_KEY_PARM);

	Issue issue = null;

	// here to retrieve issue detailed information
	if ("SANDBOX-412".equals(issueKey)) {
		issue = new Issue(
				1,
				"SANDBOX-412",
				1,
				"Test admin",
				1,
				"Test admin",
				1,
				"Verification",
				1,
				"Open",
				1,
				"Sandbox testing",
				new Date(2015, 12, 23, 16, 7, 46),
				new Date(2016, 2, 13, 11, 48, 1),
				"Please verify issue details page",
				"Here we have multiline description. <br/>"
						+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
				null);
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><%=issue == null ? "Issue not found" : issue.summary%></title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body>
	<%@ include file="logout.jsp"%>
	<%
		if (issue == null) {
	%>
	<div class="centeredText">
		Issue having key
		<%=issueKey%>
		not found. You may continue with search on the <a
			href="/Tracker/pages/index.jsp">main page</a>.
	</div>
	<%
		} else {
	%>
	<div class="margin15px">
		<%=issue.projectDisplay%> / <%=issue.idt%>
		<h1><%=issue.summary%></h1>
		<h4>Description</h4>
		<div class="margin5px">
			<%=issue.description%>
		</div>
	</div>
	<%
		}
	%>
</body>
</html>