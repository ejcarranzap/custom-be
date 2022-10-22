--SELECT * FROM m_product
/*
SELECT fn_gen_seq('CAT','m_product_category','value');
FETCH ALL IN ref_data;
*/
DROP FUNCTION IF EXISTS fn_gen_seq;
CREATE FUNCTION fn_gen_seq(P_PREFIX CHARACTER VARYING(32), P_TABLE CHARACTER VARYING(150), P_FIELD CHARACTER VARYING(150))
/*RETURNS SETOF refcursor*/
RETURNS SETOF REFCURSOR
LANGUAGE plpgsql
VOLATILE
SECURITY INVOKER
COST 100
AS $$
	DECLARE ref_data refcursor;
BEGIN
	ref_data = 'ref_data';
	OPEN ref_data FOR
	EXECUTE 'SELECT (''' || P_PREFIX || ''' || RIGHT(''000000'' || COALESCE(MAX(REPLACE(' || P_FIELD || ',''' || P_PREFIX || ''','''')::INTEGER) + 1,1),6)) seq FROM ' 
	|| P_TABLE || ' WHERE ' || P_FIELD || ' LIKE ' || '''%' || P_PREFIX || '%''';
	RETURN NEXT ref_data;
	/*SELECT SUBSTRING(TEXT_,2) INTO RES_;
	RETURN 1;*/
END $$;