DROP FUNCTION IF EXISTS fn_complete_inventory;
CREATE FUNCTION fn_complete_inventory(_m_inventory_id CHARACTER VARYING(32), _ad_user_id CHARACTER VARYING(32), _m_warehouse_id CHARACTER VARYING(32))
RETURNS NUMERIC(1)
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
BEGIN

	IF (
		SELECT B.name FROM m_inventory A 
		INNER JOIN m_inventorytype B ON A.m_inventorytype_id = B.m_inventorytype_id 
		AND A.m_inventory_id = _m_inventory_id
	) IN('IN') THEN
	BEGIN
		WITH lines AS (
			SELECT A.m_warehouse_id,B.m_product_id,SUM(B.qty) qty FROM m_inventory A
			INNER JOIN m_inventoryline B ON A.m_inventory_id = B.m_inventory_id
			WHERE 1 = 1
			AND A.m_inventory_id = _m_inventory_id
			GROUP BY A.m_warehouse_id,B.m_product_id
		)
	
		UPDATE m_warehouse_stock
		SET qty = qty + (
			SELECT SUM(qty) FROM lines
			WHERE 1 = 1
			AND m_warehouse_stock.m_warehouse_id = lines.m_warehouse_id
			AND m_warehouse_stock.m_product_id = lines.m_product_id
		);
		
	END;
	END IF;
	
	IF (
		SELECT B.name FROM m_inventory A 
		INNER JOIN m_inventorytype B ON A.m_inventorytype_id = B.m_inventorytype_id 
		AND A.m_inventory_id = _m_inventory_id
	) IN('OUT') THEN
	BEGIN
		WITH lines AS (
			SELECT A.m_warehouse_id,B.m_product_id,SUM(B.qty) qty FROM m_inventory A
			INNER JOIN m_inventoryline B ON A.m_inventory_id = B.m_inventory_id
			WHERE 1 = 1
			AND A.m_inventory_id = _m_inventory_id
			GROUP BY A.m_warehouse_id,B.m_product_id
		)
	
		UPDATE m_warehouse_stock
		SET qty = qty - (
			SELECT SUM(qty) FROM lines
			WHERE 1 = 1
			AND m_warehouse_stock.m_warehouse_id = lines.m_warehouse_id
			AND m_warehouse_stock.m_product_id = lines.m_product_id
		);
		
	END;
	END IF;
	
	UPDATE m_inventory SET iscomplete = 'Y' WHERE m_inventory_id =  _m_inventory_id;
	
	RETURN 1;
END
$$;