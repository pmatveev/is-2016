create view projects_available as
select s.id start_status,
       s.name start_status_display,
       o.id owner,
       o.credentials owner_display,
       p.id project_id,
       p.code project_code,
       p.name project_name,
       u.id available_for,
       u.username available_for_code
  from issue_project p, 
       issue_status s, 
       officer o, 
       officer u,
       available_transitions t,
       status_transition st
 where s.id = p.start_status
   and o.id = p.owner
   and p.is_active = true
   and t.officer_id = u.id
   and st.id = t.status_transition_id
   and st.issue_project__id = p.id
   and st.status_from is null
   and st.status_to is null;
   
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
  left join status_transition st on st.id = gm.status_transition__id
  left join project_transition pt on pt.id = gm.project_transition__id; 

create view active_issues as  
select i.id,
       i.idt,
       i.prev_issue,
       c.username creator,
       c.credentials creator_display,
       a.username assignee,
       a.credentials assignee_display,
       k.code kind,
       k.name kind_display,
       s.code status,
       s.name status_display,
       p.code project,
       p.name project_display,
       i.date_created,
       i.date_updated,
       i.summary,
       i.description,
       i.resolution
  from issue i,
       officer c,
       officer a,
       issue_kind k,
       issue_status s,
       issue_project p
 where i.active = true
   and c.id = i.creator
   and a.id = i.assignee
   and k.id = i.kind
   and s.id = i.status
   and p.id = i.project;

create view issue_comments as
select f.id issue_id,
       c.date_created,
       c.summary,
       o.username author,
       o.credentials author_display
  from issue f
  join issue ib on ib.prev_issue = f.prev_issue
  join issue ia on ia.prev_issue = f.prev_issue
  join comment c on c.issue_before = ib.id and c.issue_after = ia.id
  join officer o on o.id = c.officer__id;