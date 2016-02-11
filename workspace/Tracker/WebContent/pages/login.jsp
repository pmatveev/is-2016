<%@page import="ru.ifmo.is.LoginServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Tracker</title>
<link rel='stylesheet' href='/pages/default.css'></link>
</head>
<body>
	<form action="/Tracker/login" method="post">
		<table>
			<tr>
				<td>Login</td>
				<td><input type="text" name="<%=LoginServlet.LOGIN_USERNAME_ATTR%>" /></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password" name="<%=LoginServlet.LOGIN_PASSWORD_ATTR%>" /></td>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit" name="<%=LoginServlet.LOGIN_WEBSERVICE%>" value="Login"
					class="button" /></td>
			</tr>
		</table>
	</form>
	<%
		String error = (String) request.getAttribute(LoginServlet.LOGIN_ERR_ATTR);
			if (error != null) {
		out.print(error);
			}
	%>
</body>
</html>