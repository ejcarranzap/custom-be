--fn_complete_order('')
DROP FUNCTION IF EXISTS fn_complete_order;
CREATE FUNCTION fn_complete_order(_c_order_id CHARACTER VARYING(32), _ad_user_id CHARACTER VARYING(32))
RETURNS NUMERIC(1)
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
DECLARE rcount INT;
DECLARE _fin_cashup_id CHARACTER VARYING(32) = '';
BEGIN
	/*
	SELECT fin_cashup_id INTO _fin_cashup_id FROM fin_cashup
	WHERE iscomplete <> 'Y'
	*/

	UPDATE c_order SET iscomplete = 'Y' WHERE c_order_id = _c_order_id;
	
	RAISE EXCEPTION 'No se puede completar el pedido % del usuario %', _c_order_id, _ad_user_id;
	
	
	RETURN 1;
END
$$;