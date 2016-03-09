<%@page import="ru.ifmo.is.util.JSONBuilder"%>
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
<script src="/Tracker/lib/jquery.min.js"></script>
<script src="/Tracker/lib/lodash.min.js"></script>
<script src="/Tracker/lib/backbone-min.js"></script>
<script src="/Tracker/lib/joint.min.js"></script>
</head>
<body>
	<%@ include file="logout.jsp"%>
	<%
		LogManager.log("GET project.jsp", request);
	%>
	<%
		Graph g = new Graph();
		
		Attribute text1 = new Attribute("Open status", null);
		Attribute text2 = new Attribute("Closed status", null);
		Attribute labelText = new Attribute("Close", null);
		List<Label> labels = new LinkedList<Label>();
		labels.add(new Label(0.5f, new Attributes(labelText, null)));
		
		Attribute arrow = new Attribute(null, "M 10 0 L 0 5 L 10 10 z");
	
		Element cell1 = new Cell("OPEN", "basic.Rect", new Attributes(text1, null), new Position(100, 50), new Size(100, 30));
		Element cell2 = new Cell("CLOSE", "basic.Rect", new Attributes(text2, null), new Position(100, 150), new Size(100, 30));
		Element link = new Link("OPEN_CLOSE", new Attributes(null, arrow), new LinkCell("OPEN"), new LinkCell("CLOSE"), labels);
		
		g.getCells().add(cell1);
		g.getCells().add(cell2);
		g.getCells().add(link);
		
		String json = new JSONBuilder().toJSON(g);
	%>
	JSON object dump: <br />
	<%=json%>
	<div id="wfdiv"></div>
	<script>
		var graph = new joint.dia.Graph;
	
	    var paper = new joint.dia.Paper({
	        el: $('#wfdiv'),
	        width: 600,
	        height: 200,
	        model: graph,
	        gridSize: 1
	    });
	
	    graph.fromJSON(JSON.parse('<%=json%>'));
	</script>
</body>
</html>