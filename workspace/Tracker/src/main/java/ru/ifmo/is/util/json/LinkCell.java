package ru.ifmo.is.util.json;

public class LinkCell {
	private String id;
	private String idt;

	public String getId() {
		return id;
	}

	public String getIdt() {
		return idt;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setIdt(String idt) {
		this.idt = idt;
	}
	
	public LinkCell(String id, String idt) {
		this.id = id;
		this.idt = idt;
	}
}
