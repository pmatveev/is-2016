package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

import ru.ifmo.is.manager.util.AuthenticationInfo;

@XmlRootElement
@XmlSeeAlso({
	AuthenticationInfo.class,
	IssuePageWrapper.class,
	IssueWrapper.class,
	CommentListWrapper.class,
	IssueStatusTransitionListWrapper.class,
	IssueProjectTransitionListWrapper.class,
	IssueProjectListWrapper.class
})
public class WSResponse<T> {
	private String errorMessage;

	private T response;

	public String getErrorMessage() {
		return errorMessage;
	}

	public T getResponse() {
		return response;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public void setResponse(T response) {
		this.response = response;
	}

	public WSResponse(String errorMessage, T response) {
		this.errorMessage = errorMessage;
		this.response = response;
	}

	public WSResponse() {
	}
}
