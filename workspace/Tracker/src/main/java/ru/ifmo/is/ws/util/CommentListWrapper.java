package ru.ifmo.is.ws.util;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;

import ru.ifmo.is.db.entity.Comment;

public class CommentListWrapper {
	private CommentWrapper[] comments;
	
	public CommentListWrapper() {
	}
	
	public CommentListWrapper(List<Comment> comments) {
		if (comments == null) {
			return;
		}
		
		this.comments = new CommentWrapper[comments.size()];
		for (int i = 0; i < this.comments.length; i++) {
			this.comments[i] = new CommentWrapper(comments.get(i));
		}
	}

	@XmlElement(name = "comment")
	public CommentWrapper[] getComments() {
		return comments;
	}

	public void setComments(CommentWrapper[] comments) {
		this.comments = comments;
	}
}
