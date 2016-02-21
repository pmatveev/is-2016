package ru.ifmo.is.db.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import ru.ifmo.is.db.DataClass;

public class IssueStatus extends DataClass {
	public int id;
	public String code;
	public String name;
	
	public IssueStatus (
			int id,
			String code,
			String name
			) {
		this.id = id;
		this.name = name;
		this.code = code;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}
