<%@page import="ru.ifmo.is.manager.AuthenticationManager"%>
<%@page import="ru.ifmo.is.util.Pair"%>
<%@page import="ru.ifmo.is.servlet.LoginServlet"%>
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
	<%
		// verify if already logged in -> then redirect to index.jsp
		Pair<String, String> user = new AuthenticationManager()
			.verify(request, response);
		if (user.first != null) {
			response.sendRedirect("/Tracker" + LoginServlet.INDEX_PAGE);
		}
	%>
	<script>
		function validate() {
			if (document.loginform.
	<%=LoginServlet.LOGIN_USERNAME_ATTR%>
		.value == "") {
				document.getElementById("loginErr").innerText = "Username required";
				return false;
			}
			if (document.loginform.
	<%=LoginServlet.LOGIN_PASSWORD_ATTR%>
		.value == "") {
				document.getElementById("loginErr").innerText = "Password required";
				return false;
			}

			document.loginform.getElementById("loginErr").value = "";
			return true;
		}
	</script>

	<form name="loginform" action="<%=LoginServlet.SERVLET_IDT%>"
		method="post" onsubmit="return validate()" class="centered300px">
		<table>
			<tr>
				<td>Login</td>
				<td><input type="text"
					name="<%=LoginServlet.LOGIN_USERNAME_ATTR%>" autofocus class="input" /></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password"
					name="<%=LoginServlet.LOGIN_PASSWORD_ATTR%>" class="input" /></td>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit"
					name="<%=LoginServlet.LOGIN_WEBSERVICE%>" value="Login"
					class="button" /></td>
			</tr>
			<tr>
				<td colspan="2" class="loginerr" id="loginErr">
					<%
						String error = (String) request.getSession().getAttribute(
								LoginServlet.LOGIN_ERR_ATTR);
						request.getSession().removeAttribute(LoginServlet.LOGIN_ERR_ATTR);
						if (error != null) {
							out.print(error);
						}
					%>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>