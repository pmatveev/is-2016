package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;

public class Officer extends DataClass {
	public String username;
	public Boolean isActive; // should always be placed in "is_active" column
	public String passHash;
	public String credentials;

	public Officer(
			String username, 
			Boolean isActive, 
			String passHash,
			String credentials) {
		this.username = username;
		this.isActive = isActive;
		this.passHash = passHash;
		this.credentials = credentials;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<Officer> officers = new LinkedList<Officer>();
		
		while (rs.next()) {
			officers.add(new Officer(
					username == null ? null : rs.getString(username),
					isActive == null ? null : rs.getBoolean("is_active"),
					passHash == null ? null : rs.getString(passHash),
					credentials == null ? null : rs.getString(credentials)));
		}
		
		return officers.toArray(new Officer[0]);
	}

	public static Officer[] select() throws IOException {	
		return new StatementExecutor().select(
				new Officer("username", null, null, "credentials"),
				"username, credentials from officer where is_active = true " +
					"order by credentials asc");
	}
}
