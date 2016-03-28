package ru.ifmo.is.ws.util;

import javax.xml.bind.annotation.XmlElement;

import org.springframework.data.domain.Page;

import ru.ifmo.is.db.entity.Issue;

public class IssuePageWrapper {
	private IssueWrapper[] issues;
	private Long totalCount;
	
	public IssuePageWrapper() {
	}
	
	public IssuePageWrapper(Page<Issue> page) {
		if (page == null) {
			return;
		}
		
		this.totalCount = page.getTotalElements();
		
		this.issues = new IssueWrapper[page.getContent().size()];
		for (int i = 0; i < this.issues.length; i++) {
			this.issues[i] = new IssueWrapper(page.getContent().get(i));
		}
	}

	@XmlElement(name = "issue")
	public IssueWrapper[] getIssues() {
		return issues;
	}

	@XmlElement(name = "total-count")
	public Long getTotalCount() {
		return totalCount;
	}

	public void setIssues(IssueWrapper[] issues) {
		this.issues = issues;
	}

	public void setTotalCount(Long totalCount) {
		this.totalCount = totalCount;
	}
}
