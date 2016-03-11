<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Admin tools</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body>
	<%
		request.setAttribute(LoginServlet.LOGIN_AUTH_ADMIN_REQUIRED, true);
		LogManager.log("GET adminHome.jsp", request);
	%>
	<%@ include file="include/logout.jsp"%>
	<%@ include file="include/adminLeftMenu.jsp"%>
</body>
</html>