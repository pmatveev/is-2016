delimiter $$

create function authenticate (
	p_user varchar(32),
	p_pass varchar(32),
	p_conn varchar(32)
) returns varchar(32)
begin
	declare	ofcr int(32);
	declare cookie varchar(32);
	declare tmp varchar(10);
	
	select min(id)
	  into ofcr
	  from officer
	 where username = upper(p_user)
	   and passhash = p_pass
	   and is_active = true;
	   
	if ofcr is not null then
		set cookie = date_format(now(), '%y%m%d%H%i%s');
		
		set tmp = right(concat('0000000000', floor(rand() * 1000000000000)), 10);
		set cookie = concat(cookie, tmp);
		
		set tmp = right(concat('0000000000', floor(rand() * 1000000000000)), 10);
		set cookie = concat(cookie, tmp);
		
		update officer_session
		   set date_to = now()
		 where officer__id = ofcr
		   and now() between date_from and date_to
		   and conn = p_conn;
		
		insert into officer_session
			(officer__id, date_from, date_to, token, conn)
			values
			(ofcr, now(), date_add(now(), interval 2 hour), cookie, p_conn);
		
		return cookie;
	else
		return null;
	end if;
end; 
$$

create procedure verify_auth(
	in p_conn varchar(32),
	in p_token varchar(32),
	out p_user varchar(32),
	out p_cred varchar(32),
	out p_admin bool
) 
begin
	declare ofcr int(32);
	declare ses int(32);
	
	select min(id), min(officer__id)
	  into ses, ofcr
	  from officer_session
	 where conn = p_conn
	   and token = p_token
	   and now() between date_from and date_to;
	   
	if ofcr is not null then
		update officer_session
		   set date_to = date_add(now(), interval 2 hour)
		 where id = ses;
	
		select min(o.username), min(o.credentials), case when min(ag.is_admin) is not null then true else false end
		  into p_user, p_cred, p_admin
		  from officer o
		  left join available_grants ag
		    on o.id = ag.officer_id
		   and ag.is_admin = true
		 where id = ofcr;
	end if;
end;
$$

create procedure close_auth(
	in p_conn varchar(32),
	in p_token varchar(32)
) 
begin
	update officer_session
	   set date_to = now()
	 where conn = p_conn
	   and token = p_token
	   and now() between date_from and date_to;
end;
$$