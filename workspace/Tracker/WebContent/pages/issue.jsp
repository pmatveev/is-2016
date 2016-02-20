<%@page import="ru.ifmo.is.db.data.Officer"%>
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

	String searchReturnURL = IssueServlet.getReturnAddress(request);
	SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMMM d yyyy, HH:mm:ss", Locale.ENGLISH);
	String issueKey = (String) request.getParameter(IssueServlet.ISSUE_GET_KEY_PARM);

	Issue issue = null;
	Comment[] comments = null;
	IssueStatusTransition[] statusTransitions = null;
	IssueProjectTransition[] projectTransitions = null;
	IssueKind[] issueKinds = null;
	Officer[] assignees = null;

	// TODO here to retrieve issue detailed information
	if ("SANDBOX-412".equals(issueKey)) {
		issue = new Issue(1, "SANDBOX-412", "admin", "Test admin", "admin", "Test admin", "VERIFY",
		"Verification", "OPEN", "Open", "SANDBOX", "Sandbox testing", new Date(115, 11, 23, 16, 7, 46),
		new Date(116, 1, 13, 11, 48, 1), "Please verify issue details page",
		"Here we have multiline description. \n"
		+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
		null);
		issue.resolution = "Resolution";
		
		comments = new Comment[1];
		for (int i = 0; i < 1; i++) {
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
		
		assignees = new Officer[5];
		assignees[0] = new Officer(1, "admin", true, null, "Test Admin");
		assignees[1] = new Officer(1, "test1", true, null, "Officer1");
		assignees[2] = new Officer(1, "test2", true, null, "Officer2");
		assignees[3] = new Officer(1, "test3", true, null, "Officer3");
		assignees[4] = new Officer(1, "test4", true, null, "Officer4");
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
			href="<%=searchReturnURL%>">main page</a>.
	</div>
	<%
		} else {
	%>
	<script>
	var isEditing = false;
	
	var kinds = [];
	var assignees = [];
	
	function init() {
		<%for (int i = 0; i < issueKinds.length; i++) {%>
		kinds[<%=i%>] = {
			code: "<%=issueKinds[i].code%>",
			name: "<%=issueKinds[i].name%>"
		}	
		<%}%>

		<%for (int i = 0; i < assignees.length; i++) {%>
		assignees[<%=i%>] = {
			code: "<%=assignees[i].username%>",
			name: "<%=assignees[i].credentials%>"
		}
		<%}%>
		
		resetForm();
	}
	
	function resetForm() {
		document.getElementById("issueKindTd").innerHTML = "<%=issue.kindDisplay%>";
		document.getElementById("issueStatusTd").innerHTML = "<%=issue.statusDisplay%>";
		document.getElementById("issueReporterTd").innerHTML = "<%=issue.creatorDisplay%>";
		document.getElementById("issueAssigneeTd").innerHTML = "<%=issue.assigneeDisplay%>";
		document.getElementById("issueDescription").innerHTML = "<%=issue.description == null ? "" : issue.description.replaceAll("\n", "<br/>")%>";
		document.getElementById("issueResolution").innerHTML = "<%=issue.resolution == null ? "" : issue.resolution.replaceAll("\n", "<br/>")%>";
		document.getElementById("issueSummary").innerHTML = "<%=issue.summary%>";
		
		var errDiv = document.getElementById("editErr");
		if (errDiv != null) {
			errDiv.parentNode.removeChild(errDiv);
		}
		
		var buttonDiv = document.getElementById("issueCommitButtonsDiv");
		if (buttonDiv != null) {
			buttonDiv.parentNode.removeChild(buttonDiv);
		}
		
		var commentDiv = document.getElementById("issueEditCommentHeader");
		if (commentDiv != null) {
			commentDiv.parentNode.removeChild(commentDiv);
		}
		
		var commentBody = document.getElementById("issueEditCommentArea");
		if (commentBody != null) {
			commentBody.parentNode.removeChild(commentBody);
		}
		
		document.getElementById("addRegularCommentArea").disabled = "";
		var regCommentButton = document.getElementById("addRegularCommentButton");
		regCommentButton.disabled = "";
		regCommentButton.className = "buttonFixed";
		
		isEditing = false;
	}
	
	function createSelect(parCode, selectId, data, defaultData) {
		var select = document.createElement('select');
		select.id = selectId;
		select.name = selectId;
		select.className = "editIssue";
			
		for (var i = 0; i < data.length; i++) {
		    var option = document.createElement("option");
		    option.value = data[i].code;
		    option.text = data[i].name;
		    
		    if (data[i].code == defaultData) {
		    	option.selected = "selected";
		    }
		    select.appendChild(option);
		}

		if (parCode == "issueStatusTd") {
			// cannot manually set status
			select.name += "_disabled";
			select.disabled = "disabled";
			
			var hiddenSelect = document.createElement("input");
			hiddenSelect.type = "hidden";
			hiddenSelect.name = selectId;
			hiddenSelect.value = defaultData;
			document.getElementById(parCode).appendChild(hiddenSelect);
		}		
		
		document.getElementById(parCode).innerHTML = "";
		document.getElementById(parCode).appendChild(select);
	}
	
	function enableEdit(newStatusCode, newStatus) {
		if (!isEditing) {
			// have to create dropdowns
			createSelect("issueKindTd", "<%=IssueServlet.ISSUE_SET_KIND%>", kinds, "<%=issue.kind%>");
			createSelect("issueAssigneeTd", "<%=IssueServlet.ISSUE_SET_ASSIGNEE%>", assignees, "<%=issue.assignee%>");					
			
			var summEdit = document.createElement("input");
			summEdit.id = "<%=IssueServlet.ISSUE_SET_SUMMARY%>_out";
			summEdit.name = "<%=IssueServlet.ISSUE_SET_SUMMARY%>_out";
			summEdit.value = "<%=issue.summary%>";
			summEdit.className = "summaryEdit";
			document.getElementById("issueSummary").innerHTML = "";
			document.getElementById("issueSummary").appendChild(summEdit);
			
			var descrEdit = document.createElement("textarea");
			descrEdit.id = "<%=IssueServlet.ISSUE_SET_DESCRIPTION%>";
			descrEdit.name = "<%=IssueServlet.ISSUE_SET_DESCRIPTION%>";
			descrEdit.value = "<%=issue.description == null ? "" : issue.description.replaceAll("\n", "\\\\n")%>";
			descrEdit.className = "descrEdit";
			descrEdit.rows = 9;
			document.getElementById("issueDescription").innerHTML = "";
			document.getElementById("issueDescription").appendChild(descrEdit);
			
			var resEdit = document.createElement("textarea");
			resEdit.name = "<%=IssueServlet.ISSUE_SET_RESOLUTION%>";
			resEdit.value = "<%=issue.resolution == null ? "" : issue.resolution.replaceAll("\n", "\\n")%>";
			resEdit.className = "descrEdit";
			resEdit.rows = 9;
			document.getElementById("issueResolution").innerHTML = "";
			document.getElementById("issueResolution").appendChild(resEdit);
			
			var container = document.getElementById("issueForm");
			
			var commentHeaderDiv = document.createElement("div");
			commentHeaderDiv.id = "issueEditCommentHeader";
			commentHeaderDiv.innerHTML = "<h1 class=\"briefInformation\">Comment</h1><hr>";
			container.appendChild(commentHeaderDiv);
			
			var commentAreaDiv = document.createElement("div");
			commentAreaDiv.id = "issueEditCommentArea";
			commentAreaDiv.className = "issueDescription";
			container.appendChild(commentAreaDiv);
			
			var commentArea = document.createElement("textarea");
			commentArea.name = "<%=IssueServlet.ISSUE_ADD_COMMENT%>";
			commentArea.className = "descrEdit";
			commentArea.rows = 9;
			commentAreaDiv.appendChild(commentArea);
			
			var errDiv = document.createElement("div");
			errDiv.id = "editErr";
			errDiv.className = "dialogErr";
			container.appendChild(errDiv);
			
			var buttonDiv = document.createElement("div");
			buttonDiv.id = "issueCommitButtonsDiv";
			buttonDiv.className = "issueCommitButtons";
			container.appendChild(buttonDiv);
			
			var hiddenSummary = document.createElement("input");
			hiddenSummary.type = "hidden";
			hiddenSummary.name = "<%=IssueServlet.ISSUE_SET_SUMMARY%>";
			hiddenSummary.id = "<%=IssueServlet.ISSUE_SET_SUMMARY%>";
			buttonDiv.appendChild(hiddenSummary);
			
			var hiddenStatus = document.createElement("input");
			hiddenStatus.type = "hidden";
			hiddenStatus.name = "<%=IssueServlet.ISSUE_SET_STATUS%>";
			hiddenStatus.id = "<%=IssueServlet.ISSUE_SET_STATUS%>";
			buttonDiv.appendChild(hiddenStatus);
			
			var issueId = document.createElement("input");
			issueId.type = "hidden";
			issueId.name = "<%=IssueServlet.ISSUE_GET_KEY_PARM%>";
			issueId.value = "<%=issue.idt%>";
			buttonDiv.appendChild(issueId);
			
			var submit = document.createElement("input");
			submit.type = "submit";
			submit.name = "<%=IssueServlet.ISSUE_UPDATE_WEBSERVICE%>";
			submit.value = "Save";
			submit.className = "buttonFixed";
			buttonDiv.appendChild(submit);
			
			var cancel = document.createElement("button");
			cancel.type = "button";
			cancel.innerHTML = "Cancel";
			cancel.className = "cancelButtonFixed";
			cancel.onclick = resetForm;
			buttonDiv.appendChild(cancel);
			
			document.getElementById("addRegularCommentArea").disabled = "disabled";
			var regCommentButton = document.getElementById("addRegularCommentButton");
			regCommentButton.disabled = "disabled";
			regCommentButton.className = "disabledButtonFixed";
			
			isEditing = true;
		}
		
		document.getElementById("issueStatusTd").innerHTML = newStatus;
		document.getElementById("<%=IssueServlet.ISSUE_SET_STATUS%>").value = newStatusCode;
		return;
	}
	
	function validate() {
		if (document.getElementById("<%=IssueServlet.ISSUE_SET_DESCRIPTION%>").value == "") {
			document.getElementById("editErr").innerHTML = "Issue description required";
			return false;				
		}		
		
		document.getElementById("editErr").innerHTML = "";	
		document.getElementById("<%=IssueServlet.ISSUE_SET_SUMMARY%>").value = document.getElementById("<%=IssueServlet.ISSUE_SET_SUMMARY%>_out").value;
		return true;
	}
	</script>
	<div>
		<div class="linkToEdit">
			<a href="<%=searchReturnURL%>">Back to search</a>
		</div>
		<div>
			<p class="issueName">
				<%=issue.projectDisplay%>
				/
				<%=issue.idt%>
			</p>
		</div>
		<div class="summary" id="issueSummary"></div>
	</div>
	<div class="buttons">
		<%
			for (int i = 0; i < statusTransitions.length; i++) {
		%>
		<button class="buttonFixed"
			onclick="enableEdit('<%=statusTransitions[i].statusTo%>', '<%=statusTransitions[i].statusToDisplay%>')"><%=statusTransitions[i].name%></button>
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
			<form id="issueForm" name="issueForm"
				action="<%=IssueServlet.SERVLET_IDT%>" method="post"
				onsubmit="return validate()">
				<div class="issueBriefInfo">
					<h1 class="briefInformation">Brief information</h1>
					<hr>
					<table class="briefInfoTable">
						<tr class="widthTr">
							<td class="widthTd">Issue type</td>
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
				<div class="issueDescription" id="issueDescription"></div>
				<div>
					<h1 class="briefInformation">Resolution</h1>
					<hr>
				</div>
				<div class="issueDescription" id="issueResolution"></div>
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
							<textarea id="addRegularCommentArea"
								name="<%=IssueServlet.ISSUE_ADD_COMMENT%>" rows="7"
								class="commentText"></textarea>
						</p>
					</div>
					<div class="postComment">
						<p>
							<input id="addRegularCommentButton" type="submit" value="Add"
								class="buttonFixed">
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
