package ru.ifmo.is.ws.util;

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.Comment;

public class CommentWrapper {
	private OfficerWrapper officer;
	private IssueWrapper before;
	private IssueWrapper after;
	private IssueStatusTransitionWrapper statusTransition;
	private IssueProjectTransitionWrapper projectTransition;
	private Date dateCreated;
	private String summary;
	
	public CommentWrapper() {
	}
	
	public CommentWrapper(Comment comment) {
		if (comment == null) {
			return;
		}
		
		this.officer = new OfficerWrapper(comment.getOfficer());
		this.before = new IssueWrapper(comment.getBefore());
		this.after = new IssueWrapper(comment.getAfter());
		this.statusTransition = new IssueStatusTransitionWrapper(comment.getStatusTransition());
		this.projectTransition = new IssueProjectTransitionWrapper(comment.getProjectTransition());
		this.dateCreated = comment.getDateCreated();
		this.summary = comment.getSummary();
	}

	@XmlElement
	public OfficerWrapper getOfficer() {
		return officer;
	}
	
	@XmlElement
	public IssueWrapper getBefore() {
		return before;
	}
	
	@XmlElement
	public IssueWrapper getAfter() {
		return after;
	}
	
	@XmlElement(name = "status-transition")
	public IssueStatusTransitionWrapper getStatusTransition() {
		return statusTransition;
	}
	
	@XmlElement(name = "project-transition")
	public IssueProjectTransitionWrapper getProjectTransition() {
		return projectTransition;
	}
	
	@XmlElement(name = "date-created")
	public Date getDateCreated() {
		return dateCreated;
	}
	
	@XmlElement
	public String getSummary() {
		return summary;
	}

	public void setOfficer(OfficerWrapper officer) {
		this.officer = officer;
	}

	public void setBefore(IssueWrapper before) {
		this.before = before;
	}

	public void setAfter(IssueWrapper after) {
		this.after = after;
	}

	public void setStatusTransition(IssueStatusTransitionWrapper statusTransition) {
		this.statusTransition = statusTransition;
	}

	public void setProjectTransition(IssueProjectTransitionWrapper projectTransition) {
		this.projectTransition = projectTransition;
	}

	public void setDateCreated(Date dateCreated) {
		this.dateCreated = dateCreated;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}
}
