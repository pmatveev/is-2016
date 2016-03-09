<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="ru.ifmo.is.util.Pair"%>
<%@page import="ru.ifmo.is.manager.AuthenticationManager"%>
<%@page import="ru.ifmo.is.servlet.LoginServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="headerLeft">	
	<a target="_blank" href="/Tracker/pages/report.jsp">Reporting</a>
</div>
<div class="headerRight">
	<%
		LogManager.log("GET logout.jsp", request);
		boolean authenticated = new AuthenticationManager().verify(request, response);
		if (!authenticated) {
			return;
		}
		
		String returnURL = IssueServlet.getReturnAddress(request);
	%>
	You are logged in as
	<%=Util.replaceHTML((String) request.getAttribute(LoginServlet.LOGIN_AUTH_DISPLAYNAME) +
	(new Boolean(true).equals((Boolean) request.getAttribute(LoginServlet.LOGIN_AUTH_USER_ADMIN)) ? " (administrator)." : "."))%> <a
		href="<%=LoginServlet.SERVLET_IDT%>?action=logout">Logout</a>
</div>
<br />
<hr />