package ru.ifmo.is.manager;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Types;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.context.ApplicationContext;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.db.entity.IssueKind;
import ru.ifmo.is.db.entity.IssueProject;
import ru.ifmo.is.db.entity.IssueStatus;
import ru.ifmo.is.db.service.IssueKindService;
import ru.ifmo.is.db.service.IssueProjectService;
import ru.ifmo.is.db.service.IssueStatusService;
import ru.ifmo.is.db.util.Context;
//import ru.ifmo.is.util.LogLevel;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;
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
	private static final char SEPARATOR = '.';
	
	private static final String PROJ_LOCATION;;

	private ApplicationContext ctx;
	
	static {
		Properties p = new Properties();
		try {
			p.load(Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("app.ini"));
			PROJ_LOCATION = p.getProperty("pathfinder.projectlocation");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	public List<IssueProject> selectAllProjects() {
		return ctx.getBean(IssueProjectService.class).selectAll();
	}

	public IssueProject selectProjectByCode(String code) {
		return ctx.getBean(IssueProjectService.class).selectByCode(code);
	}
	
	public List<IssueProject> selectAvailableProjects(String username) {
		return ctx.getBean(IssueProjectService.class).selectAvailable(username);
	}
	
	public List<IssueStatus> selectAllStatuses() {
		return ctx.getBean(IssueStatusService.class).selectAll();
	}
	
	public List<IssueKind> selectAllKinds() {
		return ctx.getBean(IssueKindService.class).selectAll();
	}
	
	public ProjectManager() {
		ctx = Context.getContext();		
	}
	
	public static String getProjectFile(String code) {
		return PROJ_LOCATION + code + ".json";
	}

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
			} else if (SELF_LINK_OBJ_TYP.equals(curr.getType())) {
				links.add(curr);
			} else if (STATUS_TYP.equals(curr.getType())) {
				statuses.add(curr);
			}
		}

		if (startWith == null) {
			return "E:Please add connection from start element";
		}

		for (Element l : links) {
			if (l.getGrants() == null || l.getGrants().size() == 0) {
				return "E:Missing grants for " + l.getIdt();
			}
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

		List<IssueStatus> statusesInc = statusService.selectIncByProject(code);
		for (IssueStatus s : statusesInc) {
			Element templ = new Element();
			templ.setIdt(s.getCode());
			if (!statuses.contains(templ)) {
				return "E:Status '"
						+ s.getName()
						+ "' is missing but there are incoming project transitions for this status";
			}
		}
		
		Map<String, List<IssueStatus>> statusesOutg = new HashMap<String, List<IssueStatus>>();
		for (Element t : links) {
			if (OTHER_PRJ_TYP.equals(t.getTargetElem().getType())) {
				// outg project transition
				String to = t.getTargetElem().getIdt();
				int separator = to.indexOf(SEPARATOR);
				if (separator == -1) {
					continue;
				}
				
				String projTo = to.substring(0, separator);
				if (!statusesOutg.containsKey(projTo)) {
					statusesOutg.put(projTo, statusService.selectAvailableByProject(projTo));
				}
				
				String stTo = to.substring(separator + 1);
				if (!statusesOutg.get(projTo).contains(
						new IssueStatus(null, stTo))) {
					return "E:Linked project " + t.getTargetElem().getText().replace("<br/>", "/")
							+ " misses target status";
				}
			}
		}
		List<IssueStatus> existingStatuses = statusService.selectAll();

		StatementExecutor db = new StatementExecutor();
		try {
			db.startTransaction();

			// create new statuses
			for (Element s : statuses) {
				//LogManager.log(LogLevel.NONE, "Creating " + s.getIdt());
				if (!existingStatuses
						.contains(new IssueStatus(null, s.getIdt()))) {
					db.call("? = call add_status(?, ?)",
							new Pair<SQLParmKind, Object>(
									SQLParmKind.OUT_STRING, Types.VARCHAR),
							new Pair<SQLParmKind, Object>(
									SQLParmKind.IN_STRING, s.getIdt()),
							new Pair<SQLParmKind, Object>(
									SQLParmKind.IN_STRING, s.getText()));
				}
			}

			//LogManager.log(LogLevel.NONE, "Resetting project");
			// reset project
			Object[] prjRes = db.call("? = call add_project(?, ?, ?, ?)",
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, code), 
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, name), 
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, startWith.getIdt()), 
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, owner));
			
			// there may be (theoretically) some issues
			if (prjRes != null && prjRes.length > 0 && prjRes[0] instanceof String) {
				db.rollbackTransaction();
				return "E:" + prjRes[0];
			}
			
			// add new transitions and set grants
			for (Element t : links) {
				//LogManager.log(LogLevel.NONE, "Adding " + t.getIdt());
				boolean internal = !OTHER_PRJ_TYP.equals(t.getTargetElem().getType());
				if (START_TYP.equals(t.getSourceElem().getType())) {
					// "creation" transition
					db.call("? = call add_status_transition(?, ?, ?, ?, ?)",
							new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getIdt()),  
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getLabels().get(0).getAttrs().getText().getText()),  
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, code),  
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, null),  
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, null));
				} else {
					if (internal) {
						// mind self-connections different labeling
						String label = SELF_LINK_OBJ_TYP.equals(t.getType()) ? 
								t.getText() 
								: t.getLabels().get(0).getAttrs().getText().getText();
								
						db.call("? = call add_status_transition(?, ?, ?, ?, ?)",
								new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getIdt()),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, label),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, code),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getSourceElem().getIdt()),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getTargetElem().getIdt()));
					} else {
						String to = t.getTargetElem().getIdt();
						int separator = to.indexOf(SEPARATOR);
						if (separator == -1) {
							continue;
						}
						String projTo = to.substring(0, separator);
						String stTo = to.substring(separator + 1);
						db.call("? = call add_project_transition(?, ?, ?, ?, ?)",
								new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR), 
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getIdt()),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, code),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, projTo),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, t.getSourceElem().getIdt()),  
								new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, stTo));
					}
				}
				
				for (String g : t.getGrants()) {
					db.call("? = call add_grant_mapping(?, ?, ?)",
							new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, g),
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, internal ? null : t.getIdt()),
							new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, internal ? t.getIdt() : null));
				}
			}

			//LogManager.log(LogLevel.NONE, "Done");
		} catch (Exception e) {
			db.rollbackTransaction();
			throw e;
		}
		//LogManager.log(LogLevel.NONE, "Comitting");
		db.commitTransaction();

		//LogManager.log(LogLevel.NONE, "Saving to " + PROJ_LOCATION);
		new File(PROJ_LOCATION).mkdirs();
		try (PrintWriter save = new PrintWriter(getProjectFile(code))) {
			save.print(json);
		}
		
		//LogManager.log(LogLevel.NONE, "Done");
		
		return null;
	}
}
