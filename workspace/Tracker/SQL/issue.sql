create function new_issue(
	p_creator varchar(32),
	p_project varchar(32),
	p_kind varchar(32),
	p_summ varchar(255),
	p_descr varchar(4000)
) returns varchar(255)
begin
	declare v_project int(18);
	declare v_creator int(18);
	declare v_assignee int(18);
	declare v_kind int(18);
	declare v_status int(18);
	declare v_idt varchar(32);
	declare v_iss int(18);
	
	select min(project_id), min(available_for), min(owner), min(start_status)
	  into v_project, v_creator, v_assignee, v_status
	  from projects_available
	 where available_for_code = p_creator
	   and project_code = p_project;
	   
	if v_project is null or v_creator is null 
		or v_assignee is null or v_status is null 
		then
		return concat('E:Issue is not created. You may be lacking grants.');
	end if;
	
	select min(id)
	  into v_kind
	  from issue_kind
	 where code = p_kind;
	 
	if v_kind is null then
		return concat('E:Issue is not created: type ', p_kind, ' not found');
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
	
	return concat('I:', v_idt);
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
create function transit_issue(
	p_user varchar(32),
	p_idt varchar(32),
	p_transit varchar(32),
	p_summary varchar(255),
	p_assignee varchar(32),
	p_kind varchar(32),
	p_description varchar(4000),
	p_resolution varchar(4000),
	p_comment varchar(4000)
) returns varchar(255)
begin
	declare v_user int(18);
	declare v_issue int(18);
	declare v_transition int(18);
	declare v_status_to int(18);
	declare v_assignee int(18);
	declare v_kind int(18);
	declare v_updated datetime;
	declare v_new_issue int(18);
		
	set v_issue = get_issue_by_idt(p_idt);
		
	if v_issue is null then
		return concat('E:', p_transit, ' is not completed: issue ', p_idt, ' not found');
	end if;	

	select id into v_issue from issue where id = v_issue for update;
	
	select min(id)
	  into v_assignee
	  from officer
	 where username = p_assignee
	   and is_active = true;
	
	if v_assignee is null then
		return concat('E:', p_transit, ' is not completed: assignee ', p_assignee, ' not found');
	end if;	   
	
	select min(id)
	  into v_kind
	  from issue_kind
	 where code = p_kind;
	
	if v_kind is null then
		return concat('E:', p_transit, ' is not completed: issue kind ', p_kind, ' not found');
	end if;	  
	
	select min(available_for),
	       min(transition),
	       min(status_to)
	  into v_user, 
	       v_transition,
	       v_status_to
	  from issue_status_transitions_available
	 where available_for_code = p_user
	   and issue_for = v_issue
	   and code = p_transit;
	   
	if v_user is null or v_transition is null or v_status_to is null then
		return concat('E:', p_transit, ' is not completed. You may be lacking grants.');
	end if;
	
	update issue set active = false where id = v_issue;
	set v_updated = now();
	
	insert into issue
		(idt, active, creator, assignee, kind, status, project, prev_issue, date_created, date_updated, summary, description, resolution)
		select idt, true, creator, v_assignee, v_kind, v_status_to, project, prev_issue, date_created, v_updated, p_summary, p_description, p_resolution
			from issue where id = v_issue;
	select last_insert_id() into v_new_issue;			
	
	insert into comment
		(officer__id, issue_before, issue_after, status_transition, date_created, summary)
		values
		(v_user, v_issue, v_new_issue, v_transition, v_updated, p_comment);
	
	return 'I:';
end 
$$