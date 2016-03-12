<%@page import="ru.ifmo.is.db.entity.IssueStatus"%>
<%@page import="ru.ifmo.is.db.service.IssueStatusService"%>
<%@page import="ru.ifmo.is.db.entity.Officer"%>
<%@page import="ru.ifmo.is.db.service.OfficerService"%>
<%@page import="ru.ifmo.is.manager.ProjectManager"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="ru.ifmo.is.util.json.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
<link rel="stylesheet" type="text/css" href="/Tracker/lib/joint.min.css" />
<link rel="stylesheet" type="text/css" href="/Tracker/lib/joint.pathfinder.css" />
<script src="/Tracker/lib/jquery.min.js"></script>
<script src="/Tracker/lib/lodash.min.js"></script>
<script src="/Tracker/lib/backbone-min.js"></script>
<script src="/Tracker/lib/joint.min.js"></script>
<script src="/Tracker/lib/joint.pathfinder.js"></script>
</head>
<body onload="init()">
	<%
		LogManager.log("GET project.jsp", request);
	%>
	<%@ include file="include/adminLeftMenu.jsp"%>
	<%
		String currProjectKey = request.getParameter(ProjectServlet.PROJECT_KEY);
	
		ApplicationContext ctx = Context.getContext();
		
		IssueProjectService projectService = ctx.getBean(IssueProjectService.class);
		IssueProject currProject = null;
		if (currProjectKey != null) {
			currProject = projectService.selectByCode(currProjectKey);
		}
		
		OfficerService officerService = ctx.getBean(OfficerService.class);
		List<Officer> officers = officerService.selectAll();
		
		IssueStatusService issueStatusService = ctx.getBean(IssueStatusService.class);
		List<IssueStatus> statuses = issueStatusService.selectAll();
	%>
	<%
		// TODO remove
		Graph g = new Graph("TEST");
		
		Attribute labelText1 = new Attribute("Close", null);
		Attribute labelText2 = new Attribute("Reopen", null);
		List<Label> labels1 = new LinkedList<Label>();
		labels1.add(new Label(0.5f, new Attributes(labelText1, null)));
		List<Label> labels2 = new LinkedList<Label>();
		labels2.add(new Label(0.5f, new Attributes(labelText2, null)));

		Attribute labelTextStart = new Attribute("Create", null);
		List<Label> labelsStart = new LinkedList<Label>();
		labelsStart.add(new Label(0.5f, new Attributes(labelTextStart, null)));
		
		Element start = Element.createCell("__START", "__START", "pathfinder.StartObj", new Position(125, 50), null);
		Element cell1 = Element.createCell("OPEN", "OPEN", "pathfinder.EditableStatus", new Position(100, 150), "Open");
		Element cell2 = Element.createCell("CLOSE", "CLOSE", "pathfinder.EditableStatus", new Position(100, 250), "Closed");
		Element startLink = Element.createLink("__START_OPEN", "__START_OPEN", new LinkCell("__START", "__START"), new LinkCell("OPEN", "OPEN"), labelsStart);
		Element link1 = Element.createLink("OPEN_CLOSE", "OPEN_CLOSE", new LinkCell("OPEN", "OPEN"), new LinkCell("CLOSE", "CLOSE"), labels1);
		Element link2 = Element.createLink("CLOSE_OPEN", "CLOSE_OPEN", new LinkCell("CLOSE", "CLOSE"), new LinkCell("OPEN", "OPEN"), labels2);
		
		g.getCells().add(start);
		g.getCells().add(cell1);
		g.getCells().add(cell2);
		g.getCells().add(startLink);
		g.getCells().add(link1);
		g.getCells().add(link2);
		
		String json = new ProjectManager().toJSON(g);
	%>
	<script>
		var paper;
		var graph; 
		var statuses = '<%
			for (IssueStatus s : statuses) {
				out.print("<option class=\"VAL_" + Util.replaceStr(s.getCode()) + "\"" + "value=\"" + Util.replaceStr(s.getCode()) + "\">" + Util.replaceHTML(s.getName()) + "</option>");
			}
		%>';
		
		function init() {
			document.title = "<%=currProject == null ? "New project" : Util.replaceStr(currProject.getName())%>";			
			<%
				if (currProject != null) {
			%>
			var tmp = createGraph('<%=json%>', statuses);
			paper = tmp[0];
			graph = tmp[1];
			<%
				}
			%>
		}
		
		function createNewWorkflow() {
			if (graph != null) {
				return; // will not recreate
			}
			
			var wfIdt = document.getElementById("<%=ProjectServlet.SET_PROJECT_KEY%>").value;
			if (wfIdt == "") {
				document.getElementById("createErr").innerHTML = "Project identifier required";
				return;
			}
			
			var tmp = createGraph(null, statuses);
			paper = tmp[0];
			graph = tmp[1];
			
			graph.set('idt', wfIdt);
			
	        graph.addCell(new joint.shapes.pathfinder.StartObj({
	        	id: "__START",
	        	idt: "__START",
	        	position: {
	        		x: paper.options.width / 2 - 25,
	        		y: 20
	        	}
	        }));
	        
	        document.getElementById("createErr").innerHTML = "";
	        
	        // make idt uneditable
	        document.getElementById("<%=ProjectServlet.SET_PROJECT_KEY%>").disabled = "disabled";
			
	        // remove button
	        var buttonRow = document.getElementById("createProjectRow");
	        buttonRow.parentNode.removeChild(buttonRow);
	        
	        // allow adding new elements
	        document.getElementById("createProjectButton").style.display = "block";
		}
		
		function addNewStatus() {
			graph.addCell(new joint.shapes.pathfinder.EditableStatus({
				position: {
					x: 20,
					y: 20
				}
			}))
		}
	</script>
	<div class="adminMainScreen">
		<div class="divProjectModelLeft">
			<div id="divProjectMain">
				<h1 class="briefInformation">Summary</h1>
				<hr>
				<div id="createErr" class="dialogErr"></div>
				<table class="briefInfoTable">
					<tr class="widthTr">
						<td class="widthTd">Name</td>
						<td id="issueKindTd">
							<input type="text" 
								id="<%=ProjectServlet.SET_PROJECT_NAME%>" 
								name="<%=ProjectServlet.SET_PROJECT_NAME%>" 
								value="<%=currProject == null ? "" : Util.replaceStr(currProject.getName())%>" 
								class="editProject"/>
						</td>
					</tr>
					<tr>
						<td class="widthTd">Identifier</td>
						<td id="issueKindTd">
							<input type="text" 
								id="<%=ProjectServlet.SET_PROJECT_KEY%>"
								name="<%=ProjectServlet.SET_PROJECT_KEY%>" 
								value="<%=currProject == null ? "" : Util.replaceStr(currProject.getCode())%>" 
								class="editProject" 
								<%=currProject == null ? "" : "disabled"%>/>
						</td>
					</tr>
					<tr>
						<td class="widthTd">Owner</td>
						<td id="issueKindTd">
							<select id="<%=ProjectServlet.SET_PROJECT_OWNER%>"
								name="<%=ProjectServlet.SET_PROJECT_OWNER%>" 
								class="editProject" >
								<option value="" disabled <%=currProject == null ? "selected" : ""%>></option>
								<% for (Officer o : officers) { %>
								<option value="<%=Util.replaceStr(o.getUsername())%>"
									<%=(currProject != null && o.getUsername().equals(currProject.getOwner().getUsername())) ? "selected" : ""%>>
									<%=Util.replaceHTML(o.getCredentials())%>
								</option>
								<% } %>							
							</select>
						</td>
					</tr>
					<%
						if (currProject == null) {
					%>
					<tr id="createProjectRow">
						<td colspan=2 style="text-align: center;">
							<button id="createProjectButton" 
								onclick="createNewWorkflow()"
								class="buttonFixed">Create</button>
						</td>
					</tr>
					<%
						}
					%>
				</table>
			</div>
			<div id="divProjectModel">
				<h1 class="briefInformation">Workflow</h1>
				<hr>
				<button id="createProjectButton" 
					onclick="addNewStatus()"
					class="buttonFixed" 
					<%=currProject == null ? "style=\"display: none;\"" : ""%>>Add status</button>
				<div id="wfdiv"></div>		
			</div>	
		</div>
		<div class="divProjectModelRight">
			
		</div>
		<button onclick="printJSON()">JSON</button>
		<table>
			<tr>
				<td><%=json%></td>
				<td id="outJSON"></td>
			</tr>
		</table>
		<script>		
			function printJSON() {
				document.getElementById("outJSON").innerHTML = JSON.stringify(graph.toJSON());
			}
		</script>
	</div>
</body>
</html>