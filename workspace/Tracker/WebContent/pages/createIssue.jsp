<%@page import="ru.ifmo.is.db.data.IssueProject"%>
<%@page import="ru.ifmo.is.db.data.IssueKind"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	IssueKind[] kinds = new IssueKind[4];
	kinds[0] = new IssueKind(1, "BUG", "Bug");
	kinds[1] = new IssueKind(2, "TASK", "Assignment");
	kinds[2] = new IssueKind(3, "VERIFY", "Verification");
	kinds[3] = new IssueKind(4, "RESEARCH", "Research");

	IssueProject[] projects = new IssueProject[2];
	projects[0] = new IssueProject(1, "OPEN", "Open", "admin", "Test Admin", "SANDBOX", "Sandbox Testing");
	projects[1] = new IssueProject(2, "OPEN", "Open", "pmatveev", "Philipp Matveev", "WORK", "In work");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create new issue</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body onload="init()">
	<script>
	var projectStatusTo = [];
	var projectOfficerTo = [];
	
		function init() {
			<%for (int i = 0; i < projects.length; i++) {%>
			projectStatusTo["<%=projects[i].code%>"] = "<%=projects[i].startStatusDisplay%>";
			projectOfficerTo["<%=projects[i].code%>"] = "<%=projects[i].ownerDisplay%>";
	<%}%>
		}

		function setProject(project) {
			var toStatus = projectStatusTo[project.value];
			if (toStatus == undefined) {
				toStatus = "";
			}
			document.getElementById("issueStatusInput").value = toStatus;

			var toOfficer = projectOfficerTo[project.value];
			if (toOfficer == undefined) {
				toOfficer = "";
			}
			document.getElementById("issueAssigneeInput").value = toOfficer;
		}

		function validate() {
			if (document.getElementById("<%=IssueServlet.ISSUE_SET_PROJECT%>").value == "") {
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
	<%@ include file="logout.jsp"%>
	<%
		LogManager.log("GET createIndex.jsp", request);
		String searchReturnURL = IssueServlet.getReturnAddress(request);
	%>
	<div class="createIssue">
		<form id="ussueForm" name="issueForm"
			action="<%=IssueServlet.SERVLET_IDT%>" method="post"
			onsubmit="return validate()">
			<div class="issueBriefInfo">
				<h1 class="briefInformation">Common</h1>
				<hr>
				<table class="briefInfoTable">
					<tr class="widthTr">
						<td class="widthTd">Project</td>
						<td id="issueKindTd"><select
							id="<%=IssueServlet.ISSUE_SET_PROJECT%>"
							name="<%=IssueServlet.ISSUE_SET_PROJECT%>" class="editIssue"
							onchange="setProject(this)">
								<option value=""></option>
								<%
									for (int i = 0; i < projects.length; i++) {
								%>
								<option value="<%=projects[i].code%>"><%=projects[i].name%></option>
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
									for (int i = 0; i < kinds.length; i++) {
								%>
								<option value="<%=kinds[i].code%>"><%=kinds[i].name%></option>
								<%
									}
								%>
						</select></td>
					</tr>
					<tr>
						<td class="widthTd">Status</td>
						<td id="issueStatusTd"><input id="issueStatusInput"
							type="text" disabled></input></td>
					</tr>
					<tr>
						<td class="widthTd">Assignee</td>
						<td id="issueAssigneeTd"><input id="issueAssigneeInput"
							type="text" disabled></input></td>
					</tr>
				</table>
			</div>
			<div class="issueDescriptionCreate">
				<h1 class="briefInformation">Description</h1>
				<hr>
				<textarea id="<%=IssueServlet.ISSUE_SET_DESCRIPTION%>" 
					name="<%=IssueServlet.ISSUE_SET_DESCRIPTION%>" rows="9"
					class="descrEdit"></textarea>
			</div>
			<div id="createErr" class="dialogErr"></div>
			<div class="issueCommitButtons" id="issueCommitButtonsDiv">
				<input type="submit" class="buttonFixed"
					name="<%=IssueServlet.ISSUE_CREATE_WEBSERVICE%>" value="Create"></input>
				<button type="button" class="cancelButtonFixed" onclick="parent.location = '<%=IssueServlet.getReturnAddress(request)%>'">Cancel</button>
			</div>
		</form>
	</div>
</body>
</html>