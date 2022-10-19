--SELECT fn_generate_all_table();
DROP FUNCTION IF EXISTS fn_generate_all_table;
CREATE FUNCTION fn_generate_all_table()
RETURNS numeric(1)
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
DECLARE ref_table refcursor;
DECLARE msg CHARACTER VARYING(255);
DECLARE _UUID CHARACTER VARYING(32);
DECLARE _UUIDW CHARACTER VARYING(32);
DECLARE _UUIDM CHARACTER VARYING(32);
DECLARE _UUIDT CHARACTER VARYING(32);
BEGIN	
	DECLARE ref_table CURSOR FOR
	SELECT table_name
	FROM information_schema.tables
	WHERE 1 = 1
	AND table_schema = 'public'
	/*AND table_name = COALESCE(_table_name,table_name)*/
	AND table_name IN('c_uom')
	/*AND table_name IN('ad_menu')*/
	ORDER BY table_name;
	record_cur RECORD;

	BEGIN
		OPEN ref_table;
		LOOP
			FETCH ref_table INTO record_cur;
			IF NOT FOUND THEN
				EXIT;
		   	END IF;

			RAISE NOTICE '%',record_cur.table_name;
			
			IF NOT EXISTS(SELECT 0 FROM ad_table WHERE value = record_cur.table_name) THEN
			BEGIN			
				_UUID := fn_get_uuid();
				_UUIDW := fn_get_uuid();
				_UUIDM := fn_get_uuid();
				_UUIDT := fn_get_uuid();
				INSERT INTO ad_table VALUES(_UUID,'0','0','0',record_cur.table_name, 'Name: ' || record_cur.table_name,'Dscription: ' || record_cur.table_name,'Y','Y',NOW(),'0',NOW(),'0');
				PERFORM fn_generate_column(_UUID,'GETCOL');
				
				INSERT INTO ad_window VALUES(_UUIDW,'0','0',record_cur.table_name,'Win Name: ' || record_cur.table_name,'Win Description: ' || record_cur.table_name,'Y',NOW(),'0',NOW(),'0');
				INSERT INTO ad_menu VALUES(_UUIDM,'0','0','0',_UUIDW,record_cur.table_name,'Menu' || record_cur.table_name,'Menu Description: ' || record_cur.table_name,'Y',NOW(),'0',NOW(),'0');
				INSERT INTO ad_tab VALUES(_UUIDT,'0','0',_UUIDW,NULL,record_cur.table_name,'Tab: ' || record_cur.table_name,'Tab Description: ' || record_cur.table_name,10,'Y','Y',NOW(),'0',NOW(),'0');
				PERFORM fn_generate_field(_UUIDT,'GETFIELD');
			END;			
			END IF;

		END LOOP;	
		CLOSE ref_table;
	END;
	
	RETURN 1;	
END $$

