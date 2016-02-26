package ru.ifmo.is.manager;

import java.util.AbstractCollection;
import java.util.Enumeration;
import java.util.LinkedList;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import ru.ifmo.is.servlet.LoginServlet;
import ru.ifmo.is.util.LogLevel;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

public class LogManager {
	public static synchronized void log(Exception e) {
		log(LogLevel.EXCEPTION, e.getMessage(), LogLevel.EXCEPTION,
				(Object[]) e.getStackTrace());
	}

	public static synchronized void log(LogLevel level, String action) {
		log(level, action, LogLevel.NONE);
	}

	@SafeVarargs
	public static synchronized void log(String sql,
			Pair<SQLParmKind, Object>... attributes) {
		Object[] attrs = new String[attributes.length];

		for (int i = 0; i < attributes.length; i++) {
			attrs[i] = attributes[i].toString();
		}

		log(LogLevel.SQL, sql, LogLevel.SQL_PARMS, attrs);
	}

	public static synchronized void log(String servlet,
			HttpServletRequest request) {
		LinkedList<String> msg = new LinkedList<String>();

		Enumeration<String> names = request.getParameterNames();

		msg.add("PARAMETERS");
		while (names.hasMoreElements()) {
			String par = names.nextElement();
			if (!par.equals(LoginServlet.LOGIN_PASSWORD_ATTR)) {
				msg.add("\t" + par + ": " + request.getParameter(par));
			} else {
				msg.add("\t" + par + ": ***");
			}
		}

		names = request.getAttributeNames();

		msg.add("ATTRIBUTES");
		while (names.hasMoreElements()) {
			String attr = names.nextElement();
			msg.add("\t" + attr + ": " + request.getAttribute(attr));
		}

		names = request.getSession().getAttributeNames();

		msg.add("SESSION ATTRIBUTES");
		while (names.hasMoreElements()) {
			String attr = names.nextElement();
			msg.add("\t" + attr + ": " + request.getSession().getAttribute(attr));
		}		
		
		msg.add("COOKIES");
		if (request.getCookies() != null) {
			for (Cookie c : request.getCookies()) {
				msg.add("\t" + c.getName() + ": " + c.getValue());
			}
		}

		log(LogLevel.REQUEST, servlet, LogLevel.REQUEST_PARMS, msg);
	}

	public static synchronized void log(LogLevel level, String action,
			LogLevel detailsLevel, AbstractCollection<String> details) {
		log(level, action, detailsLevel, details.toArray());
	}

	public static synchronized void log(LogLevel level, String action,
			LogLevel detailsLevel, Object... details) {
		synchronized (System.out) {
			System.out.println(action);
			for (Object s : details) {
				System.out.println("\t" + s);
			}
			System.out.println();
		}
	}
}
