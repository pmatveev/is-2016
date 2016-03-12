package ru.ifmo.is.util.json;

import java.util.LinkedList;
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
		this.cells = new LinkedList<Element>();
	}

	public Graph(String idt) {
		this.idt = idt;
		this.cells = new LinkedList<Element>();
	}

	public Graph(String idt, List<Element> cells) {
		this.idt = idt;
		this.cells = cells;
	}
}
