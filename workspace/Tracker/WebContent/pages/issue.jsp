<%@page import="ru.ifmo.is.db.data.IssueKind"%>
<%@page import="ru.ifmo.is.db.data.IssueProjectTransition"%>
<%@page import="ru.ifmo.is.db.data.IssueStatusTransition"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@page import="ru.ifmo.is.db.data.Comment"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	LogManager.log("GET issue.jsp", request);

	SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMMM d yyyy, HH:mm:ss", Locale.ENGLISH);
	String issueKey = (String) request.getParameter(IssueServlet.ISSUE_GET_KEY_PARM);

	Issue issue = null;
	Comment[] comments = null;
	IssueStatusTransition[] statusTransitions = null;
	IssueProjectTransition[] projectTransitions = null;
	IssueKind[] issueKinds = null;

	// TODO here to retrieve issue detailed information
	if ("SANDBOX-412".equals(issueKey)) {
		issue = new Issue(1, "SANDBOX-412", "admin", "Test admin", "admin", "Test admin", "VERIFY",
		"Verification", "OPEN", "Open", "SANDBOX", "Sandbox testing", new Date(115, 11, 23, 16, 7, 46),
		new Date(116, 1, 13, 11, 48, 1), "Please verify issue details page",
		"Here we have multiline description. \n"
		+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
		null);
		issue.resolution = "Resolution";
		
		comments = new Comment[12];
		for (int i = 0; i < 12; i++) {
	comments[i] = new Comment(i, issue.id,"admin", "Test admin", new Date(116, 1, 15, 14, 34, 5),
	"really, really long long long\n multiline comment #" + Integer.toString(i));
		}
	

		statusTransitions = new IssueStatusTransition[4];
		statusTransitions[0] = new IssueStatusTransition(1, "EDIT_SANDBOX", "Edit sandbox", "SANDBOX",
		"Sandbox testing", "OPEN", "Open", "OPEN", "Open", "EDIT_SANDBOX", "Edit");
		statusTransitions[1] = new IssueStatusTransition(2, "WORK_SANDBOX", "Work on sandbox", "SANDBOX",
		"Sandbox testing", "OPEN", "Open", "IN_PROGRESS", "In progress", "START_SANDBOX",
		"Start progress");
		statusTransitions[2] = new IssueStatusTransition(3, "WORK_SANDBOX", "Work on sandbox", "SANDBOX",
		"Sandbox testing", "OPEN", "Open", "CLOSE", "Closed", "CLOSE_SANDBOX", "Close");
		statusTransitions[3] = new IssueStatusTransition(4, "WORK_SANDBOX", "Work on sandbox", "SANDBOX",
		"Sandbox testing", "OPEN", "Open", "REJECTED", "Rejected", "REJECT_SANDBOX", "Reject");

		projectTransitions = new IssueProjectTransition[1];
		projectTransitions[0] = new IssueProjectTransition(1, "WORK_SANDBOX", "Work on sandbox", "SANDBOX",
		"Sandbox testing", "WISH", "Delayed issues", "OPEN", "Open", "TO_REVIEW", "To be reviewed");

		issueKinds = new IssueKind[3];
		issueKinds[0] = new IssueKind(1, "BUG", "Bug");
		issueKinds[1] = new IssueKind(2, "TASK", "Assignment");
		issueKinds[2] = new IssueKind(3, "VERIFY", "Verification");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><%=issue == null ? "Issue not found" : issue.idt + "/" + issue.summary%></title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body onload="init()">
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
	<script>
	var isEditing = false;
	
	var kinds = [];
	var kindsDisplay = [];
	
	var statuses = [];
	var statusesDisplay = [];
	
	function init() {
		<%for (int i = 0; i < issueKinds.length; i++) {%>
		kinds[<%=i%>] = "<%=issueKinds[i].code%>";
		kindsDisplay[<%=i%>] = "<%=issueKinds[i].name%>"; 
		<%}%>
		<%for (int i = 0; i < statusTransitions.length; i++) {%>
		statuses[<%=i%>] = "<%=statusTransitions[i].statusTo%>";
		statusesDisplay[<%=i%>] = "<%=statusTransitions[i].statusToDisplay%>"; 
		<%}%>
		resetForm();
	}
	
	function resetForm() {
		document.getElementById("issueKindTd").innerText = "<%=issue.kindDisplay%>";
		document.getElementById("issueStatusTd").innerText = "<%=issue.statusDisplay%>";
		document.getElementById("issueReporterTd").innerText = "<%=issue.creatorDisplay%>";
		document.getElementById("issueAssigneeTd").innerText = "<%=issue.assigneeDisplay%>";
		
		isEditing = false;
	}
	
	function createSelect(parCode, selectId, data, display, defaultData) {
		var select = document.createElement('select');
		select.id = selectId;
		
		if (parCode == "issueStatusTd") {
			// cannot manually set status
			select.disabled = "disabled";
		}
		
		for (var i = 0; i < data.length; i++) {
		    var option = document.createElement("option");
		    option.value = data[i];
		    option.text = display[i];
		    
		    if (data[i] == defaultData) {
		    	option.selected = "selected";
		    }
		    select.appendChild(option);
		}

		document.getElementById(parCode).innerText = "";
		document.getElementById(parCode).appendChild(select);
	}
	
	function enableEdit(newStatus) {
		if (!isEditing) {
			// have to create dropdowns
			createSelect("issueKindTd", "<%=IssueServlet.ISSUE_SET_KIND%>", kinds, kindsDisplay, "<%=issue.kind%>");
			createSelect("issueStatusTd", "<%=IssueServlet.ISSUE_SET_STATUS%>", statuses, statusesDisplay, "<%=issue.status%>");
			
			var buttonDiv = document.getElementById("issueCommitButtonsDiv");
			var submit = document.createElement("input");
			submit.type = "submit";
			submit.name = "<%=IssueServlet.ISSUE_UPDATE_WEBSERVICE%>";
			submit.value = "Save";
			submit.className = "buttonFixed";
			buttonDiv.appendChild(submit);
			
			var cancel = document.createElement("button");
			cancel.innerText = "Cancel";
			cancel.className = "buttonFixed";
			cancel.onclick = resetForm;
			buttonDiv.appendChild(cancel);
			
			isEditing = true;
		}
		
		document.getElementById("<%=IssueServlet.ISSUE_SET_STATUS%>").value = newStatus;

		return;
	}
	</script>
	<div>
		<div>
			<p class="issueName">
				<%=issue.projectDisplay%>
				/
				<%=issue.idt%>
			</p>
		</div>
		<div>
			<div align="right" class="linkToEdit">
				<a href="/Tracker/pages/index.jsp">Back to search</a>
			</div>
		</div>
		<div class="summary">
			<%=issue.summary%>
		</div>
	</div>
	<div class="buttons">
		<%
			for (int i = 0; i < statusTransitions.length; i++) {
		%>
		<button class="buttonFixed"
			onclick="enableEdit('<%=statusTransitions[i].statusTo%>')"><%=statusTransitions[i].name%></button>
		<%
			}

				if (projectTransitions.length > 0) {
		%>
		<button class="buttonFixed">Move...</button>
		<%
			}
		%>
	</div>
	<div class="divIssueComments">
		<div class="divIssue">
			<form name="issueForm" action="<%=IssueServlet.SERVLET_IDT%> method="post">
				<div class="issueBriefInfo">
					<h1 class="briefInformation">Brief information</h1>
					<hr>
					<table class="briefInfoTable">
						<tr class="widthTr">
							<td class="widthTd">Issue kind</td>
							<td id="issueKindTd"></td>
						</tr>
						<tr>
							<td class="widthTd">Status</td>
							<td id="issueStatusTd"></td>
						</tr>
						<tr>
							<td class="widthTd">Reporter</td>
							<td id="issueReporterTd"></td>
						</tr>
						<tr>
							<td class="widthTd">Assignee</td>
							<td id="issueAssigneeTd"></td>
						</tr>
						<tr>
							<td class="widthTd">Date created</td>
							<td><%=dateFormat.format(issue.dateCreated)%></td>
						</tr>
						<tr>
							<td class="widthTd">Last updated</td>
							<td><%=dateFormat.format(issue.dateUpdated)%></td>
						</tr>
					</table>
				</div>

				<div>
					<h1 class="briefInformation">Description</h1>
					<hr>
				</div>
				<div class="issueDescription">
					<%=issue.description.replaceAll("\n", "<br/>")%>
				</div>
				<%
					if (issue.resolution != null) {
				%>
				<div>
					<h1 class="briefInformation">Resolution</h1>
					<hr>
				</div>
				<div class="issueDescription">
					<%=issue.resolution.replaceAll("\n", "<br/>")%>
				</div>
				<%
					}
				%>
				<div class="issueCommitButtons" id="issueCommitButtonsDiv">
				</div>
			</form>
		</div>
		<div class="divComments">
			<h1 class="briefInformation">Comments</h1>
			<hr>
			<div class="commentScroll">
				<table class="commentTable">
					<%
						for (int i = 0; i < comments.length; i++) {
					%>
					<tr>
						<td class="commentTableAuthor"><%=comments[i].authorDisplay%></td>
						<td class="commentTableDate"><%=dateFormat.format(comments[i].dateCreated)%></td>
					</tr>
					<tr>
						<td class="commentTableText" colspan="2"><%=comments[i].text.replaceAll("\n", "<br/>")%><hr></td>
					</tr>
					<%
						}
					%>
				</table>
				<form>
					<div>
						<p>
							<textarea rows="7" class="commentText"></textarea>
						</p>
					</div>
					<div class="postComment">
						<p>
							<input type="submit" value="Add" class="buttonFixed">
						</p>
					</div>
				</form>
			</div>
			<%
				}
			%>
		</div>

	</div>
</body>
</html>
