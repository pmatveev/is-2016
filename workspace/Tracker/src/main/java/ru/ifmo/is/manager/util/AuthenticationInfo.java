package ru.ifmo.is.manager.util;

import javax.xml.bind.annotation.XmlElement;

public class AuthenticationInfo {
	private String username;
	private String displayName;
	private Boolean isAdmin;

	@XmlElement
	public String getUsername() {
		return username;
	}

	@XmlElement(name = "display-name")
	public String getDisplayName() {
		return displayName;
	}

	@XmlElement(name = "admin")
	public Boolean isAdmin() {
		return isAdmin;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public void setAdmin(Boolean isAdmin) {
		this.isAdmin = isAdmin;
	}

	public AuthenticationInfo(String username, String displayName,
			Boolean isAdmin) {
		this.username = username;
		this.displayName = displayName;
		this.isAdmin = isAdmin;
	}

	public AuthenticationInfo() {
	}
}
