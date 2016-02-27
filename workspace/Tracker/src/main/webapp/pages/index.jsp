<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="ru.ifmo.is.db.data.IssueProjectData"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Enumeration"%>
<%@page import="ru.ifmo.is.db.data.IssueStatusData"%>
<%@page import="ru.ifmo.is.db.data.IssueKindData"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.db.data.IssueData"%>
<%@page import="ru.ifmo.is.util.LogLevel"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="ru.ifmo.is.db.data.IssueData"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
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

		String from = request.getParameter(IssueServlet.ISSUE_GET_START_FROM);
		int intFrom = 0;
		if (from != null) {
			try {
		intFrom = Integer.parseInt(from);
			} catch (NumberFormatException e) {
			}
		}
		Pair<IssueData[], Integer> issuesCnt = IssueData.selectLike(
		intFrom, 
		IssueServlet.ISSUE_GET_PAGE_NUMBER, 
		request.getParameter(IssueServlet.ISSUE_GET_BY_KEY),
		request.getParameter(IssueServlet.ISSUE_GET_BY_SUMM),
		request.getParameter(IssueServlet.ISSUE_GET_BY_PROJECT),
		request.getParameter(IssueServlet.ISSUE_GET_BY_KIND),
		request.getParameter(IssueServlet.ISSUE_GET_BY_STATUS),
		request.getParameter(IssueServlet.ISSUE_GET_BY_REPORTER),
		request.getParameter(IssueServlet.ISSUE_GET_BY_ASSIGNEE),
		request.getParameter(IssueServlet.ISSUE_GET_BY_CREATED),
		request.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED));
		
		int totalCount = issuesCnt.second;
		IssueData[] issues = issuesCnt.first;
		IssueKindData[] kinds = IssueKindData.select();
		IssueStatusData[] statuses = IssueStatusData.select();
		IssueProjectData[] projects = IssueProjectData.select();

		SimpleDateFormat dateFormat = new SimpleDateFormat(
		"HH:mm:ss dd.MM.yyyy", Locale.ENGLISH);

		String returnTo = request.getRequestURI() + "?" + Util.nvl(request.getQueryString());
		StringBuilder returnToFrom0 = new StringBuilder(request.getRequestURI() + "?");
		Enumeration<String> parms = request.getParameterNames();

		int p = 0, p0 = 0;
		while (parms.hasMoreElements()) {
			String attr = parms.nextElement();
			
			if (!IssueServlet.ISSUE_GET_START_FROM.equals(attr)) {
		if (p0 > 0) {
			returnToFrom0.append("&");
		}
		p0++;
		returnToFrom0.append(attr + "="
		+ URLEncoder.encode(request.getParameter(attr), "ISO-8859-1"));
			}
		}
		
		if (p0 > 0) {
			returnToFrom0.append("&");
		}
		returnToFrom0.append(IssueServlet.ISSUE_GET_START_FROM).append("=");

		String returnToStr = URLEncoder.encode(returnTo.toString(), "ISO-8859-1");
	%>
	<div class="indexHeader">
		<div class="createIssueButtonDiv">
			<button class="createIssueButton"
				onclick="parent.location = '/Tracker<%=IssueServlet.ISSUE_CREATE%>?<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>'">Create
				issue</button>
		</div>
		<div class="searchInfo">
		<%if (issues.length > 0) {%>
		Showing issues <%=(intFrom + 1)%>-<%=intFrom + issues.length%> of <%=totalCount%>
		<%} else {
			out.println("No issues found");
		}
		%>
		</div>
		<div class="searchInput">
			<input type="submit" class="createIssueButton" 
				value="Apply filter" form="issueFilter"
				name="<%=IssueServlet.ISSUE_SELECT_WEBSERVICE%>"></input>
		</div>
	</div>
	<form id="issueFilter" name="issueFilter"
		action="/Tracker<%=LoginServlet.INDEX_PAGE%>" method="get">
		<div class="issuesTableDiv">
			<table cellpadding="0" cellspacing="0" class="issuesTable">
				<thead>
					<tr>
						<th class="issuesTableProject">Project</th>
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
						<td class="issuesTableProject"><select id="filterProject"
							name="<%=IssueServlet.ISSUE_GET_BY_PROJECT%>"
							class="selectIssueType">
								<option value="">---</option>
								<%
									for (int i = 0; i < projects.length; i++) {
								%>
								<option value="<%=Util.replaceStr(projects[i].code)%>"
									<%=projects[i].code.equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_PROJECT)) ? "selected"
						: ""%>><%=Util.replaceHTML(projects[i].name)%></option>
								<%
									}
								%>
						</select></td>
						<td class="issuesTableKey"><input type="text"
							value="<%=Util.replaceStr(Util.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_KEY)))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_KEY%>" id="filterKey"
							class="inputKey"></td>
						<td class="issuesTableName"><input type="text"
							value="<%=Util.replaceStr(Util.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_SUMM)))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_SUMM%>" id="filterName"
							class="inputKey"></td>
						<td class="issuesTableType"><select id="filterType"
							name="<%=IssueServlet.ISSUE_GET_BY_KIND%>"
							class="selectIssueType">
								<option value="">---</option>
								<%
									for (int i = 0; i < kinds.length; i++) {
								%>
								<option value="<%=Util.replaceStr(kinds[i].code)%>"
									<%=kinds[i].code.equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_KIND)) ? "selected"
						: ""%>><%=Util.replaceHTML(kinds[i].name)%></option>
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
								<option value="<%=Util.replaceStr(statuses[i].code)%>"
									<%=statuses[i].code.equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_STATUS)) ? "selected"
						: ""%>><%=Util.replaceHTML(statuses[i].name)%></option>
								<%
									}
								%>
						</select></td>
						<td class="issuesTableReporter"><input type="text"
							value="<%=Util.replaceStr(Util.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_REPORTER)))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_REPORTER%>"
							id="filterReporter" class="inputKey"></td>
						<td class="issuesTableAssignee"><input type="text"
							value="<%=Util.replaceStr(Util.nvl(request
					.getParameter(IssueServlet.ISSUE_GET_BY_ASSIGNEE)))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_ASSIGNEE%>"
							id="filterAssignee" class="inputKey"></td>
						<td class="issuesTableCreated"><select id="dateCreated"
							value="<%=Util.replaceStr(request.getParameter(IssueServlet.ISSUE_GET_BY_CREATED))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_CREATED%>"
							class="selectIssueType">
								<option value="">---</option>
								<option value="1DESC"
									<%="1DESC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Desc Primary</option>
								<option value="1ASC"
									<%="1ASC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Asc Primary</option>
								<option value="2DESC"
									<%="2DESC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Desc Secondary</option>
								<option value="2ASC"
									<%="2ASC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_CREATED)) ? "selected"
					: ""%>>Sort
									Asc Secondary</option>
						</select></td>
						<td class="issuesTableUpdated"><select id="dateUpdated"
							value="<%=Util.replaceStr(request.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED))%>"
							name="<%=IssueServlet.ISSUE_GET_BY_UPDATED%>"
							class="selectIssueType">
								<option value="">---</option>
								<option value="1DESC"
									<%="1DESC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Desc Primary</option>
								<option value="1ASC"
									<%="1ASC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Asc Primary</option>
								<option value="2DESC"
									<%="2DESC".equals(request
					.getParameter(IssueServlet.ISSUE_GET_BY_UPDATED)) ? "selected"
					: ""%>>Sort
									Desc Secondary</option>
								<option value="2ASC"
									<%="2ASC".equals(request
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
						<td class="issuesTableProjectBody"><%=Util.replaceHTML(issues[i].projectDisplay)%></td>
						<td class="issuesTableKeyBody"><a
							href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=Util.replaceStr(issues[i].idt)%>
							&<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>">
								<%=Util.replaceHTML(issues[i].idt)%>
						</a></td>
						<td class="issuesTableNameBody"><a
							href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=Util.replaceStr(issues[i].idt)%>
							&<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>">
								<%=Util.replaceHTML(issues[i].summary)%>
						</a></td>
						<td class="issuesTableTypeBody"><%=Util.replaceHTML(issues[i].kindDisplay)%></td>
						<td class="issuesTableStatusBody"><%=Util.replaceHTML(issues[i].statusDisplay)%></td>
						<td class="issuesTableReporterBody"><%=Util.replaceHTML(issues[i].creatorDisplay)%></td>
						<td class="issuesTableAssigneeBody"><%=Util.replaceHTML(issues[i].assigneeDisplay)%></td>
						<td class="issuesTableCreatedBody"><%=dateFormat.format(issues[i].dateCreated)%></td>
						<td class="issuesTableUpdatedBody"><%=dateFormat.format(issues[i].dateUpdated)%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
			String key = request.getParameter(IssueServlet.ISSUE_GET_BY_KEY);
			if (issues.length == 0 && key != null && !"".equals(key)) {
			%>
			<div class="indexNoIssue">
			Issue having key "<%=Util.replaceHTML(key)%>" not found. Check out
			<a
				href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=Util.replaceStr(key)%>
				&<%=IssueServlet.RETURN_URL%>=<%=returnToStr%>">this page</a>
			to find out if it ever existed.
			</div>
			<%
			}
			%>
			
			<div>
			<%
			if (intFrom > 0) {
			%>
			<div class="indexPrev">
			<a href="<%=returnToFrom0%><%=Math.max(intFrom - IssueServlet.ISSUE_GET_PAGE_NUMBER, 0)%>">Previous</a>
			</div>
			<%
			}
			if (intFrom + issues.length < totalCount) {
			%>
			<div class="indexNext">
			<a href="<%=returnToFrom0%><%=intFrom + IssueServlet.ISSUE_GET_PAGE_NUMBER%>">Next</a>
			</div>
			<%	
			}
			%>
			</div>
		</div>
	</form>
</body>
</html>