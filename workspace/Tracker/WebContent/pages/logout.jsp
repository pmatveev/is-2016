<%@page import="ru.ifmo.is.util.Pair"%>
<%@page import="ru.ifmo.is.manager.AuthenticationManager"%>
<%@page import="ru.ifmo.is.servlet.LoginServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<div class="header">
	<%
		new AuthenticationManager().verify(request, response);
	%>
	You are logged in as
	<%=request.getAttribute(LoginServlet.LOGIN_AUTH_DISPLAYNAME) +
	(true == (Boolean) request.getAttribute(LoginServlet.LOGIN_AUTH_USER_ADMIN) ? " (administrator)." : ".")%> <a
		href="<%=LoginServlet.SERVLET_IDT%>?action=logout">Logout</a>
</div>
<hr />