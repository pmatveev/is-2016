<%@page import="ru.ifmo.is.LoginServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	String username = (String) request.getAttribute(LoginServlet.AUTH_USERNAME_ATTR);
	
	if (username == null) {
		response.sendRedirect("/Tracker" + LoginServlet.LOGIN_PAGE);
	}
%>
You are logged in as <%=username%>.<hr/><br/>
</body>
</html>