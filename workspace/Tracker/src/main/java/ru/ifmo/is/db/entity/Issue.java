package ru.ifmo.is.db.entity;

import java.util.Date;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "issue")
public class Issue {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private long id;

	@Column(name = "idt", length = 32, nullable = false)
	private String idt;
	
	@Column(name = "active", columnDefinition = "bit", length = 1, nullable = false)
	private boolean active;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "creator", nullable = false)
	private Officer creator;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "assignee", nullable = false)
	private Officer assignee;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "kind", nullable = false)
	private IssueKind kind;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "status", nullable = false)
	private IssueStatus status;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "project", nullable = false)
	private IssueProject project;

	@Column(name = "prev_issue", columnDefinition = "int", length = 18, nullable = true)
	private Long prevIssue;
	
	@Column(name = "date_created", columnDefinition = "datetime", nullable = false)
	private Date dateCreated;
	
	@Column(name = "date_updated", columnDefinition = "datetime", nullable = false)
	private Date dateUpdated;

	@Column(name = "summary", length = 255, nullable = false)
	private String summary;

	@Column(name = "description", length = 4000, nullable = false)
	private String description;

	@Column(name = "resolution", length = 4000, nullable = true)
	private String resolution;
	
	public Issue() {
	}

	public Issue(
			String idt, 
			boolean active, 
			Officer creator, 
			Officer assignee,
			IssueKind kind, 
			IssueStatus status, 
			IssueProject project,
			Long prevIssue, 
			Date dateCreated, 
			Date dateUpdated, 
			String summary,
			String description, 
			String resolution) {
		this.idt = idt;
		this.active = active;
		this.creator = creator;
		this.assignee = assignee;
		this.kind = kind;
		this.status = status;
		this.project = project;
		this.prevIssue = prevIssue;
		this.dateCreated = dateCreated;
		this.dateUpdated = dateUpdated;
		this.summary = summary;
		this.description = description;
		this.resolution = resolution;
	}

	public long getId() {
		return id;
	}

	public String getIdt() {
		return idt;
	}

	public boolean isActive() {
		return active;
	}

	public Officer getCreator() {
		return creator;
	}

	public Officer getAssignee() {
		return assignee;
	}

	public IssueKind getKind() {
		return kind;
	}

	public IssueStatus getStatus() {
		return status;
	}

	public IssueProject getProject() {
		return project;
	}

	public Long getPrevIssue() {
		return prevIssue;
	}

	public Date getDateCreated() {
		return dateCreated;
	}

	public Date getDateUpdated() {
		return dateUpdated;
	}

	public String getSummary() {
		return summary;
	}

	public String getDescription() {
		return description;
	}

	public String getResolution() {
		return resolution;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setIdt(String idt) {
		this.idt = idt;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	public void setCreator(Officer creator) {
		this.creator = creator;
	}

	public void setAssignee(Officer assignee) {
		this.assignee = assignee;
	}

	public void setKind(IssueKind kind) {
		this.kind = kind;
	}

	public void setStatus(IssueStatus status) {
		this.status = status;
	}

	public void setProject(IssueProject project) {
		this.project = project;
	}

	public void setPrevIssue(Long prevIssue) {
		this.prevIssue = prevIssue;
	}

	public void setDateCreated(Date dateCreated) {
		this.dateCreated = dateCreated;
	}

	public void setDateUpdated(Date dateUpdated) {
		this.dateUpdated = dateUpdated;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setResolution(String resolution) {
		this.resolution = resolution;
	}
}
