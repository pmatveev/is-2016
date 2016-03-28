package ru.ifmo.is.ws.util;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueStatusTransition;

public class IssueStatusTransitionListWrapper {
	private IssueStatusTransitionWrapper[] transitions;
	
	public IssueStatusTransitionListWrapper() {
	}
	
	public IssueStatusTransitionListWrapper(List<IssueStatusTransition> transitions) {
		if (transitions == null) {
			return;
		}
		
		this.transitions = new IssueStatusTransitionWrapper[transitions.size()];
		for (int i = 0; i < this.transitions.length; i++) {
			this.transitions[i] = new IssueStatusTransitionWrapper(transitions.get(i));
		}
	}

	@XmlElement(name = "transition")
	public IssueStatusTransitionWrapper[] getTransitions() {
		return transitions;
	}

	public void setTransitions(IssueStatusTransitionWrapper[] transitions) {
		this.transitions = transitions;
	}
}
