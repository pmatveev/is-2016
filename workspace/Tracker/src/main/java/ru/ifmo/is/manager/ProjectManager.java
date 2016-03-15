package ru.ifmo.is.manager;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import org.springframework.context.ApplicationContext;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.db.entity.IssueStatus;
import ru.ifmo.is.db.service.IssueStatusService;
import ru.ifmo.is.db.util.Context;
import ru.ifmo.is.util.json.Element;
import ru.ifmo.is.util.json.Graph;

import com.google.gson.Gson;

public class ProjectManager {
	private static final String START_TYP = "pathfinder.StartObj";
	private static final String STATUS_TYP = "pathfinder.EditableStatus";
	private static final String OTHER_PRJ_TYP = "pathfinder.EditableOtherProject";
	private static final String LINK_TYP = "pathfinder.Link";
	private static final String SELF_LINK_OBJ_TYP = "pathfinder.SelfLinkObj";
	private static final String SELF_LINK_TYP = "pathfinder.SelfLink";

	public String toJSON(Graph g) {
		return new Gson().toJson(g);
	}

	public Graph fromJSON(String json) {
		return new Gson().fromJson(json, Graph.class);
	}

	public String alterProcess(String code, String name, String owner,
			String json) throws IOException {
		// parms verification
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

		// basic verification and cell separation
		Element startWith = null;
		List<Element> statuses = new LinkedList<Element>();
		List<Element> links = new LinkedList<Element>();
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

				links.add(curr);
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

				links.add(curr);
			} else if (STATUS_TYP.equals(curr.getType())) {
				statuses.add(curr);
			}
		}

		if (startWith == null) {
			return "E:Please add connection from start element";
		}

		// basic DB verification
		ApplicationContext ctx = Context.getContext();
		IssueStatusService statusService = ctx
				.getBean(IssueStatusService.class);
		List<IssueStatus> statusesUsed = statusService
				.selectUsedByProject(code);
		for (IssueStatus s : statusesUsed) {
			Element templ = new Element();
			templ.setIdt(s.getCode());
			if (!statuses.contains(templ)) {
				return "E:Status '"
						+ s.getName()
						+ "' is missing but there are active issues with this status";
			}
		}

		StatementExecutor db = new StatementExecutor();
		try {
			db.startTransaction();
			
			// create new statuses
		} catch (IOException e) {
			db.rollbackTransaction();
			throw e;
		}
		db.commitTransaction();
		return null;
	}
}
