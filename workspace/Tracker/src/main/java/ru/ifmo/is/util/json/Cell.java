package ru.ifmo.is.util.json;

public class Cell extends Element {
	private Position position;
	private Size size;

	public Position getPosition() {
		return position;
	}

	public Size getSize() {
		return size;
	}

	public void setPosition(Position position) {
		this.position = position;
	}

	public void setSize(Size size) {
		this.size = size;
	}

	public Cell(
			String id, 
			String type, 
			Attributes attrs, 
			Position position,
			Size size) {
		super(id, type, attrs);
		this.position = position;
		this.size = size;
	}
}
