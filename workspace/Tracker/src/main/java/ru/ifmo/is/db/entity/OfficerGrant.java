package ru.ifmo.is.db.entity;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "officer_grant")
public class OfficerGrant {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private long id;

	@Column(name = "name", length = 32, nullable = false)
	private String name;

	@Column(name = "code", length = 32, nullable = false)
	private String code;
	
	@Column(name = "is_admin", columnDefinition = "BIT", length = 1, nullable = false)
	private boolean isAdmin;
	
	public OfficerGrant() {
	}
	
	public OfficerGrant(String name, String code, boolean isAdmin) {
		this.name = name;
		this.code = code;
		this.isAdmin = isAdmin;
	}

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getCode() {
		return code;
	}

	public boolean isAdmin() {
		return isAdmin;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
}
