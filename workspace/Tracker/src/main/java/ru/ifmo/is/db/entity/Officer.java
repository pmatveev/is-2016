package ru.ifmo.is.db.entity;

import java.util.List;

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
	
	@ManyToOne(fetch = FetchType.LAZY, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "officer_group__id", nullable = false)
	private OfficerGroup group;
	
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "officer_grant_map", 
		joinColumns = { @JoinColumn(name = "officer__id", nullable = true) }, 
		inverseJoinColumns = { @JoinColumn(name = "officer_grant__id", nullable = false) })
	private List<OfficerGrant> grants;	
	
	public Officer() {
	}

	public Officer(
			String username,
			boolean isActive, 
			String passHash, 
			String credentials,
			OfficerGroup group,
			List<OfficerGrant> grants) {
		this.username = username;
		this.isActive = isActive;
		this.passHash = passHash;
		this.credentials = credentials;
		this.group = group;
		this.grants = grants;
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
	
	public OfficerGroup getGroup() {
		return group;
	}
	
	public List<OfficerGrant> getGrants() {
		return grants;
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
	
	public void setGroup(OfficerGroup group) {
		this.group = group;
	}
	
	public void setGrants(List<OfficerGrant> grants) {
		this.grants = grants;
	}
}
