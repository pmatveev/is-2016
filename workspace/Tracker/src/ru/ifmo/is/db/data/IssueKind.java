package ru.ifmo.is.db.data;

import ru.ifmo.is.db.DataClass;

public class IssueKind extends DataClass {
	public int id;
	public String name;
	public String code;
	
	public IssueKind(
			int id,
			String name,
			String code) {
		this.id = id;
		this.name = name;
		this.code = code;
	}
}
