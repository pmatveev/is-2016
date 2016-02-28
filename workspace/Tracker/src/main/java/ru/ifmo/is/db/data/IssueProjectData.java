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
public class IssueProjectData extends DataClass {
	public String startStatus;
	public String startStatusDisplay;
	public String owner;
	public String ownerDisplay;
	public String code;
	public String name;

	public IssueProjectData(
			String startStatus,
			String startStatusDisplay,
			String owner,
			String ownerDisplay,
			String code,
			String name) {
		this.startStatus = startStatus;
		this.startStatusDisplay = startStatusDisplay;
		this.owner = owner;
		this.ownerDisplay = ownerDisplay;
		this.code = code;
		this.name = name;
	}
	
	@Override
	public IssueProjectData[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueProjectData> projects = new LinkedList<IssueProjectData>();
		
		while (rs.next()) {
			projects.add(new IssueProjectData(
					startStatus == null ? null : rs.getString(startStatus),
					startStatusDisplay == null ? null : rs.getString(startStatusDisplay),
					owner == null ? null : rs.getString(owner), 
					ownerDisplay == null ? null : rs.getString(ownerDisplay),
					code == null ? null : rs.getString(code), 
					name == null ? null : rs.getString(name)));
		}
		
		return projects.toArray(new IssueProjectData[0]);
	}
	
	public static IssueProjectData[] selectAvailable(String username) throws IOException {	
		IssueProjectData mask = new IssueProjectData(null, 
				"start_status_display", 
				null, 
				"owner_display", 
				"project_code", 
				"project_name");
		
		return new StatementExecutor().select(
				mask,
				"start_status_display, owner_display, project_code, project_name " +
						"from projects_available " +
						"where available_for_code = ? " +
						"order by project_name asc",
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, username));
	}
	
	public static IssueProjectData[] select() throws IOException {
		return new StatementExecutor().select(new IssueProjectData(null, null,
				null, null, "code", "name"),
				"code, name from issue_project " +
				"order by name asc");
	}
}
