package ru.ifmo.is.db.entity;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="issue_project")
public class IssueProject {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private long id;

	@ManyToOne(fetch = FetchType.LAZY, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "start_status", nullable = false)
	private IssueStatus startStatus;

	@ManyToOne(fetch = FetchType.LAZY, optional = false, cascade = CascadeType.ALL)
	@JoinColumn(name = "owner", nullable = false)
	private Officer owner;
	
	@Column(name = "name", length = 32, nullable = false)
	private String name;

	@Column(name = "code", length = 32, nullable = false)
	private String code;
	
	@Column(name = "is_active", columnDefinition = "bit", length = 1, nullable = false)
	private boolean isActive;
	
	@Column(name = "counter", columnDefinition = "int", length = 18, nullable = false)
	private long counter;

	public IssueProject() {
	}
	
	public IssueProject(
			IssueStatus startStatus, 
			Officer owner, 
			String name,
			String code, 
			boolean isActive, 
			long counter) {
		this.startStatus = startStatus;
		this.owner = owner;
		this.name = name;
		this.code = code;
		this.isActive = isActive;
		this.counter = counter;
	}

	public long getId() {
		return id;
	}

	public IssueStatus getStartStatus() {
		return startStatus;
	}

	public Officer getOwner() {
		return owner;
	}

	public String getName() {
		return name;
	}

	public String getCode() {
		return code;
	}

	public boolean isActive() {
		return isActive;
	}

	public long getCounter() {
		return counter;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setStartStatus(IssueStatus startStatus) {
		this.startStatus = startStatus;
	}

	public void setOwner(Officer owner) {
		this.owner = owner;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public void setCounter(long counter) {
		this.counter = counter;
	}
}
