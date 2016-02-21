create view projects_available as
select s.name startStatusDisplay,
       o.credentials ownerDisplay,
       p.code,
       p.name
  from issue_project p, issue_status s, officer o 
 where s.id = p.start_status
   and o.id = p.owner
   and p.is_active = true;