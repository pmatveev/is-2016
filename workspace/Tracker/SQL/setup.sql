delimiter $$

create function add_status (
	p_code varchar(32),
	p_name varchar(32)
) returns varchar(255)
begin
	declare st int(32);
	
	select min(id)
	  into st
	  from issue_status
	 where code = p_code;
	 
	if st is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation
		insert into issue_status
			(code, name)
			values
			(p_code, p_name);
		
		return null;
	else
		return concat('Duplicated issue status code: ', p_code);
	end if;
end 
$$

create function add_kind (
	p_code varchar(32),
	p_name varchar(32)
) returns varchar(255)
begin
	declare ty int(32);
	
	select min(id)
	  into ty
	  from issue_kind
	 where code = p_code;
	 
	if ty is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation
		insert into issue_kind
			(code, name)
			values
			(p_code, p_name);
		
		return null;
	else
		return concat('Duplicated issue type code: ', p_code);
	end if;
end 
$$

create function add_project(
	p_code varchar(32),
	p_name varchar(32),
	p_status varchar(32),
	p_owner varchar(32)
) returns varchar(255)
begin
	declare pr int(32);
	declare off int(32);
	declare offActive bool;
	declare st int(32);
	
	select min(id), min(is_active)
	  into off, offActive
	  from officer
	 where username = p_owner;
	 
	if off is null then
		return concat('Officer ',  p_owner,  ' doesn''t exist: ',  p_code);
	elseif offActive = false then
		return concat('Officer ',  p_owner,  ' isn''t active: ',  p_code);		
	end if;
	
	select min(id)
	  into st
	  from issue_status
	 where code = p_status;
	 
	if st is null then
		return concat('Status ',  p_status,  ' doesn''t exist: ',  p_code);		
	end if;
	
	select min(id)
	  into pr
	  from issue_project
	 where code = p_code;
	 
	if pr is null then 
		insert into issue_project
			(start_status, owner, code, name, is_active, counter)
			values
			(st, off, p_code, p_name, true, 1);
	else
		-- just update existing
		update issue_project
		   set start_status = st,
		       owner = off,
		       name = p_name
		 where id = pr;
		 
		-- remove grants
		delete from grant_transition_map
		 where project_transition__id in (select id
		                                     from project_transition pt
		                                    where pt.is_active = true
		                                      and pt.project_from = pr)
		    or status_transition__id in (select id
		                                    from status_transition st
		                                   where st.is_active = true
		                                     and st.issue_project__id = pr);
		
		-- and make its transitions deprecated
		 update status_transition
		    set code = concat('OLD_', id, '_', code),
		        is_active = false
		  where issue_project__id = pr
		    and is_active = true;
		    
		 update project_transition
		    set code = concat('OLD_', id, '_', code),
		        is_active = false
		  where project_from = pr
		    and is_active = true;
	end if;	

	return null;
end
$$ 

create function add_status_transition(
	p_code varchar(255),
	p_name varchar(32),
	p_project varchar(32),
	p_status_from varchar(32),
	p_status_to varchar(32)
) returns varchar(255)
begin
	declare tr int(32);
	declare pr int(32);
	declare st1 int(32);
	declare st2 int(32);	
	
	if (p_status_from is null and p_status_to is not null)
		or (p_status_from is not null and p_status_to is null)
		then
		return 'Statuses should be both null or both filled';
	end if;
		
	select min(id) 
	  into tr
	  from status_transition
	 where code = p_code;
	 
	if tr is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation		
		select min(id)
		  into pr
		  from issue_project
		 where code = p_project;
		
		if pr is null then
			return concat('Project ',  p_project,  ' doesn''t exist: ',  p_code);				
		end if;
	
		if p_status_from is not null and p_status_to is not null then
			select min(id)
			  into st1
			  from issue_status
			 where code = p_status_from;
			 
			if st1 is null then
				return concat('Status ',  p_status_from,  ' doesn''t exist: ',  p_code);		
			end if;
			
			select min(id)
			  into st2
			  from issue_status
			 where code = p_status_to;
			 
			if st2 is null then
				return concat('Status ',  p_status_to,  ' doesn''t exist: ',  p_code);		
			end if;
		end if;
	
		insert into status_transition
			(issue_project__id, status_from, status_to, name, code)
			values
			(pr, st1, st2, p_name, p_code);
		
		return null;
	else
		return concat('Duplicated issue status transition code: ',  p_code);
	end if;		
end
$$

create function add_project_transition(
	p_code varchar(255),
	p_project_from varchar(32),
	p_project_to varchar(32),
	p_status_from varchar(32),
	p_status_to varchar(32)
) returns varchar(255)
begin
	declare tr int(32);
	declare pr1 int(32);
	declare pr2 int(32);
	declare st1 int(32);
	declare st2 int(32);	
	
	select min(id) 
	  into tr
	  from project_transition
	 where code = p_code;
	 
	if tr is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation		
		select min(id)
		  into pr1
		  from issue_project
		 where code = p_project_from;
		
		if pr1 is null then
			return concat('Project ',  p_project_from,  ' doesn''t exist: ',  p_code);				
		end if;
		
		select min(id)
		  into pr2
		  from issue_project
		 where code = p_project_to;
		
		if pr2 is null then
			return concat('Project ',  p_project_to,  ' doesn''t exist: ',  p_code);				
		end if;
	
		select min(id)
		  into st1
		  from issue_status
		 where code = p_status_from;
		 
		if st1 is null then
			return concat('Status ',  p_status_from,  ' doesn''t exist: ',  p_code);		
		end if;
		
		select min(id)
		  into st2
		  from issue_status
		 where code = p_status_to;
		 
		if st2 is null then
			return concat('Status ',  p_status_to,  ' doesn''t exist: ',  p_code);		
		end if;
	
		insert into project_transition
			(project_from, project_to, status_from, status_to, code)
			values
			(pr1, pr2, st1, st2, p_code);
		
		return null;
	else
		return concat('Duplicated issue project transition code: ',  p_code);
	end if;		
end
$$

create function add_officer_grant (
	p_code varchar(32),
	p_name varchar(32),
	p_admin bool
) returns varchar(255)
begin
	declare gr int(32);
	
	select min(id)
	  into gr
	  from officer_grant
	 where code = p_code;
	 
	if gr is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation
		insert into officer_grant
			(code, name, is_admin)
			values
			(p_code, p_name, p_admin);
		
		return null;
	else
		return concat('Duplicated officer grant code: ',  p_code);
	end if;
end 
$$

create function add_grant_mapping (
	p_grant varchar(32),
	p_project_transition varchar(32),
	p_status_transition varchar(32)
) returns varchar(255)
begin
	declare gr int(32);
	declare pr int(32);
	declare st int(32);
	
	select min(id)
	  into gr
	  from officer_grant
	 where code = p_grant;
 
 	if gr is null then
		return 'Officer grant does not exist';	-- some kind of bug in connector does not allow concat here
	end if;
	
	if p_project_transition is not null then
		select min(id)
		  into pr
		  from project_transition
		 where code = p_project_transition;
	 
	 	if pr is null then
			return concat('Project transition ',  p_project_transition,  ' doesn''t exist');		
		end if;
	end if;
	
	if p_status_transition is not null then
		select min(id)
		  into st
		  from status_transition
		 where code = p_status_transition;
	 
	 	if st is null then
			return concat('Status transition ',  p_status_transition,  ' doesn''t exist');		
		end if;
	end if;
	
	insert into grant_transition_map
		(officer_grant__id, project_transition__id, status_transition__id)
		values
		(gr, pr, st);
	
	return null;
end 
$$