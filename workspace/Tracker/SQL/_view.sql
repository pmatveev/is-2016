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
       st.id status_to,
       st.code status_to_code,
       st.name status_to_name,
       str.id transition,
       str.code,
       str.name
  from available_transitions tr,
       status_transition str, 
       officer o,
       issue_project p,
       issue_status sf,
       issue_status st,
       issue i
 where str.id = tr.status_transition_id
   and o.id = tr.officer_id
   and p.id = str.issue_project__id
   and sf.id = str.status_from
   and st.id = str.status_to
   and i.status = sf.id
   and i.project = p.id
   and i.active = true;
   
create view issue_project_transitions_available as
select i.id issue_for,
       i.idt issue_for_idt,
       o.id available_for,
       o.username available_for_code,
       pt.id project_to,
       pt.code project_to_code,
       pt.name project_to_name,
       st.id status_to,
       st.code status_to_code,
       st.name status_to_name,
       ptr.id transition,
       ptr.code
  from available_transitions tr,
       project_transition ptr,
       officer o,
       issue_project pf,
       issue_status sf,
       issue_project pt,
       issue_status st,
       issue i
 where ptr.id = tr.project_transition_id
   and o.id = tr.officer_id
   and pf.id = ptr.project_from
   and sf.id = ptr.status_from
   and pt.id = ptr.project_to
   and st.id = ptr.status_to
   and i.status = sf.id
   and i.project = pf.id
   and i.active = true;
  
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
       o.credentials author_display,
       st.code status_transition,
       st.name status_transition_display,
       pt.code project_transition,
       ib.idt idt_before,
       ia.idt idt_after,
       pb.code project_before,
       pb.name project_before_display,
       pa.code project_after,
       pa.name project_after_display,
       kb.code kind_before,
       kb.name kind_before_display,
       ka.code kind_after,
       ka.name kind_after_display,
       sb.code status_before,
       sb.name status_before_display,
       sa.code status_after,
       sa.name status_after_display,
       ab.username assignee_before,
       ab.credentials assignee_before_display,
       aa.username assignee_after,
       aa.credentials assignee_after_display
  from issue f
  join issue ib on ib.prev_issue = f.prev_issue
  join issue_kind kb on kb.id = ib.kind
  join issue_status sb on sb.id = ib.status
  join issue_project pb on pb.id = ib.project
  join officer ab on ab.id = ib.assignee
  join issue ia on ia.prev_issue = f.prev_issue
  join issue_kind ka on ka.id = ia.kind
  join issue_status sa on sa.id = ia.status
  join issue_project pa on pa.id = ia.project
  join officer aa on aa.id = ia.assignee
  join comment c on c.issue_before = ib.id and c.issue_after = ia.id
  join officer o on o.id = c.officer__id
  left join status_transition st on st.id = c.status_transition
  left join project_transition pt on pt.id = c.project_transition;