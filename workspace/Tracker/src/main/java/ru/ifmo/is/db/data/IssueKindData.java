package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;

@Deprecated
public class IssueKindData extends DataClass {
	public String code;
	public String name;
	
	public IssueKindData(
			String code,
			String name) {
		this.name = name;
		this.code = code;
	}

	@Override
	public IssueKindData[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueKindData> kinds = new LinkedList<IssueKindData>();
		
		while (rs.next()) {
			kinds.add(new IssueKindData(
					code == null ? null : rs.getString(code), 
					name == null ? null : rs.getString(name)));
		}
		
		return kinds.toArray(new IssueKindData[0]);
	}
	
	public static IssueKindData[] select() throws IOException {	
		return new StatementExecutor().select(new IssueKindData("code", "name"),
				"code, name from issue_kind order by name asc");
	}
}
