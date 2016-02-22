package ru.ifmo.is.db;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import javax.naming.NamingException;

import ru.ifmo.is.manager.LogManager;
import ru.ifmo.is.util.LogLevel;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

public class StatementExecutor {
	@SafeVarargs
	public final Object[] call(String sql,
			Pair<SQLParmKind, Object>... attributes) throws IOException {
		LogManager.log(sql, attributes);

		Object[] res = null;
		Connection conn = null;
		try {
			conn = new ConnectionManager().getConnection();
			conn.setAutoCommit(false);
			
			CallableStatement stmt = conn.prepareCall("{" + sql + "}");

			List<Integer> out = new LinkedList<Integer>();
			for (int i = 0; i < attributes.length; i++) {
				Pair<SQLParmKind, Object> a = attributes[i];
				switch (a.first) {
				case IN_STRING:
					String parm = (String) a.second;
					if ("".equals(parm)) {
						parm = null;
					}
					stmt.setString(i + 1, parm);
					break;
				case OUT_STRING:
					out.add(i + 1);
					stmt.registerOutParameter(i + 1, (Integer) a.second);
					break;
				case OUT_BOOL:
					out.add(i + 1);
					stmt.registerOutParameter(i + 1, (Integer) a.second);
				}
			}

			stmt.execute();

			res = new Object[out.size()];
			for (int i = 0; i < out.size(); i++) {
				switch (attributes[out.get(i) - 1].first) {
				case OUT_STRING:
					res[i] = stmt.getString(out.get(i));
					break;
				case OUT_BOOL:
					res[i] = stmt.getBoolean(out.get(i));
				case IN_STRING: // should not be like this
					break;
				}

				conn.commit();
			}
		} catch (NamingException | SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
			}
			LogManager.log(e);
			throw new IOException(e);
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					LogManager.log(e);
					throw new IOException(e);
				}
			}
		}

		LogManager.log(LogLevel.SQL, "finished " + sql, LogLevel.SQL_RESULT,
				res);
		return res;
	}
	
	@SuppressWarnings("unchecked")
	private <T extends DataClass> T[] selectData(Connection conn, T data, String sql,
			Pair<SQLParmKind, Object>[] attributes) throws SQLException {
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		for (int i = 0; i < attributes.length; i++) {
			Pair<SQLParmKind, Object> a = attributes[i];
			switch (a.first) {
			case IN_STRING:
				stmt.setString(i + 1, (String) a.second);
				break;
			case OUT_STRING:
			case OUT_BOOL: // out parms not expected
				break;
			}
		}
		
		ResultSet rs = stmt.executeQuery();
		return (T[]) data.parseResultSet(rs);		
	}
	
	@SafeVarargs
	public final <T extends DataClass> T[] select(T data, String sql,
			Pair<SQLParmKind, Object>... attributes) throws IOException {
		LogManager.log(sql, attributes);
		Connection conn = null;
		
		try {
			conn = new ConnectionManager().getConnection();			
			T[] res = selectData(conn, data, sql, attributes);
			LogManager.log(LogLevel.SQL, "finished " + sql, LogLevel.SQL_RESULT,
					res.length + " rows extracted");
			return res;
		} catch (NamingException | SQLException e) {
			LogManager.log(e);
			throw new IOException(e);
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					LogManager.log(e);
					throw new IOException(e);
				}
			}			
		}
	}
	
	@SafeVarargs
	public final <T extends DataClass> Pair<T[], Integer> selectCount(T data, String sql,
			Pair<SQLParmKind, Object>... attributes) throws IOException {
		LogManager.log(sql, attributes);
		Connection conn = null;
		
		try {
			conn = new ConnectionManager().getConnection();
			
			T[] res = selectData(conn, data, sql, attributes);
			LogManager.log(LogLevel.SQL, "finished " + sql, LogLevel.SQL_RESULT,
					res.length + " rows extracted");
			
			LogManager.log(LogLevel.SQL, "SELECT FOUND_ROWS()");
			PreparedStatement stmt2 = conn.prepareStatement("SELECT FOUND_ROWS()");
			ResultSet rs2 = stmt2.executeQuery();
			Integer num = 0;
			if (rs2.next()) {
				num = rs2.getInt(1);
			}
			LogManager.log(LogLevel.SQL, "finished SELECT FOUND_ROWS()",
					LogLevel.SQL_RESULT, num);
			return new Pair<T[], Integer>(res, num);
		} catch (NamingException | SQLException e) {
			LogManager.log(e);
			throw new IOException(e);
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					LogManager.log(e);
					throw new IOException(e);
				}
			}			
		}
	}	
}
