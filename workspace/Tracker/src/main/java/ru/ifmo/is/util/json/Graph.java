package ru.ifmo.is.util.json;

import java.util.ArrayList;
import java.util.List;

public class Graph {
	private String idt;
	private List<Element> cells;

	public String getIdt() {
		return idt;
	}
	
	public List<Element> getCells() {
		return cells;
	}
	
	public void setIdt(String idt) {
		this.idt = idt;
	}

	public void setCells(List<Element> cells) {
		this.cells = cells;
	}

	public Graph() {
		this.cells = new ArrayList<Element>();
	}

	public Graph(String idt) {
		this.idt = idt;
		this.cells = new ArrayList<Element>();
	}

	public Graph(String idt, List<Element> cells) {
		this.idt = idt;
		this.cells = cells;
	}
	
	public Element findByIdt(String idt) {
		Element templ = new Element();
		templ.setIdt(idt);
		
		int index = cells.indexOf(templ);
		if (index == -1) {
			return null;
		}
		return cells.get(index);
	}
}
