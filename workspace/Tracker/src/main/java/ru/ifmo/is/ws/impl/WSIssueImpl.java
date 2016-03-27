package ru.ifmo.is.ws.impl;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.IssueManager;
import ru.ifmo.is.manager.util.AuthenticationInfo;
import ru.ifmo.is.ws.WSIssue;
import ru.ifmo.is.ws.util.ConnectionInfo;
import ru.ifmo.is.ws.util.IssuePageWrapper;
import ru.ifmo.is.ws.util.WSResponse;

@WebService(endpointInterface = "ru.ifmo.is.ws.WSIssue")
public class WSIssueImpl implements WSIssue {
	@Override
	@WebMethod(operationName = "getLike")
	public WSResponse<IssuePageWrapper> getLike(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "from") int from, @WebParam(name = "num") int num,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "summary") String summary,
			@WebParam(name = "project") String project,
			@WebParam(name = "kind") String kind,
			@WebParam(name = "status") String status,
			@WebParam(name = "creator") String creator,
			@WebParam(name = "assignee") String assignee,
			@WebParam(name = "createdOrder") String createdOrder,
			@WebParam(name = "updatedOrder") String updatedOrder) {
		try {
			AuthenticationInfo auth = new AuthenticationManager().verify(
					connection.getToken(), connection.getSystem());
			
			if (auth == null) {
				return new WSResponse<IssuePageWrapper>("Authentication failed", null);
			}

			IssuePageWrapper wrapped = new IssuePageWrapper(
					new IssueManager().selectLike(from, num, idt, summary,
							project, kind, status, creator, assignee,
							createdOrder, updatedOrder));
			
			return new WSResponse<IssuePageWrapper>(null, wrapped);
		} catch (Throwable e) {
			return new WSResponse<IssuePageWrapper>(e.getMessage(), null);
		}
	}
}
