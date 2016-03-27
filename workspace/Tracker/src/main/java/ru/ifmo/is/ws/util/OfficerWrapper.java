package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.Officer;

public class OfficerWrapper {
	private String username;
	private Boolean isActive;
	private String credentials;

	public OfficerWrapper() {
	}
	
	public OfficerWrapper(Officer officer) {
		this.username = officer.getUsername();
		this.isActive = officer.isActive();
		this.credentials = officer.getCredentials();
	}

	@XmlElement
	public String getUsername() {
		return username;
	}

	@XmlElement(name = "is-active")
	public Boolean getIsActive() {
		return isActive;
	}

	@XmlElement
	public String getCredentials() {
		return credentials;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public void setCredentials(String credentials) {
		this.credentials = credentials;
	}
}
