package ru.ifmo.is.util.json;

public class Attributes {
	private Attribute text;
	private Attribute markerTarget;

	public Attribute getText() {
		return text;
	}

	public Attribute getMarkerTarget() {
		return markerTarget;
	}

	public void setText(Attribute text) {
		this.text = text;
	}

	public void setMarkerTarget(Attribute markerTarget) {
		this.markerTarget = markerTarget;
	}

	public Attributes(Attribute text, Attribute markerTarget) {
		this.text = text;
		this.markerTarget = markerTarget;
	}
}
