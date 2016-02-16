package ru.ifmo.is.db.data;

import ru.ifmo.is.db.DataClass;

public class IssueProjectTransition extends DataClass {
	public int id;
	public String officerGrant;
	public String officerGrantDisplay;
	public String projectFrom;
	public String projectFromDisplay;
	public String projectTo;
	public String projectToDisplay;
	public String statusFrom;
	public String statusFromDisplay;
	public String statusTo;
	public String statusToDisplay;
	
	public IssueProjectTransition(
			int id,
			String officerGrant,
			String officerGrantDisplay,
			String projectFrom,
			String projectFromDisplay,
			String projectTo,
			String projectToDisplay,
			String statusFrom,
			String statusFromDisplay,
			String statusTo,
			String statusToDisplay) {
		this.id = id;
		this.officerGrant = officerGrant;
		this.officerGrantDisplay = officerGrantDisplay;
		this.projectFrom = projectFrom;
		this.projectFromDisplay = projectFromDisplay;
		this.projectTo = projectTo;
		this.projectToDisplay = projectToDisplay;
		this.statusFrom = statusFrom;
		this.statusFromDisplay = statusFromDisplay;
		this.statusTo = statusTo;
		this.statusToDisplay = statusToDisplay;
	}
}
