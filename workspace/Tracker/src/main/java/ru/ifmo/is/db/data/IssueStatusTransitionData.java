package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

@Deprecated
public class IssueStatusTransitionData extends DataClass {
	public String project;
	public String projectDisplay;
	public String statusFrom;
	public String statusFromDisplay;
	public String statusTo;
	public String statusToDisplay;
	public String code;
	public String name;
	
	public IssueStatusTransitionData(
			String project,
			String projectDisplay,
			String statusFrom,
			String statusFromDisplay,
			String statusTo,
			String statusToDisplay,
			String code,
			String name) {
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
		List<IssueStatusTransitionData> transitions = new LinkedList<IssueStatusTransitionData>();
		
		while (rs.next()) {
			transitions.add(new IssueStatusTransitionData(
					project == null ? null : rs.getString(project),
					projectDisplay == null ? null : rs.getString(projectDisplay),
					statusFrom == null ? null : rs.getString(statusFrom),
					statusFromDisplay == null ? null : rs.getString(statusFromDisplay),
					statusTo == null ? null : rs.getString(statusTo),
					statusToDisplay == null ? null : rs.getString(statusToDisplay),
					code == null ? null : rs.getString(code),
					name == null ? null : rs.getString(name)));
		}
		
		return transitions.toArray(new IssueStatusTransitionData[0]);
	}
	
	public static IssueStatusTransitionData[] selectByIssue(Integer id, String username) throws IOException {
		if (id == null || username == null) {
			return null;
		}
		IssueStatusTransitionData mask = new IssueStatusTransitionData(
				null, 
				null, 
				null, 
				null, 
				"status_to_code", 
				"status_to_name", 
				"code", 
				"name");
		
		String stmt = "status_to_code, " +
				"status_to_name, " +
				"code, " +
				"name " +
				"from issue_status_transitions_available " +
				"where issue_for = ? " +
				"and available_for_code = ? " +
				"order by name asc";

		return new StatementExecutor().select(
				mask, 
				stmt, 
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_INT, id),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, username));
	}
}
