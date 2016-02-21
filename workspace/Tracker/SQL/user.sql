create function add_officer_group (
	p_code varchar(32),
	p_name varchar(32)
) returns varchar(255)
begin
	declare gr int(32);
	
	select min(id)
	  into gr
	  from officer_group
	 where code = p_code;
	 
	if gr is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation
		insert into officer_group
			(code, name)
			values
			(p_code, p_name);
		
		return null;
	else
		return concat('Duplicated officer group code: ',  p_code);
	end if;
end 
$$

create function add_officer (
	p_code varchar(32),
	p_name varchar(256),
	p_pass varchar(32),
	p_group varchar(32)
) returns varchar(255)
begin
	declare of int(32);
	declare gr int(32);
	
	select min(id)
	  into of
	  from officer
	 where username = p_code;
	 
	if of is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation
		select min(id)
		  into gr
		  from officer_group
		 where code = p_group;
		
		if gr is null then
			return concat('Officer group ',  p_group,  ' does not exist: ',  p_code);
		end if;
		
		insert into officer
			(username, credentials, passhash, is_active, officer_group__id)
			values
			(upper(p_code), p_name, p_pass, true, gr);
		
		return null;
	else
		return concat('Duplicated username: ',  p_code);
	end if;
end 
$$

create function grant_officer(
	p_officer varchar(32),
	p_officer_group varchar(32),
	p_grant varchar(32)
) returns varchar(255)
begin
	declare of int(32);
	declare og int(32);
	declare gr int(32);
	declare mp int(32);
	
	if (p_officer is null and p_officer_group is null)
		or (p_officer is null and p_officer_group is null)
		then
		return 'Exactly one of (officer, officer group) should be specified';
	end if;
	
	if p_officer is not null then
		select min(id)
		  into of
		  from officer
		 where username = upper(p_officer);
		
		if of is null then
			return concat('Officer ',  p_officer,  ' does not exist.');
		end if;
	end if;
	
	if p_officer_group is not null then
		select min(id)
		  into og
		  from officer_group
		 where code = p_officer_group;
		
		if og is null then
			return concat('Officer group ',  p_officer_group,  ' does not exist.');
		end if;
	end if;
	
	select min(id)
	  into gr
	  from officer_grant
	 where code = p_grant;
	 
	if gr is null then
		return concat('Officer grant ',  p_grant,  ' does not exist.');
	end if;
	
	select min(id)
	  into mp
	  from officer_grant_map
	 where officer_grant__id = gr
	   and coalesce(officer__id, -1) = coalesce(of, -1)
	   and coalesce(officer_group__id, -1) = coalesce(og, -1);
	   
	if mp is not null then
		return concat(p_grant, ' is already granted to ', coalesce(p_officer, p_officer_group));
	end if;
	
	insert into officer_grant_map
		(officer__id, officer_group__id, officer_grant__id)
		values
		(of, og, gr);
		
	return null;
end; 
$$