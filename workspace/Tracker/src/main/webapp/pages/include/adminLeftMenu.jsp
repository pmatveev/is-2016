<%@page import="ru.ifmo.is.servlet.OfficerServlet"%>
<%@page import="ru.ifmo.is.servlet.LoginServlet"%>
<%@page import="ru.ifmo.is.util.Util"%>
<%@page import="ru.ifmo.is.servlet.ProjectServlet"%>
<%@page import="ru.ifmo.is.db.util.Context"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="ru.ifmo.is.db.service.IssueProjectService"%>
<%@page import="ru.ifmo.is.db.entity.IssueProject"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="/Tracker/lib/jquery.min.js"></script>
	<%
		request.setAttribute(LoginServlet.LOGIN_AUTH_ADMIN_REQUIRED, true);
	%>
	<%@ include file="logout.jsp"%>
<script>
	function expandCollapse(divId) {
		var div = document.getElementById(divId);
		if (div.style.display === 'none') {
			div.style.display = 'block';
		} else {
			div.style.display = 'none';
		}
		return false;
	}

	function resizeDiv() {
		vpw = $(window).width();
		vph = $(window).height();
		$('#leftMenuDiv').css({'height': vph + 'px'});
	}	

	$(document).ready(function(){
		resizeDiv();
	});

	window.onresize = function(event) {
		resizeDiv();
	}	
</script>
<% 
	{
		ApplicationContext ctx = Context.getContext(); 
%>
<div id="leftMenuDiv" class="adminLeftMenu">
	<a href="<%=returnURL%>">Back</a><br />
	<%
		String showProjects = request.getParameter("prjts");
	%>
	<a href="/Tracker<%=OfficerServlet.GRANT_EDIT%>?<%=LoginServlet.RETURN_URL%>=<%=returnUrlStr%>">Officer grants</a><br />
	<span onclick="expandCollapse('editProjects')" class="spanLink">Projects</span><br />
	<div id="editProjects" class="adminLeftSubMenu" 
		style="display:<%="true".equals(showProjects) ? "block" : "none"%>;">
		<% 
			IssueProjectService projectService = ctx.getBean(IssueProjectService.class);
			List<IssueProject> projects = projectService.selectAll();
		%>
		<a href="/Tracker<%=ProjectServlet.PROJECT_EDIT%>&<%=LoginServlet.RETURN_URL%>=<%=returnUrlStr%>">New project</a>
		<%
			for (int i = 0; i < projects.size(); i++) {
		%>
		<a href="/Tracker<%=ProjectServlet.PROJECT_EDIT%>&<%=LoginServlet.RETURN_URL%>=<%=returnUrlStr%>&<%=ProjectServlet.PROJECT_KEY%>=<%=Util.replaceStr(projects.get(i).getCode())%>">
		<br />
		<%=Util.replaceHTML(projects.get(i).getName())%>
		</a>		
		<%
			}
		%>
	</div>
</div>
<%
	}
%>