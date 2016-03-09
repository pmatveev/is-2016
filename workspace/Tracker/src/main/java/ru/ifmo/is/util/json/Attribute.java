package ru.ifmo.is.util.json;

public class Attribute {
	private String text;
	private String d;

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getD() {
		return d;
	}

	public void setD(String d) {
		this.d = d;
	}

	public Attribute(String text, String d) {
		this.text = text;
		this.d = d;
	}
}
