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
DECLARE order_total NUMERIC(19,10);
DECLARE payment_total NUMERIC(19,10);
DECLARE _ad_org_id  CHARACTER VARYING(32) = '';
DECLARE _ad_client_id  CHARACTER VARYING(32) = '';
DECLARE _ad_package_id  CHARACTER VARYING(32) = '';
DECLARE _fin_cashup_id CHARACTER VARYING(32) = '';
BEGIN
	/*
	SELECT fin_cashup_id INTO _fin_cashup_id FROM fin_cashup
	WHERE iscomplete <> 'Y'
	*/
	
	SELECT SUM(total) INTO order_total FROM c_order WHERE c_order_id = _c_order_id;
	SELECT SUM(amount) INTO payment_total FROM fin_payment_schedule WHERE c_order_id = _c_order_id;
	
	SELECT ad_org_id, ad_client_id INTO _ad_org_id, _ad_client_id FROM c_order WHERE c_order_id = _c_order_id;
	
	IF(order_total <> payment_total) THEN
	BEGIN
		RAISE EXCEPTION 'No se puede completar el pedido venta y pago no coinciden, venta: % pago: %', order_total, payment_total;
	END;
	END IF;
	
	/*INSERT INVENTORY*/
	INSERT INTO m_inventory(m_inventory_id, ad_org_id, ad_client_id,m_warehouse_id, m_inventorytype_id, isactive,created,createdby, 
	updated,updatedby, movementdate, documentno, number, series, comment,iscomplete, btn_complete)
	VALUES(uuid_generate_v4(), _ad_org_id, _ad_client_id);
	/*END INSERT INVENTORY*/

	UPDATE c_order SET iscomplete = 'Y' WHERE c_order_id = _c_order_id;
	
	RAISE EXCEPTION 'No se puede completar el pedido % del usuario %  venta: % pago: %', _c_order_id, _ad_user_id, order_total, payment_total;
	
	
	RETURN 1;
END
$$;