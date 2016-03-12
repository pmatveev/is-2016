package ru.ifmo.is.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class ProjectServlet extends HttpServlet {
	// servlet IDT
	public static final String SERVLET_IDT = "/Tracker/project";
	
	// in GET parameters
	public static final String PROJECT_KEY = "projectKey";
	
	// in POST parameters
	public static final String SET_PROJECT_NAME = "setProjectName";
	public static final String SET_PROJECT_KEY = "setProjectKey";
	public static final String SET_PROJECT_OWNER = "setProjectOwner";
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}
}
