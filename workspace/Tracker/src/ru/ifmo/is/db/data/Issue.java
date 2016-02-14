package ru.ifmo.is.db.data;

import java.util.Date;

import ru.ifmo.is.db.DataClass;

public class Issue extends DataClass {
	public static final String ISSUE_KEY_PARM = "issue";
	
	public int id;
	public String idt;
	public int creator;
	public String creatorDisplay;
	public int assignee;
	public String assigneeDisplay;
	public int kind;
	public String kindDisplay;
	public int status;
	public String statusDisplay;
	public int project;
	public String projectDisplay;
	public Date dateCreated;
	public Date dateUpdated;
	public String summary;
	public String description;
	public String resolution;
	
	public Issue(
			int id,
			String idt,
			int creator,
			String creatorDisplay,
			int assignee,
			String assigneeDisplay,
			int kind,
			String kindDisplay,
			int status,
			String statusDisplay,
			int project,
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
