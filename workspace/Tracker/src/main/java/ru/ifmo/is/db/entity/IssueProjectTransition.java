package ru.ifmo.is.db.entity;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "project_transition")
public class IssueProjectTransition {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private long id;

	@ManyToOne(fetch = FetchType.LAZY, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "project_from", nullable = false)
	private IssueProject projectFrom;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "project_to", nullable = false)
	private IssueProject projectTo;
	
	@ManyToOne(fetch = FetchType.LAZY, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "status_from", nullable = false)
	private IssueStatus statusFrom;
	
	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "status_to", nullable = false)
	private IssueStatus statusTo;
	
	@Column(name = "code", length = 255, nullable = false)
	private String code;

	@Column(name = "is_active", columnDefinition = "BIT", length = 1, nullable = false)
	private Boolean isActive;
	
	public IssueProjectTransition() {
	}

	public IssueProjectTransition(
			IssueProject projectFrom,
			IssueProject projectTo, 
			IssueStatus statusFrom,
			IssueStatus statusTo, 
			String code,
			Boolean isActive) {
		this.projectFrom = projectFrom;
		this.projectTo = projectTo;
		this.statusFrom = statusFrom;
		this.statusTo = statusTo;
		this.code = code;
		this.isActive = isActive;
	}

	public long getId() {
		return id;
	}

	public IssueProject getProjectFrom() {
		return projectFrom;
	}

	public IssueProject getProjectTo() {
		return projectTo;
	}

	public IssueStatus getStatusFrom() {
		return statusFrom;
	}

	public IssueStatus getStatusTo() {
		return statusTo;
	}

	public String getCode() {
		return code;
	}
	
	public Boolean isActive() {
		return isActive;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setProjectFrom(IssueProject projectFrom) {
		this.projectFrom = projectFrom;
	}

	public void setProjectTo(IssueProject projectTo) {
		this.projectTo = projectTo;
	}

	public void setStatusFrom(IssueStatus statusFrom) {
		this.statusFrom = statusFrom;
	}

	public void setStatusTo(IssueStatus statusTo) {
		this.statusTo = statusTo;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}
}
