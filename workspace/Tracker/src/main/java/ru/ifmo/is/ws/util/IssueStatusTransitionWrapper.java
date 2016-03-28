package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueStatusTransition;

public class IssueStatusTransitionWrapper {
	private String name;
	private String code;
	private Boolean isActive;	
	
	public IssueStatusTransitionWrapper() {
	}
	
	public IssueStatusTransitionWrapper(IssueStatusTransition transition) {
		if (transition == null) {
			return;
		}
		
		this.name = transition.getName();
		this.code = transition.getCode();
		this.isActive = transition.isActive();
	}

	@XmlElement
	public String getName() {
		return name;
	}

	@XmlElement
	public String getCode() {
		return code;
	}

	@XmlElement(name = "is-active")
	public Boolean isActive() {
		return isActive;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public void setActive(Boolean isActive) {
		this.isActive = isActive;
	}
}
