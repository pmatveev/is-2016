import java.util.Date;

import ru.ifmo.is.db.DataClass;

public class Comment extends DataClass {
	public static final String COMMENT_KEY_PARM = "comment";
	
	public int id;
	public int author;
	public String authorDisplay;
	public Date dateCreated;
	public String text;
	
	public Comment(
			int id,
			int author,
			String authorDisplay,
			Date dateCreated,
			String text)
	{
		this.id = id;
		this.author = author;
		this.authorDisplay = authorDisplay;
		this.dateCreated = dateCreated;
		this.text = text;
	}
}
