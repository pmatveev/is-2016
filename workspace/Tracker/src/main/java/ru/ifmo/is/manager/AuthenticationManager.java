package ru.ifmo.is.manager;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Types;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.servlet.LoginServlet;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

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
	
	public String authenticate(String username, String password, String conn)
			throws IOException, NoSuchAlgorithmException {
		byte[] md5 = MessageDigest.getInstance("MD5").digest(
				password.getBytes("UTF-8"));

		String hash = "";
		for (byte b : md5) {
			hash += valueOf(b);
		}

		return (String) new StatementExecutor().call(
				"? = call authenticate(?, ?, ?)",
				new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, username),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, hash),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, conn))[0];

	}

	public String authenticate(HttpServletRequest request,
			HttpServletResponse response) {
		String username = request
				.getParameter(LoginServlet.LOGIN_USERNAME_ATTR);
		String password = request
				.getParameter(LoginServlet.LOGIN_PASSWORD_ATTR);

		if (username == null || password == null || username.length() == 0
				|| password.length() == 0) {
			return "Both login and password required";
		}

		String token = null;
		String ip = getIP(request);
		try {
			token = authenticate(username, password, ip);
		} catch (NoSuchAlgorithmException | IOException e) {
			LogManager.log(e);
			return "Verification module failed: " + e.getMessage();
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

	private String getToken(HttpServletRequest request) {
		String token = (String) request
				.getAttribute(LoginServlet.LOGIN_TOKEN_COOKIE);

		if (token == null) {
			if (request.getCookies() != null) {
				for (Cookie c : request.getCookies()) {
					if (c.getName().equals(LoginServlet.LOGIN_TOKEN_COOKIE)) {
						token = c.getValue();
					}
				}
			}
		}
		return token;
	}
	
	private void removeAuth(HttpServletRequest request, 
			HttpServletResponse response, boolean forceRedirect) throws IOException {
		request.removeAttribute(LoginServlet.LOGIN_AUTH_USERNAME);
		request.removeAttribute(LoginServlet.LOGIN_AUTH_DISPLAYNAME);
		request.removeAttribute(LoginServlet.LOGIN_AUTH_USER_ADMIN);		
		if (forceRedirect) {
			response.sendRedirect("/Tracker" + LoginServlet.LOGIN_PAGE);			
		}
	}


	public boolean verify(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		return verify(request, response, true);
	}
	
	public boolean verify(HttpServletRequest request,
			HttpServletResponse response, boolean forceRedirect) throws IOException {
		String ip = getIP(request);
		String token = getToken(request);

		if (token == null) {
			removeAuth(request, response, forceRedirect);
			return false;
		}

		Object[] resTmp = null;
		try {
			resTmp = new StatementExecutor().call(
					"call verify_auth(?, ?, ?, ?, ?)", 
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, ip),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, token),
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_BOOL, Types.BOOLEAN));
		} catch (IOException e) {
			LogManager.log(e);
			Cookie c = new Cookie(LoginServlet.LOGIN_TOKEN_COOKIE, null);
			c.setMaxAge(0);
			response.addCookie(c);
			removeAuth(request, response, forceRedirect);
			return false;
		}

		boolean auth = false;
		Object isAdmin = null;
		if (resTmp.length == 3) {
			auth = resTmp[0] != null;
			request.setAttribute(LoginServlet.LOGIN_AUTH_USERNAME, resTmp[0]);
			request.setAttribute(LoginServlet.LOGIN_AUTH_DISPLAYNAME, resTmp[1]);
			isAdmin = resTmp[2];
			request.setAttribute(LoginServlet.LOGIN_AUTH_USER_ADMIN, isAdmin);	
		}

		if (auth) {
			// bool assumed
			Object adminRequired = request.getAttribute(LoginServlet.LOGIN_AUTH_ADMIN_REQUIRED);
			if (Boolean.TRUE.equals(adminRequired) && Boolean.FALSE.equals(isAdmin)) {
				response.sendRedirect(LoginServlet.getReturnAddress(request));
				return auth;
			}
		}
		
		if (!auth) {
			// not authenticated
			Cookie c = new Cookie(LoginServlet.LOGIN_TOKEN_COOKIE, null);
			c.setMaxAge(0);
			response.addCookie(c);
			removeAuth(request, response, forceRedirect);
		}
			
		return auth;
	}

	public void close(String token, String conn) throws IOException {
		new StatementExecutor().call("call close_auth(?, ?)",
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, conn),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, token));
	}
	
	public void close(HttpServletRequest request, HttpServletResponse response) {
		String ip = getIP(request);
		String token = getToken(request);

		if (token == null) {
			// nothing to do
			return;
		}

		// clean cookie
		Cookie c = new Cookie(LoginServlet.LOGIN_TOKEN_COOKIE, null);
		c.setMaxAge(0);
		response.addCookie(c);
		
		try {
			close(token, ip);
		} catch (IOException e) {
			LogManager.log(e);
		}
	}
}
