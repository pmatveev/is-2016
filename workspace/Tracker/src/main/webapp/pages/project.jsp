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
<link rel='stylesheet' href='/Tracker/pages/swg.css'></link>
<link rel="stylesheet" type="text/css" href="/Tracker/lib/joint.min.css" />
<link rel="stylesheet" type="text/css" href="/Tracker/lib/joint.pathfinder.css" />
<script src="/Tracker/lib/jquery.min.js"></script>
<script src="/Tracker/lib/lodash.min.js"></script>
<script src="/Tracker/lib/backbone-min.js"></script>
<script src="/Tracker/lib/joint.min.js"></script>
<script src="/Tracker/lib/joint.pathfinder.js"></script>
</head>
<body>
	<%@ include file="logout.jsp"%>
	<%
		LogManager.log("GET project.jsp", request);
	%>
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
		
		Element start = Element.createCell("__START", "basic.Circle", new Position(125, 50), new Size(50, 50), null);
		Element cell1 = Element.createCell("OPEN", "pathfinder.EditableStatus", new Position(100, 150), new Size(100, 50), "Open");
		Element cell2 = Element.createCell("CLOSE", "pathfinder.EditableStatus", new Position(100, 250), new Size(100, 50), "Closed");
		Element startLink = Element.createLink("__START_OPEN", new LinkCell("__START"), new LinkCell("OPEN"), labelsStart);
		Element link1 = Element.createLink("OPEN_CLOSE", new LinkCell("OPEN"), new LinkCell("CLOSE"), labels1);
		Element link2 = Element.createLink("CLOSE_OPEN", new LinkCell("CLOSE"), new LinkCell("OPEN"), labels2);
		
		g.getCells().add(start);
		g.getCells().add(cell1);
		g.getCells().add(cell2);
		g.getCells().add(startLink);
		g.getCells().add(link1);
		g.getCells().add(link2);
		
		String json = new ProjectManager().toJSON(g);
	%>
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
	    
		var myAdjustVertices = _.partial(adjustVertices, graph);

		// adjust vertices when a cell is removed or its source/target was changed
		graph.on('add remove change:source change:target', myAdjustVertices);

		// also when an user stops interacting with an element.
		paper.on('cell:pointerdown', saveXY);
		
		var onPointerUp = function(graph, cellView, evt, x, y) {
			connectByDrop(graph, cellView, evt, x, y);
			myAdjustVertices(cellView);
		}
		var myPointerUp = _.partial(onPointerUp, graph);
		
		paper.on('cell:pointerup', myPointerUp);	
	
	    graph.fromJSON(JSON.parse('<%=json%>'));
		
		var cells = graph.getElements();
		for (var cell in cells) {
			callAdjust(graph, cells[cell]);
		}
		
		function printJSON() {
			document.getElementById("outJSON").innerHTML = JSON.stringify(graph.toJSON());
		}
	</script>
</body>
</html>