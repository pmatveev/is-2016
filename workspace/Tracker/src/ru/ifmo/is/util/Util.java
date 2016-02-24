package ru.ifmo.is.util;

public class Util {
	public static String nvl(String a) {
		return a == null ? "" : a;
	}
	
	public static String replaceHTML(String s) {
		if (s == null) {
			return null;
		}
		return s.replace("<", "&lt").replace(">", "&gt");
	}
	
	public static String replaceStr(String s) {
		if (s == null) {
			return null;
		}
		return s.replace("\"", "\\\"").replace("<", "\\<").replace(">", "\\>");
	}	
	
	public static String replaceStr1(String s) {
		if (s == null) {
			return null;
		}
		return s.replace("'", "\'").replace("<", "\\<").replace(">", "\\>");
	}
}
