package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueKind;

public class IssueKindWrapper {
	private String name;
	private String code;

	public IssueKindWrapper() {
	}
	
	public IssueKindWrapper(IssueKind issueKind) {
		this.name = issueKind.getName();
		this.code = issueKind.getCode();
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
