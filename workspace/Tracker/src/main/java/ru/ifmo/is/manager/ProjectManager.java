package ru.ifmo.is.manager;

import java.util.HashMap;
import java.util.Map;

import ru.ifmo.is.util.json.Graph;

import com.google.gson.Gson;

public class ProjectManager {
	private static final Map<String, String> fromTo; // out JSON
	private static final Map<String, String> toFrom; // inc JSON
	
	static {
		fromTo = new HashMap<String, String>();
		toFrom = new HashMap<String, String>();

		fromTo.put("markerTarget", ".marker-target");
		toFrom.put(".marker-target", "markerTarget");
	}
	
	public String toJSON(Graph g) {
		String json = new Gson().toJson(g);
		
		for (String s : fromTo.keySet()) {
			json = json.replace(s, fromTo.get(s));
		}
		
		return json;
	}
	
	public Graph fromJSON(String json) {
		for (String s : toFrom.keySet()) {
			json = json.replace(s, toFrom.get(s));
		}		
		
		return new Gson().fromJson(json, Graph.class);
	}
}
