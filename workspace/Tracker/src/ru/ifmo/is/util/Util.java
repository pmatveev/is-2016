package ru.ifmo.is.util;

public class Util {
	public static String nvl(String a) {
		return a == null ? "" : a;
	}
	
	public static String replaceHTML(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("<", "&lt").replace(">", "&gt");
	}
	
	public static String replaceStr(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("\"", "\\\"").replace("<", "\\<").replace(">", "\\>");
	}	
	
	public static String replaceStr1(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("'", "\'").replace("<", "\\<").replace(">", "\\>");
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
}
