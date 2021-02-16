-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab10.sql
--  Lab Assignment: Lab #10
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab10.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

SPOOL apply_oracle_lab10.txt



SELECT   DISTINCT c.contact_id
FROM     member m INNER JOIN transaction_upload tu
ON       m.account_number = tu.account_number INNER JOIN contact c
ON       m.member_id = c.member_id
WHERE    c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
ORDER BY c.contact_id;

UPDATE SET last_updated_by = SOURCE.last_updated_by
,          last_update_date = SOURCE.last_update_date;



-- ----------------------------------------------------------------------
--  Step #1 : Query records and insert into RENTAL table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #1 : Verify number of rows prior to insert.
-- ----------------------------------------------------------------------
-- Count rentals before insert.
SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

-- ----------------------------------------------------------------------
--  Step #1 : Fix query and query results.
-- ----------------------------------------------------------------------
SET NULL '<Null>'
COLUMN rental_id        FORMAT 9999 HEADING "Rental|ID #"
COLUMN customer         FORMAT 9999 HEADING "Customer|ID #"
COLUMN check_out_date   FORMAT A9   HEADING "Check Out|Date"
COLUMN return_date      FORMAT A10  HEADING "Return|Date"
COLUMN created_by       FORMAT 9999 HEADING "Created|By"
COLUMN creation_date    FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by  FORMAT 9999 HEADING "Last|Update|By"
COLUMN last_update_date FORMAT A10  HEADING "Last|Updated"
SELECT   DISTINCT
         r.rental_id
,        c.contact_id
,        tu.check_out_date AS check_out_date
,        tu.return_date AS return_date
,        3 AS created_by
,        TRUNC(SYSDATE) AS creation_date
,        3 AS last_updated_by
,        TRUNC(SYSDATE) AS last_update_date
FROM     member m inner join contact c
On m.member_id = c.member_id
INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number
and tu.first_name = c.first_name
and NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
and tu.last_name = c.last_name
Left join rental r
on c.contact_id = r.customer_id
and tu.check_out_date = r.check_out_date
and tu.return_date = r.return_date;


-- ----------------------------------------------------------------------
--  Step #1 : Fix insert, insert records from query.
-- ----------------------------------------------------------------------
-- This is the expected solution of students, however:
-- --------------------------------------------------------
--  1. A subquery isn't necessary.
--  2. A NVL can be used with the DISTINCT operator.
-- --------------------------------------------------------


INSERT INTO rental
SELECT   NVL(r.rental_id,rental_s1.NEXTVAL) AS rental_id
,        r.contact_id
,        r.check_out_date
,        r.return_date
,        r.created_by
,        r.creation_date
,        r.last_updated_by
,        r.last_update_date
FROM    (SELECT   DISTINCT
                  r.rental_id
         ,        c.contact_id
         ,        tu.check_out_date AS check_out_date
         ,        tu.return_date AS return_date
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND  tu.account_number = m.account_number LEFT JOIN rental r
         ON   c.contact_id = r.customer_id
         AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
         AND  TRUNC(tu.return_date) = TRUNC(r.return_date)) r;

-- ----------------------------------------------------------------------
--  Step #1 : Verify number of rows after insert.
-- ----------------------------------------------------------------------
-- Count rentals after insert.

COL rental_count FORMAT 999,999 HEADING "Rental|after|Count"
SELECT   COUNT(*) AS rental_count
FROM     rental;



-- ----------------------------------------------------------------------
--  Step #2 : Query records and insert into RENTAL_ITEM table.
-- ----------------------------------------------------------------------



-- ----------------------------------------------------------------------
--  Step #2 : Fix query and query results.
-- ----------------------------------------------------------------------
SET NULL '<Null>'
COLUMN rental_item_id     FORMAT 99999 HEADING "Rental|Item ID #"
COLUMN rental_id          FORMAT 99999 HEADING "Rental|ID #"
COLUMN item_id            FORMAT 99999 HEADING "Item|ID #"
COLUMN rental_item_price  FORMAT 99999 HEADING "Rental|Item|Price"
COLUMN rental_item_type   FORMAT 99999 HEADING "Rental|Item|Type"
COLUMN created_by         FORMAT 9999 HEADING "Created|By"
COLUMN creation_date      FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by    FORMAT 9999 HEADING "Last|Update|By"
COLUMN last_update_date   FORMAT A10  HEADING "Last|Updated"
SELECT   ri.rental_item_id
,        r.rental_id
,        tu.item_id
,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
,        cl.common_lookup_id AS rental_item_type
FROM member m inner join contact c
On m.member_id = c.member_id
  INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number
and tu.first_name = c.first_name
and NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
and tu.last_name = c.last_name
  Left join rental r
on c.contact_id = r.customer_id
and tu.check_out_date = r.check_out_date
and tu.return_date = r.return_date
 inner join common_lookup cl
on cl.common_lookup_table = 'RENTAL_ITEM'
and tu.rental_item_type = cl.common_lookup_type
and cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
 left join rental_item ri
on ri.rental_id = r.rental_id
and ri.item_id = tu.item_id;











-- ----------------------------------------------------------------------
--  Step #2 : Verify number of rows before the insert.
-- ----------------------------------------------------------------------
COL rental_item_count FORMAT 999,999 HEADING "Rental|Item|Before|Count"
SELECT   COUNT(*)
FROM     rental_item;

-- ----------------------------------------------------------------------
--  Step #2 : Fix insert from query results.
-- ----------------------------------------------------------------------
insert into rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT
 rental_item_s1.nextval
, r.rental_id
, tu.item_id
, trunc(r.return_date) - trunc(r.check_out_date) as rental_item_price
, cl.common_lookup_id as rental_item_type
, 1001 as created_by
, trunc(sysdate) as creation_date
, 1001 as last_updated_by
, trunc(sysdate) as last_update_date
   FROM member m inner join contact c
On m.member_id = c.member_id
  INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number
and tu.first_name = c.first_name
and NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
and tu.last_name = c.last_name
  Left join rental r
on c.contact_id = r.customer_id
and tu.check_out_date = r.check_out_date
and tu.return_date = r.return_date
 inner join common_lookup cl
on cl.common_lookup_table = 'RENTAL_ITEM'
and tu.rental_item_type = cl.common_lookup_type
and cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
 left join rental_item ri
on ri.rental_id = r.rental_id
and ri.item_id = tu.item_id;










-- ----------------------------------------------------------------------
--  Step #2 : Verify number of rows after insert.
-- ----------------------------------------------------------------------
 COL rental_item_count FORMAT 999,999 HEADING "Rental|Item|after|Count"
SELECT   COUNT(*)
FROM     rental_item;

-- ----------------------------------------------------------------------
--  Step #3 : Query records and insert into TRANSACTION table.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
--  Step #3 : Fix query and query results.
-- ----------------------------------------------------------------------
SET NULL '<Null>'
COLUMN transaction_id         FORMAT 99999 HEADING "Transaction|ID #"
COLUMN transaction_account    FORMAT A15   HEADING "Transaction|Account"
COLUMN transaction_type       FORMAT 99999 HEADING "Transaction|Type"
COLUMN transaction_date       FORMAT A11   HEADING "Date"
COLUMN transaction_amount     FORMAT 99999 HEADING "Amount"
COLUMN rental_id              FORMAT 99999 HEADING "Rental|ID #"
COLUMN payment_method_type    FORMAT 99999 HEADING "Payment|Method|Type"
COLUMN payment_account_number FORMAT A19    HEADING "Payment|Account Number"
COLUMN created_by             FORMAT 9999 HEADING "Created|By"
COLUMN creation_date          FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by        FORMAT 9999 HEADING "Last|Update|By"
COLUMN last_update_date       FORMAT A10  HEADING "Last|Updated"
SELECT t.transaction_id AS transaction_id
      ,      tu.account_number AS transaction_account
      ,      cl1.common_lookup_id AS transaction_type
      ,      TRUNC(tu.transaction_date) AS transaction_date
      ,      SUM(tu.transaction_amount / 1.06) AS transaction_amount
      ,      r.rental_id
      ,      cl2.common_lookup_id AS payment_method_type
      ,      tu.payment_account_number
      ,      1001 AS created_by
      ,      TRUNC(SYSDATE) AS creation_date
      ,      1001 AS last_updated_by
      ,      TRUNC(SYSDATE) AS last_update_date
      FROM member m INNER JOIN contact c
      ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
      ON   c.first_name = tu.first_name
      AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
      AND  c.last_name = tu.last_name
      AND  tu.account_number = m.account_number INNER JOIN rental r
      ON   c.contact_id = r.customer_id
      AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
      AND  TRUNC(tu.return_date) = TRUNC(r.return_date)INNER JOIN common_lookup cl1
      ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2
ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
ON t.TRANSACTION_ACCOUNT = tu.payment_account_number
AND t.TRANSACTION_TYPE = cl1.common_lookup_id
AND t.TRANSACTION_DATE = tu.transaction_date
AND t.TRANSACTION_AMOUNT = tu.TRANSACTION_AMOUNT
AND t.PAYMENT_METHOD_type = cl2.common_lookup_id
AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
GROUP BY t.transaction_id, tu.account_number, cl1.common_lookup_id, tu.transaction_date,
r.rental_id, cl2.common_lookup_id, tu.payment_account_number;

-- ----------------------------------------------------------------------
--  Step #3 : Verify number of rows prior to insert.
-- ----------------------------------------------------------------------
SELECT   COUNT(*)
FROM     transaction;

-- ----------------------------------------------------------------------
--  Step #3 : Fix insert and insert records from query.
-- ----------------------------------------------------------------------
INSERT INTO transaction
SELECT NVL(r.transaction_id,transaction_s1.NEXTVAL) AS transaction_id
,      r.transaction_account
,      r.transaction_type
,      r.transaction_date
,      r.transaction_amount
,      r.rental_id
,      r.payment_method_type
,      r.payment_account_number
,      r.created_by
,      r.creation_date
,      r.last_updated_by
,      r.last_update_date
FROM (SELECT t.transaction_id AS transaction_id
      ,      tu.account_number AS transaction_account
      ,      cl1.common_lookup_id AS transaction_type
      ,      TRUNC(tu.transaction_date) AS transaction_date
      ,      (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
      ,      r.rental_id
      ,      cl2.common_lookup_id AS payment_method_type
      ,      tu.payment_account_number
      ,      1001 AS created_by
      ,      TRUNC(SYSDATE) AS creation_date
      ,      1001 AS last_updated_by
      ,      TRUNC(SYSDATE) AS last_update_date
      FROM member m INNER JOIN contact c
      ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
      ON   c.first_name = tu.first_name
      AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
      AND  c.last_name = tu.last_name
      AND  tu.account_number = m.account_number INNER JOIN rental r
      ON   c.contact_id = r.customer_id
      AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
      AND  TRUNC(tu.return_date) = TRUNC(r.return_date)INNER JOIN common_lookup cl1
ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2
ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
ON t.TRANSACTION_ACCOUNT = tu.payment_account_number
AND t.TRANSACTION_TYPE = cl1.common_lookup_id
AND t.TRANSACTION_DATE = tu.transaction_date
AND t.TRANSACTION_AMOUNT = tu.TRANSACTION_AMOUNT
AND t.PAYMENT_METHOD_type = cl2.common_lookup_id
AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
GROUP BY t.transaction_id, tu.account_number, cl1.common_lookup_id, tu.transaction_date,
r.rental_id, cl2.common_lookup_id, tu.payment_account_number) r;










-- ----------------------------------------------------------------------
--  Step #3 : Verify number of rows after insert.
-- ----------------------------------------------------------------------
COL transaction_count FORMAT 999,999 HEADING "Transaction|After|Count"
SELECT   COUNT(*)
FROM     transaction;

SPOOL OFF
