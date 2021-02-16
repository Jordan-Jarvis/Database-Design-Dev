-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab4.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Incorporate diagnostic scripts.
--  18-Jan-2020    Rewrite labs to queries.
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
--   sql> @apply_oracle_lab4.sql
--
-- ------------------------------------------------------------------

-- Set SQL*Plus environmnet variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab3/apply_oracle_lab3.sql

SPOOL apply_oracle_lab4.txt
-- ------------------------------------------------------------------
--  Enter Lab #4 Steps:
-- ------------------------------------------------------------------

-- ======================================================================
--  Step #1
--  -------
--   Write a query that returns the distinct member_id column from the
--   contact table where their last_name is 'Sweeney'.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   The purpose of this program is to find a unique foreign key value,
--   which would can be used to reverse lookup the account_number and
--   credit_card_number in the member table. It presumes that the data
--   only has one unique last_name. The current data set meets that
--   criteria but as a later problem will explain, it is possible that
--   the table could hold two or more copies of the same last name
--   that link to different member_id values in the contact table.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL member_id          FORMAT 9999  HEADING "Member|ID #"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   Member
--   ID #
--   ------
--     1003
--
--   1 row selected.
-- ======================================================================
COL member_id          FORMAT 9999  HEADING "Member|ID #"
select distinct member_id 
from contact 
where last_name = 'Sweeney';



-- ======================================================================
--  Step #2
--  -------
--   Write a query that returns the last_name column from the contact
--   table and the account_number and credit_card_number from the member
--   table. The WHERE clause should filter the data set based on the
--   last_name column in the contact table where the last name equals
--   a case insensitive 'SWEENEY'. Text matches are case sensitive in
--   the Oracle database and you will need to promote both sides of the
--   filtering statement to uppercase or demote both sides to lowercase
--   strings. The from clause should use an "ON" subclause that joins
--   the two tables on the member_id column that is found in both tables.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE clause.
-- ----------------------------------------------------------------------
--  Purpose:
--  --------
--   The purpose of this program is to use the last name to find a
--   customer's account_number and credit_card_number.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Credit Card Number
--   ---------- ---------- -------------------
--   Sweeney    B293-71447 3333-4444-5555-6666
--   Sweeney    B293-71447 3333-4444-5555-6666
--   Sweeney    B293-71447 3333-4444-5555-6666
--   
--   3 rows selected.
-- ======================================================================
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
select c.last_name, m.account_number, m.credit_card_number
from contact c join member m on c.member_id = m.member_id
where upper(last_name) = 'SWEENEY';


-- ======================================================================
--  Step #3
--  -------
--   Write a query that returns the distinct row of last_name column
--   from the contact table and the account_number and credit_card_number
--   from the member table. The WHERE clause should filter the data set
--   based on the last_name column in the contact table where the last
--   name equals a case insensitive 'SWEENEY'. Text matches are case
--   sensitive in the Oracle database and you will need to promote both
--   sides of the filtering statement to uppercase or demote both sides
--   to lowercase strings. The from clause should use an "ON" subclause
--   that joins the two tables on the member_id column that is found in
--   both tables.
-- ----------------------------------------------------------------------
--  Uses: This does use WHERE and a DISTINCT keyword in the SELECT-list.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Credit Card Number
--   ---------- ---------- -------------------
--   Sweeney    B293-71447 3333-4444-5555-6666
--   
--   1 row selected.
-- ======================================================================
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
select distinct c.last_name, m.account_number, m.credit_card_number
from contact c join member m on c.member_id = m.member_id
where upper(last_name) = 'SWEENEY';


-- ======================================================================
--  Step #4
--  -------
--   Write a query that returns the last_name from the contact table,
--   the account_number and credit_card_number from the member table,
--   and the city, state_province, and postal_code columns from the
--   address table. You need to concatenate the city, state_province,
--   and postal_code columns, and assign an address alias as follows:
--
--     San Jose, CA 95102
--
--   You should use a WHERE clause to filter the data set for the
--   'Visquel' family regardless of the case sensitive entry of the
--   families surname. A three table join is done in two steps inside
--   the FROM clause. You join one table to a second table based on a
--   shared column value, like the member_id column. The first part of
--   the join returns a temporary result set that you use like a table
--   in a two table join. You join the third table by using a shared
--   column of primary and foreign key, like contact_id, which is found
--   in the contact and address tables. You also want to return only
--   the distinct row for the data.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE and a DISTINCT keyword in the SELECT-list.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
--  COL address             FORMAT A22  HEADING "Address"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Credit Card Number  Address
--   ---------- ---------- ------------------- ----------------------
--   Vizquel    B293-71446 2222-3333-4444-5555 San Jose, CA 95192
--
--   1 row selected.
-- ======================================================================
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
COL address             FORMAT A22  HEADING "Address"
select distinct last_name, account_number, credit_card_number, a.city || ', ' || a.state_province || ' ' || a.postal_code as address
from contact c join member m on c.member_id = m.member_id join address a on c.contact_id = a.contact_id
where upper(last_name) = 'VIZQUEL';




-- ======================================================================
--  Step #5
--  -------
--   Write a query that returns the last_name from the contact table,
--   the account_number and credit_card_number from the member table,
--   the street_address from the street_address table, and the city,
--   state_province, and postal_code columns from the address table.
--   You need to concatenate the street_address from the street_address
--   table, a line return, city, state_province, and postal_code
--   columns from the address table, and assign an address alias to
--   the two row return as follows:
--
--     12 El Camino Real
--     San Jose, CA 95102
--
--   You should use a WHERE clause to filter the data set for the
--   'Visquel' family regardless of the case sensitive entry of the
--   families surname. A three table join is done in two steps inside
--   the FROM clause. You join one table to a second table based on a
--   shared column value, like the member_id column. The first part of
--   the join returns a temporary result set that you use like a table
--   in a two table join. You join the third table by using a shared
--   column of primary and foreign key, like contact_id, which is found
--   in the contact and address tables. The three table join can now be
--   extended to a four table join by using the address_id column in the
--   address table and the address_id column in the street_address table.
--   You also want to return only the distinct row for the data.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE and a DISTINCT keyword in the SELECT-list,
--        and you create a line return like this: ||CHR(10)||.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
--  COL address             FORMAT A22  HEADING "Address"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Credit Card Number  Address
--   ---------- ---------- ------------------- ----------------------
--   Vizquel    B293-71446 2222-3333-4444-5555 12 El Camino Real
--                                             San Jose, CA 95192
--   
--   1 row selected.
-- ======================================================================
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL credit_card_number  FORMAT A19  HEADING "Credit Card Number"
COL address             FORMAT A22  HEADING "Address"
select 
distinct last_name,
account_number,
credit_card_number,
s.street_address || CHR(10) || a.city || ', ' || a.state_province || ' ' || a.postal_code as address
from contact c 
join member m on c.member_id = m.member_id 
join address a on c.contact_id = a.contact_id 
join street_address s on a.address_id = s.address_id
where upper(last_name) = 'VIZQUEL';


-- ======================================================================
--  Step #6
--  -------
--   Write a query that returns the last_name from the contact table,
--   the account_number from the member table, the street_address from
--   the street_address table, and the city, state_province, and
--   postal_code columns from the address table.
-- 
--   You need to concatenate the street_address from the street_address
--   table, a line return, city, state_province, and postal_code
--   columns from the address table, and assign an address alias to
--   the two row return as follows:
--
--     12 El Camino Real
--     San Jose, CA 95102
--
--   You should use a WHERE clause to filter the data set for the
--   'Visquel' family regardless of the case sensitive entry of the
--   families surname. A three table join is done in two steps inside
--   the FROM clause. You join one table to a second table based on a
--   shared column value, like the member_id column. The first part of
--   the join returns a temporary result set that you use like a table
--   in a two table join. You join the third table by using a shared
--   column of primary and foreign key, like contact_id, which is found
--   in the contact and address tables. The three table join can now be
--   extended to a four table join by using the address_id column in the
--   address table and the address_id column in the street_address table.
--
--   You can now extend the four table join to a five table join by
--   adding the telephone table, which you can join to the contact_id
--   column in the contact and telephone tabbles.
--
--   You also want to concatenate the area_code column and
--   telephone_number columns in the telephone table as a single 
--   column with parentheses around the area code. You achieve this
--   concatenated result and assign it to a telephone alias.
-- ----------------------------------------------------------------------
--  Uses: This does use a WHERE and a DISTINCT keyword in the SELECT-list,
--        and you create a line return like this: ||CHR(10)||.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL address             FORMAT A22  HEADING "Address"
--  COL telephone           FORMAT A14  HEADING "Telephone"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Address                TELEPHONE
--   ---------- ---------- ---------------------- -------------------
--   Vizquel    B293-71446 12 El Camino Real      (408) 222-2222
--                         San Jose, CA 95192
--
--   1 rows selected.
-- ======================================================================
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL address             FORMAT A22  HEADING "Address"
COL telephone           FORMAT A14  HEADING "Telephone"
select 
distinct last_name,
account_number,
s.street_address || CHR(10) || a.city || ', ' || a.state_province || ' ' || a.postal_code as address,
'(' || t.area_code || ') ' || telephone_number as telephone
from contact c 
join member m on c.member_id = m.member_id 
join address a on c.contact_id = a.contact_id 
join street_address s on a.address_id = s.address_id
join telephone t on c.contact_id = t.contact_id
where upper(last_name) = 'VIZQUEL';



-- ======================================================================
--  Step #7
--  -------
--   Rewrite the query from Step #6 to include the DISTINCT operator
--   from the SELECT-list but remove the WHERE clause filter on the
--   contact's last_name value. Don't forget to change the width of
--   display for the address column; and make sure to use the
--   following additional SQL*PLus formatting command:
--
--   SET PAGESIZE 99
--
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause but it uses a DISTINCT keyword
--        in the SELECT-list, and you create a line return like this:
--        ||CHR(10)||.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL address             FORMAT A24  HEADING "Address"
--  COL telephone           FORMAT A14  HEADING "Telephone"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Address                  Telephone
--   ---------- ---------- ------------------------ -------------------
--   Winn       B293-71445 10 El Camino Real        (408) 111-1111
--                         San Jose, CA 95192
--
--   Vizquel    B293-71446 12 El Camino Real        (408) 222-2222
--                         San Jose, CA 95192
--   
--   Sweeney    B293-71447 14 El Camino Real        (408) 333-3333
--                         San Jose, CA 95192
--   
--   Clinton    R11-514-34 118 South 9th East       (801) 423-1234
--                         Provo, Utah 84606
--   
--   Moss       R11-514-35 1218 South 10th East     (801) 423-1235
--                         Provo, Utah 84606
--   
--   Gretelz    R11-514-36 2118 South 7th East      (801) 423-1236
--                         Provo, Utah 84606
--   
--   Royal      R11-514-37 2228 South 14th East     (801) 423-1237
--                         Provo, Utah 84606
--   
--   Smith      R11-514-38 333 North 2nd East       (801) 423-1238
--                         Spanish Fork, Utah 84606
--
--
--   8 rows selected.
-- ======================================================================
SET PAGESIZE 99
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL address             FORMAT A24  HEADING "Address"
COL telephone           FORMAT A14  HEADING "Telephone"
select 
distinct last_name,
account_number,
s.street_address || CHR(10) || a.city || ', ' || a.state_province || ' ' || a.postal_code as address,
'(' || t.area_code || ') ' || telephone_number as telephone
from contact c 
join member m on c.member_id = m.member_id 
join address a on c.contact_id = a.contact_id 
join street_address s on a.address_id = s.address_id
join telephone t on c.contact_id = t.contact_id
order by account_number;


-- ======================================================================
--  Step #8
--  -------
--   Rewrite the query from Step #7 to include the DISTINCT operator
--   from the SELECT-list but remove the WHERE clause filter on the
--   contact's last_name value. Then, join the five table query to
--   the rental table by using the contact_id column from the contact
--   table and the customer_id column from the rental table. Don't 
--   forget to change the width of display for the address column;
--   and make sure to use the following additional SQL*PLus formatting
--   command:
--
--   SET PAGESIZE 99
--
--   The new query only returns customers who have a rental agreement.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause but it uses a DISTINCT keyword
--        in the SELECT-list, and you create a line return like this:
--        ||CHR(10)||.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL address             FORMAT A24  HEADING "Address"
--  COL telephone           FORMAT A14  HEADING "Telephone"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Address                  Telephone
--   ---------- ---------- ------------------------ -------------------
--   Sweeney    B293-71447 14 El Camino Real        (408) 333-3333
--                         San Jose, CA 95192
--   
--   Winn       B293-71445 10 El Camino Real        (408) 111-1111
--                         San Jose, CA 95192
--   
--   Vizquel    B293-71446 12 El Camino Real        (408) 222-2222
--                         San Jose, CA 95192
--
--   3 rows selected.
-- ======================================================================
SET PAGESIZE 99
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL address             FORMAT A24  HEADING "Address"
COL telephone           FORMAT A14  HEADING "Telephone"
select 
distinct last_name,
account_number,
s.street_address || CHR(10) || a.city || ', ' || a.state_province || ' ' || a.postal_code as address,
'(' || t.area_code || ') ' || telephone_number as telephone
from contact c 
join member m on c.member_id = m.member_id 
join address a on c.contact_id = a.contact_id 
join street_address s on a.address_id = s.address_id
join telephone t on c.contact_id = t.contact_id
join rental r on c.contact_id = r.customer_id;



-- ======================================================================
--  Step #9
--  -------
--   Rewrite the query from Step #8. Change the inner join between the
--   the result set and the rental table to a left join and add an
--   order by clause that uses the last_name column.
--
--  Note: This query will identify customers who have yet to make a
--        rental in order to target them with a promotional
--        advertisement.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause but it uses a DISTINCT keyword
--        in the SELECT-list, and you create a line return like this:
--        ||CHR(10)||.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL address             FORMAT A24  HEADING "Address"
--  COL telephone           FORMAT A14  HEADING "Telephone"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Address                  TELEPHONE
--   ---------- ---------- ------------------------ -------------------
--   Clinton    R11-514-34 118 South 9th East       (801) 423-1234
--                         Provo, Utah 84606
--   
--   Gretelz    R11-514-36 2118 South 7th East      (801) 423-1236
--                         Provo, Utah 84606
--   
--   Moss       R11-514-35 1218 South 10th East     (801) 423-1235
--                         Provo, Utah 84606
--   
--   Royal      R11-514-37 2228 South 14th East     (801) 423-1237
--                         Provo, Utah 84606
--   
--   Smith      R11-514-38 333 North 2nd East       (801) 423-1238
--                         Spanish Fork, Utah 84606
--   
--   Sweeney    B293-71447 14 El Camino Real        (408) 333-3333
--                         San Jose, CA 95192
--   
--   Vizquel    B293-71446 12 El Camino Real        (408) 222-2222
--                         San Jose, CA 95192
--   
--   Winn       B293-71445 10 El Camino Real        (408) 111-1111
--                         San Jose, CA 95192
--   
--   8 rows selected.
-- ======================================================================
SET PAGESIZE 99
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL address             FORMAT A24  HEADING "Address"
COL telephone           FORMAT A14  HEADING "Telephone"
select 
distinct last_name,
account_number,
s.street_address || CHR(10) || a.city || ', ' || a.state_province || ' ' || a.postal_code as address,
'(' || t.area_code || ') ' || telephone_number as telephone
from contact c 
join member m on c.member_id = m.member_id 
join address a on c.contact_id = a.contact_id 
join street_address s on a.address_id = s.address_id
join telephone t on c.contact_id = t.contact_id
left join rental r on c.contact_id = r.customer_id
order by last_name;



-- ======================================================================
--  Step #10
--  --------
--   Rewrite the query from Step #8. Add a join from the rental table
--   to the rental_item table by using the rental_id column in both
--   tables; and a join from the rental_item table to the item table
--   by using the item_id column in both tables.
--
--   Move the telephone number into position as the first of three
--   rows in the address column and add a WHERE clause that looks
--   for an item_title that starts with 'Stir Wars' or 'Star Wars'.
--   Change the ORDER BY from using the last_name to using the 
--   item_title column.
-- ----------------------------------------------------------------------
--  Uses: This uses WHERE and ORDER BY clauses, and both single
--        character and multiple character wild card operators.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name           FORMAT A10  HEADING "Last Name"
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL address             FORMAT A24  HEADING "Address"
--  COL item_title          FORMAT A14  HEADING "Item Title"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--              Account
--   Last Name  Number     Address                  Item Title
--   ---------- ---------- ------------------------ --------------
--   Vizquel    B293-71446 (408) 222-2222           Star Wars I
--                         12 El Camino Real
--                         San Jose, CA 95192
--   
--   Vizquel    B293-71446 (408) 222-2222           Star Wars II
--                         12 El Camino Real
--                         San Jose, CA 95192
--   
--   Vizquel    B293-71446 (408) 222-2222           Star Wars III
--                         12 El Camino Real
--                         San Jose, CA 95192
--
--   3 row selected.
-- ======================================================================
SET PAGESIZE 99
COL last_name           FORMAT A10  HEADING "Last Name"
COL account_number      FORMAT A10  HEADING "Account|Number"
COL address             FORMAT A24  HEADING "Address"
COL item_title          FORMAT A14  HEADING "Item Title"
select 
distinct last_name,
account_number,
'(' || t.area_code || ') ' || telephone_number || CHR(10) || s.street_address || CHR(10) || a.city || ', ' || a.state_province || ' ' || a.postal_code as address,
i.item_title
from contact c 
join member m on c.member_id = m.member_id 
join address a on c.contact_id = a.contact_id 
join street_address s on a.address_id = s.address_id
join telephone t on c.contact_id = t.contact_id
join rental r on c.contact_id = r.customer_id
join rental_item ri on r.rental_id = ri.rental_id
join item i on ri.item_id = i.item_id
where i.item_title like 'St_r%'
order by item_title;



-- ----------------------------------------------------------------------
--  Close log file.
-- ----------------------------------------------------------------------
SPOOL OFF
