package ru.ifmo.is.db.entity;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "issue_status")
public class IssueStatus {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private long id;

	@Column(name = "name", length = 32, nullable = false)
	private String name;

	@Column(name = "code", length = 32, nullable = false)
	private String code;

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getCode() {
		return code;
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
	
	public IssueStatus() {
	}

	public IssueStatus(String name, String code) {
		this.name = name;
		this.code = code;
	}
}