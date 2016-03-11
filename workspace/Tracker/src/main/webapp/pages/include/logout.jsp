<%@page import="java.net.URLEncoder"%>
<%@page import="ru.ifmo.is.servlet.IssueServlet"%>
<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="ru.ifmo.is.manager.LogManager"%>
<%@page import="ru.ifmo.is.util.Pair"%>
<%@page import="ru.ifmo.is.manager.AuthenticationManager"%>
<%@page import="ru.ifmo.is.servlet.LoginServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	LogManager.log("GET logout.jsp", request);
	boolean authenticated = new AuthenticationManager().verify(request, response);
	if (!authenticated) {
		return;
	}

	String returnTo = request.getRequestURI() + "?" + Util.nvl(request.getQueryString());
	String returnToStr = URLEncoder.encode(returnTo.toString(), "UTF-8");	
	String returnURL = LoginServlet.getReturnAddress(request);
%>
<div class="headerLeft">	
	<div class="headerLeftLink">
		<a target="_blank" href="/Tracker/pages/report.jsp">Reporting</a>
	</div>
	<% if (Boolean.TRUE.equals(request.getAttribute(LoginServlet.LOGIN_AUTH_USER_ADMIN))) { %>
	<div class="headerLeftLink">
		<a href="/Tracker/pages/adminHome.jsp?<%=LoginServlet.RETURN_URL%>=<%=returnToStr%>">Admin tools</a>
	</div>
	<% } %>
</div>
<div class="headerRight">
	You are logged in as
	<%=Util.replaceHTML((String) request.getAttribute(LoginServlet.LOGIN_AUTH_DISPLAYNAME) +
	(Boolean.TRUE.equals(request.getAttribute(LoginServlet.LOGIN_AUTH_USER_ADMIN)) ? " (administrator)." : "."))%> <a
		href="<%=LoginServlet.SERVLET_IDT%>?action=logout">Logout</a>
</div>
<br />
<hr />