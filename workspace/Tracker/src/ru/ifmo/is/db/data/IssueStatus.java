package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;

public class IssueStatus extends DataClass {
	public String code;
	public String name;
	
	public IssueStatus (
			String code,
			String name
			) {
		this.name = name;
		this.code = code;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueStatus> statuses = new LinkedList<IssueStatus>();
		
		while (rs.next()) {
			statuses.add(new IssueStatus(
					code == null ? null : rs.getString(code), 
					name == null ? null : rs.getString(name)));
		}
		
		return statuses.toArray(new IssueStatus[0]);
	}
	
	public static IssueStatus[] select() throws IOException {	
		return new StatementExecutor().select(new IssueStatus("code", "name"),
				"code, name from issue_status");
	}
}
