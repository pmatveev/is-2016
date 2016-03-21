package ru.ifmo.is.util.json;

public class Attributes {
	private Attribute text;

	public Attribute getText() {
		return text;
	}

	public void setText(Attribute text) {
		this.text = text;
	}

	public Attributes(Attribute text) {
		this.text = text;
	}
}
