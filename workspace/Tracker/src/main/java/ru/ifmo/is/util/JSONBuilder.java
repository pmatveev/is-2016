package ru.ifmo.is.util;

import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

public class JSONBuilder {
	private static final Map<String, String> fromTo; // out JSON
	private static final Map<String, String> toFrom; // inc JSON
	
	static {
		fromTo = new HashMap<String, String>();
		toFrom = new HashMap<String, String>();

		fromTo.put("markerTarget", ".marker-target");
		toFrom.put(".marker-target", "markerTarget");
	}
	
	public String toJSON(Object o) {
		Gson gson = new Gson();
		String json = gson.toJson(o);
		
		for (String s : fromTo.keySet()) {
			json = json.replace(s, fromTo.get(s));
		}
		
		return json;
	}
}
