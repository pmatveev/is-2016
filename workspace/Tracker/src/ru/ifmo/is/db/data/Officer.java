package ru.ifmo.is.db.data;

import ru.ifmo.is.db.DataClass;

public class Officer extends DataClass {
	public int id;
	public String username;
	public boolean isActive;
	public String passHash;
	public String credentials;

	public Officer(
			int id, 
			String username, 
			boolean isActive, 
			String passHash,
			String credentials) {
		this.id = id;
		this.username = username;
		this.isActive = isActive;
		this.passHash = passHash;
		this.credentials = credentials;
	}
}
