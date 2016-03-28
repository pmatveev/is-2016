package ru.ifmo.is.ws.util;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.IssueProjectTransition;

public class IssueProjectTransitionListWrapper {
	private IssueProjectTransitionWrapper[] transitions;
	
	public IssueProjectTransitionListWrapper() {
	}
	
	public IssueProjectTransitionListWrapper(List<IssueProjectTransition> transitions) {
		if (transitions == null) {
			return;
		}
		
		this.transitions = new IssueProjectTransitionWrapper[transitions.size()];
		for (int i = 0; i < this.transitions.length; i++) {
			this.transitions[i] = new IssueProjectTransitionWrapper(transitions.get(i));
		}
	}

	@XmlElement(name = "transition")
	public IssueProjectTransitionWrapper[] getTransitions() {
		return transitions;
	}

	public void setTransitions(IssueProjectTransitionWrapper[] transitions) {
		this.transitions = transitions;
	}
}
