--fn_complete_order('')
DROP FUNCTION IF EXISTS fn_complete_order;
CREATE FUNCTION fn_complete_order(_c_order_id CHARACTER VARYING(32), _ad_user_id CHARACTER VARYING(32), _m_warehouse_id CHARACTER VARYING(32))
RETURNS NUMERIC(1)
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
DECLARE rcount INT;
DECLARE order_total NUMERIC(19,10);
DECLARE payment_total NUMERIC(19,10);
DECLARE _m_inventory_id  CHARACTER VARYING(32) = '';
DECLARE _ad_org_id  CHARACTER VARYING(32) = '';
DECLARE _ad_client_id  CHARACTER VARYING(32) = '';
DECLARE _ad_package_id  CHARACTER VARYING(32) = '';
DECLARE _fin_cashup_id CHARACTER VARYING(32) = '';
DECLARE _m_inventorytype_id CHARACTER VARYING(32) = '';
DECLARE _fin_cashupmtype_id CHARACTER VARYING(32) = '';
DECLARE _c_location_id CHARACTER VARYING(32) = '';
DECLARE _documentnoInv  CHARACTER VARYING(50) = '';
DECLARE _description  CHARACTER VARYING(50) = '';
DECLARE ref_data REFCURSOR;
DECLARE reg RECORD;
    	cur_lines CURSOR FOR SELECT * FROM c_orderline WHERE c_order_id = _c_order_id;
		cur_paylines CURSOR FOR SELECT * FROM fin_payment_schedule WHERE c_order_id = _c_order_id;
BEGIN
	ref_data := 'ref_data';
	/*
	SELECT fin_cashup_id INTO _fin_cashup_id FROM fin_cashup
	WHERE iscomplete <> 'Y'
	*/
	_description := 'purchase order';
	
	IF EXISTS(SELECT 0 FROM c_order A  WHERE A.c_order_id = _c_order_id AND A.issotrx = 'Y') THEN
	BEGIN
		_description := 'sales order';
	END;
	END IF;
	
	SELECT COALESCE(SUM(total),0.0) INTO order_total FROM c_order WHERE c_order_id = _c_order_id;
	SELECT COALESCE(SUM(amount-outstanding),0.0) INTO payment_total FROM fin_payment_schedule WHERE c_order_id = _c_order_id;
	
	IF(order_total <> payment_total) THEN
	BEGIN
		RAISE EXCEPTION 'No se puede completar el pedido y pago no coinciden, pedido: % pago: %', ROUND(order_total,4), ROUND(payment_total,4);
	END;
	END IF;
	
	SELECT ad_org_id, ad_client_id INTO _ad_org_id, _ad_client_id FROM c_order WHERE c_order_id = _c_order_id;
	
	SELECT m_inventorytype_id INTO _m_inventorytype_id FROM m_inventorytype WHERE name LIKE '%IN%';	
	
	IF EXISTS(SELECT 0 FROM c_order A  WHERE A.c_order_id = _c_order_id AND A.issotrx = 'Y') THEN
	BEGIN
		SELECT m_inventorytype_id INTO _m_inventorytype_id FROM m_inventorytype WHERE name LIKE '%OUT%';	
	END;
	END IF;
	
	SELECT c_location_id INTO _c_location_id FROM c_location WHERE name LIKE '%DEF%';
	
	SELECT fn_get_uuid() INTO _m_inventory_id;
	
	PERFORM fn_gen_seq('INV-','m_inventory','documentno');
	FETCH NEXT FROM ref_data INTO _documentnoInv;	
	
	/*INSERT INVENTORY*/
	INSERT INTO m_inventory(m_inventory_id, ad_org_id, ad_client_id,m_warehouse_id, m_inventorytype_id, isactive,created,createdby, 
	updated,updatedby, movementdate, documentno, number, series, comment,iscomplete, btn_complete, reference)
	SELECT _m_inventory_id, _ad_org_id, _ad_client_id, _m_warehouse_id, _m_inventorytype_id, 'Y',NOW(),_ad_user_id,
	NOW(),_ad_user_id,NOW(),_documentnoInv,'', '','Inventory from ' || _description,'N','Y',_c_order_id;
	/*END INSERT INVENTORY*/
	
	OPEN cur_lines;
   	FETCH cur_lines INTO reg;
  	WHILE( FOUND ) LOOP
    	INSERT INTO m_inventoryline(m_inventoryline_id,m_inventory_id,ad_org_id,ad_client_id,m_product_id,reference,c_uom_id,c_location_id,
		c_locationto,isactive,created,createdby,updated,updatedby,qty,cost,price)
		SELECT fn_get_uuid(),_m_inventory_id,_ad_org_id,_ad_client_id,reg.m_product_id,_c_order_id,reg.c_uom_id,
		_c_location_id,_c_location_id,'Y',NOW(),_ad_user_id,NOW(),_ad_user_id,reg.qty,reg.cost,reg.price;
    	FETCH cur_lines INTO reg;
   	END LOOP;
	
	SELECT fin_cashup_id INTO _fin_cashup_id FROM fin_cashup WHERE createdby = _ad_user_id AND isactive = 'Y';
	
	SELECT fin_cashupmtype_id INTO _fin_cashupmtype_id FROM fin_cashupmtype WHERE NAME LIKE '%COMPRA%';
	
	IF EXISTS(SELECT 0 FROM c_order A  WHERE A.c_order_id = _c_order_id AND A.issotrx = 'Y') THEN
	BEGIN
		SELECT fin_cashupmtype_id INTO _fin_cashupmtype_id FROM fin_cashupmtype WHERE NAME LIKE '%VENTA%';
	END;
	END IF;
	
	OPEN cur_paylines;
   	FETCH cur_paylines INTO reg;
  	WHILE( FOUND ) LOOP
    	INSERT INTO fin_cashupline(fin_cashupline_id,fin_cashup_id,fin_cashupmtype_id,fin_paymentmethod_id,ad_org_id,ad_client_id,reference,
		isactive,created,createdby,updated,updatedby,amount,comment)
		SELECT fn_get_uuid(),_fin_cashup_id,_fin_cashupmtype_id,reg.fin_paymentmethod_id,reg.ad_org_id,reg.ad_client_id,_c_order_id,
		'Y',NOW(),_ad_user_id,NOW(),_ad_user_id,reg.amount,'Payment from ' || _description;
		
    	FETCH cur_paylines INTO reg;
   	END LOOP;		
	
	PERFORM fn_complete_inventory(_m_inventory_id,_ad_user_id,_m_warehouse_id);

	UPDATE c_order SET iscomplete = 'Y' WHERE c_order_id = _c_order_id;
	
	RETURN 1;
END
$$;