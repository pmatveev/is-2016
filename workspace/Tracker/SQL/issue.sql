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