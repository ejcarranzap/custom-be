DROP FUNCTION IF EXISTS fn_get_datatype_id;
CREATE FUNCTION fn_get_datatype_id(_datatype CHARACTER VARYING(50), _len INT)
RETURNS CHARACTER VARYING(32)
LANGUAGE plpgsql
	VOLATILE
	SECURITY INVOKER
	COST 100
	AS $$
DECLARE _id CHARACTER VARYING(32);
DECLARE _type CHARACTER VARYING(50);
BEGIN	
	CASE 
	WHEN _datatype = 'timestamp' THEN _type = 'DATE';
	WHEN _datatype = 'select' THEN _type = 'SELECT';
	WHEN (_datatype = 'character varying' AND _len = 1) THEN _type = 'YESNO';
	WHEN (_datatype = 'integer') THEN _type = 'NUMBER';
	ELSE
		_type = 'TEXT';
	END CASE;
	
	SELECT ad_datatype_id INTO _id FROM ad_datatype 
	WHERE value = _type;
	
	RETURN _id;
END
$$;

DROP FUNCTION IF EXISTS fn_generate_column;
CREATE FUNCTION fn_generate_column(_ad_table_id CHARACTER VARYING(32),_action CHARACTER VARYING(150))
RETURNS SETOF refcursor
LANGUAGE plpgsql
	VOLATILE
	SECURITY INVOKER
	COST 100
	AS $$
--DECLARE ref_cols refcursor;	
BEGIN	
	--ref_cols = 'ref_cols';
	--OPEN ref_cols FOR

	WITH xTableP AS (
		SELECT ad_table_id,value "table_name",ad_client_id,ad_org_id FROM ad_table
		WHERE ad_table_id = _ad_table_id
	),
	xTable AS(
		SELECT table_name
		FROM information_schema.tables
		WHERE 1 = 1
		AND table_schema = 'public'		
		AND table_catalog = 'test'
	),
	xColumn AS (
		SELECT table_name,column_name,data_type,character_maximum_length,numeric_precision,numeric_scale 
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE 1 = 1 
		AND TABLE_SCHEMA = 'public' 
		AND table_catalog = 'test'
		AND column_name NOT IN('updated','created','updatedby','createdby')
		--AND column_name IN('position')
	),
	xConstraint AS (
		SELECT tc.constraint_name,
		tc.constraint_type,
		tc.table_name table_nameo,
		kcu.column_name column_nameo,
		tc.is_deferrable,
		tc.initially_deferred,
		rc.match_option AS match_type,
		rc.update_rule AS on_update,
		rc.delete_rule AS on_delete,
		ccu.table_name AS references_table,
		ccu.column_name AS references_field
		FROM information_schema.table_constraints tc
		LEFT JOIN information_schema.key_column_usage kcu
		ON tc.constraint_catalog = kcu.constraint_catalog
		AND tc.constraint_schema = kcu.constraint_schema
		AND tc.constraint_name = kcu.constraint_name
		LEFT JOIN information_schema.referential_constraints rc
		ON tc.constraint_catalog = rc.constraint_catalog
		AND tc.constraint_schema = rc.constraint_schema
		AND tc.constraint_name = rc.constraint_name
		LEFT JOIN information_schema.constraint_column_usage ccu
		ON rc.unique_constraint_catalog = ccu.constraint_catalog
		AND rc.unique_constraint_schema = ccu.constraint_schema
		AND rc.unique_constraint_name = ccu.constraint_name
		WHERE 1 = 1
		AND tc.constraint_type NOT IN('CHECK','UNIQUE')
		AND tc.constraint_schema IN('public')
	)
		
	INSERT INTO ad_column
	SELECT 
	fn_get_uuid() ad_column_id,
	A.ad_client_id,
	A.ad_org_id,
	_ad_table_id ad_table_id,	
	fn_get_datatype_id(CASE WHEN C.constraint_type = 'FOREIGN KEY' THEN 'select' ELSE B.data_type END, B.character_maximum_length) ad_datatype_id,
	B.column_name "value",
	B.column_name "name",
	B.column_name "description",
	'' "action",
	CASE WHEN C.constraint_type = 'PRIMARY KEY' THEN 'Y' ELSE 'N' END ispk,
	CASE WHEN C.constraint_type = 'FOREIGN KEY' THEN 'Y' ELSE 'N' END isfk,
	C.references_table ref_table,
	C.references_field ref_table_key_field,
	CASE WHEN C.constraint_type = 'FOREIGN KEY' THEN 'name' ELSE NULL END ref_table_text_field,
	NULL icon,
	'Y' isactive,
	NOW() created,
	'0' createdby,
	NOW() updated,
	'0' updatedby/*,
	C.**/
	FROM xTableP A
	INNER JOIN xColumn B ON A.table_name = B.table_name
	LEFT JOIN xConstraint C ON B.table_name = C.table_nameo AND B.column_name = C.column_nameo;
			
	--RETURN NEXT ref_cols;	
END
$$;