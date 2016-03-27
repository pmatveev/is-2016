package ru.ifmo.is.ws.util;

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.Issue;

public class IssueWrapper {
	private String idt;
	private OfficerWrapper creator;
	private OfficerWrapper assignee;
	private IssueKindWrapper kind;
	private IssueStatusWrapper status;
	private IssueProjectWrapper project;
	private Long prevIssue;
	private Date dateCreated;
	private Date dateUpdated;
	private String summary;
	private String description;
	private String resolution;

	public IssueWrapper() {
	}
	
	public IssueWrapper(Issue issue) {
		this.idt = issue.getIdt();
		this.creator = new OfficerWrapper(issue.getCreator());
		this.assignee = new OfficerWrapper(issue.getAssignee());
		this.kind = new IssueKindWrapper(issue.getKind());
		this.status = new IssueStatusWrapper(issue.getStatus());
		this.project = new IssueProjectWrapper(issue.getProject());
		this.prevIssue = issue.getPrevIssue();
		this.dateCreated = issue.getDateCreated();
		this.dateUpdated = issue.getDateUpdated();
		this.summary = issue.getSummary();
		this.description = issue.getDescription();
		this.resolution = issue.getResolution();
	}

	@XmlElement
	public String getIdt() {
		return idt;
	}

	@XmlElement
	public OfficerWrapper getCreator() {
		return creator;
	}

	@XmlElement
	public OfficerWrapper getAssignee() {
		return assignee;
	}

	@XmlElement
	public IssueKindWrapper getKind() {
		return kind;
	}

	@XmlElement
	public IssueStatusWrapper getStatus() {
		return status;
	}

	@XmlElement
	public IssueProjectWrapper getProject() {
		return project;
	}

	@XmlElement(name = "prev-issue")
	public Long getPrevIssue() {
		return prevIssue;
	}

	@XmlElement(name = "date-created")
	public Date getDateCreated() {
		return dateCreated;
	}

	@XmlElement(name = "date-updated")
	public Date getDateUpdated() {
		return dateUpdated;
	}

	@XmlElement
	public String getSummary() {
		return summary;
	}

	@XmlElement
	public String getDescription() {
		return description;
	}

	@XmlElement
	public String getResolution() {
		return resolution;
	}

	public void setIdt(String idt) {
		this.idt = idt;
	}

	public void setCreator(OfficerWrapper creator) {
		this.creator = creator;
	}

	public void setAssignee(OfficerWrapper assignee) {
		this.assignee = assignee;
	}

	public void setKind(IssueKindWrapper kind) {
		this.kind = kind;
	}

	public void setStatus(IssueStatusWrapper status) {
		this.status = status;
	}

	public void setProject(IssueProjectWrapper project) {
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
