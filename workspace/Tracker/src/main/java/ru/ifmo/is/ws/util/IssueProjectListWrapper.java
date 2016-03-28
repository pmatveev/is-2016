package ru.ifmo.is.ws.util;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueProject;

public class IssueProjectListWrapper {
	private IssueProjectWrapper[] projects;
	
	public IssueProjectListWrapper() {
	}
	
	public IssueProjectListWrapper(List<IssueProject> projects) {
		if (projects == null) {
			return;
		}
		
		this.projects = new IssueProjectWrapper[projects.size()];
		for (int i = 0; i < this.projects.length; i++) {
			this.projects[i] = new IssueProjectWrapper(projects.get(i));
		}
	}

	@XmlElement(name = "project")
	public IssueProjectWrapper[] getProjects() {
		return projects;
	}

	public void setProjects(IssueProjectWrapper[] projects) {
		this.projects = projects;
	}
}
