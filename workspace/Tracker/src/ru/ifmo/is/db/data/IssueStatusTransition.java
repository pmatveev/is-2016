package ru.ifmo.is.db.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import ru.ifmo.is.db.DataClass;

public class IssueStatusTransition extends DataClass {
	public int id;
	public String project;
	public String projectDisplay;
	public String statusFrom;
	public String statusFromDisplay;
	public String statusTo;
	public String statusToDisplay;
	public String code;
	public String name;
	
	public IssueStatusTransition(
			int id,
			String project,
			String projectDisplay,
			String statusFrom,
			String statusFromDisplay,
			String statusTo,
			String statusToDisplay,
			String code,
			String name) {
		this.id = id;
		this.project = project;
		this.projectDisplay = projectDisplay;
		this.statusFrom = statusFrom;
		this.statusFromDisplay = statusFromDisplay;
		this.statusTo = statusTo;
		this.statusToDisplay = statusToDisplay;
		this.code = code;
		this.name = name;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}
