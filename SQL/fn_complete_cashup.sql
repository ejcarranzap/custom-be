DROP FUNCTION IF EXISTS fn_complete_cashup;
CREATE FUNCTION fn_complete_cashup(_fin_cashup_id CHARACTER VARYING(32), _ad_user_id CHARACTER VARYING(32), _m_warehouse_id CHARACTER VARYING(32))
RETURNS NUMERIC(1)
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
DECLARE rcount INT;
BEGIN

UPDATE fin_cashup SET iscomplete = 'Y' WHERE fin_cashup_id = _fin_cashup_id;

RETURN 1;
END
$$;