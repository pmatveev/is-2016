package ru.ifmo.is.db.entity;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "status_transition")
public class IssueStatusTransition {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "issue_project__id", nullable = false)
	private IssueProject project;
	
	@ManyToOne(fetch = FetchType.LAZY, optional = true, cascade = CascadeType.ALL)
	@JoinColumn(name = "status_from", nullable = true)
	private IssueStatus statusFrom;
	
	@ManyToOne(fetch = FetchType.EAGER, optional = true, cascade = CascadeType.ALL)
	@JoinColumn(name = "status_to", nullable = true)
	private IssueStatus statusTo;
	
	@Column(name = "name", length = 32, nullable = false)
	private String name;
	
	@Column(name = "code", length = 255, nullable = false)
	private String code;

	@Column(name = "is_active", columnDefinition = "BIT", length = 1, nullable = false)
	private Boolean isActive;
	
	public IssueStatusTransition() {
	}

	public IssueStatusTransition(
			IssueProject project, 
			IssueStatus statusFrom,
			IssueStatus statusTo, 
			String name, 
			String code,
			Boolean isActive) {
		this.project = project;
		this.statusFrom = statusFrom;
		this.statusTo = statusTo;
		this.name = name;
		this.code = code;
		this.isActive = isActive;
	}

	public Long getId() {
		return id;
	}

	public IssueProject getProject() {
		return project;
	}

	public IssueStatus getStatusFrom() {
		return statusFrom;
	}

	public IssueStatus getStatusTo() {
		return statusTo;
	}

	public String getName() {
		return name;
	}

	public String getCode() {
		return code;
	}
	
	public Boolean isActive() {
		return isActive;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setProject(IssueProject project) {
		this.project = project;
	}

	public void setStatusFrom(IssueStatus statusFrom) {
		this.statusFrom = statusFrom;
	}

	public void setStatusTo(IssueStatus statusTo) {
		this.statusTo = statusTo;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}
	
	public void setActive(Boolean isActive) {
		this.isActive = isActive;
	}
}
