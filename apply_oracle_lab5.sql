-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab5.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Incorporate diagnostic scripts.
--  02-Feb-2020    Rewrite labs to queries.
--  
-- ------------------------------------------------------------------
--  This queries some tables by using aggregation mechanics; and
--  two-table joins.
-- ------------------------------------------------------------------
--  Instructions:
-- ------------------------------------------------------------------
--  The two scripts contain spooling commands, which is why there
--  isn't a spooling command in this script. When you run this file
--  you first connect to the Oracle database with this syntax:
--
--    sqlplus student/student@xe
--
--  Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab5.sql
--
-- ------------------------------------------------------------------

-- Set SQL*Plus environment variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab4/apply_oracle_lab4.sql

-- ------------------------------------------------------------------
--  Spool to log file.
-- ------------------------------------------------------------------
SPOOL apply_oracle_lab5.txt

-- ------------------------------------------------------------------
--  Enter Lab #4 Steps:
-- ------------------------------------------------------------------

-- ======================================================================
--  Task #1
--  -------
--   This task involves learning how to review how you write scalar
--   subqueries, and how you join tables recursively. The last problem
--   lets you visualize the resetting of foreign key values.
-- ======================================================================
--  Step #1
--  -------
--   Write a query that returns the distinct system_user_id column from
--   system_user table where the system_user_name is 'DBA1'.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   The purpose of this script is to find a unique primary key value,
--   which is the system_user_id column and a surrogate key for the
--   the unique and not null natural primary key. The natural primary
--   key is the system_user_name.
--
--   A query that returns one column and one row is a scalar query
--   and is often used to retrieve a primary key value from a table and 
--   insert it into a foreign key column in another table. It also can
--   be used to retrieve a primary key value form a table and insert
--   the value into a self-referencing foreign key column in the same
--   table. 
--
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL system_user_id  FORMAT 9999  HEADING "System|User|ID #"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   System
--   User
--   ID #
--   ------
--     1001
--
--   1 row selected.
-- ======================================================================
COL system_user_id  FORMAT 9999  HEADING "System|User|ID #"
select system_user_id
from system_user
where system_user_name = 'DBA1';




-- ======================================================================
--  Step #2
--  -------
--   Write a query that returns the system_user_id and system_user_name
--   columns from the system_user table where the system_user_name is
--   'DBA1'.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   The purpose of this script is to find a unique primary key value
--   and system_user_name column. While the system_user_name is used
--   in the WHERE clause to find the primary key value, it shows you
--   that all columns fo the same row are in the result set from a
--   single table query.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL system_user_id    FORMAT 9999  HEADING "System User|ID #"
--  COL system_user_name  FORMAT A12   HEADING "System User|Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   System User System User
--          ID # Name
--   ----------- ------------
--          1001 DBA1
--   
--   1 row selected.
-- ======================================================================
COL system_user_id    FORMAT 9999  HEADING "System User|ID #"
COL system_user_name  FORMAT A12   HEADING "System User|Name"
select system_user_id, system_user_name
from system_user
where system_user_name = 'DBA1';



-- ======================================================================
--  Step #3
--  -------
--   Write a query that returns the system_user_id and system_user_name
--   columns from one copy of the system_user table by using an 'su1'
--   alias and the system_user_name from a second copy of the 
--   system_user table by using an 'su2' alias. You should join the
--   two copies by doing the following:
--
--     - Find the row of the 'su1' aliased table where the
--       system_user_name is 'DBA1'.
--     - Join the copy of the system_user table with an alias of 'su1'
--       to the other copy of the system_user table with an alias of
--       'su2' by joining the two copies of the same table with the
--       su1.created_by column and su2.system_user_id.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   This type of join uses the foreign key value in the created_by
--   column to find the row where the primary key value was copied
--   from and return the system_user_name for the same row. It is
--   called a recursive or self-referencing join. Table aliases are
--   primary designed to let you reference multiple copies of the 
--   same table in a single join; and to disambiguate columns returned
--   from different tables or copies of tables in the SELECT-list.
--
--   Column aliases let you apply different formatting masks to values
--   from a query where the column names are the same. While the table
--   aliases disambiguates the two column sets, only column aliases
--   let you define the difference in SQL reporting or query results.
--   Using distinct column aliases for dulplicated column names is the
--   best practice; although, some progammers use positional alignment
--   for this purpuse. Positional programs eventually fail because
--   maintenance programmers may overlook the coupling of position in
--   the prior solution.
--
--   HINT: Please note the suggested column aliases in the formatting
--         statements below.
--
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL system_user_id1     FORMAT 9999  HEADING "System User|ID #"
--  COL system_user_name1   FORMAT A12   HEADING "System User|Name"
--  COL system_user_id2     FORMAT 9999  HEADING "Created By|System User|ID #"
--  COL system_user_name2   FORMAT A12   HEADING "Created By|System User|Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                             Created By Created By
--   System User System User  System User System User
--          ID # Name                ID # Name
--   ----------- ------------ ----------- ------------
--          1001 DBA1                   1 SYSADMIN
--   
--   1 row selected.
-- ======================================================================
COL system_user_id1     FORMAT 9999  HEADING "System User|ID #"
COL system_user_name1   FORMAT A12   HEADING "System User|Name"
COL system_user_id2     FORMAT 9999  HEADING "Created By|System User|ID #"
COL system_user_name2   FORMAT A12   HEADING "Created By|System User|Name"
select su1.system_user_id, su1.system_user_name, su2.created_by as system_user_id2, su2.system_user_name as system_user_name2
from system_user su1 join system_user su2 on su1.created_by = su2.system_user_id
where su1.system_user_name = 'DBA1';



-- ======================================================================
--  Step #4
--  -------
--   Write a query that returns the system_user_id and system_user_name
--   columns from one copy of the system_user table by using an 'su1'
--   alias, the system_user_name from a second copy of the system_user
--   table by using an 'su2' alias, and the system_user_name from a
--   third copy of the system_user table by using an 'su3' alias. You
--   should join the three copies by doing the following:
--
--     - Find the row of the 'su1' aliased table where the
--       system_user_name is 'DBA1'.
--     - Join the copy of the system_user table with an alias of 'su1'
--       to the other copy of the system_user table with an alias of 'su2'
--     - Find the row of the 'su2' aliased table in the result set
--       from the join of the two tables where the system_user_name
--       is 'DBA1'.
--     - Join the result set of the two table join to the third copy
--       of the system_user table with an alias of 'su3' by joining
--       the su1.last_updated_by column and su3.system_user_id.
--
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   This type of join uses the foreign key value in the last_updated_by
--   column to find the row where the primary key value was copied
--   from and return the system_user_name for the same row. It is also
--   called a recursive or self-referencing join.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL system_user_id1     FORMAT 9999  HEADING "System User|ID #"
--  COL system_user_name1   FORMAT A12   HEADING "System User|Name"
--  COL system_user_id2     FORMAT 9999  HEADING "Created By|System User|ID #"
--  COL system_user_name2   FORMAT A12   HEADING "Created By|System User|Name"
--  COL system_user_id3     FORMAT 9999  HEADING "Last|Updated By|System User|ID #"
--  COL system_user_name3   FORMAT A12   HEADING "Last|Updated By|System User|Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                                                            Last Last
--                             Created By Created By    Updated By Updated By
--   System User System User  System User System User  System User System User
--          ID # Name                ID # Name                ID # Name
--   ----------- ------------ ----------- ------------ ----------- ------------
--          1001 DBA1                   1 SYSADMIN               1 SYSADMIN
--
--   1 row selected.
-- ======================================================================
COL system_user_id1     FORMAT 9999  HEADING "System User|ID #"
COL system_user_name1   FORMAT A12   HEADING "System User|Name"
COL system_user_id2     FORMAT 9999  HEADING "Created By|System User|ID #"
COL system_user_name2   FORMAT A12   HEADING "Created By|System User|Name"
COL system_user_id3     FORMAT 9999  HEADING "Last|Updated By|System User|ID #"
COL system_user_name3   FORMAT A12   HEADING "Last|Updated By|System User|Name"
select su1.system_user_id, su1.system_user_name, su2.created_by as system_user_id2, su2.system_user_name as system_user_name2, su3.system_user_id as system_user_id3, su3.system_user_name as system_user_name3
from system_user su1 
join system_user su2 on su1.created_by = su2.system_user_id 
join system_user su3 on su1.last_updated_by = su3.system_user_id
where su1.system_user_name = 'DBA1';

-- ======================================================================
--  Step #5
--  -------
--   Use the answer to Task #1, Step #1 to UPDATE the last_updated_by
--   column for the row in the system_user table where you find the 
--   system_user_name is equal to 'DBA2'. The subquery should use a
--   system_user_name equal to 'DBA1'. The generic format of the
--   update statement is:
--
--     UPDATE table_name
--     SET    column_name = ( scalar_subquery )
--     WHERE  column_name = 'some_value';
--
--   Copy the first update statement, then change the target column
--   to the created_by column where the system_user_name is equal to
--   'DBA2'.
--
--   Use your query from Task #1, Step #4 to query the whole set of
--   rows from the system_user table by removing the WHERE clause and
--   adding an ORDER BY clause on the system_user_id column.
--
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   This type of join uses the foreign key value in the last_updated_by
--   column to find the row where the primary key value was copied
--   from and return the system_user_name for the same row. It is also
--   called a recursive or self-referencing join.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL system_user_id1     FORMAT 9999  HEADING "System User|ID #"
--  COL system_user_name1   FORMAT A12   HEADING "System User|Name"
--  COL system_user_id2     FORMAT 9999  HEADING "Created By|System User|ID #"
--  COL system_user_name2   FORMAT A12   HEADING "Created By|System User|Name"
--  COL system_user_id3     FORMAT 9999  HEADING "Last|Updated By|System User|ID #"
--  COL system_user_name3   FORMAT A12   HEADING "Last|Updated By|System User|Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                                                            Last Last
--                             Created By Created By    Updated By Updated By
--   System User System User  System User System User  System User System User
--          ID # Name                ID # Name                ID # Name
--   ---------- ------------ ----------- ------------ ----------- ------------
--             1 SYSADMIN               1 SYSADMIN               1 SYSADMIN
--          1001 DBA1                   1 SYSADMIN               1 SYSADMIN
--          1002 DBA2                1001 DBA1                1001 DBA1
--   3 rows selected.
-- ======================================================================


UPDATE system_user
SET  created_by = (select system_user_id
from system_user
where system_user_name = 'DBA1' )
WHERE  system_user_name = 'DBA2';

UPDATE system_user
SET    last_updated_by = (select system_user_id
from system_user
where system_user_name = 'DBA1' )
WHERE  system_user_name = 'DBA2';


COL system_user_id1     FORMAT 9999  HEADING "System User|ID #"
COL system_user_name1   FORMAT A12   HEADING "System User|Name"
COL system_user_id2     FORMAT 9999  HEADING "Created By|System User|ID #"
COL system_user_name2   FORMAT A12   HEADING "Created By|System User|Name"
COL system_user_id3     FORMAT 9999  HEADING "Last|Updated By|System User|ID #"
COL system_user_name3   FORMAT A12   HEADING "Last|Updated By|System User|Name"
select su1.system_user_id, su1.system_user_name, su2.created_by as system_user_id2, su2.system_user_name as system_user_name2, su3.system_user_id as system_user_id3, su3.system_user_name as system_user_name3
from system_user su1 
join system_user su2 on su1.created_by = su2.system_user_id 
join system_user su3 on su1.last_updated_by = su3.system_user_id
order by su1.system_user_id
;
-- ======================================================================
--  Task #2
--  -------
--   Reviewing the Entity Relationship Model (ER-Model) or Entity
--   Relationship Design (ERD), you noticed that the item table has
--   repetitive data in the item_rating column. You see data that 
--   supports movies and games, and recognize that you need two new
--   tables. You will be able to build some of the logic with queries
--   and use Data Definition Language (DDL) commands to build the
--   new tables and constraints.
-- ======================================================================
--  Step #1
--  -------
--   Create a rating_agency table with the following data column names
--   and types (check the scripts in the create library directory). 
--   There is also hidden a primary key, a unique, five not null, 
--   and two foreign key constraints. The validation scripts will 
--   generate the displayed values when you are creating the 
--   rating_agency table correctly:
--
--    Name                            Null?    Type
--    ------------------------------- -------- -----------------------
--    RATING_AGENCY_ID                NOT NULL NUMBER
--    RATING_AGENCY_ABBR              NOT NULL VARCHAR2(4)
--    RATING_AGENCY_NAME              NOT NULL VARCHAR2(40)
--    CREATED_BY                      NOT NULL NUMBER
--    CREATION_DATE                   NOT NULL DATE
--    LAST_UPDATED_BY                 NOT NULL NUMBER
--    LAST_UPDATE_DATE                NOT NULL DATE
--
--   After you create the table with the appropriate constraints, you
--   should create a rating_s1 sequence.
-- ----------------------------------------------------------------------
--  Uses: This uses the CREATE and INSERT statements.
-- ----------------------------------------------------------------------
--  Uses: This step uses a series of diagnostics for verify that you
--        have correctly completed each step.
-- ======================================================================

-- ======================================================================
--  Create and assign bind variable for rating_agency table and 
--  sequence name; and this will set a default session variable to
--  ensure diagnostic scripts run consistently.
-- ------------------------------------------------------------------

VARIABLE table_name     VARCHAR2(30)

BEGIN
  :table_name := UPPER('rating_agency');
END;
/

--  Verify table name.
SELECT :table_name FROM dual;

-- ------------------------------------------------------------------
--  Conditionally drop rating_agency table and rating_agency_s1
--  sequence.
-- ------------------------------------------------------------------
DECLARE
  /* Dynamic cursor. */
  CURSOR c (cv_object_name VARCHAR2) IS
    SELECT o.object_type
    ,      o.object_name
    FROM   user_objects o
    WHERE  o.object_name LIKE UPPER(cv_object_name||'%');
BEGIN
  FOR i IN c(:table_name) LOOP
    IF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    ELSIF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name||' CASCADE CONSTRAINTS';
    END IF;
  END LOOP;
END;
/

-- ======================================================================

-- ======================================================================
--  Enter the CREATE statement for the rating_agency table here:
-- ======================================================================
CREATE TABLE rating_agency
( RATING_AGENCY_ID          NUMBER
,RATING_AGENCY_ABBR         VARCHAR2(4) CONSTRAINT NN_RATING_AGENCY1 NOT NULL
,RATING_AGENCY_NAME         VARCHAR2(40)CONSTRAINT NN_RATING_AGENCY2 NOT NULL 
,CREATED_BY                 NUMBER      CONSTRAINT NN_RATING_AGENCY3 NOT NULL
,CREATION_DATE              DATE        CONSTRAINT NN_RATING_AGENCY4 NOT NULL
,LAST_UPDATED_BY            NUMBER      CONSTRAINT NN_RATING_AGENCY5 NOT NULL
,LAST_UPDATE_DATE           DATE        CONSTRAINT NN_RATING_AGENCY6 NOT NULL
, CONSTRAINT pk_rating_agency PRIMARY KEY(rating_agency_id)
, CONSTRAINT fk_rating_agency1 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_rating_agency2 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
, CONSTRAINT uq_rating_agency UNIQUE (rating_agency_name)
);


--   -------------------- -------- ----------------------
--   PK_RATING_AGENCY            1 RATING_AGENCY_ID
--   UQ_RATING_AGENCY            1 RATING_AGENCY_NAME


-- ======================================================================
--  Validate the columns, data types, and not null constraints.
-- ------------------------------------------------------------------

COLUMN table_name  FORMAT A16  HEADING "Table Name"
COLUMN column_id   FORMAT 9999 HEADING "Column|ID #"
COLUMN column_name FORMAT A24  HEADING "Column Name"
COLUMN nullable    FORMAT A8   HEADING "Nullable"
COLUMN data_type   FORMAT A14  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ' '
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = :table_name
ORDER BY 2;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   TABLE_NAME       COLUMN_ID COLUMN_NAME            NULLABLE DATA_TYPE
--   ---------------- --------- ---------------------- -------- ------------
--   RATING_AGENCY            1 RATING_AGENCY_ID       NOT NULL NUMBER(22)
--   RATING_AGENCY            2 RATING_AGENCY_ABBR     NOT NULL VARCHAR2(4)
--   RATING_AGENCY            3 RATING_AGENCY_NAME     NOT NULL VARCHAR2(40)
--   RATING_AGENCY            4 CREATED_BY             NOT NULL NUMBER(22)
--   RATING_AGENCY            5 CREATION_DATE          NOT NULL DATE
--   RATING_AGENCY            6 LAST_UPDATED_BY        NOT NULL NUMBER(22)
--   RATING_AGENCY            7 LAST_UPDATE_DATE       NOT NULL DATE
--
--   7 rows selected.
--
-- ======================================================================

-- ======================================================================
--  Validate the primary and non-unique contraints.
-- ------------------------------------------------------------------

COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = :table_name
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   CONSTRAINT_NAME                SEARCH_CONDITION                     C
--   ------------------------------ ------------------------------------ -
--   PK_RATING_AGENCY                                                    P
--   NN_RATING_AGENCY1              "RATING_AGENCY_ABBR" IS NOT NULL     C
--   NN_RATING_AGENCY2              "RATING_AGENCY_NAME" IS NOT NULL     C
--   NN_RATING_AGENCY3              "CREATED_BY" IS NOT NULL             C
--   NN_RATING_AGENCY4              "CREATION_DATE" IS NOT NULL          C
--   NN_RATING_AGENCY5              "LAST_UPDATED_BY" IS NOT NULL        C
--   NN_RATING_AGENCY6              "LAST_UPDATE_DATE" IS NOT NULL       C
--   
--   7 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Validate the foreign keys.
-- ------------------------------------------------------------------

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
AND      ucc1.table_name = :table_name
ORDER BY ucc1.table_name
,        uc.constraint_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   Constraint Name:                       References:
--    Table.Column                           Table.Column
--   -------------------------------------- ----------------------------------------
--   FK_RATING_AGENCY1                      REFERENCES
--   (RATING_AGENCY.CREATED_BY)             (SYSTEM_USER.SYSTEM_USER_ID)
--   
--   FK_RATING_AGENCY2                      REFERENCES
--   (RATING_AGENCY.LAST_UPDATED_BY)        (SYSTEM_USER.SYSTEM_USER_ID)
--   
--   2 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Validate the primary and unique constraint.
-- ------------------------------------------------------------------

COLUMN index_name      FORMAT A20 HEADING "Unique Indexes Names"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
ON       ui.index_name = uic.index_name
AND      ui.table_name = uic.table_name
WHERE    ui.table_name = :table_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--                          Column Column
--   Unique Indexes Names Position Name
--   -------------------- -------- ----------------------
--   PK_RATING_AGENCY            1 RATING_AGENCY_ID
--   UQ_RATING_AGENCY            1 RATING_AGENCY_NAME
--   
--   2 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Enter the CREATE statement for the rating_agency_s1 sequence that
--  starts with 1001 here:
-- ======================================================================

CREATE SEQUENCE rating_agency_s1
 START WITH     1001;


-- ======================================================================
--  Validate the creation of the correct sequence.
-- ------------------------------------------------------------------

COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = :table_name||'_S1';

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--  Sequence Name
--  --------------------
--  RATING_AGENCY_S1
--  
--  1 row selected.
--
-- ======================================================================

-- ======================================================================
--   Insert two rows into the rating_agency table with the following
--   information for the columns:
--
--   Row #1:
--   -------
--   RATING_AGENCY_ID ............  rating_agency_s1.NEXTVAL
--   RATING_AGENCY_ABBR .......... 'ESRB'
--   RATING_AGENCY_NAME .......... 'Entertainment Software Rating Board'
--   CREATED_BY ..................  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   CREATION_DATE ...............  SYSDATE
--   LAST_UPDATED_BY  ............  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   LAST_UPDATE_DATE ............  SYSDATE
--
--   Row #2:
--   -------
--   RATING_AGENCY_ID ............  rating_agency_s1.NEXTVAL
--   RATING_AGENCY_ABBR .......... 'MPAA'
--   RATING_AGENCY_NAME .......... 'Motion Picture Association of America'
--   CREATED_BY ..................  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   CREATION_DATE ...............  SYSDATE
--   LAST_UPDATED_BY  ............  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   LAST_UPDATE_DATE ............  SYSDATE
--
-- ------------------------------------------------------------------
--  The INSERT statement has the following protoype:
-- ------------------------------------------------------------------
--
--    INSERT INTO table_name
--    ( comma-separated column_name_list )
--    VALUES
--    ( comma-separated value_list );
-- 
--    HINT: You can substitute scalar queries for values in the 
--          value list of an INSERT statement.
--
-- ======================================================================

-- ======================================================================
--  Enter the INSERT statements here:
-- ======================================================================
insert into rating_agency
(RATING_AGENCY_ID
,RATING_AGENCY_ABBR
,RATING_AGENCY_NAME
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_agency_s1.NEXTVAL,
'ESRB',
'Entertainment Software Rating Board',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);


insert into rating_agency
(RATING_AGENCY_ID
,RATING_AGENCY_ABBR
,RATING_AGENCY_NAME
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_agency_s1.NEXTVAL,
'MPAA',
'Motion Picture Association of America',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);





-- ======================================================================
--  Validate the insertion of the two rows with the following query:
-- ------------------------------------------------------------------

COL rating_agency_id    FORMAT 9999  HEADING "Rating|Agency|ID #"
COL rating_agency_abbr  FORMAT A6    HEADING "Rating|Agency|Abbr"
COL rating_agency_name  FORMAT A40   HEADING "Rating Agency"
SELECT   rating_agency_id
,        rating_agency_abbr
,        rating_agency_name
FROM     rating_agency;
 
-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   Rating Rating
--   Agency Agency
--     ID # Abbr   Rating Agency
--   ------ ------ ----------------------------------------
--     1001 ESRB   Entertainment Software Rating Board
--     1002 MPAA   Motion Picture Association of America
--   
--   2 rows selected.

-- ======================================================================

-- ======================================================================
--  Step #2
--  -------
--   Create a rating table with the following data column names and
--   types (check the scripts in the create library directory for 
--   examples). There is also hidden a primary key, a unique, five 
--   not null, and two foreign key constraints. The validation 
--   scripts will generate the displayed values when you are creating
--   the rating table correctly:
--
--    Name                            Null?    Type
--    ------------------------------- -------- ----------------------------
--    RATING_ID                       NOT NULL NUMBER
--    RATING_AGENCY_ID                NOT NULL NUMBER
--    RATING                          NOT NULL VARCHAR2(5)
--    DESCRIPTION                              VARCHAR2(400)
--    CREATED_BY                      NOT NULL NUMBER
--    CREATION_DATE                   NOT NULL DATE
--    LAST_UPDATED_BY                 NOT NULL NUMBER
--    LAST_UPDATE_DATE                NOT NULL DATE
--
--   After you create the table with the appropriate constraints, you
--   should create a rating_s1 sequence.
-- ----------------------------------------------------------------------
--  Uses: This uses the CREATE and INSERT statements.
-- ----------------------------------------------------------------------
--  Uses: This step uses a series of diagnostics for verify that you
--        have correctly completed each step.
-- ======================================================================

-- ======================================================================
--  Assign bind variable for rating table and 
--  sequence name; and this will set a default session variable to
--  ensure diagnostic scripts run consistently.
-- ------------------------------------------------------------------

BEGIN
  :table_name := UPPER('rating');
END;
/

--  Verify table name.
SELECT :table_name FROM dual;

-- ------------------------------------------------------------------
--  Conditionally drop rating table and rating_s1
--  sequence.
-- ------------------------------------------------------------------
DECLARE
  /* Dynamic cursor. */
  CURSOR c (cv_object_name VARCHAR2) IS
    SELECT o.object_type
    ,      o.object_name
    FROM   user_objects o
    WHERE  o.object_name LIKE UPPER('rating') and o.object_name like UPPER('rating_s1');
BEGIN
  FOR i IN c(:table_name) LOOP
    IF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    ELSIF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name||' CASCADE CONSTRAINTS';
    END IF;
  END LOOP;
END;
/

-- ======================================================================

-- ======================================================================
--  Enter the CREATE statement for the rating table here:
-- ======================================================================

CREATE TABLE rating
( RATING_ID          NUMBER
,RATING_AGENCY_ID           NUMBER          CONSTRAINT NN_RATING_1 NOT NULL
,RATING                     VARCHAR2(8)     CONSTRAINT NN_RATING_2 NOT NULL constraint UQ_RATING unique
,DESCRIPTION                VARCHAR2(400)   
,CREATED_BY                 NUMBER          CONSTRAINT NN_RATING_3 NOT NULL
,CREATION_DATE              DATE            CONSTRAINT NN_RATING_4 NOT NULL
,LAST_UPDATED_BY            NUMBER          CONSTRAINT NN_RATING_5 NOT NULL
,LAST_UPDATE_DATE           DATE            CONSTRAINT NN_RATING_6 NOT NULL
, CONSTRAINT pk_rating PRIMARY KEY(rating_id)
, CONSTRAINT fk_rating_1 FOREIGN KEY(rating_agency_id) REFERENCES rating_agency(rating_agency_id)
, CONSTRAINT fk_rating_2 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_rating_3 foreign key (last_updated_by) references system_user(system_user_id)
);

--
--    Name                            Null?    Type
--    ------------------------------- -------- ----------------------------
--    RATING_ID                       NOT NULL NUMBER
--    RATING_AGENCY_ID                NOT NULL NUMBER
--    RATING                          NOT NULL VARCHAR2(5)
--    DESCRIPTION                              VARCHAR2(400)
--    CREATED_BY                      NOT NULL NUMBER
--    CREATION_DATE                   NOT NULL DATE
--    LAST_UPDATED_BY                 NOT NULL NUMBER
--    LAST_UPDATE_DATE                NOT NULL DATE

-- ======================================================================
--  Validate the columns, data types, and not null constraints.
-- ------------------------------------------------------------------

COLUMN table_name  FORMAT A16  HEADING "Table Name"
COLUMN column_id   FORMAT 9999 HEADING "Column|ID #"
COLUMN column_name FORMAT A24  HEADING "Column Name"
COLUMN nullable    FORMAT A8   HEADING "Nullable"
COLUMN data_type   FORMAT A14  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = :table_name
ORDER BY 2;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--                    Column
--   Table Name         ID # Column Name              Nullable Data Type
--   ---------------- ------ ------------------------ -------- --------------
--   RATING                1 RATING_ID                NOT NULL NUMBER(22)
--   RATING                2 RATING_AGENCY_ID         NOT NULL NUMBER(22)
--   RATING                3 RATING                   NOT NULL VARCHAR2(8)
--   RATING                4 DESCRIPTION                       VARCHAR2(400)
--   RATING                5 CREATED_BY               NOT NULL NUMBER(22)
--   RATING                6 CREATION_DATE            NOT NULL DATE
--   RATING                7 LAST_UPDATED_BY          NOT NULL NUMBER(22)
--   RATING                8 LAST_UPDATE_DATE         NOT NULL DATE
--   
--   8 rows selected.
--
-- ======================================================================

-- ======================================================================
--  Validate the primary and non-unique contraints.
-- ------------------------------------------------------------------

COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = :table_name
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   CONSTRAINT_NAME        SEARCH_CONDITION                     C
--   ---------------------- ------------------------------------ -
--   PK_RATING                                                   P
--   NN_RATING_1            "RATING_AGENCY_ID" IS NOT NULL       C
--   NN_RATING_2            "RATING" IS NOT NULL                 C
--   NN_RATING_3            "CREATED_BY" IS NOT NULL             C
--   NN_RATING_4            "CREATION_DATE" IS NOT NULL          C
--   NN_RATING_5            "LAST_UPDATED_BY" IS NOT NULL        C
--   NN_RATING_6            "LAST_UPDATE_DATE" IS NOT NULL       C
--   
--   7 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Validate the foreign keys.
-- ------------------------------------------------------------------

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
AND      ucc1.table_name = :table_name
ORDER BY ucc1.table_name
,        uc.constraint_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   Constraint Name:                       References:
--   Table.Column                           Table.Column
--   -------------------------------------- ----------------------------------------
--   FK_RATING_1                            REFERENCES
--   (RATING.RATING_AGENCY_ID)              (RATING_AGENCY.RATING_AGENCY_ID)
--   
--   FK_RATING_2                            REFERENCES
--   (RATING.CREATED_BY)                    (SYSTEM_USER.SYSTEM_USER_ID)
--   
--   FK_RATING_3                            REFERENCES
--   (RATING.LAST_UPDATED_BY)               (SYSTEM_USER.SYSTEM_USER_ID)
--   
--   3 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Validate the primary and unique constraint.
-- ------------------------------------------------------------------

COLUMN index_name      FORMAT A20 HEADING "Unique Indexes Names"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
ON       ui.index_name = uic.index_name
AND      ui.table_name = uic.table_name
WHERE    ui.table_name = :table_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--                          Column Column
--   Unique Indexes Names Position Name
--   -------------------- -------- ----------------------
--   PK_RATING                   1 RATING_ID
--   UQ_RATING                   2 RATING
--  
--   2 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Enter the CREATE statement for the rating_s1 sequence that starts
--  with 1001 here:
-- ======================================================================


CREATE SEQUENCE rating_s1
 START WITH     1001;




-- ======================================================================
--  Validate the creation of the correct sequence.
-- ------------------------------------------------------------------

COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = :table_name||'_S1';

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--  Sequence Name
--  --------------------
--  RATING_S1
--  
--  1 row selected.
--
-- ======================================================================

-- ======================================================================
--   Insert two rows into the rating table with the following
--   information for the columns. Your manager told you to exclude the
--   description column until later in the project.
--
--   Row #1:
--   -------
--   RATING_ID ...................  rating_s1.NEXTVAL
--   RATING_AGENCY_ID ............  Scalar subquery for 'MPAA'
--   RATING (one for each value).. 'G','PG','PG-13','R','NR','NC-17'
--   CREATED_BY ..................  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   CREATION_DATE ...............  SYSDATE
--   LAST_UPDATED_BY  ............  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   LAST_UPDATE_DATE ............  SYSDATE
--
--   Row #2:
--   -------
--   RATING_ID ...................  rating_s1.NEXTVAL
--   RATING_AGENCY_ID ............  Scalar subquery for 'ESRB'
--   RATING (one for each value).. 'Everyone','Teen','Mature'
--   CREATED_BY ..................  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   CREATION_DATE ...............  SYSDATE
--   LAST_UPDATED_BY  ............  Scalar subquery where system_user_name
--                                  is equal to 'DBA2'
--   LAST_UPDATE_DATE ............  SYSDATE
--
-- ------------------------------------------------------------------
--  The INSERT statement has the following protoype:
-- ------------------------------------------------------------------
--
--    INSERT INTO table_name
--    ( comma-separated column_name_list )
--    VALUES
--    ( comma-separated value_list );
-- 
--    HINT: You can substitute scalar queries for values in the 
--          value list of an INSERT statement.
--
-- ======================================================================

-- ======================================================================
--  Enter the INSERT statements here:
-- ======================================================================
insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'MPAA'),
'G',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);

insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'MPAA'),
'PG',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);

insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'MPAA'),
'PG-13',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);

insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'MPAA'),
'R',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);

insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'MPAA'),
'NR',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);

insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'MPAA'),
'NC-17',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);


insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'ESRB'),
'Everyone',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);

insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'ESRB'),
'Teen',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);


insert into rating
(RATING_ID
,RATING_AGENCY_ID
,RATING
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
values(
rating_s1.NEXTVAL,
(select RATING_AGENCY_ID
from rating_agency
where rating_agency_abbr = 'ESRB'),
'Mature',
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE,
(select system_user_id
from system_user
where system_user_name = 'DBA2'),
SYSDATE);






-- ======================================================================
--  Validate the insertion of the two rows with the following query:
-- ------------------------------------------------------------------

COL rating_id           FORMAT 9999  HEADING "Rating|ID #"
COL rating              FORMAT A8    HEADING "Rating"
COL rating_agency_id    FORMAT 9999  HEADING "Rating|Agency|ID #"
COL rating_agency_abbr  FORMAT A6    HEADING "Rating|Agency|Abbr"
COL rating_agency_name  FORMAT A40   HEADING "Rating Agency"
SELECT   r.rating_id
,        r.rating_agency_id
,        ra.rating_agency_abbr
,        r.rating
FROM     rating r JOIN rating_agency ra
ON       r.rating_agency_id = ra.rating_agency_id;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--          Rating Rating
--   Rating Agency Agency
--     ID #   ID # Abbr   Rating
--   ------ ------ ------ --------
--     1001   1002 MPAA   G
--     1002   1002 MPAA   PG
--     1003   1002 MPAA   PG-13
--     1004   1002 MPAA   R
--     1005   1002 MPAA   NR
--     1006   1002 MPAA   NC-17
--     1007   1001 ESRB   Everyone
--     1008   1001 ESRB   Teen
--     1009   1001 ESRB   Mature
--   
--   9 rows selected.
--
-- ======================================================================

-- ======================================================================
--  Step #3
--  -------
--   Use the ALTER statement to add a rating_id column to the item
--   table. The rating_id column should use a NUMBER data type and
--   have a foreign key constraint that references it to the rating_id
--   column in the rating table.
-- 
--   HINT: You can't add a NOT NULL constained column when there are
--         rows in the table, which means you add it as nullable and
--         you add the not null constraint after you have put data in
--         all the rows.
-- ----------------------------------------------------------------------
--  Uses: This USES the ALTER statement.
-- ======================================================================

-- ======================================================================
--  Assign bind variable for rating_agency table and 
--  sequence name; and this will set a default session variable to
--  ensure diagnostic scripts run consistently.
-- ------------------------------------------------------------------

BEGIN
  :table_name := UPPER('item');
END;
/

--  Verify table name.
SELECT :table_name FROM dual;

-- ======================================================================

-- ======================================================================
--  Enter the ALTER statement to add the rating_id column to the item
--  table here, and another ALTER statement to add a foreign key 
--  constraint on the item table's rating_id column that references
--  the rating table's rating_id column as a primary key.
-- ======================================================================


alter table item
add rating_id number
add constraint FK_ITEM_4 foreign key(rating_id) references rating(rating_id);


-- ======================================================================
--  Validate the columns, data types, and not null constraints.
-- ------------------------------------------------------------------

COLUMN table_name  FORMAT A16  HEADING "Table Name"
COLUMN column_id   FORMAT 9999 HEADING "Column|ID #"
COLUMN column_name FORMAT A24  HEADING "Column Name"
COLUMN nullable    FORMAT A8   HEADING "Nullable"
COLUMN data_type   FORMAT A14  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = :table_name
ORDER BY 2;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--                    Column
--   Table Name         ID # Column Name              Nullable Data Type
--   ---------------- ------ ------------------------ -------- --------------
--   ITEM                  1 ITEM_ID                  NOT NULL NUMBER(22)
--   ITEM                  2 ITEM_BARCODE             NOT NULL VARCHAR2(14)
--   ITEM                  3 ITEM_TYPE                NOT NULL NUMBER(22)
--   ITEM                  4 ITEM_TITLE               NOT NULL VARCHAR2(60)
--   ITEM                  5 ITEM_SUBTITLE                     VARCHAR2(60)
--   ITEM                  6 ITEM_RATING              NOT NULL VARCHAR2(8)
--   ITEM                  7 ITEM_RELEASE_DATE        NOT NULL DATE
--   ITEM                  8 CREATED_BY               NOT NULL NUMBER(22)
--   ITEM                  9 CREATION_DATE            NOT NULL DATE
--   ITEM                 10 LAST_UPDATED_BY          NOT NULL NUMBER(22)
--   ITEM                 11 LAST_UPDATE_DATE         NOT NULL DATE
--   ITEM                 12 RATING_ID                         NUMBER(22)
--   
--   12 rows selected.
--
-- ======================================================================

-- ======================================================================
--  Validate the foreign keys.
-- ------------------------------------------------------------------

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
AND      ucc1.table_name = :table_name
ORDER BY ucc1.table_name
,        uc.constraint_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   Constraint Name:                       References:
--    Table.Column                           Table.Column
--   -------------------------------------- ----------------------------------------
--   FK_ITEM_1                              REFERENCES
--   (ITEM.ITEM_TYPE)                       (COMMON_LOOKUP.COMMON_LOOKUP_ID)
--   
--   FK_ITEM_2                              REFERENCES
--   (ITEM.CREATED_BY)                      (SYSTEM_USER.SYSTEM_USER_ID)
--   
--   FK_ITEM_3                              REFERENCES
--   (ITEM.LAST_UPDATED_BY)                 (SYSTEM_USER.SYSTEM_USER_ID)
--   
--   FK_ITEM_4                              REFERENCES
--   (ITEM.RATING_ID)                       (RATING.RATING_ID)
--   
--   4 rows selected.
--   
-- ======================================================================

-- ======================================================================
--  Step #4
--  -------
--   There is a non-compliant item_rating value of 'PG13' in the item
--   table. Use an UPDATE statement to convert it from 'PG13' to 
--   'PG-13'. After you have updated the non-compliant item_rating 
--   value, use a join to update the rating_id column in the item
--   table for all rows.
-- ----------------------------------------------------------------------
--  Uses: This USES the UPDATE statement.
-- ----------------------------------------------------------------------
--
COL item_rating    FORMAT A8  HEADING "Item|Rating"
SELECT item_rating
FROM   item
WHERE  item_rating LIKE '%13';
--
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   Item
--   Rating
--   --------
--   PG-13
--   
--   1 row selected.
-- ======================================================================
--
-- ----------------------------------------------------------------------
--  Use the following correlated UPDATE statement to update the new
--  rating_id column in the item table:
-- ----------------------------------------------------------------------
--
UPDATE item i
SET    i.rating_id = (SELECT r.rating_id
                      FROM   rating r
                      WHERE  r.rating = i.item_rating);
--
-- ======================================================================

-- ======================================================================
--  Step #5
--  -------
--   Cleanup from the changes by doing the following dropping the
--   now redundant item_rating column from the item table, then add
--   a not null constraint on the rating_id column of the item table.
-- ----------------------------------------------------------------------
--  Uses: This USES the ALTER statement with a DROP and MODIFY option.
-- ======================================================================

-- ======================================================================
--  Enter the ALTER statements here:
-- ======================================================================
update item 
set rating_id = 1002
where item_title = 'Star Wars III';

alter table item 
drop column item_rating;
alter table item modify rating_id constraint 
NN_ITEM_10 not null;



-- ======================================================================
--  Validate the columns, data types, and not null constraints.
-- ------------------------------------------------------------------

COLUMN table_name  FORMAT A16  HEADING "Table Name"
COLUMN column_id   FORMAT 9999 HEADING "Column|ID #"
COLUMN column_name FORMAT A24  HEADING "Column Name"
COLUMN nullable    FORMAT A8   HEADING "Nullable"
COLUMN data_type   FORMAT A14  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ' '
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = :table_name
ORDER BY 2;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--                    Column
--   Table Name         ID # Column Name              Nullable Data Type
--   ---------------- ------ ------------------------ -------- --------------
--   ITEM                  1 ITEM_ID                  NOT NULL NUMBER(22)
--   ITEM                  2 ITEM_BARCODE             NOT NULL VARCHAR2(14)
--   ITEM                  3 ITEM_TYPE                NOT NULL NUMBER(22)
--   ITEM                  4 ITEM_TITLE               NOT NULL VARCHAR2(60)
--   ITEM                  5 ITEM_SUBTITLE                     VARCHAR2(60)
--   ITEM                  6 ITEM_RELEASE_DATE        NOT NULL DATE
--   ITEM                  7 CREATED_BY               NOT NULL NUMBER(22)
--   ITEM                  8 CREATION_DATE            NOT NULL DATE
--   ITEM                  9 LAST_UPDATED_BY          NOT NULL NUMBER(22)
--   ITEM                 10 LAST_UPDATE_DATE         NOT NULL DATE
--   ITEM                 11 RATING_ID                NOT NULL NUMBER(22)
--   
--   11 rows selected.
--
-- ======================================================================

-- ======================================================================
--  Validate the primary and non-unique contraints.
-- ------------------------------------------------------------------

COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = :table_name
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        LENGTH(uc.constraint_name)
,        uc.constraint_name;

-- ------------------------------------------------------------------
--  It should display the following:
-- ------------------------------------------------------------------
--
--   CONSTRAINT_NAME        SEARCH_CONDITION                     C
--   ---------------------- ------------------------------------ -
--   PK_ITEM_1                                                   P
--   NN_ITEM_1              "ITEM_BARCODE" IS NOT NULL           C
--   NN_ITEM_2              "ITEM_TYPE" IS NOT NULL              C
--   NN_ITEM_3              "ITEM_TITLE" IS NOT NULL             C
--   NN_ITEM_5              "ITEM_RELEASE_DATE" IS NOT NULL      C
--   NN_ITEM_6              "CREATED_BY" IS NOT NULL             C
--   NN_ITEM_7              "CREATION_DATE" IS NOT NULL          C
--   NN_ITEM_8              "LAST_UPDATED_BY" IS NOT NULL        C
--   NN_ITEM_9              "LAST_UPDATE_DATE" IS NOT NULL       C
--   NN_ITEM_10             "RATING_ID" IS NOT NULL              C
--   
--   10 rows selected.
--
-- ======================================================================


SPOOL OFF
