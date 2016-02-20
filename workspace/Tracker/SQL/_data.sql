-- create admin/1234
select add_officer_group('ADMIN', 'Administrators');
select add_officer_group('DEV', 'Developers');
select add_officer_group('TEST', 'Testers');

select add_officer('admin', 'Test Administrator', '81dc9bdb52d04dc20036dbd8313ed055', 'ADMIN');
select add_officer('pmatveev', 'Philipp Matveev', '81dc9bdb52d04dc20036dbd8313ed055', 'DEV');
select add_officer('akuzmin', 'Alex Kuzmin', '81dc9bdb52d04dc20036dbd8313ed055', 'DEV');

select add_status('OPEN', 'Open');
select add_status('REOPEN', 'Reopened');
select add_status('ANALYT', 'Analysis');
select add_status('WORK', 'In work');
select add_status('TEST', 'Testing');
select add_status('CLOSE', 'Closed');
select add_status('REJECT', 'Rejected');

select add_kind('BUG', 'Bug');
select add_kind('NEW', 'New feature');
select add_kind('RESEARCH', 'Research');
select add_kind('INFO', 'Information request');

select add_project('DEV', 'Development issues', 'OPEN', 'PMATVEEV');
select add_project('OTHER', 'Other issues', 'OPEN', 'AKUZMIN');

-- development strategy, analysis can be skipped
select add_status_transition('DEV_EDIT_OPEN', 'Edit', 'DEV', 'OPEN', 'OPEN');
select add_status_transition('DEV_EDIT_REOPEN', 'Edit', 'DEV', 'REOPEN', 'REOPEN');
select add_status_transition('DEV_EDIT_ANALYT', 'Edit', 'DEV', 'ANALYT', 'ANALYT');
select add_status_transition('DEV_EDIT_WORK', 'Edit', 'DEV', 'WORK', 'WORK');
select add_status_transition('DEV_EDIT_TEST', 'Edit', 'DEV', 'TEST', 'TEST');
select add_status_transition('DEV_OPEN_REJECT', 'Reject', 'DEV', 'OPEN', 'REJECT');
select add_status_transition('DEV_ANALYT_REJECT', 'Reject', 'DEV', 'ANALYT', 'REJECT');
select add_status_transition('DEV_OPEN_ANALYT', 'Start analysis', 'DEV', 'OPEN', 'ANALYT');
select add_status_transition('DEV_OPEN_WORK', 'Start work', 'DEV', 'OPEN', 'WORK');
select add_status_transition('DEV_ANALYT_WORK', 'Start work', 'DEV', 'ANALYT', 'WORK');
select add_status_transition('DEV_WORK_TEST', 'Start testing', 'DEV', 'WORK', 'TEST');
select add_status_transition('DEV_TEST_ANALYT', 'Return to analysis', 'DEV', 'TEST', 'ANALYT');
select add_status_transition('DEV_TEST_WORK', 'Return to work', 'DEV', 'TEST', 'WORK');
select add_status_transition('DEV_TEST_CLOSE', 'Close', 'DEV', 'TEST', 'CLOSE');
select add_status_transition('DEV_CLOSE_REOPEN', 'Reopen', 'DEV', 'CLOSE', 'REOPEN');
select add_status_transition('DEV_REOPEN_ANALYT', 'Start analysis', 'DEV', 'REOPEN', 'ANALYT');
select add_status_transition('DEV_REOPEN_WORK', 'Start work', 'DEV', 'REOPEN', 'WORK');

-- simple strategy
select add_status_transition('OTH_EDIT_OPEN', 'Edit', 'OTHER', 'OPEN', 'OPEN');
select add_status_transition('OTH_EDIT_REOPEN', 'Edit', 'OTHER', 'REOPEN', 'REOPEN');
select add_status_transition('OTH_OPEN_REJECT', 'Reject', 'OTHER', 'OPEN', 'REJECT');
select add_status_transition('OTH_OPEN_WORK', 'Start progress', 'OTHER', 'OPEN', 'WORK');
select add_status_transition('OTH_REOPEN_WORK', 'Start progress', 'OTHER', 'REOPEN', 'WORK');
select add_status_transition('OTH_WORK_CLOSE', 'Close', 'OTHER', 'WORK', 'CLOSE');
select add_status_transition('OTH_CLOSE_REOPEN', 'Reopen', 'DEV', 'CLOSE', 'REOPEN');

-- simple to dev
select add_project_transition('OTH_DEV_OPEN_OPEN', 'OTH', 'DEV', 'OPEN', 'OPEN');
select add_project_transition('OTH_DEV_REOPEN_REOPEN', 'OTH', 'DEV', 'REOPEN', 'REOPEN');
-- dev to simple
select add_project_transition('DEV_OTH_OPEN_OPEN', 'DEV', 'OTH', 'OPEN', 'OPEN');
select add_project_transition('DEV_OTH_REOPEN_REOPEN', 'DEV', 'OTH', 'REOPEN', 'REOPEN');

-- no issue transition
select add_officer_grant('ADMIN', 'Administrator', true);

-- can edit all issues and can reopen them
select add_officer_grant('REPORT', 'Reporter', false);
select add_grant_mapping('REPORT', null, 'DEV_EDIT_OPEN');
select add_grant_mapping('REPORT', null, 'DEV_EDIT_REOPEN');
select add_grant_mapping('REPORT', null, 'DEV_EDIT_ANALYT');
select add_grant_mapping('REPORT', null, 'DEV_EDIT_WORK');
select add_grant_mapping('REPORT', null, 'DEV_EDIT_TEST');
select add_grant_mapping('REPORT', null, 'OTH_EDIT_OPEN');
select add_grant_mapping('REPORT', null, 'OTH_EDIT_REOPEN');
select add_grant_mapping('REPORT', null, 'DEV_CLOSE_REOPEN');
select add_grant_mapping('REPORT', null, 'OTH_CLOSE_REOPEN');

-- can edit all DEV issues and transit them up to testing. Cannot reject
select add_officer_grant('DEV_DEV', 'DEV project developer', false);
select add_grant_mapping('DEV_DEV', null, 'DEV_EDIT_OPEN');
select add_grant_mapping('DEV_DEV', null, 'DEV_EDIT_REOPEN');
select add_grant_mapping('DEV_DEV', null, 'DEV_EDIT_ANALYT');
select add_grant_mapping('DEV_DEV', null, 'DEV_EDIT_WORK');
select add_grant_mapping('DEV_DEV', null, 'DEV_EDIT_TEST');
select add_grant_mapping('DEV_DEV', null, 'DEV_OPEN_ANALYT');
select add_grant_mapping('DEV_DEV', null, 'DEV_OPEN_WORK');
select add_grant_mapping('DEV_DEV', null, 'DEV_ANALYT_WORK');
select add_grant_mapping('DEV_DEV', null, 'DEV_WORK_TEST');

-- can work with DEV issues assigned to TEST status
select add_officer_grant('DEV_TEST', 'DEV project tester', false);
select add_grant_mapping('DEV_TEST', null, 'DEV_EDIT_TEST');
select add_grant_mapping('DEV_TEST', null, 'DEV_TEST_ANALYT');
select add_grant_mapping('DEV_TEST', null, 'DEV_TEST_WORK');
select add_grant_mapping('DEV_TEST', null, 'DEV_TEST_CLOSE');

-- can take issues to OTH and reject them
select add_officer_grant('DEV_MAN', 'DEV project manager', false);
select add_grant_mapping('DEV_MAN', null, 'DEV_OPEN_REJECT');
select add_grant_mapping('DEV_MAN', null, 'DEV_ANALYT_REJECT');
select add_grant_mapping('DEV_MAN', 'DEV_OTH_OPEN_OPEN', null);
select add_grant_mapping('DEV_MAN', 'DEV_OTH_REOPEN_REOPEN', null);

-- can do pretty everything with OTH
select add_officer_grant('OTH_SOLVE', 'OTHER project solver', false);
select add_grant_mapping('OTH_SOLVE', null, 'OTH_EDIT_OPEN');
select add_grant_mapping('OTH_SOLVE', null, 'OTH_EDIT_REOPEN');
select add_grant_mapping('OTH_SOLVE', null, 'OTH_OPEN_REJECT');
select add_grant_mapping('OTH_SOLVE', null, 'OTH_OPEN_WORK');
select add_grant_mapping('OTH_SOLVE', null, 'OTH_REOPEN_WORK');
select add_grant_mapping('OTH_SOLVE', null, 'OTH_WORK_CLOSE');
select add_grant_mapping('OTH_SOLVE', null, 'OTH_CLOSE_REOPEN');
select add_grant_mapping('OTH_SOLVE', 'OTH_DEV_OPEN_OPEN', null);
select add_grant_mapping('OTH_SOLVE', 'OTH_DEV_REOPEN_REOPEN', null);