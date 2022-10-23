--fn_complete_order('')
DROP FUNCTION IF EXISTS fn_complete_order;
CREATE FUNCTION fn_complete_order(_c_order_id CHARACTER VARYING(32))
RETURNS NUMERIC(1)
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
DECLARE rcount INT;
BEGIN
	UPDATE c_order SET iscomplete = 'Y' WHERE c_order_id = _c_order_id;
	RETURN 1;
END
$$;