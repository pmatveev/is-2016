<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@page import="ru.ifmo.is.util.LogLevel"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
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
	SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMMM d yyyy, HH:mm:ss", Locale.ENGLISH);
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
		<button class="createIssueButton">Create issue</button>
	</div>
	<div class="searchInput">
		<p class="searchInputP">
			Search <input type="text" size="40">
		</p>
	</div>
	<div class="issuesTableDiv">
		<table cellpadding="0" cellspacing="0" class="issuesTable">
			<thead>
				<tr>
					<th class="issuesTableKey">Key</th>
					<th class="issuesTableName">Name</th>
					<th class="issuesTableType">Type</th>
					<th class="issuesTableStatus">Status</th>
					<th class="issuesTableReporter">Reporter</th>
					<th class="issuesTableAssignee">Assignee</th>
					<th class="issuesTableCreated">Created</th>
					<th class="issuesTableUpdated">Updated</th>
				</tr>
				<tr>
					<!-- Filters -->
					<td class="issuesTableKey"><input type="text" id="filterKey"
						class="inputKey"></td>
					<td class="issuesTableName"><input type="text" id="filterName"
						class="inputKey"></td>
					<td class="issuesTableType"><select id="filterType"
						class="selectIssueType">
							<option value="">---</option>
							<option value="VERIFY">Verification</option>
							<option value="ASSIGN">Assignment</option>
							<option value="BUG">Bug</option>
					</select></td>
					<td class="issuesTableStatus"><select id="filterStatus"
						class="selectIssueType">
							<option value="">---</option>
							<option value="OPEN">Open</option>
							<option value="INPROGRESS">In progress</option>
							<option value="CLOSED">Close</option>
							<option value="REJECTED">Rejected</option>
					</select></td>
					<td class="issuesTableReporter"><input type="text"
						id="filterReporter" class="inputKey"></td>
					<td class="issuesTableAssignee"><input type="text"
						id="filterAssignee" class="inputKey"></td>
					<td class="issuesTableCreated"><input type="datetime"
						id="dateCreated" class="selectIssueType"></td>
					<td class="issuesTableUpdated"><input type="datetime"
						id="dateUpdated" class="selectIssueType"></td>
				</tr>
			</thead>
			<tbody id="issueTableBody">
				<tr>
					<td class="issuesTableKeyBody">
						<a href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=issue.idt%>">
							<%=issue.id%>
						</a>
					</td>
					<td class="issuesTableNameBody">
						<a href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=issue.idt%>">
							<%=issue.idt%>
						</a>
					</td>
					<td class="issuesTableTypeBody"><%=issue.kindDisplay%></td>
					<td class="issuesTableStatusBody"><%=issue.statusDisplay%></td>
					<td class="issuesTableReporterBody"><%=issue.creatorDisplay%></td>
					<td class="issuesTableAssigneeBody"><%=issue.assigneeDisplay%></td>
					<td class="issuesTableCreatedBody"><%=dateFormat.format(issue.dateCreated)%></td>
					<td class="issuesTableUpdatedBody"><%=dateFormat.format(issue.dateUpdated)%></td>
				</tr>
				<%
					for (int i = 0; i < issues.length; i++) {
				%>
				<tr>
					<td class="issuesTableKeyBody">
						<a href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=issues[i].idt%>">
							<%=issues[i].id%>
						</a>
					</td>
					<td class="issuesTableNameBody">
						<a href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=issues[i].idt%>">
							<%=issues[i].idt%>
						</a>
					</td>
					<td class="issuesTableTypeBody"><%=issues[i].kindDisplay%></td>
					<td class="issuesTableStatusBody"><%=issues[i].statusDisplay%></td>
					<td class="issuesTableReporterBody"><%=issues[i].creatorDisplay%></td>
					<td class="issuesTableAssigneeBody"><%=issues[i].assigneeDisplay%></td>
					<td class="issuesTableCreatedBody"><%=dateFormat.format(issues[i].dateCreated)%></td>
					<td class="issuesTableUpdatedBody"><%=dateFormat.format(issues[i].dateUpdated)%></td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>