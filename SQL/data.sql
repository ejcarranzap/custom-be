SELECT NOW();
ALTER DATABASE test SET timezone TO 'UTC-6';
ALTER USER "admin" SET timezone TO 'UTC-6';
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT crypt('car', gen_salt('MD5'));

DROP FUNCTION IF EXISTS fn_get_table_data;
CREATE FUNCTION fn_get_table_data(_table_name CHARACTER VARYING(150),_action CHARACTER VARYING(150))
RETURNS SETOF refcursor
LANGUAGE plpgsql
	VOLATILE
	SECURITY INVOKER
	COST 100
	AS $$
DECLARE ref_table refcursor;
DECLARE ref_column refcursor;
DECLARE ref_constraint refcursor;
BEGIN
	ref_table = 'ref_table';
	OPEN ref_table FOR
	SELECT table_name
	FROM information_schema.tables
	WHERE 1 = 1
	AND table_schema = 'public'
	AND table_name = COALESCE(_table_name,table_name)
	AND table_name NOT IN('User')
	ORDER BY table_name;		
	RETURN NEXT ref_table;
	
	IF _action <> 'ONLY_TABLE' THEN		
		ref_column = 'ref_column';
		OPEN ref_column FOR
		SELECT table_name,column_name,data_type,character_maximum_length,numeric_precision,numeric_scale 
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE 1 = 1 
		AND TABLE_SCHEMA = 'public' 
		AND table_catalog = 'test'
		AND table_name = COALESCE(_table_name,table_name)
		ORDER BY table_name,ordinal_position;
		RETURN NEXT ref_column;

		ref_constraint = 'ref_constraint';
		OPEN ref_constraint FOR
		SELECT tc.constraint_name,
		tc.constraint_type,
		tc.table_name,
		kcu.column_name,
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
		AND tc.table_name = COALESCE(_table_name,tc.table_name)
		ORDER BY tc.table_name,kcu.column_name;
		RETURN NEXT ref_constraint;
	END IF;
END
$$;

DROP FUNCTION IF EXISTS fn_get_uuid;
CREATE FUNCTION fn_get_uuid()
RETURNS CHARACTER VARYING(32)
LANGUAGE plpgsql
	VOLATILE 
	SECURITY INVOKER
	COST 100
	AS $$
DECLARE _GUID CHARACTER VARYING(32);
BEGIN 
	_GUID := REPLACE(uuid_generate_v4()::TEXT,'-','');
	RETURN _GUID;
END
$$;

DO $$

DECLARE _UUID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUIDMNU CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUIDW CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUIDT CHARACTER VARYING(32) := fn_get_uuid();

/*TYPES*/
DECLARE _UUID_TEXT CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_NUMBER CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_SELECT CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_YESNO CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_PASSWORD CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_EMAIL CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_DATE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_IMAGE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_BUTTON CHARACTER VARYING(32) := fn_get_uuid();
/*TYPES*/

/*COLUMNS*/
DECLARE _UUID_COL_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_ID_CLIENT CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_ID_ORG CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_VALUE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_NAME CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_PASSWORD CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_ISACTIVE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_EMAIL CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_FIRST_NAME CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_LAST_NAME CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_PHONE_NUMBER CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_BIRTH_DATE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_IMAGE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_DEVICE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_DEVICE_MODEL CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_SO CHARACTER VARYING(32) := fn_get_uuid();
DECLARE _UUID_COL_SO_VERSION CHARACTER VARYING(32) := fn_get_uuid();
/*COLUMNS*/

/*FIELD GROUP*/
DECLARE _UUID_FIELD_GROUP_GENERAL CHARACTER VARYING(32) := fn_get_uuid();
/*FIELDS GROUP*/


/*COLUMNS TABLE ad_table*/
DECLARE AT_UUIDT CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUIDMNU CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUIDW CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_AD_CLIENT_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_AD_ORG_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_AD_PACKAGE_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_VALUE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_NAME CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_DESCRIPTION CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_ISACTIVE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AT_UUID_COL_BTN_GETCOL CHARACTER VARYING(32) := fn_get_uuid();
/*END COLUMNS TABLE ad_table*/

/*COLUMNS TABLE ad_column*/
DECLARE AC_UUIDT CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUIDMNU CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUIDW CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_AD_CLIENT_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_AD_ORG_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_AD_TABLE_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_AD_DATATYPE_ID CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_VALUE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_NAME CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_DESCRIPTION CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_ISPK CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_ISFK CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_REF_TABLE CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_REF_TABLE_KEY_FIELD CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_REF_TABLE_TEXT_FIELD CHARACTER VARYING(32) := fn_get_uuid();
DECLARE AC_UUID_COL_ISACTIVE CHARACTER VARYING(32) := fn_get_uuid();
/*END COLUMNS TABLE ad_column*/

BEGIN

DROP TABLE IF EXISTS ad_org CASCADE;
CREATE TABLE ad_org(
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_org_key PRIMARY KEY(ad_org_id)
);
ALTER TABLE ad_org OWNER TO admin;
INSERT INTO ad_org VALUES('0','0','0','*','Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_client CASCADE;
CREATE TABLE ad_client(
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_client_key PRIMARY KEY(ad_client_id)
);
ALTER TABLE ad_client OWNER TO admin;
INSERT INTO ad_client VALUES('0','0','SYSTEM','System','Y',NOW(),'0',NOW(),'0');

ALTER TABLE ad_org ADD CONSTRAINT ad_org_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE ad_client ADD CONSTRAINT ad_client_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;

DROP TABLE IF EXISTS ad_user CASCADE;
CREATE TABLE ad_user(
	ad_user_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	password CHARACTER VARYING(150) NOT NULL,
	email CHARACTER VARYING(50) NULL,
	first_name CHARACTER VARYING(50) NULL,
	last_name CHARACTER VARYING(50) NULL,
	phone_number CHARACTER VARYING(50) NULL,
	birth_date TIMESTAMP NULL,
	image CHARACTER VARYING(255) NULL,
	device CHARACTER VARYING(32) NULL,
	device_model CHARACTER VARYING(50) NULL,
	so CHARACTER VARYING(50) NULL,
	so_version CHARACTER VARYING(20) NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_user_key PRIMARY KEY(ad_user_id),
	CONSTRAINT ad_user_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_user_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_user OWNER TO admin;
INSERT INTO ad_user VALUES('0','0','0','U00001','admin','$2a$10$ailMVjeYYsDs9YZ3t6ujG.KqbvVDXzaJNZR4Q.KXo8SWyCiSJsqN2','ejcarranzap@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
						   'Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_module CASCADE;
CREATE TABLE ad_module(
	ad_module_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_module_key PRIMARY KEY(ad_module_id),
	CONSTRAINT ad_module_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_module_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_module OWNER TO admin;
INSERT INTO ad_module VALUES('0','0','0','M00001','Core','Core Module','Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_package CASCADE;
CREATE TABLE ad_package(
	ad_package_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_module_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_package_key PRIMARY KEY(ad_package_id),
	CONSTRAINT ad_package_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_package_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_package_ad_module FOREIGN KEY(ad_module_id) REFERENCES ad_module(ad_module_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_package OWNER TO admin;
INSERT INTO ad_package VALUES('0','0','0','0','PKG001','Core Pkg','Core Pkg','Y',NOW(),'0',NOW(),'0');


DROP TABLE IF EXISTS ad_table CASCADE;
CREATE TABLE ad_table(
	ad_table_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_package_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	btn_getcol CHARACTER VARYING(1), 
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_table_key PRIMARY KEY(ad_table_id),
	CONSTRAINT ad_table_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_table_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_table_ad_package FOREIGN KEY(ad_package_id) REFERENCES ad_package(ad_package_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_table OWNER TO admin;
INSERT INTO ad_table VALUES(_UUID,'0','0','0','ad_user','Usuario','Catalogo de Usuarios','Y','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_table VALUES(AT_UUID,'0','0','0','ad_table','Tabla','Catalogo de Tablas','Y','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_table VALUES(AC_UUID,'0','0','0','ad_column','Columna','Catalogo de Columnas','Y','Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_datatype CASCADE;
CREATE TABLE ad_datatype(
	ad_datatype_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_datatype_key PRIMARY KEY(ad_datatype_id),
	CONSTRAINT ad_datatype_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_datatype_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_datatype_unique UNIQUE(value)
);
ALTER TABLE ad_datatype OWNER TO admin;
INSERT INTO ad_datatype VALUES(_UUID_TEXT,'0','0','TEXT','TEXT','TEXT','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_NUMBER,'0','0','NUMBER','NUMBER','NUMBER','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_SELECT,'0','0','SELECT','SELECT','SELECT','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_YESNO,'0','0','YESNO','YESNO','YESNO','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_PASSWORD,'0','0','PASSWORD','PASSWORD','PASSWORD','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_EMAIL,'0','0','EMAIL','EMAIL','EMAIL','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_DATE,'0','0','DATE','DATE','DATE','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_IMAGE,'0','0','IMAGE','IMAGE','IMAGE','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_datatype VALUES(_UUID_BUTTON,'0','0','BUTTON','BUTTON','BUTTON','Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_column CASCADE;
CREATE TABLE ad_column(
	ad_column_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_table_id CHARACTER VARYING(32) NOT NULL,
	ad_datatype_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	action VARCHAR(50) NULL,
	ispk CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	isfk CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	ref_table CHARACTER VARYING(50),
	ref_table_key_field CHARACTER VARYING(50),
	ref_table_text_field CHARACTER VARYING(50),
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_column_key PRIMARY KEY(ad_column_id),
	CONSTRAINT ad_column_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_column_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_column_ad_table FOREIGN KEY(ad_table_id) REFERENCES ad_table(ad_table_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_column_ad_datatype FOREIGN KEY(ad_datatype_id) REFERENCES ad_datatype(ad_datatype_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_column_unique UNIQUE(ad_table_id,value)
);
ALTER TABLE ad_column OWNER TO admin;
INSERT INTO ad_column VALUES(_UUID_COL_ID,'0','0',_UUID,_UUID_TEXT,'ad_user_id','ID','ID user',NULL,'Y','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_ID_CLIENT,'0','0',_UUID,_UUID_SELECT,'ad_client_id','ID client','ID client',NULL,'N','Y','ad_client','ad_client_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_ID_ORG,'0','0',_UUID,_UUID_SELECT,'ad_org_id','ID org','ID org',NULL,'N','Y','ad_org','ad_org_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_VALUE,'0','0',_UUID,_UUID_TEXT,'value','Code','Code',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_NAME,'0','0',_UUID,_UUID_TEXT,'name','Name','Name',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_PASSWORD,'0','0',_UUID,_UUID_PASSWORD,'password','Password','Password',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_ISACTIVE,'0','0',_UUID,_UUID_YESNO,'isactive','IsActive','IsActive',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');

/**/
INSERT INTO ad_column VALUES(_UUID_COL_EMAIL,'0','0',_UUID,_UUID_EMAIL,'email','Email','Email',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_FIRST_NAME,'0','0',_UUID,_UUID_TEXT,'first_name','First Name','First Name',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_LAST_NAME,'0','0',_UUID,_UUID_TEXT,'last_name','Last Name','Last Name',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_PHONE_NUMBER,'0','0',_UUID,_UUID_TEXT,'phone_number','Phone Number','Phone Number',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_BIRTH_DATE,'0','0',_UUID,_UUID_DATE,'birth_date','Birth Date','Birth Date',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_IMAGE,'0','0',_UUID,_UUID_IMAGE,'image','Image','Image',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_DEVICE,'0','0',_UUID,_UUID_TEXT,'device','Device','Device',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_DEVICE_MODEL,'0','0',_UUID,_UUID_TEXT,'device_model','Device Model','Device Model',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_SO,'0','0',_UUID,_UUID_TEXT,'so','SO','SO',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(_UUID_COL_SO_VERSION,'0','0',_UUID,_UUID_TEXT,'so_version','SO VERSION','SO VERSION',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
/**/


/*AT_COLUMNS*/
INSERT INTO ad_column VALUES(AT_UUID_COL_ID,'0','0',AT_UUID,_UUID_TEXT,'ad_table_id','ID','ID table',NULL,'Y','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_AD_CLIENT_ID,'0','0',AT_UUID,_UUID_SELECT,'ad_client_id','ID client','ID client',NULL,'N','Y','ad_client','ad_client_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_AD_ORG_ID,'0','0',AT_UUID,_UUID_SELECT,'ad_org_id','ID org','ID org',NULL,'N','Y','ad_org','ad_org_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_AD_PACKAGE_ID,'0','0',AT_UUID,_UUID_SELECT,'ad_package_id','ID package','ID package',NULL,'N','Y','ad_package','ad_package_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_VALUE,'0','0',AT_UUID,_UUID_TEXT,'value','Code','Code',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_NAME,'0','0',AT_UUID,_UUID_TEXT,'name','Name','Name',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_DESCRIPTION,'0','0',AT_UUID,_UUID_TEXT,'description','Description','Description',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_ISACTIVE,'0','0',AT_UUID,_UUID_YESNO,'isactive','IsActive','IsActive',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AT_UUID_COL_BTN_GETCOL,'0','0',AT_UUID,_UUID_BUTTON,'btn_getcol','Get Columns','Get Columns','getColumnService','N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
/*AT_COLUMNS*/

/*AC_COLUMNS*/
INSERT INTO ad_column VALUES(AC_UUID_COL_ID,'0','0',AC_UUID,_UUID_TEXT,'ad_column_id','ID','ID column',NULL,'Y','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_AD_CLIENT_ID,'0','0',AC_UUID,_UUID_SELECT,'ad_client_id','ID client','ID client',NULL,'N','Y','ad_client','ad_client_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_AD_ORG_ID,'0','0',AC_UUID,_UUID_SELECT,'ad_org_id','ID org','ID org',NULL,'N','Y','ad_org','ad_org_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_AD_TABLE_ID,'0','0',AC_UUID,_UUID_SELECT,'ad_table_id','ID table','ID table',NULL,'N','Y','ad_table','ad_table_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_AD_DATATYPE_ID,'0','0',AC_UUID,_UUID_SELECT,'ad_datatype_id','ID datatype','ID datatype',NULL,'N','Y','ad_datatype','ad_datatype_id','name','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_VALUE,'0','0',AC_UUID,_UUID_TEXT,'value','Code','Code',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_NAME,'0','0',AC_UUID,_UUID_TEXT,'name','Name','Name',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_DESCRIPTION,'0','0',AC_UUID,_UUID_TEXT,'description','Description','Description',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_ISPK,'0','0',AC_UUID,_UUID_YESNO,'ispk','IsPK','IsPK',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_ISFK,'0','0',AC_UUID,_UUID_YESNO,'isfk','IsFK','IsFK',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_REF_TABLE,'0','0',AC_UUID,_UUID_TEXT,'ref_table','Ref Table','Ref Table',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_REF_TABLE_KEY_FIELD,'0','0',AC_UUID,_UUID_TEXT,'table_ref_key_field','Ref Key Field','Ref Key Field',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_REF_TABLE_TEXT_FIELD,'0','0',AC_UUID,_UUID_TEXT,'table_ref_text_field','Ref Text Field','Ref Text Field',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_column VALUES(AC_UUID_COL_ISACTIVE,'0','0',AC_UUID,_UUID_YESNO,'isactive','IsActive','IsActive',NULL,'N','N',NULL,NULL,NULL,'Y',NOW(),'0',NOW(),'0');
/*AC_COLUMNS*/

DROP TABLE IF EXISTS ad_window CASCADE;
CREATE TABLE ad_window(
	ad_window_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_window_key PRIMARY KEY(ad_window_id),
	CONSTRAINT ad_window_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_window_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE ad_window OWNER TO admin;
INSERT INTO ad_window VALUES(_UUIDW,'0','0','ad_user','Usuario','Catalogo de Usuarios','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_window VALUES(AT_UUIDW,'0','0','ad_table','Tabla','Catalogo de Tablas','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_window VALUES(AC_UUIDW,'0','0','ad_column','Columna','Catalogo de Columnas','Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_menu CASCADE;
CREATE TABLE ad_menu(
	ad_menu_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	parent CHARACTER VARYING(32) NULL,
	ad_window_id CHARACTER VARYING(32) NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_menu_key PRIMARY KEY(ad_menu_id),
	CONSTRAINT ad_menu_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_menu_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO ad_menu VALUES('0','0','0',NULL,NULL,'root','Menu','Menu principal','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_menu VALUES(_UUIDMNU,'0','0','0',_UUIDW,'ad_user','Usuario','Catalogo de Usuarios','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_menu VALUES(AT_UUIDMNU,'0','0','0',AT_UUIDW,'ad_table','Tabla','Catalogo de Tablas','Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_menu VALUES(AC_UUIDMNU,'0','0','0',AC_UUIDW,'ad_column','Columna','Catalogo de Columnas','Y',NOW(),'0',NOW(),'0');


DROP TABLE IF EXISTS ad_tab CASCADE;
CREATE TABLE ad_tab(
	ad_tab_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_window_id CHARACTER VARYING(32) NOT NULL,	
	ad_tab_parent_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,	
	description VARCHAR(255) NOT NULL,
	position INT NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_tab_key PRIMARY KEY(ad_tab_id),
	CONSTRAINT ad_tab_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_tab_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_tab_ad_window FOREIGN KEY(ad_window_id) REFERENCES ad_window(ad_window_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_tab_ad_tab_parent FOREIGN KEY(ad_tab_parent_id) REFERENCES ad_tab(ad_tab_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_tab OWNER TO admin;
INSERT INTO ad_tab VALUES(_UUIDT,'0','0',_UUIDW,_UUIDT,'ad_user','Usuario','Datos Generales',0,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_tab VALUES(AT_UUIDT,'0','0',AT_UUIDW,AT_UUIDT,'ad_table','Tabla','Datos Tabla',0,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_tab VALUES(AC_UUIDT,'0','0',AT_UUIDW,AT_UUIDT,'ad_column','Columna','Datos Columna',0,'Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_field_group CASCADE;
CREATE TABLE ad_field_group(
	ad_field_group_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_field_group_key PRIMARY KEY(ad_field_group_id),
	CONSTRAINT ad_field_group_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_field_group_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_field_group OWNER TO admin;
INSERT INTO ad_field_group VALUES(_UUID_FIELD_GROUP_GENERAL,'0','0','General','General','Datos Generales','Y',NOW(),'0',NOW(),'0');

DROP TABLE IF EXISTS ad_field CASCADE;
CREATE TABLE ad_field(
	ad_field_id CHARACTER VARYING(32) NOT NULL,	
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_column_id CHARACTER VARYING(32) NOT NULL,
	ad_field_group_id CHARACTER VARYING(32) NOT NULL,
	ad_tab_id CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	description VARCHAR(255) NOT NULL,
	position INT NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	CONSTRAINT ad_field_key PRIMARY KEY(ad_field_id),
	CONSTRAINT ad_field_ad_client FOREIGN KEY(ad_client_id) REFERENCES ad_client(ad_client_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_field_ad_org FOREIGN KEY(ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_field_ad_column FOREIGN KEY(ad_column_id) REFERENCES ad_column(ad_column_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_field_ad_field_group FOREIGN KEY(ad_field_group_id) REFERENCES ad_field_group(ad_field_group_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_field_ad_tab FOREIGN KEY(ad_tab_id) REFERENCES ad_tab(ad_tab_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE ad_field OWNER TO admin;
INSERT INTO ad_field VALUES(_UUID_COL_ID,'0','0',_UUID_COL_ID,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'ad_user_id','ID','ID user',10,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_ID_CLIENT,'0','0',_UUID_COL_ID_CLIENT,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'ad_client_id','ID client','ID client',20,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_ID_ORG,'0','0',_UUID_COL_ID_ORG,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'ad_org_id','ID org','ID org',30,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_VALUE,'0','0',_UUID_COL_VALUE,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'value','Code','Code',40,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_NAME,'0','0',_UUID_COL_NAME,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'name','Name','Name',50,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_PASSWORD,'0','0',_UUID_COL_PASSWORD,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'password','Password','Password',60,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_ISACTIVE,'0','0',_UUID_COL_ISACTIVE,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'isactive','IsActive','IsActive',70,'Y',NOW(),'0',NOW(),'0');

/**/
INSERT INTO ad_field VALUES(_UUID_COL_EMAIL,'0','0',_UUID_COL_EMAIL,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'email','Email','Email',80,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_FIRST_NAME,'0','0',_UUID_COL_FIRST_NAME,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'first_name','First Name','First Name',90,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_LAST_NAME,'0','0',_UUID_COL_LAST_NAME,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'last_name','Last Name','Last Name',100,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_PHONE_NUMBER,'0','0',_UUID_COL_PHONE_NUMBER,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'phone_number','Phone Number','Phone Number',110,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_BIRTH_DATE,'0','0',_UUID_COL_BIRTH_DATE,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'birth_date','Birth Date','Birth Date',120,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_IMAGE,'0','0',_UUID_COL_IMAGE,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'image','Image','Image',130,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_DEVICE,'0','0',_UUID_COL_DEVICE,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'device','Device','Device',140,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_DEVICE_MODEL,'0','0',_UUID_COL_DEVICE_MODEL,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'device_model','Device Model','Device Model',150,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_SO,'0','0',_UUID_COL_SO,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'so','SO','SO',160,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(_UUID_COL_SO_VERSION,'0','0',_UUID_COL_SO_VERSION,_UUID_FIELD_GROUP_GENERAL,_UUIDT,'so_version','SO Version','SO Version',170,'Y',NOW(),'0',NOW(),'0');
/**/

/*AT FIELD*/
INSERT INTO ad_field VALUES(AT_UUID_COL_ID,'0','0',AT_UUID_COL_ID,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'ad_table_id','ID','ID table',10,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_AD_CLIENT_ID,'0','0',AT_UUID_COL_AD_CLIENT_ID,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'ad_client_id','ID client','ID client',20,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_AD_ORG_ID,'0','0',AT_UUID_COL_AD_ORG_ID,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'ad_org_id','ID org','ID org',30,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_AD_PACKAGE_ID,'0','0',AT_UUID_COL_AD_PACKAGE_ID,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'ad_package_id','ID package','ID package',30,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_VALUE,'0','0',AT_UUID_COL_VALUE,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'value','Code','Code',40,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_NAME,'0','0',AT_UUID_COL_NAME,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'name','Name','Name',50,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_DESCRIPTION,'0','0',AT_UUID_COL_DESCRIPTION,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'description','Description','Description',60,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_ISACTIVE,'0','0',AT_UUID_COL_ISACTIVE,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'isactive','IsActive','IsActive',70,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AT_UUID_COL_BTN_GETCOL,'0','0',AT_UUID_COL_BTN_GETCOL,_UUID_FIELD_GROUP_GENERAL,AT_UUIDT,'btn_getcol','Get Columns','Get Columns',80,'Y',NOW(),'0',NOW(),'0');
/*END AT FIELD*/

/*AC FIELD*/
INSERT INTO ad_field VALUES(AC_UUID_COL_ID,'0','0',AC_UUID_COL_ID,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ad_column_id','ID','ID column',10,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_AD_CLIENT_ID,'0','0',AC_UUID_COL_AD_CLIENT_ID,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ad_client_id','ID client','ID client',20,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_AD_ORG_ID,'0','0',AC_UUID_COL_AD_ORG_ID,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ad_org_id','ID org','ID org',30,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_AD_TABLE_ID,'0','0',AC_UUID_COL_AD_TABLE_ID,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ad_table_id','ID table','ID table',40,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_VALUE,'0','0',AC_UUID_COL_VALUE,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'value','Code','Code',50,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_NAME,'0','0',AC_UUID_COL_NAME,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'name','Name','Name',60,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_DESCRIPTION,'0','0',AC_UUID_COL_DESCRIPTION,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'description','Description','Description',70,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_REF_TABLE,'0','0',AC_UUID_COL_REF_TABLE,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ref_table','Ref Table','Ref Table',80,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_REF_TABLE_KEY_FIELD,'0','0',AC_UUID_COL_REF_TABLE_KEY_FIELD,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ref_table_key_field','Ref Key','Ref Key',90,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_REF_TABLE_TEXT_FIELD,'0','0',AC_UUID_COL_REF_TABLE_TEXT_FIELD,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ref_table_text_field','Ref Text','Ref Text',100,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_ISPK,'0','0',AC_UUID_COL_ISPK,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'ispk','IsPK','IsPK',110,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_ISFK,'0','0',AC_UUID_COL_ISFK,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'isfk','IsFK','IsFK',120,'Y',NOW(),'0',NOW(),'0');
INSERT INTO ad_field VALUES(AC_UUID_COL_ISACTIVE,'0','0',AC_UUID_COL_ISACTIVE,_UUID_FIELD_GROUP_GENERAL,AC_UUIDT,'isactive','IsActive','IsActive',130,'Y',NOW(),'0',NOW(),'0');
/*END AC FIELD*/

END $$;