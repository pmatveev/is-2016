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
<title>Tracker</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
<link rel="stylesheet" type="text/css" href="/Tracker/lib/joint.min.css" />
<link rel="stylesheet" type="text/css" href="/Tracker/lib/joint.pathfinder.css" />
<script src="/Tracker/lib/jquery.min.js"></script>
<script src="/Tracker/lib/lodash.min.js"></script>
<script src="/Tracker/lib/backbone-min.js"></script>
<script src="/Tracker/lib/joint.min.js"></script>
<script src="/Tracker/lib/joint.pathfinder.js"></script>
</head>
<body>
	<%
		request.setAttribute(LoginServlet.LOGIN_AUTH_ADMIN_REQUIRED, true);
		LogManager.log("GET project.jsp", request);
	%>
	<%@ include file="include/logout.jsp"%>
	<%@ include file="include/adminLeftMenu.jsp"%>
	<%
		Graph g = new Graph();
		
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
	<div>
		<div id="wfdiv"></div>
		<button onclick="printJSON()">JSON</button>
		<table>
			<tr>
				<td><%=json%></td>
				<td id="outJSON"></td>
			</tr>
		</table>
		<script>
			var graph = new joint.dia.Graph;
		
		    var paper = new joint.dia.Paper({
		        el: $('#wfdiv'),
		        width: 600,
		        height: 600,
		        model: graph,
		        gridSize: 1
		    });
		    
		    addListeners(graph);
		    
		    graph.fromJSON(JSON.parse('<%=json%>'));
			
			var cells = graph.getElements();
			for (var cell in cells) {
				callAdjust(graph, cells[cell]);
			}
			
			function printJSON() {
				document.getElementById("outJSON").innerHTML = JSON.stringify(graph.toJSON());
			}
		</script>
	</div>
</body>
</html>