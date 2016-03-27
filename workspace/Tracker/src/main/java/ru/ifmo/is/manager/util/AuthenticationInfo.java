package ru.ifmo.is.manager.util;

public class AuthenticationInfo {
	private String username;
	private String displayName;
	private Boolean isAdmin;

	public String getUsername() {
		return username;
	}

	public String getDisplayName() {
		return displayName;
	}

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
