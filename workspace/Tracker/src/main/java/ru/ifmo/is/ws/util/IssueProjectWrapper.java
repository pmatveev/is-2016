package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueProject;

public class IssueProjectWrapper {
	private String name;
	private String code;

	public IssueProjectWrapper() {
	}
	
	public IssueProjectWrapper(IssueProject project) {
		if (project == null) {
			return;
		}
		
		this.name = project.getName();
		this.code = project.getCode();
	}

	@XmlElement
	public String getName() {
		return name;
	}

	@XmlElement
	public String getCode() {
		return code;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}
}
