<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="/Tracker/lib/jquery.min.js"></script>
<script>
	function expandCollapse(divId) {
		var div = document.getElementById(divId);
		if (div.style.display === 'none') {
			div.style.display = 'block';
		} else {
			div.style.display = 'none';
		}
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
<div id="leftMenuDiv" class="adminLeftMenu">
	<a onclick="expandCollapse('editProjects')" href="#">Projects</a><br />
	<div id="editProjects" class="adminLeftSubMenu" style="display: none;">
		<a href="/Tracker/pages/project.jsp">New project</a>
	</div>
</div>