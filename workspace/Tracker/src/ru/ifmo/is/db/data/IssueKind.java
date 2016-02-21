package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;

public class IssueKind extends DataClass {
	public String code;
	public String name;
	
	public IssueKind(
			String code,
			String name) {
		this.name = name;
		this.code = code;
	}

	@Override
	public IssueKind[] parseResultSet(ResultSet rs) throws SQLException {
		List<IssueKind> kinds = new LinkedList<IssueKind>();
		
		while (rs.next()) {
			kinds.add(new IssueKind(
					code == null ? null : rs.getString("code"), 
					name == null ? null : rs.getString("name")));
		}
		
		return kinds.toArray(new IssueKind[0]);
	}
	
	public static IssueKind[] select() throws IOException {	
		return new StatementExecutor().select(new IssueKind("", ""),
				"select code, name from issue_kind");
	}
}
