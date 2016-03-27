<%@page import="ru.ifmo.is.manager.ProjectManager"%>
<%@page import="ru.ifmo.is.manager.IssueManager"%>
<%@page import="ru.ifmo.is.servlet.ProjectServlet"%>
<%@page import="org.springframework.data.domain.Page"%>
<%@page import="ru.ifmo.is.db.entity.Issue"%>
<%@page import="ru.ifmo.is.db.service.IssueService"%>
<%@page import="ru.ifmo.is.db.entity.IssueProject"%>
<%@page import="ru.ifmo.is.db.service.IssueProjectService"%>
<%@page import="ru.ifmo.is.db.service.IssueStatusService"%>
<%@page import="ru.ifmo.is.db.entity.IssueStatus"%>
<%@page import="ru.ifmo.is.db.entity.IssueKind"%>
<%@page import="java.util.List"%>
<%@page import="ru.ifmo.is.db.service.IssueKindService"%>
<%@page import="ru.ifmo.is.db.util.Context"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Enumeration"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.util.LogLevel"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tracker</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body>
	<%@ include file="include/logout.jsp"%>
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
			
			Page<Issue> issuePage = new IssueManager().selectIssuesLike(
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
			
			List<Issue> issues = issuePage.getContent();
			long totalCount = issuePage.getTotalElements();

			ProjectManager projectManager = new ProjectManager();
			List<IssueKind> kinds = projectManager.selectAllKinds();
			List<IssueStatus> statuses = projectManager.selectAllStatuses();
			List<IssueProject> projects = projectManager.selectAllProjects();

			SimpleDateFormat dateFormat = new SimpleDateFormat(
			"HH:mm:ss dd.MM.yyyy", Locale.ENGLISH);

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
			+ URLEncoder.encode(request.getParameter(attr), "UTF-8"));
		}
			}
			
			if (p0 > 0) {
		returnToFrom0.append("&");
			}
			returnToFrom0.append(IssueServlet.ISSUE_GET_START_FROM).append("=");
	%>
	<div class="indexHeader">
		<div class="createIssueButtonDiv">
			<button class="createIssueButton"
				onclick="parent.location = '/Tracker<%=IssueServlet.ISSUE_CREATE%>?<%=LoginServlet.RETURN_URL%>=<%=returnToStr%>'">Create
				issue</button>
		</div>
		<div class="searchInfo">
		<%if (issues.size() > 0) {%>
		Showing issues <%=(intFrom * IssueServlet.ISSUE_GET_PAGE_NUMBER + 1)%>-<%=intFrom * IssueServlet.ISSUE_GET_PAGE_NUMBER + issues.size()%> of <%=totalCount%>
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
									for (int i = 0; i < projects.size(); i++) {
								%>
								<option value="<%=Util.replaceStr(projects.get(i).getCode())%>"
									<%=projects.get(i).getCode().equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_PROJECT)) ? "selected"
						: ""%>><%=Util.replaceHTML(projects.get(i).getName())%></option>
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
									for (int i = 0; i < kinds.size(); i++) {
								%>
								<option value="<%=Util.replaceStr(kinds.get(i).getCode())%>"
									<%=kinds.get(i).getCode().equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_KIND)) ? "selected"
						: ""%>><%=Util.replaceHTML(kinds.get(i).getName())%></option>
								<%
									}
								%>
						</select></td>
						<td class="issuesTableStatus"><select id="filterStatus"
							name="<%=IssueServlet.ISSUE_GET_BY_STATUS%>"
							class="selectIssueType">
								<option value="">---</option>
								<%
									for (int i = 0; i < statuses.size(); i++) {
								%>
								<option value="<%=Util.replaceStr(statuses.get(i).getCode())%>"
									<%=statuses.get(i).getCode().equals(request
						.getParameter(IssueServlet.ISSUE_GET_BY_STATUS)) ? "selected"
						: ""%>><%=Util.replaceHTML(statuses.get(i).getName())%></option>
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
						for (int i = 0; i < issues.size(); i++) {
					%>
					<tr>
						<td class="issuesTableProjectBody">
							<%=Util.replaceHTML(issues.get(i).getProject().getName())%>
						</td>
						<td class="issuesTableKeyBody">
							<a href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=Util.replaceStr(issues.get(i).getIdt())%>
								&<%=LoginServlet.RETURN_URL%>=<%=returnToStr%>">
								<%=Util.replaceHTML(issues.get(i).getIdt())%>
							</a>
						</td>
						<td class="issuesTableNameBody"><a
							href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=Util.replaceStr(issues.get(i).getIdt())%>
							&<%=LoginServlet.RETURN_URL%>=<%=returnToStr%>">
								<%=Util.replaceHTML(issues.get(i).getSummary())%>
						</a></td>
						<td class="issuesTableTypeBody"><%=Util.replaceHTML(issues.get(i).getKind().getName())%></td>
						<td class="issuesTableStatusBody"><%=Util.replaceHTML(issues.get(i).getStatus().getName())%></td>
						<td class="issuesTableReporterBody"><%=Util.replaceHTML(issues.get(i).getCreator().getCredentials())%></td>
						<td class="issuesTableAssigneeBody"><%=Util.replaceHTML(issues.get(i).getAssignee().getCredentials())%></td>
						<td class="issuesTableCreatedBody"><%=dateFormat.format(issues.get(i).getDateCreated())%></td>
						<td class="issuesTableUpdatedBody"><%=dateFormat.format(issues.get(i).getDateUpdated())%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
			String key = request.getParameter(IssueServlet.ISSUE_GET_BY_KEY);
			if (issues.size() == 0 && key != null && !"".equals(key)) {
			%>
			<div class="indexNoIssue">
			Issue having key "<%=Util.replaceHTML(key)%>" not found. Check out
			<a
				href="/Tracker/pages/issue.jsp?<%=IssueServlet.ISSUE_GET_KEY_PARM%>=<%=Util.replaceStr(key)%>
				&<%=LoginServlet.RETURN_URL%>=<%=returnToStr%>">this page</a>
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
			<a href="<%=returnToFrom0%><%=Math.max(intFrom - 1, 0)%>">Previous</a>
			</div>
			<%
			}
			if (intFrom + issues.size() < totalCount) {
			%>
			<div class="indexNext">
			<a href="<%=returnToFrom0%><%=intFrom + 1%>">Next</a>
			</div>
			<%	
			}
			%>
			</div>
		</div>
	</form>
</body>
</html>