package ru.ifmo.is.ws;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;

import ru.ifmo.is.ws.util.CommentListWrapper;
import ru.ifmo.is.ws.util.ConnectionInfo;
import ru.ifmo.is.ws.util.IssuePageWrapper;
import ru.ifmo.is.ws.util.IssueProjectListWrapper;
import ru.ifmo.is.ws.util.IssueProjectTransitionListWrapper;
import ru.ifmo.is.ws.util.IssueStatusTransitionListWrapper;
import ru.ifmo.is.ws.util.IssueWrapper;
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
			@WebParam(name = "created-order") String createdOrder,
			@WebParam(name = "updated-order") String updatedOrder);

	@WebMethod(operationName = "get")
	public WSResponse<IssueWrapper> get(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt);

	@WebMethod(operationName = "getComments")
	public WSResponse<CommentListWrapper> getComments( 
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "issue-id") Long id);

	@WebMethod(operationName = "getAvailableStatusTransitions")
	public WSResponse<IssueStatusTransitionListWrapper> getStatusTransitionsAvailable(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "issue-id") Long id);

	@WebMethod(operationName = "getAvailableProjectTransitions")
	public WSResponse<IssueProjectTransitionListWrapper> getProjectTransitionsAvailable(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "issue-id") Long id);
	
	@WebMethod(operationName = "getAvailableProjects")
	public WSResponse<IssueProjectListWrapper> getProjectsAvailable(
			@WebParam(name = "connection") ConnectionInfo connection);
	
	@WebMethod(operationName = "create")
	public WSResponse<String> create(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "creator") String creator, 
			@WebParam(name = "project") String project, 
			@WebParam(name = "kind") String kind,
			@WebParam(name = "summary") String summary, 
			@WebParam(name = "description") String description);
	
	@WebMethod(operationName = "addIssueComment")
	public WSResponse<Void> addComment(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "comment") String comment);
	
	@WebMethod(operationName = "transitIssue")
	public WSResponse<Void> issueStatusTransit(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "transition") String transition,
			@WebParam(name = "summary") String summary,
			@WebParam(name = "assignee") String assignee,
			@WebParam(name = "kind") String kind,
			@WebParam(name = "description") String descr,
			@WebParam(name = "resolution") String resol,
			@WebParam(name = "comment") String comment);
	
	@WebMethod(operationName = "moveIssue")
	public WSResponse<String> issueProjectTransit(
			@WebParam(name = "connection") ConnectionInfo connection,
			@WebParam(name = "idt") String idt,
			@WebParam(name = "transition") String transition,
			@WebParam(name = "comment") String comment);
}
