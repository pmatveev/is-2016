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
	String issueKey = (String) request
			.getParameter(Issue.ISSUE_KEY_PARM);
	Issue issue = null;
	// here to retrieve issue detailed information
	if ("SANDBOX-412".equals(issueKey)) {
		issue = new Issue(
				1,
				"SANDBOX-412",
				1,
				"Test admin",
				1,
				"Test admin",
				1,
				"Verification",
				1,
				"Open",
				1,
				"Sandbox testing",
				new Date(2015, 12, 23, 16, 7, 46),
				new Date(2016, 2, 13, 11, 48, 1),
				"Please verify issue details page",
				"Here we have multiline description. <br/>"
						+ "We expect it to work fine. Please verify, wouldn't you? Really appreciate it.",
				null);
	}
	Comment[] comments = new Comment[3];
	for (int i=0;i!=2;i++)
	{
		comments[i] = new Comment(
				i,
				1,
				"Test admin",
				new Date(2016,1,15,14,34,5),
				"comment" + Integer.toString(i)
				);
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><%=issue == null ? "Issue not found" : issue.summary%></title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body>
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
	<div>
		<p id="issueName">Issue "<%=issue.idt%>" </p>
		<p id="issueID">ID: <%=issue.id%></p>
	</div>
	<hr>
	<div>
		<div align="right" id="linkToEdit">
			<a href="">Edit</a> <!-- link to create.jsp -->
		</div>
		<div id="issueBriefInfo">
		<h1 id="briefInformation">Brief information</h1>
		 <table id="briefInfoTable">
		  <tr class="widthTr">
		  	<td class="widthTd">Issue kind:</td> <td><%=issue.kindDisplay%></td>
		  </tr>
		  <tr>
		  	<td class="widthTd">Status:</td> <td><%=issue.statusDisplay%></td>
		  </tr>
		  <tr>
		  	<td class="widthTd">Reporter:</td> <td><%=issue.creatorDisplay%></td>
		  </tr>
		  <tr>
		  	<td class="widthTd">Assignee:</td> <td><%=issue.assigneeDisplay%></td>
		  </tr>
		  <tr>
		  	<td class="widthTd">Date of created:</td> <td><%=issue.dateCreated%></td>
		  </tr>
		  <tr>
		  	<td class="widthTd">Last updated:</td> <td><%=issue.dateUpdated%></td>
		  </tr>
		 </table>
		</div>
		<div id="divComments">
		</div>
		<div class="clear">
			<h1 class="issueHeader">Description</h1>
		</div>
		<div class="issueDescription">
			<%=issue.description%>
		</div>
		<div class="clear">
			<h1 class="issueHeader">Resolution</h1>
		</div>
		<%if (issue.resolution == null) {%>
		<div id="noResolution"> There is no resolution </div>
		<%} else { %>
		<div class="issueDescription">
			<%=issue.resolution%>
		</div>
	<% } %>
	</div>
	<%
		}
	%>
</body>
</html>
