package ru.ifmo.is.servlet;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.manager.AuthenticationManager;

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

	// cookies
	public static final String LOGIN_TOKEN_COOKIE = "PATHFINDER_USER_TOKEN";
	public static final int LOGIN_COOKIE_EXPIRE = 86400;

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ServletContext context = getServletContext();

		if (request.getParameter(LOGIN_WEBSERVICE) != null) {
			AuthenticationManager auth = new AuthenticationManager();

			String errMsg = auth.authenticate(
					request.getParameter(LOGIN_USERNAME_ATTR),
					request.getParameter(LOGIN_PASSWORD_ATTR), request,
					response);

			if (errMsg != null) {
				request.setAttribute(LOGIN_ERR_ATTR, errMsg);
				context.getRequestDispatcher(LOGIN_PAGE).forward(request,
						response);
			} else {
				context.getRequestDispatcher(INDEX_PAGE).forward(request,
						response);
			}
			return;
		}
		context.getRequestDispatcher(INDEX_PAGE).forward(request,
				response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		getServletContext().getRequestDispatcher(LOGIN_PAGE).forward(request,
				response);
	}
}
