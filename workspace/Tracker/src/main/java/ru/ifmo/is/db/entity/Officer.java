package ru.ifmo.is.db.entity;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "officer")
public class Officer {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private long id;

	@Column(name = "username", length = 32, nullable = false)
	private String username;

	@Column(name = "is_active", columnDefinition = "BIT", length = 1, nullable = false)
	private boolean isActive;

	@Column(name = "passhash", length = 32, nullable = false)
	private String passHash;

	@Column(name = "credentials", length = 32, nullable = false)
	private String credentials;
	
	public Officer() {
	}

	public Officer(
			String username,
			boolean isActive, 
			String passHash, 
			String credentials) {
		this.username = username;
		this.isActive = isActive;
		this.passHash = passHash;
		this.credentials = credentials;
	}

	public long getId() {
		return id;
	}

	public String getUsername() {
		return username;
	}

	public boolean isActive() {
		return isActive;
	}

	public String getPassHash() {
		return passHash;
	}

	public String getCredentials() {
		return credentials;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public void setPassHash(String passHash) {
		this.passHash = passHash;
	}

	public void setCredentials(String credentials) {
		this.credentials = credentials;
	}
}
