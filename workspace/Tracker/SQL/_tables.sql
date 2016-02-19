CREATE TABLE OFFICER (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	OFFICER_GROUP__ID INT (18) NOT NULL,
	USERNAME VARCHAR(32) NOT NULL UNIQUE,
	IS_ACTIVE BOOL NOT NULL,
	PASSHASH VARCHAR(32) NOT NULL,
	CREDENTIALS VARCHAR(256) NOT NULL,
	PRIMARY KEY (ID)
	);

CREATE TABLE OFFICER_SESSION (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	OFFICER__ID INT (18) NOT NULL,
	DATE_FROM DATETIME NOT NULL,
	DATE_TO DATETIME NOT NULL,
	TOKEN VARCHAR(32) NOT NULL UNIQUE,
	CONN VARCHAR(32) NOT NULL,
	PRIMARY KEY (ID)
	);

CREATE TABLE ISSUE (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	IDT VARCHAR(32) NOT NULL,
	ACTIVE BOOL NOT NULL,
	CREATOR INT (18) NOT NULL,
	ASSIGNEE INT (18) NOT NULL,
	KIND INT (18) NOT NULL,
	STATUS INT (18) NOT NULL,
	PROJECT INT (18) NOT NULL,
	PREV_ISSUE INT (18),
	DATE_CREATED DATETIME NOT NULL,
	DATE_UPDATED DATETIME NOT NULL,
	SUMMARY VARCHAR(256) NOT NULL,
	DESCRIPTION VARCHAR(4000) NOT NULL,
	RESOLUTION VARCHAR(4000),
	PRIMARY KEY (ID)
	);

CREATE TABLE ISSUE_KIND (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(32) NOT NULL,
	CODE VARCHAR(32) NOT NULL UNIQUE,
	PRIMARY KEY (ID)
	);

CREATE TABLE ISSUE_STATUS (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(32) NOT NULL,
	CODE VARCHAR(32) NOT NULL UNIQUE,
	PRIMARY KEY (ID)
	);

CREATE TABLE ISSUE_PROJECT (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	START_STATUS INT (18) NOT NULL,
	OWNER INT (18) NOT NULL,
	CODE VARCHAR(32) NOT NULL UNIQUE,
	NAME VARCHAR(32) NOT NULL UNIQUE,
	IS_ACTIVE BOOL NOT NULL,
	COUNTER INT (18) NOT NULL,
	PRIMARY KEY (ID)
	);

CREATE TABLE COMMENT (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	OFFICER__ID INT (18) NOT NULL,
	ISSUE_BEFORE INT (18) NOT NULL,
	ISSUE_AFTER INT (18) NOT NULL,
	STATUS_TRANSITION INT (18),
	PROJECT_TRANSITION INT (18),
	DATE_CREATED DATETIME NOT NULL,
	SUMMARY VARCHAR(4000),
	PRIMARY KEY (ID)
	);

CREATE TABLE OFFICER_GROUP (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(32) NOT NULL,
	CODE VARCHAR(32) NOT NULL UNIQUE,
	PRIMARY KEY (ID)
	);

CREATE TABLE OFFICER_GRANT (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(32) NOT NULL,
	CODE VARCHAR(32) NOT NULL UNIQUE,
	IS_ADMIN BOOL NOT NULL,
	PRIMARY KEY (ID)
	);

CREATE TABLE OFFICER_GRANT_MAP (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	OFFICER__ID INT (18),
	OFFICER_GROUP__ID INT (18),
	OFFICER_GRANT__ID INT (18) NOT NULL,
	PRIMARY KEY (ID)
	);

CREATE TABLE STATUS_TRANSITION (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	OFFICER_GRANT__ID INT (18) NOT NULL,
	ISSUE_PROJECT__ID INT (18) NOT NULL,
	STATUS_FROM INT (18),
	STATUS_TO INT (18) NOT NULL,
	NAME VARCHAR(32) NOT NULL,
	CODE VARCHAR(32) NOT NULL UNIQUE,
	PRIMARY KEY (ID)
	);

CREATE TABLE PROJECT_TRANSITION (
	ID INT (18) NOT NULL AUTO_INCREMENT,
	OFFICER_GRANT__ID INT (18) NOT NULL,
	PROJECT_FROM INT (18) NOT NULL,
	PROJECT_TO INT (18) NOT NULL,
	STATUS_FROM INT (18) NOT NULL,
	STATUS_TO INT (18) NOT NULL,
	PRIMARY KEY (ID)
	);

ALTER TABLE OFFICER_SESSION ADD INDEX FKOFFICER_SE113248 (OFFICER__ID),
	ADD CONSTRAINT FKOFFICER_SE113248 FOREIGN KEY (OFFICER__ID) REFERENCES OFFICER (ID);

ALTER TABLE ISSUE ADD INDEX FKISSUE788111 (CREATOR),
	ADD CONSTRAINT FKISSUE788111 FOREIGN KEY (CREATOR) REFERENCES OFFICER (ID);

ALTER TABLE ISSUE ADD INDEX FKISSUE5539 (ASSIGNEE),
	ADD CONSTRAINT FKISSUE5539 FOREIGN KEY (ASSIGNEE) REFERENCES OFFICER (ID);

ALTER TABLE ISSUE ADD INDEX FKISSUE25904 (KIND),
	ADD CONSTRAINT FKISSUE25904 FOREIGN KEY (KIND) REFERENCES ISSUE_KIND (ID);

ALTER TABLE ISSUE ADD INDEX FKISSUE560505 (STATUS),
	ADD CONSTRAINT FKISSUE560505 FOREIGN KEY (STATUS) REFERENCES ISSUE_STATUS (ID);

ALTER TABLE ISSUE ADD INDEX FKISSUE237703 (PROJECT),
	ADD CONSTRAINT FKISSUE237703 FOREIGN KEY (PROJECT) REFERENCES ISSUE_PROJECT (ID);

ALTER TABLE COMMENT ADD INDEX FKCOMMENT990952 (OFFICER__ID),
	ADD CONSTRAINT FKCOMMENT990952 FOREIGN KEY (OFFICER__ID) REFERENCES OFFICER (ID);

ALTER TABLE COMMENT ADD INDEX FKCOMMENT571551 (ISSUE_BEFORE),
	ADD CONSTRAINT FKCOMMENT571551 FOREIGN KEY (ISSUE_BEFORE) REFERENCES ISSUE (ID);

ALTER TABLE ISSUE_PROJECT ADD INDEX FKISSUE_PROJ990820 (OWNER),
	ADD CONSTRAINT FKISSUE_PROJ990820 FOREIGN KEY (OWNER) REFERENCES OFFICER (ID);

ALTER TABLE OFFICER ADD INDEX FKOFFICER365892 (OFFICER_GROUP__ID),
	ADD CONSTRAINT FKOFFICER365892 FOREIGN KEY (OFFICER_GROUP__ID) REFERENCES OFFICER_GROUP (ID);

ALTER TABLE OFFICER_GRANT_MAP ADD INDEX FKOFFICER_GR911903 (OFFICER_GRANT__ID),
	ADD CONSTRAINT FKOFFICER_GR911903 FOREIGN KEY (OFFICER_GRANT__ID) REFERENCES OFFICER_GRANT (ID);

ALTER TABLE OFFICER_GRANT_MAP ADD INDEX FKOFFICER_GR790623 (OFFICER__ID),
	ADD CONSTRAINT FKOFFICER_GR790623 FOREIGN KEY (OFFICER__ID) REFERENCES OFFICER (ID);

ALTER TABLE OFFICER_GRANT_MAP ADD INDEX FKOFFICER_GR38881 (OFFICER_GROUP__ID),
	ADD CONSTRAINT FKOFFICER_GR38881 FOREIGN KEY (OFFICER_GROUP__ID) REFERENCES OFFICER_GROUP (ID);

ALTER TABLE STATUS_TRANSITION ADD INDEX FKSTATUS_TRA30418 (OFFICER_GRANT__ID),
	ADD CONSTRAINT FKSTATUS_TRA30418 FOREIGN KEY (OFFICER_GRANT__ID) REFERENCES OFFICER_GRANT (ID);

ALTER TABLE STATUS_TRANSITION ADD INDEX FKSTATUS_TRA373974 (ISSUE_PROJECT__ID),
	ADD CONSTRAINT FKSTATUS_TRA373974 FOREIGN KEY (ISSUE_PROJECT__ID) REFERENCES ISSUE_PROJECT (ID);

ALTER TABLE STATUS_TRANSITION ADD INDEX FKSTATUS_TRA11951 (STATUS_FROM),
	ADD CONSTRAINT FKSTATUS_TRA11951 FOREIGN KEY (STATUS_FROM) REFERENCES ISSUE_STATUS (ID);

ALTER TABLE STATUS_TRANSITION ADD INDEX FKSTATUS_TRA531521 (STATUS_TO),
	ADD CONSTRAINT FKSTATUS_TRA531521 FOREIGN KEY (STATUS_TO) REFERENCES ISSUE_STATUS (ID);

ALTER TABLE PROJECT_TRANSITION ADD INDEX FKPROJECT_TR167882 (OFFICER_GRANT__ID),
	ADD CONSTRAINT FKPROJECT_TR167882 FOREIGN KEY (OFFICER_GRANT__ID) REFERENCES OFFICER_GRANT (ID);

ALTER TABLE PROJECT_TRANSITION ADD INDEX FKPROJECT_TR532737 (PROJECT_FROM),
	ADD CONSTRAINT FKPROJECT_TR532737 FOREIGN KEY (PROJECT_FROM) REFERENCES ISSUE_PROJECT (ID);

ALTER TABLE PROJECT_TRANSITION ADD INDEX FKPROJECT_TR413580 (PROJECT_TO),
	ADD CONSTRAINT FKPROJECT_TR413580 FOREIGN KEY (PROJECT_TO) REFERENCES ISSUE_PROJECT (ID);

ALTER TABLE PROJECT_TRANSITION ADD INDEX FKPROJECT_TR874486 (STATUS_FROM),
	ADD CONSTRAINT FKPROJECT_TR874486 FOREIGN KEY (STATUS_FROM) REFERENCES ISSUE_STATUS (ID);

ALTER TABLE PROJECT_TRANSITION ADD INDEX FKPROJECT_TR605942 (STATUS_TO),
	ADD CONSTRAINT FKPROJECT_TR605942 FOREIGN KEY (STATUS_TO) REFERENCES ISSUE_STATUS (ID);

ALTER TABLE ISSUE_PROJECT ADD INDEX FKISSUE_PROJ745281 (START_STATUS),
	ADD CONSTRAINT FKISSUE_PROJ745281 FOREIGN KEY (START_STATUS) REFERENCES ISSUE_STATUS (ID);

ALTER TABLE ISSUE ADD INDEX FKISSUE834298 (PREV_ISSUE),
	ADD CONSTRAINT FKISSUE834298 FOREIGN KEY (PREV_ISSUE) REFERENCES ISSUE (ID);

ALTER TABLE COMMENT ADD INDEX FKCOMMENT649104 (STATUS_TRANSITION),
	ADD CONSTRAINT FKCOMMENT649104 FOREIGN KEY (STATUS_TRANSITION) REFERENCES STATUS_TRANSITION (ID);

ALTER TABLE COMMENT ADD INDEX FKCOMMENT924032 (PROJECT_TRANSITION),
	ADD CONSTRAINT FKCOMMENT924032 FOREIGN KEY (PROJECT_TRANSITION) REFERENCES PROJECT_TRANSITION (ID);

ALTER TABLE COMMENT ADD INDEX FKCOMMENT459212 (ISSUE_AFTER),
	ADD CONSTRAINT FKCOMMENT459212 FOREIGN KEY (ISSUE_AFTER) REFERENCES ISSUE (ID);

CREATE INDEX ISSUE_IDT ON ISSUE (
	IDT,
	ACTIVE
	);
	
 DROP TABLE OFFICER_GRANT_MAP ;
 DROP TABLE OFFICER_SESSION ;
 DROP TABLE COMMENT ;
 DROP TABLE ISSUE ;
 DROP TABLE ISSUE_KIND ;
 DROP TABLE STATUS_TRANSITION ;
 DROP TABLE PROJECT_TRANSITION ;	
 DROP TABLE ISSUE_PROJECT ;
 DROP TABLE ISSUE_STATUS ;
 DROP TABLE OFFICER_GRANT ;
 DROP TABLE OFFICER ;
 DROP TABLE OFFICER_GROUP ;