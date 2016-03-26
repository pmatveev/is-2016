package ru.ifmo.is.db.entity;

import java.util.List;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "officer_group")
public class OfficerGroup {
	@Id
	@GeneratedValue(generator = "increment")
	@GenericGenerator(name = "increment", strategy = "increment")
	@Column(name = "id", columnDefinition = "int", length = 18, nullable = false)
	private Long id;

	@Column(name = "name", length = 32, nullable = false)
	private String name;

	@Column(name = "code", length = 32, nullable = false)
	private String code;

	@OneToMany(fetch = FetchType.EAGER, mappedBy = "group")
	private List<Officer> officers;
	
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "officer_grant_map", 
		joinColumns = { @JoinColumn(name = "officer_group__id", nullable = true) }, 
		inverseJoinColumns = { @JoinColumn(name = "officer_grant__id", nullable = false) })
	private List<OfficerGrant> grants;
	
	public OfficerGroup() {
	}

	public OfficerGroup(
			String name, 
			String code, 
			List<Officer> officers, 
			List<OfficerGrant> grants) {
		this.name = name;
		this.code = code;
		this.officers = officers;
		this.grants = grants;
	}

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getCode() {
		return code;
	}

	public List<Officer> getOfficers() {
		return officers;
	}
	
	public List<OfficerGrant> getGrants() {
		return grants;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public void setOfficers(List<Officer> officers) {
		this.officers = officers;
	}
	
	public void setGrants(List<OfficerGrant> grants) {
		this.grants = grants;
	}
}
