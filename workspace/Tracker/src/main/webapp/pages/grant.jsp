<%@page import="ru.ifmo.is.db.entity.OfficerGrant"%>
<%@page import="ru.ifmo.is.db.service.OfficerGrantService"%>
<%@page import="ru.ifmo.is.db.entity.Officer"%>
<%@page import="ru.ifmo.is.db.entity.OfficerGroup"%>
<%@page import="ru.ifmo.is.db.service.OfficerGroupService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Officer grants</title>
<link rel='stylesheet' href='/Tracker/pages/default.css'></link>
</head>
<body onload="init()">
	<%
		LogManager.log("GET grant.jsp", request);
	%>
	<%@ include file="include/adminLeftMenu.jsp"%>
	<%
		ApplicationContext ctx = Context.getContext();
		OfficerGroupService officerGroupService = ctx.getBean(OfficerGroupService.class);
		List<OfficerGroup> groups = officerGroupService.selectAll();
		
		OfficerGrantService officerGrantService = ctx.getBean(OfficerGrantService.class);
		List<OfficerGrant> grants = officerGrantService.selectAll();
	%>
	<script>
		function init() {
			document.getElementById("divGrantList").innerHTML = "Click on officer or its group to define grants";
			<%
				if ("error".equals(request.getSession().getAttribute(OfficerServlet.GRANT_ADD_WEBSERVICE))) {
					request.getSession().removeAttribute(OfficerServlet.GRANT_ADD_WEBSERVICE);

					String error = (String) request.getSession().getAttribute(OfficerServlet.GRANT_ERROR);
					if (error != null) {
						request.getSession().removeAttribute(OfficerServlet.GRANT_ERROR);
						out.println(
								"document.getElementById(\"createErr\").innerHTML = \"" + Util.replaceStr(error) + "\";");
					}

					String admin = (String) request.getSession().getAttribute(OfficerServlet.SET_GRANT_ADMIN);
					if (error != null) {
						request.getSession().removeAttribute(OfficerServlet.SET_GRANT_ADMIN);
						out.println(
								"document.getElementById(\"" + OfficerServlet.SET_GRANT_ADMIN + "\").value = \"" + Util.replaceStr(admin) + "\";");
					}

					String name = (String) request.getSession().getAttribute(OfficerServlet.SET_GRANT_NAME);
					if (error != null) {
						request.getSession().removeAttribute(OfficerServlet.SET_GRANT_NAME);
						out.println(
								"document.getElementById(\"" + OfficerServlet.SET_GRANT_NAME + "\").value = \"" + Util.replaceStr(name) + "\";");
					}
				}
			%>
			<%
				String forGroup = request.getParameter(OfficerServlet.FOR_OFFICER_GROUP);
				if (forGroup != null) {
			%>
			document.getElementById("GRP_<%=forGroup%>").click();
			<%
				}
				String forOff = request.getParameter(OfficerServlet.FOR_OFFICER);
				if (forOff!= null) {
			%>
			document.getElementById("OFF_<%=forOff%>").click();
			<%
				}
			%>
		}
	
		var grants = {<%
			for (OfficerGroup g : groups) {
				out.print("GRP_" + Util.replaceStr(g.getCode()) + ": [");
				for (int i = 0; i < g.getGrants().size(); i++) {
					out.print("'" + Util.replaceStr1(g.getGrants().get(i).getCode()) + "'" + (i == g.getGrants().size() - 1 ? "" : ", "));
				}
				out.println("],");
				
				for (Officer o : g.getOfficers()) {
					out.print("OFF_" + Util.replaceStr(o.getUsername()) + ": [");
					for (int i = 0; i < o.getGrants().size(); i++) {
						out.print("'" + Util.replaceStr1(o.getGrants().get(i).getCode()) + "'" + (i == o.getGrants().size() - 1 ? "" : ", "));
					}
					out.println("],");
				}
			}
			out.println("trailer: 0");
		%>};
		
		var lastClickGrp = null;
		
		function officerGroupClick(groupCode, groupName) {
			var div = document.getElementById("GRP_DIV_" + groupCode);
			
			if (div.style.display === 'none') {
				div.style.display = 'block';
			} else {
				if (lastClickGrp === groupCode) {
					div.style.display = 'none';					
				}
			}
			
			displayGrants(groupCode, groupName, null, null);
				
			lastClickGrp = groupCode;
		}
		

		function officerClick(groupCode, groupName, officerCode, officerName) {
			lastClickGrp = null;
			displayGrants(groupCode, groupName, officerCode, officerName);
		}
		
		function displayGrants(groupCode, groupName, officerCode, officerName) {
			if (document.getElementById("tblOfficerGrants") == null) {
				var div = document.getElementById("divGrantList");
				div.innerHTML = [
					'<form name="applyGrantForm" action="<%=OfficerServlet.SERVLET_IDT%>" method="post" onsubmit="return applyGrants()">',
					'<input type="hidden" id="<%=OfficerServlet.FOR_OFFICER_GROUP%>" name="<%=OfficerServlet.FOR_OFFICER_GROUP%>">',
					'<input type="hidden" id="APPL_<%=LoginServlet.RETURN_URL%>" name="<%=LoginServlet.RETURN_URL%>"/>',
					'<input type="hidden" id="<%=OfficerServlet.FOR_OFFICER%>" name="<%=OfficerServlet.FOR_OFFICER%>">',
					'<input type="hidden" id="<%=OfficerServlet.SET_GRANT_LIST%>" name="<%=OfficerServlet.SET_GRANT_LIST%>">',
				    '<table id="tblOfficerGrants" class="briefInfoTable">',
				    '<tr class="widthTr">',
				    '<td class="widthTd">Officer group</td>',
				    '<td><input id="grantListOfficerGroupShow" type="text" class="editOfficer" disabled/></td>',
				    '</tr>',
				    '<tr>',
				    '<td class="widthTd">Officer</td>',
				    '<td><input id="grantListOfficerShow" type="text" class="editOfficer" disabled/></td>',
				    '</tr>',
				    '<tr id="inherTr">',
				    '<td class="widthTd">Inherited grants</td>',
				    '<td>',
				    '<select id="inheritedGrants" class="editOfficer" multiple size=<%=grants.size()%> style="overflow: hidden;" disabled>',
				    <% for (OfficerGrant gr : grants) { %>
				    '<option id="GrOptInh<%=Util.replaceStr(gr.getCode())%>" value="<%=Util.replaceStr(gr.getCode())%>"><%=Util.replaceHTML(gr.getName())%></option>',
				    <% } %>
				    '</select>',
				    '</td>',
				    '</tr>',
				    '<tr>',
				    '<td class="widthTd">Grants</td>',
				    '<td>',
				    '<select id="SEL_<%=OfficerServlet.SET_GRANT_LIST%>" class="editOfficer" multiple size=<%=grants.size()%> style="overflow: hidden;">',
				    <% for (OfficerGrant gr : grants) { %>
				    '<option id="GrOpt<%=Util.replaceStr(gr.getCode())%>" value="<%=Util.replaceStr(gr.getCode())%>"><%=Util.replaceHTML(gr.getName())%></option>',
				    <% } %>
				    '</select>',
				    '</td>',
				    '</tr>',
				    '<tr>',
				    '<td colspan=2 style="text-align: center;">',
				    '<input type="submit" class="buttonFixed" value="Apply" name="<%=OfficerServlet.GRANT_SET_WEBSERVICE%>"/>',
				    '</td>',
				    '</tr>',
				    '</table>',
				    '</form>'
					].join('');
			}

			document.getElementById("<%=OfficerServlet.FOR_OFFICER_GROUP%>").value = groupCode;
			document.getElementById("<%=OfficerServlet.FOR_OFFICER%>").value = officerCode;
			document.getElementById("grantListOfficerGroupShow").value = groupName;
			document.getElementById("grantListOfficerShow").value = officerName;
			
			var select = document.getElementById("SEL_<%=OfficerServlet.SET_GRANT_LIST%>");
			for (var i in select.options) {
				select.options[i].selected = "";
			}
			
			var granted = null;
			var inherTd = document.getElementById("inherTr");
			var inherSel = document.getElementById("inheritedGrants");
			if (officerCode != null) {
				granted = grants["OFF_" + officerCode];
				inherTd.style.display = 'table-row';
				
				var inhGranted = grants["GRP_" + groupCode];
				for (var i in inherSel.options) {
					inherSel.options[i].selected = "";
				}
				for (var i in inhGranted) {
					document.getElementById("GrOptInh" + inhGranted[i]).selected = "selected";
				}
			} else {
				granted = grants["GRP_" + groupCode];
				inherTd.style.display = 'none';
			}
			for (var i in granted) {
				document.getElementById("GrOpt" + granted[i]).selected = "selected";
			}
		}
		
		function submitNewGrant() {
			if (document.getElementById("<%=OfficerServlet.SET_GRANT_NAME%>").value == "") {
				document.getElementById("createErr").innerHTML = "Grant name required";
				return false;				
			}		
					
			document.getElementById("createErr").innerHTML = "";
			document.getElementById("NEW_<%=LoginServlet.RETURN_URL%>").value = '<%=returnTo%>';
			
			return true;
		}
		
		function applyGrants() {
			var returnTo = '<%=request.getRequestURI()%>';
			returnTo += '?<%=OfficerServlet.FOR_OFFICER_GROUP%>=' + document.getElementById("<%=OfficerServlet.FOR_OFFICER_GROUP%>").value;
			
			var off = document.getElementById("<%=OfficerServlet.FOR_OFFICER%>").value;
			if (off != "") {
				returnTo += '&<%=OfficerServlet.FOR_OFFICER%>=' + off;
			}			
			document.getElementById("APPL_<%=LoginServlet.RETURN_URL%>").value = returnTo;
			
			var sel = document.getElementById("SEL_<%=OfficerServlet.SET_GRANT_LIST%>");
			var grants = '';
			for (var i = 0; i < sel.length; i++) {
				if (sel.options[i].selected) {
					grants += sel.options[i].value + ',';
				}
			}
			document.getElementById("<%=OfficerServlet.SET_GRANT_LIST%>").value = grants;
			return true;
		}
	</script>
	<div class="adminMainScreen">
		<div id="createErr" class="dialogErr"></div>
		<div class="divOfficersLeft">
			<h1 class="briefInformation">Officer groups</h1>
			<hr>
			<%
				for (OfficerGroup g : groups) {
					out.print("<h3 class=\"link\" id=\"GRP_" + Util.replaceStr(g.getCode()) + "\" onclick=\"officerGroupClick('" + Util.replaceStr(g.getCode()) + "', '" + Util.replaceStr(g.getName()) + "')\">");
					out.print(Util.replaceHTML(g.getName()));
					out.println("</h3>");
					out.print("<div style=\"display: none;\" id=\"GRP_DIV_" + Util.replaceStr(g.getCode()) + "\">");
					out.print("<hr/>");
					out.print("<div class=\"officersDiv\">");
					for (Officer o : g.getOfficers()) {
						out.print("<span class=\"spanLink\" id=\"OFF_" + Util.replaceStr(o.getUsername()) + "\" onclick=\"officerClick('" + Util.replaceStr(g.getCode()) + "', '" + Util.replaceStr(g.getName()) + "', '" + Util.replaceStr(o.getUsername()) + "', '" + Util.replaceStr(o.getCredentials()) + "')\">");
						out.print(Util.replaceHTML(o.getCredentials()));
						out.print("</span>");
						out.print("<br/>");
					}
					out.println("</div>");
					out.println("</div>");
				}
			%>
		</div>
		<div class="divOfficersRight">
			<h1 class="briefInformation">Add grant</h1>
			<hr>
			<div id="divNewGrant">
				<form name="newGrantForm" action="<%=OfficerServlet.SERVLET_IDT%>"
					method="post" onsubmit="return submitNewGrant()">
					<input type="hidden"
						id="NEW_<%=LoginServlet.RETURN_URL%>"
						name="<%=LoginServlet.RETURN_URL%>"/>
					<table class="briefInfoTable">
						<tr class="widthTr">
							<td class="widthTd">Admin</td>
							<td>
								<input type="checkbox" 
									id="<%=OfficerServlet.SET_GRANT_ADMIN%>" 
									name="<%=OfficerServlet.SET_GRANT_ADMIN%>" 
									class="editOfficer"/>
							</td>
						</tr>
						<tr>
							<td class="widthTd">Name</td>
							<td>
								<input type="text" 
									id="<%=OfficerServlet.SET_GRANT_NAME%>" 
									name="<%=OfficerServlet.SET_GRANT_NAME%>" 
									class="editOfficer"/>
							</td>
						</tr>
						<tr>
							<td colspan=2 style="text-align: center;">
								<input type="submit"
									name="<%=OfficerServlet.GRANT_ADD_WEBSERVICE%>"
									value="Submit"
									class="buttonFixed"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<h1 class="briefInformation">Grant list</h1>
			<hr>
			<div id="divGrantList"></div>
		</div>
	</div>
</body>
</html>