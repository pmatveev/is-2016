package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;

@Deprecated
public class IssueStatusData extends DataClass {
	public String code;
	public String name;
	
	public IssueStatusData (
			String code,
			String name
			) {
		this.name = name;
		this.code = code;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueStatusData> statuses = new LinkedList<IssueStatusData>();
		
		while (rs.next()) {
			statuses.add(new IssueStatusData(
					code == null ? null : rs.getString(code), 
					name == null ? null : rs.getString(name)));
		}
		
		return statuses.toArray(new IssueStatusData[0]);
	}
	
	public static IssueStatusData[] select() throws IOException {	
		return new StatementExecutor().select(new IssueStatusData("code", "name"),
				"code, name from issue_status order by name asc");
	}
}
