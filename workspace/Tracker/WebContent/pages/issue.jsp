<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
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
		
		comments = new Comment[10];
		for (int i = 0; i < comments.length; i++) {
	comments[i] = new Comment(i, issue.id,"admin", "Test admin", new Date(116, 1, 15, 14, 34, 5),
	"really, really long long long\n multiline comment #" + Integer.toString(i));
		}

		statusTransitions = new IssueStatusTransition[4];
		statusTransitions[0] = new IssueStatusTransition(1, "SANDBOX",
				"Sandbox testing", "OPEN", "Open", "OPEN", "Open",
				"EDIT_SANDBOX", "Edit");
		statusTransitions[1] = new IssueStatusTransition(2, "SANDBOX",
				"Sandbox testing", "OPEN", "Open", "IN_PROGRESS",
				"In progress", "START_SANDBOX", "Start progress");
		statusTransitions[2] = new IssueStatusTransition(3, "SANDBOX",
				"Sandbox testing", "OPEN", "Open", "CLOSE", "Closed",
				"CLOSE_SANDBOX", "Close");
		statusTransitions[3] = new IssueStatusTransition(4, "SANDBOX",
				"Sandbox testing", "OPEN", "Open", "REJECTED",
				"Rejected", "REJECT_SANDBOX", "Reject");

		projectTransitions = new IssueProjectTransition[3];
		projectTransitions[0] = new IssueProjectTransition(1,
				"SANDBOX", "Sandbox testing", "WISH", "Delayed issues",
				"OPEN", "Open", "TO_REVIEW", "To be reviewed");
		projectTransitions[1] = new IssueProjectTransition(1,
				"SANDBOX", "Sandbox testing", "PBOX", "Inbox",
				"OPEN", "Open", "WAITING", "Waiting");
		projectTransitions[2] = new IssueProjectTransition(1,
				"SANDBOX", "Sandbox testing", "WISH", "Delayed issues",
				"OPEN", "Open", "CLOSE", "To be closed");

		issueKinds = IssueKind.select();

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
	var editRows = 6;
	var kinds = [];
	var assignees = [];
	var projects = [];
	
	function init() {
		<%for (int i = 0; i < issueKinds.length; i++) {%>
		kinds[<%=i%>] = {
			code: "<%=issueKinds[i].code%>",
			name: "<%=issueKinds[i].name%>"
		};	
		<%}%>

		<%for (int i = 0; i < assignees.length; i++) {%>
		assignees[<%=i%>] = {
			code: "<%=assignees[i].username%>",
			name: "<%=assignees[i].credentials%>"
		};
		<%
		}
		Set<String> projectTo = new HashSet<String>();
		for (int i = 0; i < projectTransitions.length; i++) {
			if (!projectTo.contains(projectTransitions[i].projectTo)) {
				projectTo.add(projectTransitions[i].projectTo);
		%>
		projects["<%=projectTransitions[i].projectTo%>"] = {
			name: "<%=projectTransitions[i].projectToDisplay%>",
			statuses: [{
				code: "<%=projectTransitions[i].statusTo%>",
				name: "<%=projectTransitions[i].statusToDisplay%>"
				}]
		};
		<%} else {%>
		projects["<%=projectTransitions[i].projectTo%>"].statuses.push({
			code: "<%=projectTransitions[i].statusTo%>",
			name: "<%=projectTransitions[i].statusToDisplay%>"			
		});
		<%}}%>
		
		resetForm();
	}
	
	function disableButton(elem) {
		var button = document.getElementById(elem);
		button.disabled = "disabled";
		button.className = "disabledButtonFixed";
	}
	
	function enableButton(elem) {
		var button = document.getElementById(elem);
		button.disabled = "";
		button.className = "buttonFixed";
	}
	
	function disableComment() {
		document.getElementById("addRegularCommentArea").disabled = "disabled";
		disableButton("addRegularCommentButton");
	}	
	
	function enableComment() {
		document.getElementById("addRegularCommentArea").disabled = "";
		enableButton("addRegularCommentButton");
	}
	
	function resetForm() {
		document.getElementById("issueKindTd").innerHTML = "<%=issue.kindDisplay%>";
		document.getElementById("issueStatusTd").innerHTML = "<%=issue.statusDisplay%>";
		document.getElementById("issueReporterTd").innerHTML = "<%=issue.creatorDisplay%>";
		document.getElementById("issueAssigneeTd").innerHTML = "<%=issue.assigneeDisplay%>";
		document.getElementById("issueDescription").innerHTML = "<%=issue.description == null ? "" : issue.description.replaceAll("\n", "<br/>")%>";
		document.getElementById("issueResolution").innerHTML = "<%=issue.resolution == null ? "" : issue.resolution.replaceAll("\n", "<br/>")%>";
		document.getElementById("issueSummary").innerHTML = "<%=issue.summary%>";
	}
	
	function removeEditElements() {
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
		
		enableComment();			
	}
	
	function disableEdit() {
		removeEditElements();
		resetForm();
		enableButton("moveButton");		
		isEditing = false;
	}
	
	function createSelect(parElem, selectId, data, defaultData) {
		var select = document.createElement("select");
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
		
		parElem.innerHTML = "";
		parElem.appendChild(select);
	}
	
	function addEditElements(cancelFunc) {
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
		commentArea.rows = editRows;
		commentAreaDiv.appendChild(commentArea);
		
		var errDiv = document.createElement("div");
		errDiv.id = "editErr";
		errDiv.className = "dialogErr";
		container.appendChild(errDiv);
		
		var buttonDiv = document.createElement("div");
		buttonDiv.id = "issueCommitButtonsDiv";
		buttonDiv.className = "issueCommitButtons";
		container.appendChild(buttonDiv);
		
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
		cancel.onclick = cancelFunc;
		buttonDiv.appendChild(cancel);
		
		disableComment();		
	}
	
	function enableEdit(newStatusCode, newStatus) {
		if (!isEditing) {
			// have to create dropdowns
			createSelect(document.getElementById("issueKindTd"), "<%=IssueServlet.ISSUE_SET_KIND%>", kinds, "<%=issue.kind%>");
			createSelect(document.getElementById("issueAssigneeTd"), "<%=IssueServlet.ISSUE_SET_ASSIGNEE%>", assignees, "<%=issue.assignee%>");					
			
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
			descrEdit.rows = editRows;
			document.getElementById("issueDescription").innerHTML = "";
			document.getElementById("issueDescription").appendChild(descrEdit);

			var resEdit = document.createElement("textarea");
			resEdit.name = "<%=IssueServlet.ISSUE_SET_RESOLUTION%>";
			resEdit.value = "<%=issue.resolution == null ? "" : issue.resolution.replaceAll("\n", "\\n")%>";
			resEdit.className = "descrEdit";
			resEdit.rows = editRows;
			document.getElementById("issueResolution").innerHTML = "";
			document.getElementById("issueResolution").appendChild(resEdit);

			addEditElements(disableEdit);
			var buttonDiv = document.getElementById("issueCommitButtonsDiv");
			
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
			
			disableButton("moveButton");			
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
	
	function setProjStatusList(project, status) {
		status.innerHTML = "";
		
		var def = document.createElement("option");
		def.selected = "selected";
		def.disabled = "disabled";
		status.appendChild(def);
		
		if (project.value != null) {
			var list = projects[project.value].statuses;		
			for (var i = 0; i < list.length; i++) {
			    var option = document.createElement("option");
			    option.value = list[i].code;
			    option.text = list[i].name;
			    status.appendChild(option);
			}
		}
	}
	
	function enableMove() {
		<%
			for (int i = 0; i < statusTransitions.length; i++) {
		%>
		disableButton("button_<%=statusTransitions[i].code%>");
		<%
			}
		%>
		disableButton("moveButton");
		addEditElements(disableMove);

		var container = document.getElementById("issueForm");
		var brief = document.getElementById("issueBriefInfo");

		var moveHeaderDiv = document.createElement("div");
		moveHeaderDiv.id = "issueMoveHeader";
		moveHeaderDiv.innerHTML = "<h1 class=\"briefInformation\">Move to</h1><hr>";
		container.insertBefore(moveHeaderDiv, brief);
		
		var moveAreaDiv = document.createElement("div");
		moveAreaDiv.id = "issueMoveArea";
		moveAreaDiv.className = "issueDescription";
		container.insertBefore(moveAreaDiv, brief);
		
		var table = document.createElement("table");
		table.className = "briefInfoTable";
		moveAreaDiv.appendChild(table);
		
		var tbody = document.createElement("tbody");
		table.appendChild(tbody);
		
		var row1 = document.createElement("tr");
		row1.className = "widthTr";
		tbody.appendChild(row1);
		
		var row1col1 = document.createElement("td");
		row1col1.className = "widthTd";
		row1col1.innerHTML = "New project";
		row1.appendChild(row1col1);
		
		var row1col2 = document.createElement("td");
		row1.appendChild(row1col2);
		
		var selectProj = document.createElement("select");
		selectProj.id = "<%=IssueServlet.ISSUE_SET_PROJECT%>";
		selectProj.name = "<%=IssueServlet.ISSUE_SET_PROJECT%>";
		selectProj.className = "editIssue";

		var def = document.createElement("option");
		def.selected = "selected";
		def.disabled = "disabled";
		selectProj.appendChild(def);
		
		for (var key in projects) {
		    var option = document.createElement("option");
		    option.value = key;
		    option.text = projects[key].name;
		    selectProj.appendChild(option);
		}
		
		row1col2.appendChild(selectProj);
		
		var row2 = document.createElement("tr");
		row2.className = "widthTr";
		tbody.appendChild(row2);
		
		var row2col1 = document.createElement("td");
		row2col1.className = "widthTd";
		row2col1.innerHTML = "New status";
		row2.appendChild(row2col1);
		
		var row2col2 = document.createElement("td");
		row2.appendChild(row2col2);		
		
		var selectStatus = document.createElement("select");
		selectStatus.id = "<%=IssueServlet.ISSUE_SET_STATUS%>";
		selectStatus.name = "<%=IssueServlet.ISSUE_SET_STATUS%>";
		selectStatus.className = "editIssue";
		
		row2col2.appendChild(selectStatus);
		var def = document.createElement("option");
		def.selected = "selected";
		def.disabled = "disabled";
		selectStatus.appendChild(def);
		selectProj.onchange = function() { setProjStatusList(selectProj, selectStatus);};
	}
	
	function disableMove() {
		<%
		for (int i = 0; i < statusTransitions.length; i++) {
		%>
		enableButton("button_<%=statusTransitions[i].code%>");
		<%
			}
		%>
		enableButton("moveButton");	
		removeEditElements();
		var moveHeaderDiv = document.getElementById("issueMoveHeader");
		if (moveHeaderDiv != null) {
			moveHeaderDiv.parentNode.removeChild(moveHeaderDiv);
		}		
		var moveAreaDiv = document.getElementById("issueMoveArea");
		if (moveAreaDiv != null) {
			moveAreaDiv.parentNode.removeChild(moveAreaDiv);
		}
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
		<button class="buttonFixed" id="button_<%=statusTransitions[i].code%>"
			onclick="enableEdit('<%=statusTransitions[i].statusTo%>', '<%=statusTransitions[i].statusToDisplay%>')"><%=statusTransitions[i].name%></button>
		<%
			}

				if (projectTransitions.length > 0) {
		%>
		<button class="buttonFixed" id="moveButton" onclick="enableMove()">Move...</button>
		<%
			}
		%>
	</div>
	<div class="divIssueComments">
		<div class="divIssue">
			<form id="issueForm" name="issueForm"
				action="<%=IssueServlet.SERVLET_IDT%>" method="post"
				onsubmit="return validate()">
				<div class="issueBriefInfo" id="issueBriefInfo">
					<h1 class="briefInformation">Brief information</h1>
					<hr>
				</div>
				<div class="issueDescription" id="briefInfoTable">
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
								name="<%=IssueServlet.ISSUE_ADD_COMMENT%>" rows="6"
								class="commentText"></textarea>
						</p>
					</div>
					<div class="postComment">
						<p>
							<input type="hidden" name="<%=IssueServlet.ISSUE_GET_KEY_PARM%>" value="<%=issue.idt%>"></input>
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
