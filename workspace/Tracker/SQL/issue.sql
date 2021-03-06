delimiter $$

create procedure new_issue(
	p_creator varchar(32),
	p_project varchar(32),
	p_kind varchar(32),
	p_summ varchar(255),
	p_descr varchar(4000),
	out p_res varchar(255)
) 
proc_label: begin
	declare v_project int(18);
	declare v_creator int(18);
	declare v_assignee int(18);
	declare v_kind int(18);
	declare v_status int(18);
	declare v_idt varchar(32);
	declare v_iss int(18);
	
	select min(id), min(available_for), min(owner), min(start_status)
	  into v_project, v_creator, v_assignee, v_status
	  from projects_available
	 where available_for_code = p_creator
	   and code = p_project;
	   
	if v_project is null or v_creator is null 
		or v_assignee is null or v_status is null 
		then
		set p_res = concat('E:Issue is not created. You may be lacking grants.');
		leave proc_label;
	end if;
	
	select min(id)
	  into v_kind
	  from issue_kind
	 where code = p_kind;
	 
	if v_kind is null then
		set p_res = concat('E:Issue is not created: type ', p_kind, ' not found');
		leave proc_label;
	end if;
	
	select concat(code, '-', counter)
	  into v_idt
	  from issue_project
	 where id = v_project
	   for update; -- here we guaratee that no issues will be having the same IDT
	   
	update issue_project
	   set counter = counter + 1
	 where id = v_project;
	
	insert into issue
		(idt, creator, assignee, kind, status, project, date_created, date_updated, 
			summary, description, active)
		values
		(v_idt, v_creator, v_assignee, v_kind, v_status, v_project, now(), now(), 
			p_summ, p_descr, true);
	
	select last_insert_id() into v_iss;
	update issue set prev_issue = v_iss where id = v_iss;
	
	set p_res = concat('I:', v_idt);
end 
$$

create function get_issue_by_idt(
	p_idt varchar(32)
) returns int(18)
begin
	declare v_res int(18);
	
	select min(id)
	  into v_res
	  from issue curr
	 where curr.prev_issue in (select min(i.prev_issue) from issue i where idt = p_idt)
	   and curr.active = true;
	
	return v_res;
end 
$$

create function add_issue_comment(
	p_user varchar(32),
	p_idt varchar(32),
	p_comment varchar(4000)
) returns varchar(255)
begin
	declare v_user int(18);
	declare v_issue int(18);
	declare v_updated datetime;
	
	if p_comment is null then
		return concat('E:Comment is not added: null comment specified');
	end if;	
	
	select min(id)
	  into v_user
	  from officer
	 where is_active = true
	   and username = p_user;
	   
	if v_user is null then
		return concat('E:Comment is not added: user ', p_user, ' not found');
	end if;
	
	set v_issue = get_issue_by_idt(p_idt);
	if v_issue is null then
		return concat('E:Comment is not added: issue ', p_idt, ' not found');
	end if;	
	
	set v_updated = now();
	
	insert into comment
		(officer__id, issue_before, issue_after, date_created, summary)
		values
		(v_user, v_issue, v_issue, v_updated, p_comment);
	
	update issue set date_updated = v_updated where id = v_issue;
	
	return 'I:';
end 
$$

-- no workflow change
create procedure transit_issue(
	p_user varchar(32),
	p_idt varchar(32),
	p_transit varchar(32),
	p_summary varchar(255),
	p_assignee varchar(32),
	p_kind varchar(32),
	p_description varchar(4000),
	p_resolution varchar(4000),
	p_comment varchar(4000),
	out p_res varchar(255)
)
proc_label: begin
	declare v_user int(18);
	declare v_issue int(18);
	declare v_transition int(18);
	declare v_status_to int(18);
	declare v_assignee int(18);
	declare v_kind int(18);
	declare v_updated datetime;
	declare v_new_issue int(18);
	declare v_active bool;
	declare v_counter int(3);
	
	set v_counter = 0;
	get_lock: loop
		commit; -- we've got the wrong lock, remove it
		-- no data affected so far
		set v_counter = v_counter + 1;
		if v_counter > 10 then
			set p_res = concat('E:', p_transit, ' is not completed: cannot lock the issue. Please try again later.');
			leave proc_label;
		end if;
		
		set v_issue = get_issue_by_idt(p_idt);
			
		if v_issue is null then
			set p_res = concat('E:', p_transit, ' is not completed: issue ', p_idt, ' not found');
			leave proc_label;
		end if;	
	
		select min(id), min(active) 
		  into v_issue, v_active 
		  from issue 
		 where id = v_issue 
		   for update;
		   
		if coalesce(v_active, false) = false then
			iterate get_lock;
		end if;
		leave get_lock;
	end loop get_lock;
	
	select min(id)
	  into v_assignee
	  from officer
	 where username = p_assignee
	   and is_active = true;
	
	select min(id)
	  into v_kind
	  from issue_kind
	 where code = p_kind;
	
	select min(available_for),
	       min(id),
	       min(status_to)
	  into v_user, 
	       v_transition,
	       v_status_to
	  from issue_status_transitions_available
	 where available_for_code = p_user
	   and issue_for = v_issue
	   and code = p_transit;
	   
	if v_user is null or v_transition is null or v_status_to is null then
		set p_res =  concat('E:', p_transit, ' is not completed. You may be lacking grants.');
		leave proc_label;
	end if;
	
	update issue set active = false where id = v_issue;
	set v_updated = now();
	
	insert into issue
		(idt, active, creator, assignee, kind, status, project, prev_issue, date_created, date_updated, summary, description, resolution)
		select idt, true, creator, coalesce(v_assignee, assignee), coalesce(v_kind, kind), v_status_to, project, prev_issue, date_created, v_updated, coalesce(p_summary, summary), coalesce(p_description, description), coalesce(p_resolution, resolution)
			from issue where id = v_issue;
	select last_insert_id() into v_new_issue;			
	
	insert into comment
		(officer__id, issue_before, issue_after, status_transition, date_created, summary)
		values
		(v_user, v_issue, v_new_issue, v_transition, v_updated, p_comment);
	
	set p_res = 'I:';
end 
$$

-- workflow change only
create procedure move_issue(
	p_user varchar(32),
	p_idt varchar(32),
	p_transit varchar(32),
	p_comment varchar(4000),
	out p_res varchar(255)
)
proc_label: begin
	declare v_user int(18);
	declare v_issue int(18);
	declare v_transition int(18);
	declare v_status_to int(18);
	declare v_project_to int(18);
	declare v_idt varchar(32);
	declare v_updated datetime;
	declare v_new_issue int(18);
	declare v_active bool;
	declare v_counter int(3);
	
	set v_counter = 0;
	get_lock: loop
		commit; -- we've got the wrong lock, remove it
		-- no data affected so far
		set v_counter = v_counter + 1;
		if v_counter > 10 then
			set p_res = concat('E:', p_transit, ' is not completed: cannot lock the issue. Please try again later.');
			leave proc_label;
		end if;
		
		set v_issue = get_issue_by_idt(p_idt);
			
		if v_issue is null then
			set p_res = concat('E:', p_transit, ' is not completed: issue ', p_idt, ' not found');
			leave proc_label;
		end if;	
	
		select min(id), min(active) 
		  into v_issue, v_active 
		  from issue 
		 where id = v_issue 
		   for update;
		   
		if coalesce(v_active, false) = false then
			iterate get_lock;
		end if;
		leave get_lock;
	end loop get_lock;
	
	select min(available_for),
	       min(id),
	       min(project_to),
	       min(status_to)
	  into v_user, 
	       v_transition,
	       v_project_to,
	       v_status_to
	  from issue_project_transitions_available
	 where available_for_code = p_user
	   and issue_for = v_issue
	   and code = p_transit;
	   
	if v_user is null or v_transition is null or v_project_to is null or v_status_to is null then
		set p_res = concat('E:', p_transit, ' is not completed. You may be lacking grants.');
		leave proc_label;
	end if;
	
	select concat(code, '-', counter)
	  into v_idt
	  from issue_project
	 where id = v_project_to
	   for update; -- here we guaratee that no issues will be having the same IDT
	   
	update issue_project
	   set counter = counter + 1
	 where id = v_project_to;
	
	update issue set active = false where id = v_issue;
	set v_updated = now();
	
	insert into issue
		(idt, active, creator, assignee, kind, status, project, prev_issue, date_created, date_updated, summary, description, resolution)
		select v_idt, true, creator, assignee, kind, v_status_to, v_project_to, prev_issue, date_created, v_updated, summary, description, resolution
			from issue where id = v_issue;
	select last_insert_id() into v_new_issue;			
	
	insert into comment
		(officer__id, issue_before, issue_after, project_transition, date_created, summary)
		values
		(v_user, v_issue, v_new_issue, v_transition, v_updated, p_comment);
	
	set p_res = concat('I:', v_idt);
end 
$$