<%@page import="ru.ifmo.is.manager.ProjectManager"%>
<%@page import="ru.ifmo.is.db.entity.IssueProject"%>
<%@page import="ru.ifmo.is.db.service.IssueProjectService"%>
<%@page import="java.util.List"%>
<%@page import="ru.ifmo.is.db.service.IssueKindService"%>
<%@page import="ru.ifmo.is.db.util.Context"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="ru.ifmo.is.db.entity.IssueKind"%>
<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create new issue</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body onload="init()">
	<%@ include file="include/logout.jsp"%>
	<%
		LogManager.log("GET createIssue.jsp", request); 
		
		ProjectManager projectManager = new ProjectManager();
		List<IssueKind> kinds = projectManager.selectAllKinds();
		List<IssueProject> projects = projectManager.selectAvailableProjects(
				(String) request.getAttribute(LoginServlet.LOGIN_AUTH_USERNAME));
	%>
	<script>
	var projectTo = [];
	
		function init() {
			projectTo["-"] = {
				status: "",
				owner: ""
			};
			<%for (int i = 0; i < projects.size(); i++) {%>
			projectTo["<%=Util.replaceStr(projects.get(i).getCode())%>"] = {
					status: "<%=Util.replaceStr(projects.get(i).getStartStatus().getName())%>",
			 		owner: "<%=Util.replaceStr(projects.get(i).getOwner().getCredentials())%>"
			};
			<%}%>
			
			<%
			if ("error".equals(request.getSession().getAttribute(IssueServlet.ISSUE_CREATE_WEBSERVICE))) {
				request.getSession().removeAttribute(IssueServlet.ISSUE_CREATE_WEBSERVICE);
				
				String error = (String) request.getSession().getAttribute(
						IssueServlet.ISSUE_ERROR);
				if (error != null) {
					request.getSession().removeAttribute(IssueServlet.ISSUE_ERROR);
					out.println("document.getElementById(\"createErr\").innerHTML = \""
							+ Util.replaceStr(error) + "\";");
				}

				String summary = (String) request.getSession().getAttribute(
						IssueServlet.ISSUE_SET_SUMMARY);
				if (summary != null) {
					request.getSession().removeAttribute(
							IssueServlet.ISSUE_SET_SUMMARY);
					out.println("document.getElementById(\""
							+ IssueServlet.ISSUE_SET_SUMMARY + "\").value = \""
							+ Util.replaceStr(summary) + "\";");
				}

				String project = (String) request.getSession().getAttribute(
						IssueServlet.ISSUE_SET_PROJECT);
				if (project != null) {
					request.getSession().removeAttribute(
							IssueServlet.ISSUE_SET_PROJECT);
					out.println("document.getElementById(\""
							+ IssueServlet.ISSUE_SET_PROJECT + "\").value = \""
							+ Util.replaceStr(project) + "\";");
					out.println("setProject(document.getElementById(\""
							+ IssueServlet.ISSUE_SET_PROJECT + "\"))");
				}

				String kind = (String) request.getSession().getAttribute(
						IssueServlet.ISSUE_SET_KIND);
				if (kind != null) {
					request.getSession().removeAttribute(
							IssueServlet.ISSUE_SET_KIND);
					out.println("document.getElementById(\""
							+ IssueServlet.ISSUE_SET_KIND + "\").value = \"" 
							+ Util.replaceStr(kind) + "\";");
				}

				String descr = (String) request.getSession().getAttribute(
						IssueServlet.ISSUE_SET_DESCRIPTION);
				if (descr != null) {
					request.getSession().removeAttribute(
							IssueServlet.ISSUE_SET_DESCRIPTION);
					out.println("document.getElementById(\""
							+ IssueServlet.ISSUE_SET_DESCRIPTION + "\").value = \""
							+ Util.replaceStr(descr) + "\";");
				}
			}
			%>			
		}

		function setProject(project) {
			var toStatus = projectTo[project.value].status;
			document.getElementById("issueStatusInput").value = toStatus;

			var toOfficer = projectTo[project.value].owner;
			document.getElementById("issueAssigneeInput").value = toOfficer;
		}

		function validate() {
//			return true;
			
			if (document.getElementById("<%=IssueServlet.ISSUE_SET_SUMMARY%>").value == "") {
				document.getElementById("createErr").innerHTML = "Issue summary required";
				return false;				
			}
			
			if (document.getElementById("<%=IssueServlet.ISSUE_SET_PROJECT%>").value == "" || 
					document.getElementById("<%=IssueServlet.ISSUE_SET_PROJECT%>").value == "-") {
				document.getElementById("createErr").innerHTML = "Issue project required";
				return false;				
			}

			if (document.getElementById("<%=IssueServlet.ISSUE_SET_KIND%>").value == "") {
				document.getElementById("createErr").innerHTML = "Issue type required";
				return false;				
			}

			if (document.getElementById("<%=IssueServlet.ISSUE_SET_DESCRIPTION%>").value == "") {
				document.getElementById("createErr").innerHTML = "Issue description required";
				return false;				
			}
			
			document.getElementById("createErr").innerHTML = "";
			return true;
		}
	</script>
	<div class="createIssue">
		<form id="ussueForm" name="issueForm"
			action="<%=IssueServlet.SERVLET_IDT%>" method="post"
			onsubmit="return validate()"
			autocomplete="off">
			<input type="hidden" name="<%=LoginServlet.RETURN_URL%>"
				value="<%=returnTo%>"/>
			<div class="issueBriefInfo">
				<h1 class="briefInformation">Summary</h1>
				<hr>
				<input class="summaryEdit" 
					id="<%=IssueServlet.ISSUE_SET_SUMMARY%>"
					name="<%=IssueServlet.ISSUE_SET_SUMMARY%>"/>
				<h1 class="briefInformation">Common</h1>
				<hr>
				<table class="briefInfoTable">
					<tr class="widthTr">
						<td class="widthTd">Project</td>
						<td id="issueKindTd"><select
							id="<%=IssueServlet.ISSUE_SET_PROJECT%>"
							name="<%=IssueServlet.ISSUE_SET_PROJECT%>" class="editIssue"
							onchange="setProject(this)">
								<option value="-"></option>
								<%
									for (int i = 0; i < projects.size(); i++) {
								%>
								<option value="<%=Util.replaceStr(projects.get(i).getCode())%>">
								<%=Util.replaceHTML(projects.get(i).getName())%>
								</option>
								<%
									}
								%>
						</select></td>
					</tr>
					<tr>
						<td class="widthTd">Type</td>
						<td id="issueStatusTd"><select
							id="<%=IssueServlet.ISSUE_SET_KIND%>"
							name="<%=IssueServlet.ISSUE_SET_KIND%>" class="editIssue">
								<option value=""></option>
								<%
									for (int i = 0; i < kinds.size(); i++) {
								%>
								<option value="<%=Util.replaceStr(kinds.get(i).getCode())%>">
								<%=Util.replaceHTML(kinds.get(i).getName())%>
								</option>
								<%
									}
								%>
						</select></td>
					</tr>
					<tr>
						<td class="widthTd">Status</td>
						<td id="issueStatusTd"><input id="issueStatusInput" 
							class="editIssue" type="text" disabled></input></td>
					</tr>
					<tr>
						<td class="widthTd">Assignee</td>
						<td id="issueAssigneeTd"><input id="issueAssigneeInput"
							class="editIssue" type="text" disabled></input></td>
					</tr>
				</table>				
			</div>
			<div class="issueDescriptionCreate">
				<h1 class="briefInformation">Details</h1>
				<hr>
				<textarea id="<%=IssueServlet.ISSUE_SET_DESCRIPTION%>" 
					name="<%=IssueServlet.ISSUE_SET_DESCRIPTION%>" rows="9"
					class="descrEdit"></textarea>
			</div>
			<div id="createErr" class="dialogErr"></div>
			<div class="issueCommitButtons" id="issueCommitButtonsDiv">
				<input type="submit" class="buttonFixed"
					name="<%=IssueServlet.ISSUE_CREATE_WEBSERVICE%>" value="Create"></input>
				<button type="button" class="cancelButtonFixed" onclick="parent.location = '<%=returnURL%>'">Cancel</button>
			</div>
		</form>
	</div>
</body>
</html>