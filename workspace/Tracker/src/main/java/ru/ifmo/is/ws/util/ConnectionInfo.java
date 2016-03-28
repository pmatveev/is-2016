package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

public class ConnectionInfo {
	private String system;
	private String token;

	@XmlElement(required = true)
	public String getSystem() {
		return system;
	}

	@XmlElement(required = true)
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
