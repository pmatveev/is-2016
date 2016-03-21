package ru.ifmo.is.servlet;

import java.io.IOException;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.LogManager;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

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
	
	// out parameters
	public static final String GRANT_ERROR = "grantError";

	private void addGrantReturn(HttpServletRequest request,
			HttpServletResponse response, String errMsg)
			throws ServletException, IOException {
		request.getSession().setAttribute(GRANT_ADD_WEBSERVICE, "error");
		request.getSession().setAttribute(SET_GRANT_ADMIN, 
				request.getParameter(SET_GRANT_ADMIN));
		request.getSession().setAttribute(SET_GRANT_NAME, 
				request.getParameter(SET_GRANT_NAME));
		request.getSession().setAttribute(GRANT_ERROR, errMsg);
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}

	private void addGrant(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		Boolean admin = "on".equals(request.getParameter(SET_GRANT_ADMIN));
		String name = request.getParameter(SET_GRANT_NAME);
		
		Object[] res = null;
		try {
			res = new StatementExecutor().call(
					"? = call add_officer_grant(?, ?, ?)", 
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, name.toUpperCase().replace(" ", "_")),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, name),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_BOOL, admin));
		} catch (IOException e) {
			LogManager.log(e);
			addGrantReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}		
		
		if (res.length == 0) {
			addGrantReturn(request, response, "Service failed: no response from DB");
			return;			
		}
		
		String message = (String) res[0];
		if (message != null) {
			addGrantReturn(request, response, message);
			return;				
		}
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
	
	private void setGrantsReturn(HttpServletRequest request,
			HttpServletResponse response, String errMsg)
			throws ServletException, IOException {
		request.getSession().setAttribute(GRANT_SET_WEBSERVICE, "error");
		request.getSession().setAttribute(FOR_OFFICER_GROUP, 
				request.getParameter(FOR_OFFICER_GROUP));
		String forOfficer = request.getParameter(FOR_OFFICER);
		if (!"".equals(forOfficer)) {
			request.getSession().setAttribute(FOR_OFFICER, 
					forOfficer);
		}
		request.getSession().setAttribute(SET_GRANT_LIST, 
				request.getParameter(SET_GRANT_LIST));
		request.getSession().setAttribute(GRANT_ERROR, errMsg);
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}

	private void setGrants(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {	
		String groupFor = request.getParameter(FOR_OFFICER_GROUP);
		String officerFor = request.getParameter(FOR_OFFICER);
		String grantList = request.getParameter(SET_GRANT_LIST);
		
		if (!"".equals(officerFor)) {
			groupFor = null;
		}

		StatementExecutor db = new StatementExecutor();
		try {
			db.startTransaction();
			
			db.call("? = call clear_grants(?, ?)", 
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, officerFor),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, groupFor));
			
			int delimiter = grantList.indexOf(',');
			while (delimiter > -1) {
				String grant = grantList.substring(0, delimiter);
				
				db.call("? = call grant_officer(?, ?, ?)", 
						new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
						new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, officerFor),
						new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, groupFor),
						new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, grant));
				
				grantList = grantList.substring(delimiter + 1);
				delimiter = grantList.indexOf(',');
			}
		} catch (Exception e) {
			db.rollbackTransaction();
			setGrantsReturn(request, response, "Service failed: " + e.getMessage());
			return;
		}
		db.commitTransaction();
		
		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LogManager.log("POST OfficerServlet", request);

		// verify login information
		if (!new AuthenticationManager().verify(request, response)) {
			return;
		}

		if (request.getParameter(GRANT_ADD_WEBSERVICE) != null) {
			addGrant(request, response);
			return;
		}
		
		if (request.getParameter(GRANT_SET_WEBSERVICE) != null) {
			setGrants(request, response);
			return;
		}

		response.sendRedirect(LoginServlet.getReturnAddress(request));
	}
}
