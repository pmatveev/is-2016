package ru.ifmo.is.db;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnectionManager {	
	public Connection getConnection() throws NamingException, SQLException {
		InitialContext ic = new InitialContext();
		Context ec = (Context)ic.lookup("java:comp/env");
		DataSource ds = (DataSource) ec.lookup("jdbc/pathfinder");
		return ds.getConnection();
	}
}
