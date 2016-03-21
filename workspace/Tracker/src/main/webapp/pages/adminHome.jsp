<%@page import="ru.ifmo.is.manager.LogManager"%>
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
	<% LogManager.log("GET adminHome.jsp", request); %>
	<%@ include file="include/adminLeftMenu.jsp"%>
</body>
</html>