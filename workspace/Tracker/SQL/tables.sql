create table officer (
	id int(18) auto_increment primary key,
	username varchar(32) not null,
	unique index (username),
	passhash varchar(32) not null,
	credentials varchar(256) not null
);

-- create admin/1234
insert into officer (username, passhash, credentials) values ('admin', '81dc9bdb52d04dc20036dbd8313ed055', 'Test Admin');

create table officer_session (
	id int(18) auto_increment primary key,
	officer__id int(18) not null,
	foreign key (officer__id) references officer (id),
	date_from datetime not null,
	date_to datetime not null,
	token varchar(32) not null,
	unique index (token),
	conn varchar(32) not null
);
