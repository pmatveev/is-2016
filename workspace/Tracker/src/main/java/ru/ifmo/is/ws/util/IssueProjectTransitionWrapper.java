package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueProjectTransition;

public class IssueProjectTransitionWrapper {
	private String code;
	private Boolean isActive;	
	
	public IssueProjectTransitionWrapper() {
	}
	
	public IssueProjectTransitionWrapper(IssueProjectTransition transition) {
		if (transition == null) {
			return;
		}
		
		this.code = transition.getCode();
		this.isActive = transition.isActive();
	}

	@XmlElement
	public String getCode() {
		return code;
	}

	@XmlElement(name = "is-active")
	public Boolean isActive() {
		return isActive;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public void setActive(Boolean isActive) {
		this.isActive = isActive;
	}

}
