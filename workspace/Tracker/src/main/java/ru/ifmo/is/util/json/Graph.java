package ru.ifmo.is.util.json;

import java.util.LinkedList;
import java.util.List;

public class Graph {
	private List<Element> cells;

	public List<Element> getCells() {
		return cells;
	}

	public void setCells(List<Element> cells) {
		this.cells = cells;
	}

	public Graph() {
		this.cells = new LinkedList<Element>();
	}

	public Graph(List<Element> cells) {
		this.cells = cells;
	}
}
