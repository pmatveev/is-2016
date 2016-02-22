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

public class IssueProject extends DataClass {
	public String startStatus;
	public String startStatusDisplay;
	public String owner;
	public String ownerDisplay;
	public String code;
	public String name;

	public IssueProject(
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
	public IssueProject[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueProject> projects = new LinkedList<IssueProject>();
		
		while (rs.next()) {
			projects.add(new IssueProject(
					startStatus == null ? null : rs.getString(startStatus),
					startStatusDisplay == null ? null : rs.getString(startStatusDisplay),
					owner == null ? null : rs.getString(owner), 
					ownerDisplay == null ? null : rs.getString(ownerDisplay),
					code == null ? null : rs.getString(code), 
					name == null ? null : rs.getString(name)));
		}
		
		return projects.toArray(new IssueProject[0]);
	}
	
	public static IssueProject[] selectAvailable(String username) throws IOException {	
		IssueProject mask = new IssueProject(null, 
				"start_status_display", 
				null, 
				"owner_display", 
				"project_code", 
				"project_name");
		
		return new StatementExecutor().select(
				mask,
				"select start_status_display, owner_display, project_code, project_name " +
						"from projects_available " +
						"where available_for_code = ?",
				new Pair<>(SQLParmKind.IN_STRING, (Object) username));
	}
	
	public static IssueProject[] select() throws IOException {
		return new StatementExecutor().select(new IssueProject(null, null,
				null, null, "code", "name"),
				"select code, name from issue_project");
	}
}
