package ru.ifmo.is.util.json;

import java.util.List;

// cannot use derivation because of Gson
public class Element {
	// common
	private String id;
	private String idt;
	private String type;

	// cell
	private Position position;
	private String text;

	// link
	private LinkCell source;
	private LinkCell target;
	private List<Label> labels;
	private List<String> grants;
	
	// link not used in JS
	private Element sourceElem;
	private Element targetElem;

	public String getId() {
		return id;
	}

	public String getIdt() {
		return idt;
	}

	public String getType() {
		return type;
	}

	public Position getPosition() {
		return position;
	}

	public String getText() {
		return text;
	}

	public LinkCell getSource() {
		return source;
	}

	public LinkCell getTarget() {
		return target;
	}

	public List<Label> getLabels() {
		return labels;
	}

	public List<String> getGrants() {
		return grants;
	}

	public Element getSourceElem() {
		return sourceElem;
	}

	public Element getTargetElem() {
		return targetElem;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setIdt(String idt) {
		this.idt = idt;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setPosition(Position position) {
		this.position = position;
	}

	public void setText(String text) {
		this.text = text;
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

	public void setGrants(List<String> grants) {
		this.grants = grants;
	}
	
	public void setSourceElem(Element sourceElem) {
		this.sourceElem = sourceElem;
	}

	public void setTargetElem(Element targetElem) {
		this.targetElem = targetElem;
	}

	public Element() {
	}

	public static Element createCell(
			String id, 
			String idt,
			String type, 
			Position position, 
			String text) {
		return new Element(
				id,
				idt,
				type,
				position,
				text,
				null,
				null,
				null);
	}
	
	public static Element createLink(
			String id, 
			String idt,
			LinkCell source, 
			LinkCell target,
			List<Label> labels) {
		return new Element(
				id,
				idt,
				"pathfinder.Link",
				null,
				null,
				source,
				target,
				labels);		
	}
	
	private Element(
			String id, 
			String idt,
			String type, 
			Position position, 
			String text,
			LinkCell source, 
			LinkCell target,
			List<Label> labels) {
		this.id = id;
		this.idt = idt;
		this.type = type;
		this.position = position;
		this.text = text;
		this.source = source;
		this.target = target;
		this.labels = labels;
	}

	@Override
	public int hashCode() {
		return getIdt().hashCode();
	}

	@Override
	public boolean equals(Object o) {
		if (o instanceof Element) {
			Element e = (Element) o;
			return getIdt().equals(e.getIdt());			
		}
		return false;
	}
}