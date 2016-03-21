create view available_grants as   
select o.id officer_id, 
	   g.id group_id, 
	   gr.id grant_id, 
	   gr.is_admin is_admin,
	   case when gm.officer__id is not null then true else false end is_personal
  from officer o, officer_group g, officer_grant_map gm, officer_grant gr
 where o.is_active = true
   and g.id = o.officer_group__id
   and (gm.officer__id = o.id or gm.officer_group__id = g.id)
   and gr.id = gm.officer_grant__id;
   
create view available_transitions as
select distinct
       g.officer_id,
       g.group_id,
       st.id status_transition_id,
       pt.id project_transition_id
  from available_grants g
 inner join grant_transition_map gm on g.grant_id = gm.officer_grant__id
  left join status_transition st on st.id = gm.status_transition__id and st.is_active = true
  left join project_transition pt on pt.id = gm.project_transition__id and pt.is_active = true; 

create view projects_available as
select p.*,
       u.id available_for,
       u.username available_for_code
  from issue_project p, 
       officer u,
       available_transitions t,
       status_transition st
 where p.is_active = true
   and t.officer_id = u.id
   and st.id = t.status_transition_id
   and st.issue_project__id = p.id
   and st.status_from is null
   and st.status_to is null;
   
create view issue_status_transitions_available as
select i.id issue_for,
       i.idt issue_for_idt,
       o.id available_for,
       o.username available_for_code,
       str.*
  from available_transitions tr,
       status_transition str, 
       officer o,
       issue i
 where str.id = tr.status_transition_id
   and o.id = tr.officer_id
   and i.active = true
   and str.issue_project__id = i.project
   and str.status_from = i.status;
   
create view issue_project_transitions_available as
select i.id issue_for,
       i.idt issue_for_idt,
       o.id available_for,
       o.username available_for_code,
       ptr.*
  from available_transitions tr,
       project_transition ptr,
       officer o,
       issue i
 where ptr.id = tr.project_transition_id
   and o.id = tr.officer_id
   and i.active = true
   and ptr.project_from = i.project
   and ptr.status_from = i.status;
     
create view issue_comments as
select i.id issue_id,
       c.*
  from issue i, issue ib, issue ia, comment c
 where ib.prev_issue = i.prev_issue
   and ia.prev_issue = i.prev_issue
   and c.issue_before = ib.id 
   and c.issue_after = ia.id;

create view project_statuses as   
select s.*, p.code project_for 
  from issue_status s, issue_project p 
 where s.id = p.start_status 
   and p.is_active = true
 union 
select distinct s.*, p.code project_for
  from issue_status s, status_transition t, issue_project p
 where s.id = t.status_from
   and t.is_active = true
   and p.id = t.issue_project__id
 union 
select distinct s.*, p.code project_for
  from issue_status s, status_transition t, issue_project p
 where s.id = t.status_to
   and t.is_active = true
   and p.id = t.issue_project__id;