package ru.ifmo.is.manager;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import org.springframework.context.ApplicationContext;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.db.entity.IssueProject;
import ru.ifmo.is.db.service.IssueProjectService;
import ru.ifmo.is.db.util.Context;
import ru.ifmo.is.util.json.Element;
import ru.ifmo.is.util.json.Graph;

import com.google.gson.Gson;

public class ProjectManager {
	private static final String START_TYP = "pathfinder.1StartObj";
	private static final String STATUS_TYP = "pathfinder.2EditableStatus";
	private static final String OTHER_PRJ_TYP = "pathfinder.3EditableOtherProject";
	private static final String LINK_TYP = "pathfinder.4Link";
	private static final String SELF_LINK_OBJ_TYP = "pathfinder.5SelfLinkObj";
	private static final String SELF_LINK_TYP = "pathfinder.6SelfLink";

	public String toJSON(Graph g) {
		return new Gson().toJson(g);
	}

	public Graph fromJSON(String json) {
		return new Gson().fromJson(json, Graph.class);
	}

	public String alterProcess(String code, String name, String owner,
			String json) throws IOException {
		/*
		 * ApplicationContext ctx = Context.getContext(); IssueProjectService
		 * projectService = ctx.getBean(IssueProjectService.class); IssueProject
		 * project = projectService.selectByCode(code);
		 */
		if (json == null) {
			return "E:Workflow JSON representation not found";
		}
		if (code == null) {
			return "E:Project identifier cannot be empty";
		}
		if (name == null) {
			return "E:Project name cannot be empty";
		}
		if (owner == null) {
			return "E:Project owner must be specified";
		}
		
		Graph graph = fromJSON(json);

		if (!code.equals(graph.getIdt())) {
			return "E:Internal error: code '" + code
					+ "' is not equal to graph idt '" + graph.getIdt() + "'";
		}

		if (graph.getCells().size() == 0) {
			return "E:No cells found";
		}

		List<Element> cells = graph.getCells();
		Collections.sort(cells);

		Element startWith = null;
		// set all the links and find start status
		for (int i = 0; i < cells.size(); i++) {
			Element curr = cells.get(i);
			if (LINK_TYP.equals(curr.getType())) {
				// normal links, let's find its source and target
				Element source = graph.findByIdt(curr.getSource().getIdt());
				Element target = graph.findByIdt(curr.getTarget().getIdt());

				if (source == null) {
					return "E:Source cell having idt '"
							+ curr.getSource().getIdt()
							+ "' not found for link '" + curr.getIdt() + "'";
				}
				if (target == null) {
					return "E:Target cell having idt '"
							+ curr.getTarget().getIdt()
							+ "' not found for link '" + curr.getIdt() + "'";
				}

				curr.setSourceElem(source);
				curr.setTargetElem(target);

				if (START_TYP.equals(source.getType())) {
					// we found "create" link
					if (startWith != null) {
						// only one "create" allowed
						return "E:Only one 'Create' connection from start element allowed";
					}
					startWith = target;
				}
			} else if (SELF_LINK_TYP.equals(curr.getType())) {
				Element source = graph.findByIdt(curr.getSource().getIdt());
				Element target = graph.findByIdt(curr.getTarget().getIdt());

				if (source == null) {
					return "E:Source cell having idt '"
							+ curr.getSource().getIdt()
							+ "' not found for link '" + curr.getIdt() + "'";
				}
				if (target == null) {
					return "E:Target cell having idt '"
							+ curr.getTarget().getIdt()
							+ "' not found for link '" + curr.getIdt() + "'";
				}

				curr.setSourceElem(source);
				curr.setTargetElem(target);

				if (SELF_LINK_OBJ_TYP.equals(source.getType())) {
					source.setSourceElem(target);
					source.setTargetElem(target);
				} else if (SELF_LINK_OBJ_TYP.equals(target.getType())) {
					target.setSourceElem(source);
					target.setTargetElem(source);
				} else {
					return "E:Self link having idt '" + curr.getIdt()
							+ "' is not linked to 'Edit' element";
				}
			}
		}

		if (startWith == null) {
			return "E:Please add connection from start element";
		}

		StatementExecutor db = new StatementExecutor();
		try {
			db.startTransaction();
		} catch (IOException e) {
			db.rollbackTransaction();
			throw e;
		}
		db.commitTransaction();
		return null;
	}
}
