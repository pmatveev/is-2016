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
public class IssueProjectTransitionData extends DataClass {
	public String projectFrom;
	public String projectFromDisplay;
	public String projectTo;
	public String projectToDisplay;
	public String statusFrom;
	public String statusFromDisplay;
	public String statusTo;
	public String statusToDisplay;
	public String code;
	
	public IssueProjectTransitionData(
			String projectFrom,
			String projectFromDisplay,
			String projectTo,
			String projectToDisplay,
			String statusFrom,
			String statusFromDisplay,
			String statusTo,
			String statusToDisplay,
			String code) {
		this.projectFrom = projectFrom;
		this.projectFromDisplay = projectFromDisplay;
		this.projectTo = projectTo;
		this.projectToDisplay = projectToDisplay;
		this.statusFrom = statusFrom;
		this.statusFromDisplay = statusFromDisplay;
		this.statusTo = statusTo;
		this.statusToDisplay = statusToDisplay;
		this.code = code;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueProjectTransitionData> transitions = new LinkedList<IssueProjectTransitionData>();
		
		while (rs.next()) {
			transitions.add(new IssueProjectTransitionData(
					projectFrom == null ? null : rs.getString(projectFrom),
					projectFromDisplay == null ? null : rs.getString(projectFromDisplay),
					projectTo == null ? null : rs.getString(projectTo),
					projectToDisplay == null ? null : rs.getString(projectToDisplay),
					statusFrom == null ? null : rs.getString(statusFrom),
					statusFromDisplay == null ? null : rs.getString(statusFromDisplay),
					statusTo == null ? null : rs.getString(statusTo),
					statusToDisplay == null ? null : rs.getString(statusToDisplay),
					code == null ? null : rs.getString(code)));
		}
		
		return transitions.toArray(new IssueProjectTransitionData[0]);
	}
	
	public static IssueProjectTransitionData[] selectByIssue(Integer id, String username) throws IOException {
		if (id == null || username == null) {
			return null;
		}
		IssueProjectTransitionData mask = new IssueProjectTransitionData(
				null, 
				null, 
				"project_to_code", 
				"project_to_name", 
				null,
				null,
				"status_to_code", 
				"status_to_name",
				"code");
		
		String stmt = "project_to_code, " +
				"project_to_name, " +
				"status_to_code, " +
				"status_to_name, " +
				"code " +
				"from issue_project_transitions_available " +
				"where issue_for = ? " +
				"and available_for_code = ? " +
				"order by project_to_name asc, " +
				"status_to_name asc";

		return new StatementExecutor().select(
				mask, 
				stmt, 
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_INT, id),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, username));
	}
}
