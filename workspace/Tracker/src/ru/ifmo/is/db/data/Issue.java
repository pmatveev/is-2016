package ru.ifmo.is.db.data;

import java.util.Date;

import ru.ifmo.is.db.DataClass;

public class Issue extends DataClass {	
	public int id;
	public String idt;
	public String creator;
	public String creatorDisplay;
	public String assignee;
	public String assigneeDisplay;
	public String kind;
	public String kindDisplay;
	public String status;
	public String statusDisplay;
	public String project;
	public String projectDisplay;
	public Date dateCreated;
	public Date dateUpdated;
	public String summary;
	public String description;
	public String resolution;
	
	public Issue(
			int id,
			String idt,
			String creator,
			String creatorDisplay,
			String assignee,
			String assigneeDisplay,
			String kind,
			String kindDisplay,
			String status,
			String statusDisplay,
			String project,
			String projectDisplay,
			Date dateCreated,
			Date dateUpdated,
			String summary,
			String description,
			String resolution) {
		this.id = id;
		this.idt = idt;
		this.creator = creator;
		this.creatorDisplay = creatorDisplay;
		this.assignee = assignee;
		this.assigneeDisplay = assigneeDisplay;
		this.kind = kind;
		this.kindDisplay = kindDisplay;
		this.status = status;
		this.statusDisplay = statusDisplay;
		this.project = project;
		this.projectDisplay = projectDisplay;
		this.dateCreated = dateCreated;
		this.dateUpdated = dateUpdated;
		this.summary = summary;
		this.description = description;
		this.resolution = resolution;
	}
}
