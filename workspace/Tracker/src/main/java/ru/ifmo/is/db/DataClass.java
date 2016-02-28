package ru.ifmo.is.db;

import java.sql.ResultSet;
import java.sql.SQLException;

@Deprecated
public abstract class DataClass {
	public abstract DataClass[] parseResultSet(ResultSet rs) throws SQLException;
}
