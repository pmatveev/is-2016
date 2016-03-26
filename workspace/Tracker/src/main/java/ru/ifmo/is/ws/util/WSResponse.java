package ru.ifmo.is.ws.util;

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
