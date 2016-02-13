package ru.ifmo.is.manager;

import java.util.AbstractCollection;
import java.util.Enumeration;
import java.util.LinkedList;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import ru.ifmo.is.servlet.LoginServlet;
import ru.ifmo.is.util.LogLevel;

public class LogManager {
	private static String[] strArr = new String[0];

	public static synchronized void log(LogLevel level, String action) {
		log(level, action, LogLevel.NONE);
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
		log(level, action, detailsLevel, details.toArray(strArr));
	}

	public static synchronized void log(LogLevel level, String action,
			LogLevel detailsLevel, String... details) {
		synchronized (System.out) {
			System.out.println(action);
			for (String s : details) {
				System.out.println("\t" + s);
			}
			System.out.println();
		}
	}
}
