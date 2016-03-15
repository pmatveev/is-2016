package ru.ifmo.is.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.LogManager;
import ru.ifmo.is.manager.ProjectManager;

@SuppressWarnings("serial")
public class ProjectServlet extends HttpServlet {
	// servlet IDT
	public static final String SERVLET_IDT = "/Tracker/project";

	// pages
	public static final String PROJECT_EDIT = "/pages/project.jsp?prjts=true";

	// services
	public static final String PROJECT_SUBMIT_WEBSERVICE = "projectSubmitService";

	// in GET parameters
	public static final String PROJECT_KEY = "projectKey";

	// in POST parameters
	public static final String SET_PROJECT_NAME = "setProjectName";
	public static final String SET_PROJECT_KEY = "setProjectKey";
	public static final String SET_PROJECT_OWNER = "setProjectOwner";
	public static final String SET_PROJECT_JSON = "setProjectJSON";

	// out parameters
	public static final String PROJECT_ERROR = "projectError";

	private void alterProjectReturn(HttpServletRequest request,
			HttpServletResponse response, String errMsg) throws IOException {
		request.getSession().setAttribute(PROJECT_SUBMIT_WEBSERVICE, "error");
		request.getSession().setAttribute(PROJECT_ERROR, errMsg);
		request.getSession().setAttribute(SET_PROJECT_KEY,
				request.getParameter(SET_PROJECT_KEY));
		request.getSession().setAttribute(SET_PROJECT_NAME,
				request.getParameter(SET_PROJECT_NAME));
		request.getSession().setAttribute(SET_PROJECT_OWNER,
				request.getParameter(SET_PROJECT_OWNER));
		request.getSession().setAttribute(SET_PROJECT_JSON,
				request.getParameter(SET_PROJECT_JSON));

		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}

	private void alterProject(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String code = request.getParameter(SET_PROJECT_KEY);
		String name = request.getParameter(SET_PROJECT_NAME);
		String owner = request.getParameter(SET_PROJECT_OWNER);
		String json = request.getParameter(SET_PROJECT_JSON);

		String result = new ProjectManager().alterProcess(code, name, owner,
				json);
		if (result != null && result.startsWith("E:")) {
			alterProjectReturn(request, response, result.substring(2));
			return;
		}
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("POST ProjectServlet", request);

		// verify login information
		if (!new AuthenticationManager().verify(request, response)) {
			return;
		}

		if (request.getParameter(PROJECT_SUBMIT_WEBSERVICE) != null) {
			alterProject(request, response);
			return;
		}

		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
}
