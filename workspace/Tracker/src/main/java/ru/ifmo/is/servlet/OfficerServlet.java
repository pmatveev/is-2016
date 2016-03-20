package ru.ifmo.is.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.LogManager;

@SuppressWarnings("serial")
public class OfficerServlet extends HttpServlet {
	// servlet IDT
	public static final String SERVLET_IDT = "/Tracker/officer";

	// pages
	public static final String GRANT_EDIT = "/pages/grant.jsp";

	// services
	public static final String GRANT_ADD_WEBSERVICE = "addGrantService";
	public static final String GRANT_SET_WEBSERVICE = "setGrantService";

	// in POST parameters
	public static final String SET_GRANT_ADMIN = "setGrantAdmin";
	public static final String SET_GRANT_NAME = "setGrantName";
	public static final String FOR_OFFICER_GROUP = "forOfficerGroup";
	public static final String FOR_OFFICER = "forOfficer";
	public static final String SET_GRANT_LIST = "setGrantList";
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("POST OfficerServlet", request);

		// verify login information
		if (!new AuthenticationManager().verify(request, response)) {
			return;
		}

		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}	
}
