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

@Deprecated
public class CommentData extends DataClass {
	public String issueIdt;
	public String author;
	public String authorDisplay;
	public Date dateCreated; // should always be placed in "date_created" column
	public String statusTransition;
	public String statusTransitionDisplay;
	public String projectTransition;
	public IssueData before;
	public IssueData after;
	public String text;
	
	public CommentData(
			String issueIdt,
			String author,
			String authorDisplay,
			Date dateCreated,
			String statusTransition,
			String statusTransitionDisplay,
			String projectTransition,
			IssueData before,
			IssueData after,
			String text)
	{
		this.issueIdt = issueIdt;
		this.author = author;
		this.authorDisplay = authorDisplay;
		this.dateCreated = dateCreated;
		this.statusTransition = statusTransition;
		this.statusTransitionDisplay = statusTransitionDisplay;
		this.projectTransition = projectTransition;
		this.before = before;
		this.after = after;
		this.text = text;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<CommentData> comments = new LinkedList<CommentData>();
		
		while (rs.next()) {
			comments.add(new CommentData(
					issueIdt == null ? null : rs.getString(issueIdt),
					author == null ? null : rs.getString(author),
					authorDisplay == null ? null : rs.getString(authorDisplay),
					dateCreated == null ? null : rs.getTimestamp("date_created"),
					statusTransition == null ? null : rs.getString(statusTransition),
					statusTransitionDisplay == null ? null : rs.getString(statusTransitionDisplay),
					projectTransition == null ? null : rs.getString(projectTransition),
					new IssueData(
							0,
							before.idt == null ? null : rs.getString(before.idt),
							before.creator == null ? null : rs.getString(before.creator),
							before.creatorDisplay == null ? null : rs.getString(before.creatorDisplay),
							before.assignee == null ? null : rs.getString(before.assignee),
							before.assigneeDisplay == null ? null : rs.getString(before.assigneeDisplay),
							before.kind == null ? null : rs.getString(before.kind),
							before.kindDisplay == null ? null : rs.getString(before.kindDisplay),
							before.status == null ? null : rs.getString(before.status),
							before.statusDisplay == null ? null : rs.getString(before.statusDisplay),
							before.project == null ? null : rs.getString(before.project),
							before.projectDisplay == null ? null : rs.getString(before.projectDisplay),
							null,
							null,
							before.summary == null ? null : rs.getString(before.summary),
							before.description == null ? null : rs.getString(before.description),
							before.resolution == null ? null : rs.getString(before.resolution)
							),
					new IssueData(
							0,
							after.idt == null ? null : rs.getString(after.idt),
							after.creator == null ? null : rs.getString(after.creator),
							after.creatorDisplay == null ? null : rs.getString(after.creatorDisplay),
							after.assignee == null ? null : rs.getString(after.assignee),
							after.assigneeDisplay == null ? null : rs.getString(after.assigneeDisplay),
							after.kind == null ? null : rs.getString(after.kind),
							after.kindDisplay == null ? null : rs.getString(after.kindDisplay),
							after.status == null ? null : rs.getString(after.status),
							after.statusDisplay == null ? null : rs.getString(after.statusDisplay),
							after.project == null ? null : rs.getString(after.project),
							after.projectDisplay == null ? null : rs.getString(after.projectDisplay),
							null,
							null,
							after.summary == null ? null : rs.getString(after.summary),
							after.description == null ? null : rs.getString(after.description),
							after.resolution == null ? null : rs.getString(after.resolution)
							),
					text == null ? null : rs.getString(text)));
		}
		
		return comments.toArray(new CommentData[0]);
	}
	
	public static CommentData[] selectByIssue(Integer id) throws IOException {
		if (id == null) {
			return null;
		}
		IssueData beforeMask = new IssueData(
				-1,
				"idt_before",
				null,
				null,
				null,
				"assignee_before_display",
				null,
				"kind_before_display",
				null,
				"status_before_display",
				null,
				"project_before_display",
				null,
				null,
				null,
				null,
				null
				);
		IssueData afterMask = new IssueData(
				-1,
				"idt_after",
				null,
				null,
				null,
				"assignee_after_display",
				null,
				"kind_after_display",
				null,
				"status_after_display",
				null,
				"project_after_display",
				null,
				null,
				null,
				null,
				null
				);
		
		CommentData mask = new CommentData(
				null,
				null,
				"author_display",
				new Date(),
				null,
				"status_transition_display",
				"project_transition",
				beforeMask,
				afterMask,
				"summary");
		
		String stmt = "date_created, " +
				"summary, " +
				"author_display, " +
				"status_transition_display, " +
				"project_transition, " +
				"idt_before, " +
				"assignee_before_display, " +
				"kind_before_display, " +
				"status_before_display, " +
				"project_before_display, " +
				"idt_after, " +
				"assignee_after_display, " +
				"kind_after_display, " +
				"status_after_display, " +
				"project_after_display " +
				"from issue_comments " +
				"where issue_id = ? " +
				"order by date_created asc";
		
		return new StatementExecutor().select(
				mask, 
				stmt, 
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_INT, id));
	}
}
