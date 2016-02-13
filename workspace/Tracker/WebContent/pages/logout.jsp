<%@page import="ru.ifmo.is.util.Pair"%>
<%@page import="ru.ifmo.is.manager.AuthenticationManager"%>
<%@page import="ru.ifmo.is.servlet.LoginServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div class="header">
		<%
			Pair<String, String> user = new AuthenticationManager().verify(
					request, response);
			if (user.first == null) {
				// not authenticated
				response.sendRedirect("/Tracker" + LoginServlet.LOGIN_PAGE);
			}
		%>
		You are logged in as
		<%=user.second%>. <a href="<%=LoginServlet.SERVLET_IDT%>?action=logout">Exit</a>
	</div>
	<hr />
</body>
</html>