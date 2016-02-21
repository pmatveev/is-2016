<%@page import="ru.ifmo.is.db.data.IssueProject"%>
<%@page import="ru.ifmo.is.db.data.IssueKind"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create new issue</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body onload="init()">
	<%@ include file="logout.jsp"%>
	<%
		LogManager.log("GET createIssue.jsp", request);
		String searchReturnURL = IssueServlet.getReturnAddress(request);
	
		IssueKind[] kinds = IssueKind.select();
		IssueProject[] projects = IssueProject.selectAvailable(
				(String) request.getAttribute(LoginServlet.LOGIN_AUTH_USERNAME));
	%>
	<script>
	var projectTo = [];
	
		function init() {
			<%
			String error = (String) request.getSession().getAttribute(IssueServlet.ISSUE_ERROR);
			if (error != null) {
				request.getSession().removeAttribute(IssueServlet.ISSUE_ERROR);
			%>
			document.getElementById("createErr").innerHTML = "<%=error%>";
			<%
			}
			%>
			projectTo["-"] = {
				status: "",
				owner: ""
			};
			<%for (int i = 0; i < projects.length; i++) {%>
			projectTo["<%=projects[i].code%>"] = {
					status: "<%=projects[i].startStatusDisplay%>",
			 		owner: "<%=projects[i].ownerDisplay%>"
			};
	<%}%>
		}

		function setProject(project) {
			var toStatus = projectTo[project.value].status;
			document.getElementById("issueStatusInput").value = toStatus;

			var toOfficer = projectTo[project.value].owner;
			document.getElementById("issueAssigneeInput").value = toOfficer;
		}

		function validate() {
			// return true;
			
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
			onsubmit="return validate()">
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
				<button type="button" class="cancelButtonFixed" onclick="parent.location = '<%=IssueServlet.getReturnAddress(request)%>'">Cancel</button>
			</div>
		</form>
	</div>
</body>
</html>