package ru.ifmo.is.util.json;

import java.util.List;

public class Link extends Element {
	private LinkCell source;
	private LinkCell target;
	private List<Label> labels;

	public LinkCell getSource() {
		return source;
	}

	public LinkCell getTarget() {
		return target;
	}

	public List<Label> getLabels() {
		return labels;
	}

	public void setSource(LinkCell source) {
		this.source = source;
	}

	public void setTarget(LinkCell target) {
		this.target = target;
	}

	public void setLabels(List<Label> labels) {
		this.labels = labels;
	}

	public Link(
			String id, 
			Attributes attrs, 
			LinkCell source, 
			LinkCell target,
			List<Label> labels) {
		super(id, "link", attrs);
		this.source = source;
		this.target = target;
		this.labels = labels;
	}
}
