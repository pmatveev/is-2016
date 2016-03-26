package ru.ifmo.is.db.entity;

import java.util.Date;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "comment")
public class Comment {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private Long id;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "officer__id", nullable = false)
	private Officer officer;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "issue_before", nullable = false)
	private Issue before;

	@ManyToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "issue_after", nullable = false)
	private Issue after;

	@ManyToOne(fetch = FetchType.EAGER, optional = true, cascade = CascadeType.ALL)
	@JoinColumn(name = "status_transition", nullable = true)
	private IssueStatusTransition statusTransition;

	@ManyToOne(fetch = FetchType.LAZY, optional = true, cascade = CascadeType.ALL)
	@JoinColumn(name = "project_transition", nullable = true)
	private IssueProjectTransition projectTransition;
	
	@Column(name = "date_created", columnDefinition = "datetime", nullable = false)
	private Date dateCreated;

	@Column(name = "summary", length = 4000, nullable = false)
	private String summary;
	
	public Comment() {
	}

	public Comment(
			Officer officer, 
			Issue before, 
			Issue after,
			IssueStatusTransition statusTransition,
			IssueProjectTransition projectTransition, 
			Date dateCreated,
			String summary) {
		this.officer = officer;
		this.before = before;
		this.after = after;
		this.statusTransition = statusTransition;
		this.projectTransition = projectTransition;
		this.dateCreated = dateCreated;
		this.summary = summary;
	}

	public Long getId() {
		return id;
	}

	public Officer getOfficer() {
		return officer;
	}

	public Issue getBefore() {
		return before;
	}

	public Issue getAfter() {
		return after;
	}

	public IssueStatusTransition getStatusTransition() {
		return statusTransition;
	}

	public IssueProjectTransition getProjectTransition() {
		return projectTransition;
	}

	public Date getDateCreated() {
		return dateCreated;
	}

	public String getSummary() {
		return summary;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setOfficer(Officer officer) {
		this.officer = officer;
	}

	public void setBefore(Issue before) {
		this.before = before;
	}

	public void setAfter(Issue after) {
		this.after = after;
	}

	public void setStatusTransition(IssueStatusTransition statusTransition) {
		this.statusTransition = statusTransition;
	}

	public void setProjectTransition(IssueProjectTransition projectTransition) {
		this.projectTransition = projectTransition;
	}

	public void setDateCreated(Date dateCreated) {
		this.dateCreated = dateCreated;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}
}
