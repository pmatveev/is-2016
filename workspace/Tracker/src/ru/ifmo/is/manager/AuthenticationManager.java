package ru.ifmo.is.manager;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.db.ConnectionManager;
import ru.ifmo.is.servlet.LoginServlet;
import ru.ifmo.is.util.Pair;

public class AuthenticationManager {
	private String valueOf(byte b) {
		String res = Integer.toHexString(b & 0xFF);
		while (res.length() < 2) {
			res = "0" + res;
		}
		return res;
	}

	private String getIP(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		if (ip == null || ip.length() == 0) {
			ip = "unknown";
		}
		return ip;
	}

	public String authenticate(String username, String password,
			HttpServletRequest request, HttpServletResponse response) {
		if (username == null || password == null || username.length() == 0
				|| password.length() == 0) {
			return "Both login and password required";
		}

		Connection conn = null;
		String token = null;
		String ip = getIP(request);
		try {
			byte[] md5 = MessageDigest.getInstance("MD5").digest(
					password.getBytes("UTF-8"));

			String hash = "";
			for (byte b : md5) {
				hash += valueOf(b);
			}

			conn = new ConnectionManager().getConnection();
			CallableStatement stmt = conn
					.prepareCall("{? = call authenticate(?, ?, ?)}");
			stmt.registerOutParameter(1, Types.VARCHAR);
			stmt.setString(2, username);
			stmt.setString(3, hash);
			stmt.setString(4, ip);
			stmt.execute();
			token = stmt.getString(1);
		} catch (NoSuchAlgorithmException | UnsupportedEncodingException
				| NamingException | SQLException e) {
			return "Verification module failed: " + e.getMessage();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				}
			}
		}

		if (token == null || token.length() == 0) {
			return "Wrong username or password";
		}

		Cookie c = new Cookie(LoginServlet.LOGIN_TOKEN_COOKIE, token);
		c.setMaxAge(LoginServlet.LOGIN_COOKIE_EXPIRE);
		response.addCookie(c);

		// test
		request.setAttribute(LoginServlet.LOGIN_TOKEN_COOKIE, token);

		return null;
	}

	public Pair<String, String> verify(HttpServletRequest request,
			HttpServletResponse response) {
		Pair<String, String> res = new Pair<String, String>();

		String ip = getIP(request);
		String token = (String) request
				.getAttribute(LoginServlet.LOGIN_TOKEN_COOKIE);

		System.out.println("Token v0: " + token);

		if (token == null) {
			if (request.getCookies() != null) {
				for (Cookie c : request.getCookies()) {
					if (c.getName().equals(LoginServlet.LOGIN_TOKEN_COOKIE)) {
						token = c.getValue();
					}
				}
			}
		}

		System.out.println("Token: " + token);
		System.out.println("IP: " + ip);

		if (token == null) {
				return res;
		}

		Connection conn = null;
		try {
			conn = new ConnectionManager().getConnection();
			CallableStatement stmt = conn
					.prepareCall("{call verify_auth(?, ?, ?, ?)}");
			stmt.setString(1, ip);
			stmt.setString(2, token);
			stmt.registerOutParameter(3, Types.VARCHAR);
			stmt.registerOutParameter(4, Types.VARCHAR);
			stmt.execute();

			res.first = stmt.getString(3);
			res.second = stmt.getString(4);
		} catch (NamingException | SQLException e) {
			return res;
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				}
			}
		}

		if (res.first == null) {
			// not authenticated
			Cookie c = new Cookie(LoginServlet.LOGIN_TOKEN_COOKIE, null);
			c.setMaxAge(0);
			response.addCookie(c);
		}

		return res;
	}
}
