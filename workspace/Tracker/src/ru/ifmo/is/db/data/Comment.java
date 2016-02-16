package ru.ifmo.is.db.data;

import java.util.Date;
import ru.ifmo.is.db.DataClass;

public class Comment extends DataClass {
	public int id;
	public int issueId;
	public String author;
	public String authorDisplay;
	public Date dateCreated;
	public String text;
	
	public Comment(
			int id,
			int issueId,
			String author,
			String authorDisplay,
			Date dateCreated,
			String text)
	{
		this.id = id;
		this.issueId = issueId;
		this.author = author;
		this.authorDisplay = authorDisplay;
		this.dateCreated = dateCreated;
		this.text = text;
	}
}
