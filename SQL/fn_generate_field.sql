/*
BEGIN;
SELECT fn_generate_field('ad_table', NULL);
FETCH ALL IN "ref_table";
COMMIT;
*/
DROP FUNCTION IF EXISTS fn_generate_field;
CREATE FUNCTION fn_generate_field(_ad_tab_id CHARACTER VARYING(32), _action CHARACTER VARYING(150))
/*RETURNS SETOF refcursor*/
RETURNS NUMERIC(1) 
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
/*DECLARE ref_tab refcursor;*/
DECLARE rcount INT;
BEGIN
	/*ref_tab = 'ref_tab';
	OPEN ref_tab FOR
	SELECT * FROM ad_tab
	WHERE value = _ad_tab_id;
	RETURN NEXT ref_tab;*/
	
	SELECT COUNT(*) INTO rcount FROM ad_tab A WHERE A.ad_tab_id = _ad_tab_id;
	
	IF rcount > 0 THEN		
		INSERT INTO ad_field
		SELECT fn_get_uuid() ad_field_id,C.ad_client_id, C.ad_org_id,C.ad_column_id,
		(SELECT X.ad_field_group_id FROM ad_field_group X WHERE X.ad_org_id = C.ad_org_id AND X.ad_client_id = C.ad_client_id limit 1) ad_field_group_id,
	 	ad_tab_id,C.value,C.name,C.description,(ROW_NUMBER () OVER ())*10 "position",'Y' isactive,NOW() created,'0' createdby,NOW() updated, '0' updatedby
		FROM ad_tab A
		INNER JOIN ad_table B ON A.value = B.value 
		INNER JOIN ad_column C ON B.ad_table_id = C.ad_table_id
		WHERE A.ad_tab_id = _ad_tab_id;
	END IF;
	
	RETURN 1;
END
$$;