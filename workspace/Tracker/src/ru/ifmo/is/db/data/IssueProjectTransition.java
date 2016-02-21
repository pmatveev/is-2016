package ru.ifmo.is.db.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import ru.ifmo.is.db.DataClass;

public class IssueProjectTransition extends DataClass {
	public int id;
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
			String projectFrom,
			String projectFromDisplay,
			String projectTo,
			String projectToDisplay,
			String statusFrom,
			String statusFromDisplay,
			String statusTo,
			String statusToDisplay) {
		this.id = id;
		this.projectFrom = projectFrom;
		this.projectFromDisplay = projectFromDisplay;
		this.projectTo = projectTo;
		this.projectToDisplay = projectToDisplay;
		this.statusFrom = statusFrom;
		this.statusFromDisplay = statusFromDisplay;
		this.statusTo = statusTo;
		this.statusToDisplay = statusToDisplay;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}
