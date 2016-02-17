<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@page import="ru.ifmo.is.util.LogLevel"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	Issue issue = new Issue(1, "SANDBOX-412", "admin", "Test admin", "admin", "Test admin", "VERIFY",
			"Verification", "OPEN", "Open", "SANDBOX", "Sandbox testing", new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1), "Please verify issue details page",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
	Issue[] issues = new Issue[3];
	issues[0] = new Issue(2, "SANDBOX-1", "admin", "Test admin", "admin", "Test admin", "BUG", "Bug", "OPEN",
			"Open", "SANDBOX", "Sandbox testing", new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1), "Please verify issue details page",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
	issues[1] = new Issue(3, "SANDBOX-2", "admin", "Test admin", "admin", "Test admin", "VERIFY",
			"Verification", "OPEN", "Open", "SANDBOX", "Sandbox testing", new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1), "Please verify issue details page",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
	issues[2] = new Issue(4, "SANDBOX-3", "admin", "Test admin", "admin", "Test admin", "VERIFY",
			"Verification", "OPEN", "Open", "SANDBOX", "Sandbox testing", new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1), "Please verify issue details page",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Tracker</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body>
	<%@ include file="logout.jsp"%>
	<%
		LogManager.log("GET index.jsp", request);
	%>
	<div class="createIssue">
		<button class="buttonFixed">Create issue</button>
	</div>
	<div class="issuesTableDiv">
		<table cellpadding="0" cellspacing="0" class="issuesTable">
			<thead>
			<tr>
				<th class="issuesTableKey">Key</th>
				<th class="issuesTableSummary">Summary</th>
				<th class="issuesTableType">Type</th>
				<th class="issuesTableStatus">Status</th>
				<th class="issuesTableReporter">Reporter</th>
				<th class="issuesTableAssignee">Assignee</th>
				<th class="issuesTableCreated">Created</th>
				<th class="issuesTableUpdated">Updated</th>
			</tr>
			<tr>
				<!-- Filters -->
				<td class="issuesTableKey">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableSummary">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableType">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableStatus">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableReporter">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableAssignee">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableCreated">
					<input type="text" class="inputKey">
				</td>
				<td class="issuesTableUpdated">
					<input type="text" class="inputKey">
				</td>
			</tr>
			</thead>
		</table>
	</div>
	index.jsp
	<br />
	<br /> For testing purposes:
	<br />
	<a
		href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=SANDBOX-1">SANDBOX-1</a>
	<br />
	<a
		href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=SANDBOX-412">SANDBOX-412</a>
</body>
</html>