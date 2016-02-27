<%@page import="ru.ifmo.is.db.entity.IssueKind"%>
<%@page import="java.util.List"%>
<%@page import="ru.ifmo.is.db.service.IssueKindService"%>
<%@page import="ru.ifmo.is.util.Context"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="ru.ifmo.is.db.data.OfficerData"%>
<%@page import="ru.ifmo.is.db.data.IssueProjectTransitionData"%>
<%@page import="ru.ifmo.is.db.data.IssueStatusTransitionData"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="ru.ifmo.is.db.data.IssueData"%>
<%@page import="ru.ifmo.is.db.data.CommentData"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Issue</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body onload="init()">
	<%@ include file="logout.jsp"%>
	<%
		LogManager.log("GET issue.jsp", request);
		
			String returnTo = request.getRequestURI() + "?" + Util.nvl(request.getQueryString());
			String searchReturnURL = IssueServlet.getReturnAddress(request);
			SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMMM d yyyy, HH:mm:ss", Locale.ENGLISH);
			String issueKey = (String) request.getParameter(IssueServlet.ISSUE_GET_KEY_PARM);
		
			ApplicationContext ctx = Context.getContext();
			
			IssueData issue = IssueData.selectByIdt(issueKey);
			CommentData[] comments = CommentData.selectByIssue(issue == null ? null : issue.id);
			IssueStatusTransitionData[] statusTransitions = IssueStatusTransitionData.selectByIssue(
			issue == null ? null : issue.id, 
			(String) request.getAttribute(LoginServlet.LOGIN_AUTH_USERNAME));
			IssueProjectTransitionData[] projectTransitions = IssueProjectTransitionData.selectByIssue(
			issue == null ? null : issue.id, 
			(String) request.getAttribute(LoginServlet.LOGIN_AUTH_USERNAME));

			IssueKindService kindService = ctx.getBean(IssueKindService.class);
			List<IssueKind> kinds = kindService.selectAll();
			// TODO currently we can assign to everyone. See task #24
			OfficerData[] assignees = OfficerData.select();
	%>
	<%
		if (issue == null) {
	%>
	<div class="centeredText">
		Issue having key
		<%=Util.replaceHTML(issueKey)%>
		not found. You may continue with search on the <a
			href="<%=Util.replaceStr(searchReturnURL)%>">main page</a>.
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
		document.title = "<%=issue == null ? "Issue not found" : Util.replaceStr(issue.idt)
				+ "/" + Util.replaceStr(issue.summary)%>";
		<%for (int i = 0; i < kinds.size(); i++) {%>
		kinds[<%=i%>] = {
			code: "<%=Util.replaceStr(kinds.get(i).getCode())%>",
			name: "<%=Util.replaceStr(kinds.get(i).getName())%>"
		};	
		<%}%>

		<%for (int i = 0; i < assignees.length; i++) {%>
		assignees[<%=i%>] = {
			code: "<%=Util.replaceStr(assignees[i].username)%>",
			name: "<%=Util.replaceStr(assignees[i].credentials)%>"
		};
		<%}
		Set<String> projectTo = new HashSet<String>();
		for (int i = 0; i < projectTransitions.length; i++) {
			if (!projectTo.contains(projectTransitions[i].projectTo)) {
				projectTo.add(projectTransitions[i].projectTo);%>
		projects["<%=Util.replaceStr(projectTransitions[i].projectTo)%>"] = {
			name: "<%=Util.replaceStr(projectTransitions[i].projectToDisplay)%>",
			statuses: [{
				code: "<%=Util.replaceStr(projectTransitions[i].statusTo)%>",
				name: "<%=Util.replaceStr(projectTransitions[i].statusToDisplay)%>",
				transCode: "<%=Util.replaceStr(projectTransitions[i].code)%>"
				}]
		};
		<%} else {%>
		projects["<%=Util.replaceStr(projectTransitions[i].projectTo)%>"].statuses.push({
			code: "<%=Util.replaceStr(projectTransitions[i].statusTo)%>",
			name: "<%=Util.replaceStr(projectTransitions[i].statusToDisplay)%>",
			transCode: "<%=Util.replaceStr(projectTransitions[i].code)%>"			
		});
		<%}}%>
		
		resetForm();
		
		<%if ("error".equals(request.getSession().
				getAttribute(IssueServlet.ISSUE_UPDATE_WEBSERVICE))) {
			request.getSession().removeAttribute(IssueServlet.ISSUE_UPDATE_WEBSERVICE);
			
			// error during status transition
			String statusTransition = (String) request.getSession().getAttribute(IssueServlet.ISSUE_STATUS_TRANSITION);
			if (statusTransition != null) {
				request.getSession().removeAttribute(IssueServlet.ISSUE_STATUS_TRANSITION);

				boolean edit = false;
				for (IssueStatusTransitionData t : statusTransitions) {
					if (statusTransition.equals(t.code)) {
						out.println("enableEdit(\"" + Util.replaceStr(t.statusTo) + "\", \"" +
								Util.replaceStr(t.statusToDisplay) + "\", \"" +
								Util.replaceStr(t.code) + "\");");
						edit = true;
						break;
					}
				}
				
				if (edit) {
					String error = (String) request.getSession().getAttribute(
							IssueServlet.ISSUE_ERROR);
					if (error != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_ERROR);
						out.println("document.getElementById(\"editErr\").innerHTML = \""
								+ Util.replaceStr(error) + "\";");
					}
					
					String summary = (String) request.getSession().getAttribute(IssueServlet.ISSUE_SET_SUMMARY);
					if (summary != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_SET_SUMMARY);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_SUMMARY + "\").value = \""
								+ Util.replaceStr(summary) + "\";");
					}
					
					String assignee = (String) request.getSession().getAttribute(IssueServlet.ISSUE_SET_ASSIGNEE);
					if (assignee != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_SET_ASSIGNEE);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_ASSIGNEE + "\").value = \""
								+ Util.replaceStr(assignee) + "\";");
					}
					
					String kind = (String) request.getSession().getAttribute(IssueServlet.ISSUE_SET_KIND);
					if (kind != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_SET_KIND);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_KIND + "\").value = \""
								+ Util.replaceStr(kind) + "\";");
					}
					
					String descr = (String) request.getSession().getAttribute(IssueServlet.ISSUE_SET_DESCRIPTION);
					if (descr != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_SET_DESCRIPTION);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_DESCRIPTION + "\").value = \""
								+ Util.replaceStr(descr) + "\";");
					}
					
					String resol = (String) request.getSession().getAttribute(IssueServlet.ISSUE_SET_RESOLUTION);
					if (resol != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_SET_RESOLUTION);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_RESOLUTION + "\").value = \""
								+ Util.replaceStr(resol) + "\";");
					}
					
					String comm = (String) request.getSession().getAttribute(IssueServlet.ISSUE_ADD_COMMENT);
					if (comm != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_ADD_COMMENT);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_ADD_COMMENT + "\").value = \""
								+ Util.replaceStr(comm) + "\";");
					}
				} else {					
					request.getSession().removeAttribute(IssueServlet.ISSUE_SET_SUMMARY);
					request.getSession().removeAttribute(IssueServlet.ISSUE_SET_ASSIGNEE);
					request.getSession().removeAttribute(IssueServlet.ISSUE_SET_KIND);
					request.getSession().removeAttribute(IssueServlet.ISSUE_SET_DESCRIPTION);
					request.getSession().removeAttribute(IssueServlet.ISSUE_SET_RESOLUTION);
					request.getSession().removeAttribute(IssueServlet.ISSUE_ADD_COMMENT);
				}
			}
			
			// error during project transition
			String projectTransition = (String) request.getSession().getAttribute(IssueServlet.ISSUE_PROJECT_TRANSITION);
			if (projectTransition != null) {
				request.getSession().removeAttribute(IssueServlet.ISSUE_PROJECT_TRANSITION);

				boolean edit = false;
				for (IssueProjectTransitionData t : projectTransitions) {
					if (projectTransition.equals(t.code)) {
						out.println("enableMove()");
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_PROJECT + 
								"\").value = \"" + Util.replaceStr(t.projectTo) + "\"");
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_SET_STATUS + 
								"\").value = \"" + Util.replaceStr(t.statusTo) + "\"");
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_PROJECT_TRANSITION + 
								"\").value = \"" + Util.replaceStr(t.code) + "\"");
						edit = true;
						break;
					}
				}
				
				if (edit) {
					String error = (String) request.getSession().getAttribute(
							IssueServlet.ISSUE_ERROR);
					if (error != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_ERROR);
						out.println("document.getElementById(\"editErr\").innerHTML = \""
								+ Util.replaceStr(error) + "\";");
					}
					
					String comm = (String) request.getSession().getAttribute(IssueServlet.ISSUE_ADD_COMMENT);
					if (comm != null) {
						request.getSession().removeAttribute(IssueServlet.ISSUE_ADD_COMMENT);
						out.println("document.getElementById(\"" + IssueServlet.ISSUE_ADD_COMMENT + "\").value = \""
								+ Util.replaceStr(comm) + "\";");
					}
				} else {
					request.getSession().removeAttribute(IssueServlet.ISSUE_ADD_COMMENT);
				}
			}
		}
		// error while adding comments
		if ("error".equals(request.getSession().
				getAttribute(IssueServlet.ISSUE_COMMENT_WEBSERVICE))) {
			request.getSession().removeAttribute(IssueServlet.ISSUE_COMMENT_WEBSERVICE);
			
			String error = (String) request.getSession().getAttribute(
					IssueServlet.ISSUE_ERROR);
			if (error != null) {
				request.getSession().removeAttribute(IssueServlet.ISSUE_ERROR);
				out.println("document.getElementById(\"commentErr\").innerHTML = \""
						+ Util.replaceStr(error) + "\";");
			}
			
			String comment = (String) request.getSession().getAttribute(
					IssueServlet.ISSUE_ADD_COMMENT);
			if (comment != null) {
				request.getSession().removeAttribute(IssueServlet.ISSUE_ADD_COMMENT);
				out.println("document.getElementById(\"addRegularCommentArea\").value = \""
						+ Util.replaceStr(comment) + "\";");
			}
		}
		

		String error = (String) request.getSession().getAttribute(
				IssueServlet.ISSUE_ERROR);
		if (error != null) {
			request.getSession().removeAttribute(IssueServlet.ISSUE_ERROR);
			out.println("document.getElementById(\"generalErr\").innerHTML = \""
					+ Util.replaceStr(error) + "\";");
		}%>
	}
	
	function disableButton(elem) {
		var button = document.getElementById(elem);
		if (button != null) {
			button.disabled = "disabled";
			button.className = "disabledButtonFixed";
		}
	}
	
	function enableButton(elem) {
		var button = document.getElementById(elem);
		if (button != null) {
			button.disabled = "";
			button.className = "buttonFixed";
		}
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
		document.getElementById("issueKindTd").innerHTML = "<%=Util.replaceStr(Util.replaceHTML(issue.kindDisplay))%>";
		document.getElementById("issueStatusTd").innerHTML = "<%=Util.replaceStr(Util.replaceHTML(issue.statusDisplay))%>";
		document.getElementById("issueReporterTd").innerHTML = "<%=Util.replaceStr(Util.replaceHTML(issue.creatorDisplay))%>";
		document.getElementById("issueAssigneeTd").innerHTML = "<%=Util.replaceStr(Util.replaceHTML(issue.assigneeDisplay))%>";
		document.getElementById("issueDescription").innerHTML = "<%=issue.description == null ? "" : Util.replaceStr(Util.replaceHTML(issue.description))%>";
		document.getElementById("issueResolution").innerHTML = "<%=issue.resolution == null ? "" : Util.replaceStr(Util.replaceHTML(issue.resolution))%>";
		document.getElementById("issueSummary").innerHTML = "<%=Util.replaceStr(Util.replaceHTML(issue.summary))%>";
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
		commentArea.id = "<%=IssueServlet.ISSUE_ADD_COMMENT%>";
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
		
		var returnUrl = document.createElement("input");
		returnUrl.type = "hidden";
		returnUrl.name = "<%=IssueServlet.RETURN_URL%>";
		returnUrl.value = "<%=returnTo%>";
		buttonDiv.appendChild(returnUrl);
		
		var issueId = document.createElement("input");
		issueId.type = "hidden";
		issueId.name = "<%=IssueServlet.ISSUE_GET_KEY_PARM%>";
		issueId.value = "<%=Util.replaceStr(issue.idt)%>";
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
	
	function enableEdit(newStatusCode, newStatus, transitionCode) {
		if (!isEditing) {
			// have to create dropdowns
			createSelect(document.getElementById("issueKindTd"), "<%=IssueServlet.ISSUE_SET_KIND%>", kinds, "<%=Util.replaceStr(issue.kind)%>");
			createSelect(document.getElementById("issueAssigneeTd"), "<%=IssueServlet.ISSUE_SET_ASSIGNEE%>", assignees, "<%=Util.replaceStr(issue.assignee)%>");					
			
			var summEdit = document.createElement("input");
			summEdit.id = "<%=IssueServlet.ISSUE_SET_SUMMARY%>";
			summEdit.name = "<%=IssueServlet.ISSUE_SET_SUMMARY%>";
			summEdit.value = "<%=Util.replaceStr(issue.summary)%>";
			summEdit.className = "summaryEdit";
			summEdit.setAttribute("form", "issueForm");
			document.getElementById("issueSummary").innerHTML = "";
			document.getElementById("issueSummary").appendChild(summEdit);

			var descrEdit = document.createElement("textarea");
			descrEdit.id = "<%=IssueServlet.ISSUE_SET_DESCRIPTION%>";
			descrEdit.name = "<%=IssueServlet.ISSUE_SET_DESCRIPTION%>";
			descrEdit.value = "<%=issue.description == null ? "" : Util.replaceStr(issue.description)%>";
			descrEdit.className = "descrEdit";
			descrEdit.rows = editRows;
			document.getElementById("issueDescription").innerHTML = "";
			document.getElementById("issueDescription").appendChild(descrEdit);

			var resEdit = document.createElement("textarea");
			resEdit.id = "<%=IssueServlet.ISSUE_SET_RESOLUTION%>";
			resEdit.name = "<%=IssueServlet.ISSUE_SET_RESOLUTION%>";
			resEdit.value = "<%=issue.resolution == null ? "" : Util.replaceStr(issue.resolution)%>";
			resEdit.className = "descrEdit";
			resEdit.rows = editRows;
			document.getElementById("issueResolution").innerHTML = "";
			document.getElementById("issueResolution").appendChild(resEdit);

			addEditElements(disableEdit);
			var buttonDiv = document.getElementById("issueCommitButtonsDiv");
			
			var hiddenStatus = document.createElement("input");
			hiddenStatus.type = "hidden";
			hiddenStatus.name = "<%=IssueServlet.ISSUE_SET_STATUS%>";
			hiddenStatus.id = "<%=IssueServlet.ISSUE_SET_STATUS%>";
			buttonDiv.appendChild(hiddenStatus);
			
			var hiddenTransitionCode = document.createElement("input");
			hiddenTransitionCode.type = "hidden";
			hiddenTransitionCode.name = "<%=IssueServlet.ISSUE_STATUS_TRANSITION%>";
			hiddenTransitionCode.id = "<%=IssueServlet.ISSUE_STATUS_TRANSITION%>";
			buttonDiv.appendChild(hiddenTransitionCode);
			
			disableButton("moveButton");			
			isEditing = true;
		}
		
		document.getElementById("issueStatusTd").innerHTML = newStatus;
		document.getElementById("<%=IssueServlet.ISSUE_SET_STATUS%>").value = newStatusCode;
		document.getElementById("<%=IssueServlet.ISSUE_STATUS_TRANSITION%>").value = transitionCode;
		return;
	}
	
	function validate() {
		return true;
		
		if (document.getElementById("<%=IssueServlet.ISSUE_SET_SUMMARY%>").value == "") {
			document.getElementById("editErr").innerHTML = "Issue summary required";
			return false;				
		}		

		if (document.getElementById("<%=IssueServlet.ISSUE_SET_DESCRIPTION%>").value == "") {
			document.getElementById("editErr").innerHTML = "Issue description required";
			return false;				
		}		
		
		document.getElementById("editErr").innerHTML = "";	
		
		return true;
	}
	
	function setProjStatus(project, status) {
		var transCode = projects[project.value].statuses
					.filter(function(obj) {
						return obj.code == status.value;
					});
		
		if (transCode.length > 0) {
			document.getElementById("<%=IssueServlet.ISSUE_PROJECT_TRANSITION%>").value = transCode[0].transCode;		
		} else {
			document.getElementById("<%=IssueServlet.ISSUE_PROJECT_TRANSITION%>").value = "";					
		}
	}

	function setProjStatusList(project, status) {
		status.innerHTML = "";

		var def = document.createElement("option");
		def.selected = "selected";
		def.disabled = "disabled";
		status.appendChild(def);

		if (project.value != null) {
			var list = projects[project.value].statuses;
			for ( var i = 0; i < list.length; i++) {
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
		disableButton("button_<%=Util.replaceStr(statusTransitions[i].code)%>");
		<%
			}
		%>
		disableButton("moveButton");
		addEditElements(disableMove);

		var buttonDiv = document.getElementById("issueCommitButtonsDiv");
		
		var hiddenTransitionCode = document.createElement("input");
		hiddenTransitionCode.type = "hidden";
		hiddenTransitionCode.name = "<%=IssueServlet.ISSUE_PROJECT_TRANSITION%>";
		hiddenTransitionCode.id = "<%=IssueServlet.ISSUE_PROJECT_TRANSITION%>";
		buttonDiv.appendChild(hiddenTransitionCode);	
		
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
		selectStatus.onchange = function() { setProjStatus(selectProj, selectStatus);};
	}
	
	function disableMove() {
		<%
		for (int i = 0; i < statusTransitions.length; i++) {
		%>
		enableButton("button_<%=Util.replaceStr(statusTransitions[i].code)%>");
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
	
	function validateComment() {
//		return true;
		
		var comment = document.getElementById("addRegularCommentArea").value;
		if (comment == "") {
			document.getElementById("commentErr").innerHTML = "Comment required";
			return false;
		}
		if (comment.length > 4000) {
			document.getElementById("commentErr").innerHTML = "Maximum comment length is 4000 characters";			
			return false;
		}
		
		document.getElementById("commentErr").innerHTML = "";
		return true;
	}
	</script>
	<div>
		<div class="linkToEdit">
			<a href="<%=searchReturnURL%>">Back to search</a>
		</div>
		<div>
			<p class="issueName">
				<%=Util.replaceHTML(issue.projectDisplay)%>
				/
				<%=Util.replaceHTML(issue.idt)%>
			</p>
		</div>
		<div class="summary" id="issueSummary"></div>
	</div>
	<div id="generalErr" class="dialogErr"></div>
	<div class="buttons">
		<%
			for (int i = 0; i < statusTransitions.length; i++) {
		%>
		<button class="buttonFixed" id="button_<%=Util.replaceStr(statusTransitions[i].code)%>"
			onclick="enableEdit('<%=Util.replaceStr1(statusTransitions[i].statusTo)%>', 
				'<%=Util.replaceStr1(statusTransitions[i].statusToDisplay)%>',
				'<%=Util.replaceStr1(statusTransitions[i].code)%>')">
		<%=Util.replaceHTML(statusTransitions[i].name)%>
		</button>
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
						<td class="commentTableAuthor"><%=Util.replaceHTML(comments[i].authorDisplay)%></td>
						<td class="commentTableDate" colspan="2"><%=dateFormat.format(comments[i].dateCreated)%></td>
					</tr>
					<%
						if (!"".equals(Util.nvl(comments[i].statusTransitionDisplay))) {
					%>
					<tr>
						<td class="commentTableParm">Action</td>
						<td class="commentTableParmVal">
							<%=Util.replaceHTML(comments[i].statusTransitionDisplay)%>
						</td>						
						<td class="commentTableParmVal">
						</td>						
					</tr>
					<%
						}
					%>
					<%
						if (!Util.stringEquals(comments[i].before.idt, comments[i].after.idt)) {
					%>
					<tr>
						<td class="commentTableParm">Identifier</td>
						<td class="commentTableParmVal">
							<del><%=Util.replaceHTML(comments[i].before.idt)%></del>
						</td>						
						<td class="commentTableParmVal">
							<%=Util.replaceHTML(comments[i].after.idt)%>
						</td>						
					</tr>
					<%
						}
					%>
					<%
						if (!Util.stringEquals(comments[i].before.projectDisplay, comments[i].after.projectDisplay)) {
					%>
					<tr>
						<td class="commentTableParm">Project</td>
						<td class="commentTableParmVal">
							<del><%=Util.replaceHTML(comments[i].before.projectDisplay)%></del>
						</td>						
						<td class="commentTableParmVal">
							<%=Util.replaceHTML(comments[i].after.projectDisplay)%>
						</td>						
					</tr>
					<%
						}
					%>
					<%
						if (!Util.stringEquals(comments[i].before.kindDisplay, comments[i].after.kindDisplay)) {
					%>
					<tr>
						<td class="commentTableParm">Issue type</td>
						<td class="commentTableParmVal">
							<del><%=Util.replaceHTML(comments[i].before.kindDisplay)%></del>
						</td>						
						<td class="commentTableParmVal">
							<%=Util.replaceHTML(comments[i].after.kindDisplay)%>
						</td>						
					</tr>
					<%
						}
					%>
					<%
						if (!Util.stringEquals(comments[i].before.statusDisplay, comments[i].after.statusDisplay)) {
					%>
					<tr>
						<td class="commentTableParm">Issue status</td>
						<td class="commentTableParmVal">
							<del><%=Util.replaceHTML(comments[i].before.statusDisplay)%></del>
						</td>						
						<td class="commentTableParmVal">
							<%=Util.replaceHTML(comments[i].after.statusDisplay)%>
						</td>						
					</tr>
					<%
						}
					%>
					<%
						if (!Util.stringEquals(comments[i].before.assigneeDisplay, comments[i].after.assigneeDisplay)) {
					%>
					<tr>
						<td class="commentTableParm">Assignee</td>
						<td class="commentTableParmVal">
							<del><%=Util.replaceHTML(comments[i].before.assigneeDisplay)%></del>
						</td>						
						<td class="commentTableParmVal">
							<%=Util.replaceHTML(comments[i].after.assigneeDisplay)%>
						</td>						
					</tr>
					<%
						}
					%>
					<tr>
						<td class="commentTableText" colspan="3"><%=Util.replaceHTML(comments[i].text)%><hr></td>
					</tr>
					<%
						}
					%>
				</table>
				<form id="commentForm" name="commentForm"
					action="<%=IssueServlet.SERVLET_IDT%>" method="post"
					onsubmit="return validateComment()">
					<input type="hidden" name="<%=IssueServlet.RETURN_URL%>" value="<%=returnTo%>"/>
					<input type="hidden" name="<%=IssueServlet.ISSUE_GET_KEY_PARM%>" value="<%=Util.replaceStr(issue.idt)%>"></input>
					<div>
						<p>
							<textarea id="addRegularCommentArea"
								name="<%=IssueServlet.ISSUE_ADD_COMMENT%>" rows="6"
								class="commentText"></textarea>
						</p>
					</div>
					<div id="commentErr" class="dialogErr"></div>
					<div class="postComment">
						<p>
							<input id="addRegularCommentButton" type="submit"
								name="<%=IssueServlet.ISSUE_COMMENT_WEBSERVICE%>" value="Add"
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
