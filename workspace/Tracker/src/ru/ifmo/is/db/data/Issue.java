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

public class Issue extends DataClass {	
	public int id; // should always be placed in "id" column
	public String idt;
	public String creator;
	public String creatorDisplay;
	public String assignee;
	public String assigneeDisplay;
	public String kind;
	public String kindDisplay;
	public String status;
	public String statusDisplay;
	public String project;
	public String projectDisplay;
	public Date dateCreated; // should always be placed in "date_created" column
	public Date dateUpdated; // should always be placed in "date_updated" column
	public String summary;
	public String description;
	public String resolution;
	
	public Issue(
			int id,
			String idt,
			String creator,
			String creatorDisplay,
			String assignee,
			String assigneeDisplay,
			String kind,
			String kindDisplay,
			String status,
			String statusDisplay,
			String project,
			String projectDisplay,
			Date dateCreated,
			Date dateUpdated,
			String summary,
			String description,
			String resolution) {
		this.id = id;
		this.idt = idt;
		this.creator = creator;
		this.creatorDisplay = creatorDisplay;
		this.assignee = assignee;
		this.assigneeDisplay = assigneeDisplay;
		this.kind = kind;
		this.kindDisplay = kindDisplay;
		this.status = status;
		this.statusDisplay = statusDisplay;
		this.project = project;
		this.projectDisplay = projectDisplay;
		this.dateCreated = dateCreated;
		this.dateUpdated = dateUpdated;
		this.summary = summary;
		this.description = description;
		this.resolution = resolution;
	}

	@Override
	public DataClass[] parseResultSet(ResultSet rs) throws SQLException {
		List<Issue> issues = new LinkedList<Issue>();
		
		while (rs.next()) {
				issues.add(new Issue(
					id == -1 ? -1 : rs.getInt("id"),
					idt == null ? null : rs.getString(idt),
					creator == null ? null : rs.getString(creator),
					creatorDisplay == null ? null : rs.getString(creatorDisplay),
					assignee == null ? null : rs.getString(assignee),
					assigneeDisplay == null ? null : rs.getString(assigneeDisplay),
					kind == null ? null : rs.getString(kind),
					kindDisplay == null ? null : rs.getString(kindDisplay),
					status == null ? null : rs.getString(status),
					statusDisplay == null ? null : rs.getString(statusDisplay),
					project == null ? null : rs.getString(project),
					projectDisplay == null ? null : rs.getString(projectDisplay),
					dateCreated == null ? null : rs.getTimestamp("date_created"),
					dateUpdated == null ? null : rs.getTimestamp("date_updated"),
					summary == null ? null : rs.getString(summary),
					description == null ? null : rs.getString(description),
					resolution == null ? null : rs.getString(resolution)));
		}
		
		return issues.toArray(new Issue[0]);
	}

	private static void appendWhereLike(StringBuilder where, String column,
			String filter) {
		if (filter != null && !"".equals(filter)) {
			where.append(" and ")
					.append(column)
					.append(" like '%")
					.append(filter.replaceAll("_", "\\_")
							.replaceAll("%", "\\%")).append("%' ");
		}
	}
	
	private static void appendOrderBy(StringBuilder order, int priority,
			String column, String code) {
		if (code != null && code.length() > 0
				&& code.charAt(0) == Integer.toString(priority).charAt(0)) {
			order.append(column).append(" ").append(code.substring(1)).append(", ");
		}
	}
	
	public static Pair<Issue[], Integer> selectLike(
			int from,
			int num,
			String idt, 
			String summary, 
			String project,
			String kind, 
			String status, 
			String creator, 
			String assignee, 
			String createdOrder, 
			String updatedOrder) throws IOException {
		
		StringBuilder where = new StringBuilder();
		appendWhereLike(where, "idt", idt);
		appendWhereLike(where, "summary", summary);
		appendWhereLike(where, "project", project);
		appendWhereLike(where, "kind", kind);
		appendWhereLike(where, "status", status);
		appendWhereLike(where, "creator_display", creator);
		appendWhereLike(where, "assignee_display", assignee);

		if (where.length() > 3 && " and".equals(where.substring(0, 4))) {
			where.replace(0, 4, " where");
		}
		
		StringBuilder order = new StringBuilder(" order by ");
		// 1st priority
		appendOrderBy(order, 1, "date_created", createdOrder);
		appendOrderBy(order, 1, "date_updated", updatedOrder);
		// 2nd priority
		appendOrderBy(order, 2, "date_created", createdOrder);
		appendOrderBy(order, 2, "date_updated", updatedOrder);
		order.append("prev_issue asc");
		
		Issue mask = new Issue(
				-1,
				"idt",
				null,
				"creator_display",
				null,
				"assignee_display",
				null,
				"kind_display",
				null,
				"status_display",
				null,
				"project_display",
				new Date(),
				new Date(),
				"summary",
				null,
				null);

		String stmt = "select SQL_CALC_FOUND_ROWS " +
				"idt, " +
				"creator_display, " +
				"assignee_display, " +
				"kind_display, " +
				"status_display, " +
				"project_display, " +
				"date_created, " +
				"date_updated, " +
				"summary " +
				"from active_issues a"
				+ where.toString() + order.toString()
				+ " limit " + from + ", " + num;
		
		return new StatementExecutor().selectCount(mask, stmt);
	}
}
