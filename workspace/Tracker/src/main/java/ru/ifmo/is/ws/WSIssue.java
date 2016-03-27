package ru.ifmo.is.ws;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;

import ru.ifmo.is.ws.util.ConnectionInfo;
import ru.ifmo.is.ws.util.IssuePageWrapper;
import ru.ifmo.is.ws.util.WSResponse;

@WebService
@SOAPBinding(style = Style.RPC)
public interface WSIssue {
	@WebMethod(operationName = "getLike")
	public WSResponse<IssuePageWrapper> getLike(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "from") int from,
			@WebParam(name = "num") int num,
			@WebParam(name = "idt") String idt, 
			@WebParam(name = "summary") String summary, 
			@WebParam(name = "project") String project,
			@WebParam(name = "kind") String kind, 
			@WebParam(name = "status") String status, 
			@WebParam(name = "creator") String creator, 
			@WebParam(name = "assignee") String assignee,
			@WebParam(name = "createdOrder") String createdOrder,
			@WebParam(name = "updatedOrder") String updatedOrder);
}
