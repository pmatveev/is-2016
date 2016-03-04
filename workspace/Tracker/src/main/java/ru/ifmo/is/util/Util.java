package ru.ifmo.is.util;

import java.io.IOException;
import java.util.Properties;


public class Util {
	private static final String icCube;
	private static final String icCubeMainReport;
	
	static {
		Properties p = new Properties();
		try {
			p.load(Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("app.ini"));
			icCube = p.getProperty("iccube.url");
			icCubeMainReport = p.getProperty("iccube.mainreport");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	public static String nvl(String a) {
		return a == null ? "" : a;
	}
	
	public static String replaceHTML(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("<", "&lt").replace(">", "&gt").replace("\r", "").replace("\n", "<br/>");
	}
	
	public static String replaceStr(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("\"", "\\\"").replace("<", "\\<").replace(">", "\\>").replace("\r", "").replace("\n", "\\n");
	}	
	
	public static String replaceStr1(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("'", "\'").replace("<", "\\<").replace(">", "\\>").replace("\r", "").replace("\n", "\\n");
	}
	
	public static boolean stringEquals(String s1, String s2) {
		if (s1 == null && s2 == null) {
			return true;
		}
		if (s1 == null || s2 == null) {
			return false;
		}
		return s1.equals(s2);
	}
	
	public static String getIcCube() {
		return icCube;
	}
	
	public static String getIcCubeMainReport() {
		return icCubeMainReport;
	}
}
