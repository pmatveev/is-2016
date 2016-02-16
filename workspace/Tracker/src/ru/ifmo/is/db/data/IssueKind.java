package ru.ifmo.is.db.data;

import ru.ifmo.is.db.DataClass;

public class IssueKind extends DataClass {
	public int id;
	public String code;
	public String name;
	
	public IssueKind(
			int id,
			String code,
			String name
			) {
		this.id = id;
		this.name = name;
		this.code = code;
	}
}
