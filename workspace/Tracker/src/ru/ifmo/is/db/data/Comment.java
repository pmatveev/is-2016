package ru.ifmo.is.db.data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import ru.ifmo.is.db.DataClass;
import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

public class Comment extends DataClass {
	public String issueIdt;
	public String author;
	public String authorDisplay;
	public Date dateCreated; // should always be placed in "date_created" column
	public String text;
	
	public Comment(
			String issueIdt,
			String author,
			String authorDisplay,
			Date dateCreated,
			String text)
	{
		this.issueIdt = issueIdt;
		this.author = author;
		this.authorDisplay = authorDisplay;
		this.dateCreated = dateCreated;
		this.text = text;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<Comment> comments = new LinkedList<Comment>();
		
		while (rs.next()) {
			comments.add(new Comment(
					issueIdt == null ? null : rs.getString(issueIdt),
					author == null ? null : rs.getString(author),
					authorDisplay == null ? null : rs.getString(authorDisplay),
					dateCreated == null ? null : rs.getTimestamp("date_created"),
					text == null ? null : rs.getString(text)));
		}
		
		return comments.toArray(new Comment[0]);
	}
	
	public static Comment[] selectByIssue(Integer id) throws IOException {
		if (id == null) {
			return null;
		}
		Comment mask = new Comment(
				null,
				"author",
				"author_display",
				new Date(),
				"summary");
		
		String stmt = "date_created, " +
				"summary, " +
				"author, " +
				"author_display " +
				"from issue_comments " +
				"where issue_id = ? " +
				"order by date_created asc";
		
		return new StatementExecutor().select(
				mask, 
				stmt, 
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_INT, id));
	}
}
