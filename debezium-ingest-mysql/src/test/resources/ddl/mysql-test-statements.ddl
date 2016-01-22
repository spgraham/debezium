--
-- BUILD SCRIPT
--                      RDBMS: MYSQL 5.0
--

RENAME TABLE blue_table TO red_table,
     orange_table TO green_table,
     black_table TO white_table;

RENAME DATABASE blue_db TO red_db;

RENAME SCHEMA blue_schema TO red_schema;
     
CREATE TABLE RT_VDB_MDLS
(
  VDB_UID         NUMERIC(10) NOT NULL ,
  MDL_UID         NUMERIC(10) NOT NULL ,
  CNCTR_BNDNG_NM  VARCHAR(255)
);

CREATE INDEX AWA_SYS_MSGLEVEL_1E6F845E ON LOGENTRIES (MSGLEVEL);

CREATE UNIQUE INDEX AUTHPERM_UIX ON AUTHPERMISSIONS ( POLICYUID, RESOURCENAME);

CREATE TABLE CS_EXT_FILES  (
   FILE_UID             INTEGER                          NOT NULL,
   CHKSUM               NUMERIC(20),
   FILE_NAME            VARCHAR(255)        NOT NULL,
   FILE_CONTENTS        LONGBLOB,
   CONFIG_CONTENTS    LONGTEXT,
   SEARCH_POS           INTEGER,
   IS_ENABLED           CHAR(1),
   FILE_DESC            VARCHAR(4000),
   CONSTRAINT PK_CS_EXT_FILES PRIMARY KEY (FILE_UID)
)
;

ALTER TABLE CS_EXT_FILES ADD CONSTRAINT CSEXFILS_FIL_NA_UK UNIQUE (FILE_NAME);

CREATE TABLE MMSCHEMAINFO_CA
(
    SCRIPTNAME        VARCHAR(50),
    SCRIPTEXECUTEDBY  VARCHAR(50),
    SCRIPTREV         VARCHAR(50),
    RELEASEDATE VARCHAR(50),
    DATECREATED       DATE,
    DATEUPDATED       DATE,
    UPDATEID          VARCHAR(50),
    METAMATRIXSERVERURL  VARCHAR(100)
)
;


CREATE INDEX MOD_PATH_NDX ON MMR_MODELS (NAME);
-- ============ 10 STATEMENTS ====================
ALTER TABLE MMR_MODELS
  ADD CONSTRAINT MOD_PK
    PRIMARY KEY (ID);

ALTER TABLE MMR_RESOURCES
  ADD CONSTRAINT RSRC_PK
    PRIMARY KEY (MODEL_ID);

    -- View for obtaining the features by metaclass
    -- (don't use parenthesis)

    CREATE OR REPLACE VIEW MMR_FEATURES AS 
    SELECT MMR_MODELS.NAMESPACE AS NAMESPACE, 
           PARENTS.NAME AS CLASS_NAME, 
           MMR_OBJECTS.NAME AS FEATURE_NAME, 
           MMR_ATTR_FEATURES.OBJ_ID AS FEATURE_ID, 
           'Attribute' AS FEATURE_TYPE 
      FROM MMR_MODELS JOIN MMR_OBJECTS ON MMR_MODELS.ID=MMR_OBJECTS.MODEL_ID
      JOIN MMR_ATTR_FEATURES ON MMR_OBJECTS.ID = MMR_ATTR_FEATURES.OBJ_ID
      JOIN MMR_RESOLVED_OBJECTS ON MMR_OBJECTS.ID = MMR_RESOLVED_OBJECTS.OBJ_ID
      JOIN MMR_OBJECTS PARENTS ON MMR_RESOLVED_OBJECTS.CONTAINER_ID = PARENTS.ID
    UNION ALL
    SELECT MMR_MODELS.NAMESPACE AS NAMESPACE, 
           PARENTS.NAME AS CLASS_NAME, 
           MMR_OBJECTS.NAME AS FEATURE_NAME, 
           MMR_REF_FEATURES.OBJ_ID AS FEATURE_ID, 
           'Reference' AS FEATURE_TYPE 
      FROM MMR_MODELS JOIN MMR_OBJECTS ON MMR_MODELS.ID=MMR_OBJECTS.MODEL_ID 
      JOIN MMR_REF_FEATURES ON MMR_OBJECTS.ID = MMR_REF_FEATURES.OBJ_ID
      JOIN MMR_RESOLVED_OBJECTS ON MMR_OBJECTS.ID = MMR_RESOLVED_OBJECTS.OBJ_ID
      JOIN MMR_OBJECTS PARENTS ON MMR_RESOLVED_OBJECTS.CONTAINER_ID = PARENTS.ID
    ;

INSERT INTO MMSCHEMAINFO_CA (SCRIPTNAME,SCRIPTEXECUTEDBY,SCRIPTREV,
    RELEASEDATE, DATECREATED,DATEUPDATED, UPDATEID,METAMATRIXSERVERURL)
    SELECT 'MM_CREATE.SQL',USER(),'Seneca.3117', '10/03/2008 12:01 AM',SYSDATE(),SYSDATE(),'','';

ALTER TABLE t MODIFY latin1_text_col TEXT CHARACTER SET utf8;
ALTER TABLE t MODIFY latin1_varchar_col VARCHAR(M) CHARACTER SET utf8;

ALTER TABLE t1 CHANGE c1 c1 BLOB;
ALTER TABLE t1 CHANGE c1 c1 TEXT CHARACTER SET utf8;

ALTER TABLE t1
    PARTITION BY HASH(id)
    PARTITIONS 8;

    CREATE TABLE t1 (
    id INT,
    year_col INT
)
PARTITION BY RANGE (year_col) (
    PARTITION p0 VALUES LESS THAN (1991),
    PARTITION p1 VALUES LESS THAN (1995),
    PARTITION p2 VALUES LESS THAN (1999)
);

CREATE TABLE t2 (
    name VARCHAR (30),
    started DATE,
    a BIT,
    b VARCHAR(20) NOT NULL
)
PARTITION BY HASH( YEAR(started) )
PARTITIONS 6;


ALTER TABLE t1 DROP PARTITION p0, p1;
-- ============ 20 STATEMENTS ====================
ALTER TABLE t1 RENAME t2;

ALTER TABLE t2 MODIFY a TINYINT NOT NULL, CHANGE b c CHAR(20);

ALTER TABLE t2 ADD d TIMESTAMP;

ALTER TABLE t2 ADD INDEX (d), ADD UNIQUE (a);

ALTER TABLE t2 DROP COLUMN c;

ALTER TABLE t2 ADD c INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ADD PRIMARY KEY (c);

ALTER TABLE t1 TABLESPACE ts_1 STORAGE DISK;

ALTER TABLE t2 STORAGE DISK;

ALTER TABLE t3 MODIFY c2 INT STORAGE MEMORY;

ALTER TABLE T2 ADD id INT AUTO_INCREMENT PRIMARY KEY;
-- ============ 30 STATEMENTS ====================
ALTER DATABASE `#mysql50#a-b-c` UPGRADE DATA DIRECTORY NAME;

CREATE EVENT myevent
    ON SCHEDULE
      EVERY 6 HOUR
    COMMENT 'A sample comment.'
    DO
      UPDATE myschema.mytable SET mycol = mycol + 1;

--ALTER
--    [DEFINER = { user | CURRENT_USER }]
--    EVENT event_name
--    [ON SCHEDULE schedule]
--    [ON COMPLETION [NOT] PRESERVE]
--    [RENAME TO new_event_name]
--    [ENABLE | DISABLE | DISABLE ON SLAVE]
--    [COMMENT 'comment']
--    [DO sql_statement]

ALTER EVENT myevent
    ON SCHEDULE
      EVERY 12 HOUR
    STARTS CURRENT_TIMESTAMP + INTERVAL 4 HOUR;

ALTER TABLE myevent
    ON SCHEDULE
      AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
    DO
      TRUNCATE TABLE myschema.mytable;

ALTER EVENT myevent
    DISABLE;

ALTER EVENT myevent
    RENAME TO yourevent;

ALTER EVENT olddb.myevent
    RENAME TO newdb.myevent;
    
--ALTER LOGFILE GROUP logfile_group
--    ADD UNDOFILE 'file_name'
--    [INITIAL_SIZE [=] size]
--    [WAIT]
--    ENGINE [=] engine_name

ALTER LOGFILE GROUP lg_3
    ADD UNDOFILE 'undo_10.dat'
    INITIAL_SIZE=32M
    ENGINE=NDBCLUSTER;

--ALTER FUNCTION func_name [characteristic ...]
--
--characteristic:
--    { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
--  | SQL SECURITY { DEFINER | INVOKER }
--  | COMMENT 'string'

ALTER FUNCTION break_wind MODIFIES SQL DATA;

ALTER FUNCTION break_wind SQL SECURITY INVOKER;
-- ============ 40 STATEMENTS ====================
ALTER FUNCTION break_wind COMMENT 'no more wind please';

ALTER PROCEDURE fall_back MODIFIES SQL DATA;

ALTER PROCEDURE fall_back SQL SECURITY INVOKER;

ALTER PROCEDURE fall_back COMMENT 'no more wind please';

ALTER SERVER s OPTIONS (USER 'sally');

--ALTER TABLESPACE tablespace_name
--    {ADD|DROP} DATAFILE 'file_name'
--    [INITIAL_SIZE [=] size]
--    [WAIT]
--    ENGINE [=] engine_name

ALTER TABLESPACE tspace_name ADD DATAFILE 'file_name'INITIAL_SIZE = 9999 WAIT;

--ALTER
--    [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
--    [DEFINER = { user | CURRENT_USER }]
--    [SQL SECURITY { DEFINER | INVOKER }]
--    VIEW view_name [(column_list)]
--    AS select_statement
--    [WITH [CASCADED | LOCAL] CHECK OPTION]

ALTER VIEW great_view (c1, c2) AS SELECT * FROM table_a;

ALTER VIEW great_view (c1, c2) AS SELECT * FROM table_a WITH LOCAL CHECK OPTION;

ALTER VIEW ALGORITHM = MERGE great_view AS SELECT * FROM table_a;

ALTER VIEW DEFINER = 'joe'@'there.com' great_view AS SELECT * FROM table_a;
-- ============ 50 STATEMENTS ====================
ALTER VIEW SQL SECURITY INVOKER great_view AS SELECT * FROM table_a;

ALTER VIEW ALGORITHM = MERGE DEFINER = 'joe'@'there.com' SQL SECURITY INVOKER great_view AS SELECT * FROM table_a;

--CREATE {DATABASE | SCHEMA} [IF NOT EXISTS] db_name
--    [create_specification] ...
--
--create_specification:
--    [DEFAULT] CHARACTER SET [=] charset_name
--  | [DEFAULT] COLLATE [=] collation_name

CREATE DATABASE db_1;

CREATE DATABASE db_2 DEFAULT CHARACTER SET = utf8;

CREATE DATABASE db_3 CHARACTER SET utf10;

CREATE DATABASE IF NOT EXISTS db_4 DEFAULT CHARACTER SET = utf8;

CREATE SCHEMA schema_1;

CREATE SCHEMA schema_2 DEFAULT CHARACTER SET = utf8;

CREATE SCHEMA schema_3 CHARACTER SET utf10;

CREATE SCHEMA IF NOT EXISTS schema_4 DEFAULT CHARACTER SET = utf8;
-- ============ 60 STATEMENTS ====================
CREATE TABLE lookup (id INT) ENGINE = MEMORY;

CREATE INDEX id_index USING BTREE ON lookup (id);

-- CREATE [ONLINE|OFFLINE] [UNIQUE|FULLTEXT|SPATIAL] INDEX index_name

CREATE ONLINE INDEX index_1;

CREATE OFFLINE INDEX index_2;

CREATE ONLINE UNIQUE INDEX index_3;

CREATE OFFLINE FULLTEXT INDEX index_4;

CREATE UNIQUE INDEX index_5;

CREATE FULLTEXT INDEX index_6;

CREATE SPATIAL INDEX index_7;

--CREATE LOGFILE GROUP lf_group_name
--    ADD UNDOFILE 'undo_file'
--    [INITIAL_SIZE [=] initial_size]
--    [UNDO_BUFFER_SIZE [=] undo_buffer_size]
--    [REDO_BUFFER_SIZE [=] redo_buffer_size]
--    [NODEGROUP [=] nodegroup_id]
--    [WAIT]
--    [COMMENT [=] comment_text]
--    ENGINE [=] engine_name

CREATE LOGFILE GROUP lf_group_name_1 ADD UNDOFILE 'my_undo_file'
    ENGINE some_engine_name;
-- ============ 70 STATEMENTS ====================
CREATE LOGFILE GROUP lf_group_name_2 ADD UNDOFILE 'my_undo_file'
    INITIAL_SIZE = 9999 WAIT COMMENT = 'some bogus comment'
    ENGINE some_engine_name;
    
CREATE DEFINER = 'admin'@'localhost' PROCEDURE account_count()
    BEGIN
      SELECT 'Number of accounts:', COUNT(*) FROM mysql.user;
    END;

CREATE DEFINER = 'admin'@'localhost' FUNCTION account_count()
    SQL SECURITY INVOKER
    BEGIN
      SELECT 'Number of accounts:', COUNT(*) FROM mysql.user;
    END;

CREATE SERVER server_1
    FOREIGN DATA WRAPPER mysql
    OPTIONS (USER 'Remote', HOST '192.168.1.106', DATABASE 'test');

--CREATE TABLESPACE tablespace_name
--    ADD DATAFILE 'file_name'
--    USE LOGFILE GROUP logfile_group
--    [EXTENT_SIZE [=] extent_size]
--    [INITIAL_SIZE [=] initial_size]
--    [AUTOEXTEND_SIZE [=] autoextend_size]
--    [MAX_SIZE [=] max_size]
--    [NODEGROUP [=] nodegroup_id]
--    [WAIT]
--    [COMMENT [=] comment_text]
--    ENGINE [=] engine_name

CREATE TABLESPACE tbl_space_1 ADD DATAFILE 'my_data_file' USER LOGFILE GROUP my_lf_group
    ENGINE = my_engine_1;

--CREATE
--    [DEFINER = { user | CURRENT_USER }]
--    TRIGGER trigger_name trigger_time trigger_event
--    ON tbl_name FOR EACH ROW trigger_stmt
--
--    trigger_time:  BEFORE | AFTER
--    trigger_event:  INSERT | UPDATE | DELETE | 

CREATE TRIGGER testref BEFORE INSERT ON test1
  FOR EACH ROW BEGIN
    INSERT INTO test2 SET a2 = NEW.a1;
    DELETE FROM test3 WHERE a3 = NEW.a1;
    UPDATE test4 SET b4 = b4 + 1 WHERE a4 = NEW.a1;
  END;

CREATE DEFINER = 'user'@'hostname' TRIGGER my_trigger_1 INSERT ON test1
  FOR EACH ROW BEGIN
    INSERT INTO test2 SET a2 = NEW.a1;
    DELETE FROM test3 WHERE a3 = NEW.a1;
    UPDATE test4 SET b4 = b4 + 1 WHERE a4 = NEW.a1;
  END;
  
--CREATE
--    [OR REPLACE]
--    [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
--    [DEFINER = { user | CURRENT_USER }]
--    [SQL SECURITY { DEFINER | INVOKER }]
--    VIEW view_name [(column_list)]
--    AS select_statement
--    [WITH [CASCADED | LOCAL] CHECK OPTION]

CREATE VIEW my_view_1 AS SELECT * FROM table_a;

CREATE ALGORITHM = UNDEFINED VIEW my_view_2 AS SELECT * FROM table_a;

CREATE ALGORITHM = UNDEFINED DEFINER = CURRENT_USER VIEW my_view_3 AS SELECT * FROM table_a;
-- ============ 80 STATEMENTS ====================
CREATE DEFINER = CURRENT_USER SQL SECURITY INVOKER VIEW my_view_4 AS SELECT * FROM table_a;

DROP DATABASE db_name_1;

DROP DATABASE IF EXISTS db_name_2;

DROP SCHEMA schema_name_1;

DROP SCHEMA IF EXISTS schema_name_2;

DROP EVENT my_event_1;

DROP EVENT IF EXISTS my_event_2;

DROP PROCEDURE  my_proc_1;

DROP PROCEDURE IF EXISTS my_proc_2;

DROP FUNCTION my_funct_1;
-- ============ 90 STATEMENTS ====================
DROP FUNCTION IF EXISTS my_funct_2;

DROP SERVER my_server_1;

DROP SERVER IF EXISTS my_server_2;

--DROP [TEMPORARY] TABLE [IF EXISTS]
--    tbl_name [, tbl_name] ...
--    [RESTRICT | CASCADE]

DROP TABLE table_1;

DROP TEMPORARY TABLE table_2 CASCADE;

DROP TEMPORARY TABLE IF EXISTS table_3;

DROP TABLE IF EXISTS table_4, table_5, table_6;

DROP TABLE IF EXISTS table_7, table_8 RESTRICT;

--DROP TABLESPACE tablespace_name
--    ENGINE [=] engine_name

DROP TABLESPACE my_tbl_space_1 ENGINE = my_eng;

DROP TABLESPACE my_tbl_space_2 ENGINE my_eng;
-- ============ 100 STATEMENTS ====================
DROP TRIGGER my_schema_1.blue_trigger;

DROP TRIGGER IF EXISTS my_schema_2.red_trigger;

DROP VIEW view_1;

DROP VIEW IF EXISTS view_2 CASCADE;

DROP VIEW IF EXISTS view_3, view_4, view_5;

DROP VIEW IF EXISTS view_6, view_7 RESTRICT;
-- ============ 106 STATEMENTS ====================