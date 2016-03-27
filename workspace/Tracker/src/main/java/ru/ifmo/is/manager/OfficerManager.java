package ru.ifmo.is.manager;

import java.io.IOException;
import java.sql.Types;
import java.util.List;

import org.springframework.context.ApplicationContext;

import ru.ifmo.is.db.StatementExecutor;
import ru.ifmo.is.db.entity.Officer;
import ru.ifmo.is.db.entity.OfficerGrant;
import ru.ifmo.is.db.entity.OfficerGroup;
import ru.ifmo.is.db.service.OfficerGrantService;
import ru.ifmo.is.db.service.OfficerGroupService;
import ru.ifmo.is.db.service.OfficerService;
import ru.ifmo.is.db.util.Context;
import ru.ifmo.is.util.Pair;
import ru.ifmo.is.util.SQLParmKind;

public class OfficerManager {
	private ApplicationContext ctx;
	
	public OfficerManager() {
		ctx = Context.getContext();
	}
	
	public List<Officer> selectAllOfficers() {
		return ctx.getBean(OfficerService.class).selectAll();
	}

	public List<OfficerGroup> selectAllGroups() {
		return ctx.getBean(OfficerGroupService.class).selectAll();
	}
	
	public List<OfficerGrant> selectAllGrants() {
		return ctx.getBean(OfficerGrantService.class).selectAll();
	}
	
	public String addOfficerGrant(String name, Boolean admin) throws IOException {
		Object[] res = new StatementExecutor().call(
				"? = call add_officer_grant(?, ?, ?)", 
				new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, name.toUpperCase().replace(" ", "_")),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, name),
				new Pair<SQLParmKind, Object>(SQLParmKind.IN_BOOL, admin));
		if (res.length > 0 && res[0] != null && res[0] instanceof String) {
			return (String) res[0];
		}
		
		if (res.length > 1 && res[0] == null) {
			return null;
		}
		
		return "Service failed: no response from DB";	
	}
	
	public void setOfficerGrants(String officerFor, String groupFor,
			String grantList) throws IOException {
		if (!"".equals(officerFor)) {
			groupFor = null;
		}

		StatementExecutor db = new StatementExecutor();
		try {
			db.startTransaction();
			
			db.call("? = call clear_grants(?, ?)", 
					new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, officerFor),
					new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, groupFor));
			
			int delimiter = grantList.indexOf(',');
			while (delimiter > -1) {
				String grant = grantList.substring(0, delimiter);
				
				db.call("? = call grant_officer(?, ?, ?)", 
						new Pair<SQLParmKind, Object>(SQLParmKind.OUT_STRING, Types.VARCHAR),
						new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, officerFor),
						new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, groupFor),
						new Pair<SQLParmKind, Object>(SQLParmKind.IN_STRING, grant));
				
				grantList = grantList.substring(delimiter + 1);
				delimiter = grantList.indexOf(',');
			}
		} catch (Exception e) {
			db.rollbackTransaction();
			throw e;
		}
		db.commitTransaction();
	}
}
