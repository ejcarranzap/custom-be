SELECT * FROM ad_tab WHERE value = 'fin_cashupline'
SELECT * FROM ad_field WHERE ad_tab_id = '203bcbdbd73b4fec865b9874473ef5bc'
ORDER BY position


SELECT * FROM fin_cashup
ALTER TABLE fin_cashup ADD number CHARACTER VARYING(32)
ALTER TABLE fin_cashup ALTER COLUMN series DROP NOT NULL;
ALTER TABLE fin_cashup ALTER COLUMN number DROP NOT NULL;
ALTER TABLE fin_cashup ADD closeddate TIMESTAMP 

ALTER TABLE fin_cashupline ALTER COLUMN reference DROP NOT NULL;

SELECT * FROM fin_cashupmtype;


ALTER TABLE fin_cashupmtype ADD sign CHARACTER VARYING(1)