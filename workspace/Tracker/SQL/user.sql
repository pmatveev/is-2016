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
