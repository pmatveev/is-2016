package ru.ifmo.is;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class LoginServlet extends HttpServlet {
	public static final String LOGIN_PAGE = "/pages/login.jsp";
	public static final String INDEX_PAGE = "/pages/index.jsp";

	// common out parameters
	public static final String AUTH_USERNAME_ATTR = "authUsername";

	// LOGIN
	public static final String LOGIN_WEBSERVICE = "loginSubmit";

	// in parameters
	public static final String LOGIN_USERNAME_ATTR = "username";
	public static final String LOGIN_PASSWORD_ATTR = "password";

	// out parameters
	public static final String LOGIN_ERR_ATTR = "loginErr";

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ServletContext context = getServletContext();
		String username = null;

		if (request.getParameter(LOGIN_WEBSERVICE) != null) {
			username = verifyLogin(request, response);
			if (username == null) {
				context.getRequestDispatcher(LOGIN_PAGE).forward(request,
						response);
			} else {
				context.getRequestDispatcher(INDEX_PAGE).forward(request,
						response);
			}
			return;
		}
	}

	private String verifyLogin(HttpServletRequest request,
			HttpServletResponse response) {
		String username = request.getParameter(LOGIN_USERNAME_ATTR);
		String password = request.getParameter(LOGIN_PASSWORD_ATTR);

		if (username == null || password == null || username.length() == 0
				|| password.length() == 0) {
			request.setAttribute(LOGIN_ERR_ATTR, "Login and password required");
			return null;
		}

		request.setAttribute(AUTH_USERNAME_ATTR, username);
		return username;
	}
}
