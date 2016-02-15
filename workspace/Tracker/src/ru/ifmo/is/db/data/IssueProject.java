package ru.ifmo.is.db.data;

import ru.ifmo.is.db.DataClass;

public class IssueProject extends DataClass {
	public int id;
	public String startStatus;
	public String startStatusDisplay;
	public String owner;
	public String ownerDisplay;
	public String code;
	public String name;

	public IssueProject(
			int id,
			String startStatus,
			String startStatusDisplay,
			String owner,
			String ownerDisplay,
			String code,
			String name) {
		this.id = id;
		this.startStatus = startStatus;
		this.startStatusDisplay = startStatusDisplay;
		this.owner = owner;
		this.ownerDisplay = ownerDisplay;
		this.code = code;
		this.name = name;
	}
}
