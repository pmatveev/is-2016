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
		return 'Duplicated issue status code: ' || p_code;
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
		return 'Duplicated issue type code: ' || p_code;
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
	declare offActive int(32);
	declare st int(32);
	
	select min(id)
	  into pr
	  from issue_project
	 where code = p_code;
	 
	if pr is null then 
		-- do not insert with existing codes, 
		-- prevent from exception on constraint violation
		select min(id), min(is_active)
		  into off, offActive
		  from officer
		 where username = p_owner;
		 
		if off is null then
			return 'Officer ' || p_owner || ' does not exist: ' || p_code;
		elsif offActive = false then
			return 'Officer ' || p_owner || ' is not active: ' || p_code;		
		end if;
		
		select min(id)
		  into st
		  from ussue_status
		 where code = p_status;
		 
		if st is null then
			return 'Status ' || p_status || ' does not exist: ' || p_code;		
		end if;
	
		insert into issue_project
			(start_status, owner, code, name, is_active, counter)
			values
			(st, off, p_code, p_name, true, 1);
		
		return null;
	else
		return 'Duplicated issue project code: ' || p_code;
	end if;	
end
$$ 