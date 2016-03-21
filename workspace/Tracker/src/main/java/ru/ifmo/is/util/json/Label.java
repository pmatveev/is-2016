package ru.ifmo.is.util.json;

public class Label {
	private Float position;
	private Attributes attrs;

	public Float getPosition() {
		return position;
	}

	public Attributes getAttrs() {
		return attrs;
	}

	public void setPosition(Float position) {
		this.position = position;
	}

	public void setAttrs(Attributes attrs) {
		this.attrs = attrs;
	}

	public Label(Float position, Attributes attrs) {
		this.position = position;
		this.attrs = attrs;
	}
}
