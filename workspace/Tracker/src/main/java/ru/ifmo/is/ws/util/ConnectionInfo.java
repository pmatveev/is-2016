package ru.ifmo.is.ws.util;

public class ConnectionInfo {
	private String system;
	private String token;

	public String getSystem() {
		return system;
	}

	public String getToken() {
		return token;
	}

	public void setSystem(String system) {
		this.system = system;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public ConnectionInfo(String system, String token) {
		this.system = system;
		this.token = token;
	}

	public ConnectionInfo() {
	}
}
