<%@page import="ru.ifmo.is.db.data.Issue"%>
<%@page import="ru.ifmo.is.util.LogLevel"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Tracker</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body>
	<%@ include file="logout.jsp"%>
	<% LogManager.log("GET index.jsp", request); %>
	index.jsp
	<br /> <br /> For testing purposes:
	<br /> <a href="/Tracker/pages/issue.jsp?<%=Issue.ISSUE_KEY_PARM%>=SANDBOX-1">SANDBOX-1</a>
	<br /> <a href="/Tracker/pages/issue.jsp?<%=Issue.ISSUE_KEY_PARM%>=SANDBOX-412">SANDBOX-412</a>
</body>
</html>