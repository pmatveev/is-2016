package ru.ifmo.is.util.json;

public abstract class Element {
	private String id;
	private String type;
	private Attributes attrs;

	public String getId() {
		return id;
	}

	public String getType() {
		return type;
	}

	public Attributes getAttrs() {
		return attrs;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setAttrs(Attributes attrs) {
		this.attrs = attrs;
	}

	protected Element(String id, String type, Attributes attrs) {
		this.id = id;
		this.type = type;
		this.attrs = attrs;
	}
}