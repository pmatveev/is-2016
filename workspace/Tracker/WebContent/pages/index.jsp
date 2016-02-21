<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Enumeration"%>
<%@page import="ru.ifmo.is.db.data.IssueStatus"%>
<%@page import="ru.ifmo.is.db.data.IssueKind"%>
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
	Issue[] issues = new Issue[4];
	issues[0] = new Issue(
			2,
			"SANDBOX-1",
			"admin",
			"Test admin",
			"admin",
			"Test admin",
			"BUG",
			"Bug",
			"OPEN",
			"Open",
			"SANDBOX",
			"Sandbox testing",
			new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1),
			"Issue with kind of long description that does not fit into index table",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
	issues[1] = new Issue(
			3,
			"SANDBOX-2",
			"admin",
			"Test admin",
			"admin",
			"Test admin",
			"VERIFY",
			"Verification",
			"OPEN",
			"Open",
			"SANDBOX",
			"Sandbox testing",
			new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1),
			"The other issue",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
	issues[2] = new Issue(
			1,
			"SANDBOX-412",
			"admin",
			"Test admin",
			"admin",
			"Test admin",
			"VERIFY",
			"Verification",
			"OPEN",
			"Open",
			"SANDBOX",
			"Sandbox testing",
			new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1),
			"Please verify issue details page",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);
	issues[3] = new Issue(
			4,
			"SANDBOX-3",
			"admin",
			"Test admin",
			"admin",
			"Test admin",
			"VERIFY",
			"Verification",
			"OPEN",
			"Open",
			"SANDBOX",
			"Sandbox testing",
			new Date(115, 11, 23, 16, 7, 46),
			new Date(116, 1, 13, 11, 48, 1),
			"Once more",
			"Here we have multiline description. \n"
					+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
			null);

	IssueKind[] kinds = IssueKind.select();

	IssueStatus[] statuses = new IssueStatus[4];
	statuses[0] = new IssueStatus(1, "OPEN", "Open");
	statuses[1] = new IssueStatus(2, "IN_PROGRESS", "In progress");
	statuses[2] = new IssueStatus(3, "CLOSED", "Closed");
	statuses[3] = new IssueStatus(4, "REJECTED", "Rejected");

	SimpleDateFormat dateFormat = new SimpleDateFormat(
			"EEE, MMMM d yyyy, HH:mm:ss", Locale.ENGLISH);
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
	<%
		StringBuffer returnTo = request.getRequestURL().append("?");
		Enumeration<String> parms = request.getParameterNames();

		int p = 0;
		while (parms.hasMoreElements()) {
			if (p > 0) {
				returnTo.append("&");
			}
			String attr = parms.nextElement();

			returnTo.append(attr + "="
					+ URLEncoder.encode(request.getParameter(attr)));
			p++;
		}

		String returnToStr = URLEncoder.encode(returnTo.toString());
	%>
	<div class="createIssueButtonDiv">
		<button class="createIssueButton"
			onclick="parent.location = '/Tracker<%=IssueServlet.ISSUE_CREATE%>?<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>'">Create
			issue</button>
	</div>
	<form id="issueFilter" name="issueFilter"
		action="/Tracker<%=LoginServlet.INDEX_PAGE%>" method="get">
		<div class="searchInput">
			<input type="submit" class="createIssueButton" value="Apply filter"
				name="<%=IssueServlet.ISSUE_SELECT_WEBSERVICE%>"></input>
		</div>
		<div class="issuesTableDiv">
			<table cellpadding="0" cellspacing="0" class="issuesTable">
				<thead>
					<tr>
						<th class="issuesTableKey">Key</th>
						<th class="issuesTableName">Summary</th>
						<th class="issuesTableType">Type</th>
						<th class="issuesTableStatus">Status</th>
						<th class="issuesTableReporter">Reporter</th>
						<th class="issuesTableAssignee">Assignee</th>
						<th class="issuesTableCreated">Created</th>
						<th class="issuesTableUpdated">Updated</th>
					</tr>
					<tr>
						<!-- Filters -->
						<td class="issuesTableKey"><input type="text"
							value="<%=IssueServlet.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_KEY))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_KEY%>" id="filterKey"
							class="inputKey"></td>
						<td class="issuesTableName"><input type="text"
							value="<%=IssueServlet.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_SUMM))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_SUMM%>" id="filterName"
							class="inputKey"></td>
						<td class="issuesTableType"><select id="filterType"
							name="<%=IssueServlet.ISSUE_GET_BY_KIND%>"
							class="selectIssueType">
								<option value="">---</option>
								<%
									for (int i = 0; i < kinds.length; i++) {
								%>
								<option value="<%=kinds[i].code%>"
									<%=kinds[i].code.equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_KIND)) ? "selected"
						: ""%>><%=kinds[i].name%></option>
								<%
									}
								%>
						</select></td>
						<td class="issuesTableStatus"><select id="filterStatus"
							name="<%=IssueServlet.ISSUE_GET_BY_STATUS%>"
							class="selectIssueType">
								<option value="">---</option>
								<%
									for (int i = 0; i < statuses.length; i++) {
								%>
								<option value="<%=statuses[i].code%>"
									<%=statuses[i].code.equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_STATUS)) ? "selected"
						: ""%>><%=statuses[i].name%></option>
								<%
									}
								%>
						</select></td>
						<td class="issuesTableReporter"><input type="text"
							value="<%=IssueServlet.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_REPORTER))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_REPORTER%>"
							id="filterReporter" class="inputKey"></td>
						<td class="issuesTableAssignee"><input type="text"
							value="<%=IssueServlet.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_ASSIGNEE))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_ASSIGNEE%>"
							id="filterAssignee" class="inputKey"></td>
						<td class="issuesTableCreated"><select id="dateCreated"
							value="<%=request.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)%>"
							name="<%=IssueServlet.ISSUE_GET_BY_CREATED%>"
							class="selectIssueType" onchange="sortOrder(this)">
								<option value="">---</option>
								<option value="DESC1"
									<%="DESC1".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Desc Primary</option>
								<option value="ASC1"
									<%="ASC1".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Asc Primary</option>
								<option value="DESC2"
									<%="DESC2".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Desc Secondary</option>
								<option value="ASC2"
									<%="ASC2".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Asc Secondary</option>
						</select></td>
						<td class="issuesTableUpdated"><select id="dateUpdated"
							value="<%=request.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)%>"
							name="<%=IssueServlet.ISSUE_GET_BY_UPDATED%>"
							class="selectIssueType" onchange="sortOrder(this)">
								<option value="">---</option>
								<option value="DESC1"
									<%="DESC1".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Desc Primary</option>
								<option value="ASC1"
									<%="ASC1".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Asc Primary</option>
								<option value="DESC2"
									<%="DESC2".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Desc Secondary</option>
								<option value="ASC2"
									<%="ASC2".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Asc Secondary</option>
						</select></td>
					</tr>
				</thead>
				<tbody id="issueTableBody">
					<%
						for (int i = 0; i < issues.length; i++) {
					%>
					<tr>
						<td class="issuesTableKeyBody"><a
							href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=issues[i].idt%>&<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>">
								<%=issues[i].idt%>
						</a></td>
						<td class="issuesTableNameBody"><a
							href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=issues[i].idt%>&<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>">
								<%=issues[i].summary%>
						</a></td>
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
	</form>
</body>
</html>