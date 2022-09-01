--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE admin;
ALTER ROLE admin WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:GA/am1a/Ax7jeaNfsWhpgA==$FUMHEry6jL1PnXuPFDfZntCVqy61D6zdUvQuptRnyK0=:cf6UlIaJWvQA2hNfvE+K1YPZia28n/lXYTmNiCQbqPw=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:3OZPNlDMxH+H3xXqWBHTtg==$UeLBAjWOvynzbUWJQmbFzmyZ/3DvNX+cxsvSGJR1pNc=:fXptEG8LfG5Bw0xvya/AU49vW92fdstO3pqFw5IxHg4=';






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Debian 14.4-1.pgdg110+1)
-- Dumped by pg_dump version 14.4 (Debian 14.4-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Debian 14.4-1.pgdg110+1)
-- Dumped by pg_dump version 14.4 (Debian 14.4-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "test" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Debian 14.4-1.pgdg110+1)
-- Dumped by pg_dump version 14.4 (Debian 14.4-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: test; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE test OWNER TO postgres;

\connect test

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: fn_generate_column(character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_generate_column(_ad_table_id character varying, _action character varying) RETURNS SETOF refcursor
    LANGUAGE plpgsql
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


ALTER FUNCTION public.fn_generate_column(_ad_table_id character varying, _action character varying) OWNER TO admin;

--
-- Name: fn_generate_field(character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_generate_field(_ad_tab_id character varying, _action character varying) RETURNS SETOF refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE ref_tab refcursor;
DECLARE rcount INT;
BEGIN
	ref_tab = 'ref_tab';
	OPEN ref_tab FOR
	SELECT * FROM ad_tab
	WHERE value = _ad_tab_id;
	RETURN NEXT ref_tab;
	
	SELECT COUNT(*) INTO rcount FROM ad_tab A WHERE A.ad_tab_id = _ad_tab_id;
	
	IF rcount > 0 THEN
		INSERT INTO ad_field
		SELECT fn_get_uuid() ad_field_id,C.ad_client_id, C.ad_org_id,C.ad_column_id,
		(SELECT X.ad_field_group_id FROM ad_field_group X WHERE X.ad_org_id = C.ad_org_id AND X.ad_client_id = C.ad_client_id limit 1) ad_field_group_id,
	 	ad_tab_id,C.value,C.name,C.description,'0' "position",'Y' isactive,NOW() created,'0' createdby,NOW() updated, '0' updatedby
		FROM ad_tab A
		INNER JOIN ad_table B ON A.value = B.value 
		INNER JOIN ad_column C ON B.ad_table_id = C.ad_table_id
		WHERE A.ad_tab_id = _ad_tab_id;
	END IF;
END
$$;


ALTER FUNCTION public.fn_generate_field(_ad_tab_id character varying, _action character varying) OWNER TO admin;

--
-- Name: fn_get_datatype_id(character varying, integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_get_datatype_id(_datatype character varying, _len integer) RETURNS character varying
    LANGUAGE plpgsql
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


ALTER FUNCTION public.fn_get_datatype_id(_datatype character varying, _len integer) OWNER TO admin;

--
-- Name: fn_get_table_data(character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_get_table_data(_table_name character varying, _action character varying) RETURNS SETOF refcursor
    LANGUAGE plpgsql
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


ALTER FUNCTION public.fn_get_table_data(_table_name character varying, _action character varying) OWNER TO admin;

--
-- Name: fn_get_user_code(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_get_user_code() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE _code CHARACTER VARYING(50);
BEGIN	
	_code = 'U000000';
	
	_code = 'U' || RIGHT('000000' || (SELECT MAX(COALESCE(REPLACE("value",'U',''),'0')::INT)+1 FROM ad_user) ,6);
		
	RETURN _code;
END
$$;


ALTER FUNCTION public.fn_get_user_code() OWNER TO admin;

--
-- Name: fn_get_uuid(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_get_uuid() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE _GUID CHARACTER VARYING(32);
BEGIN 
	_GUID := REPLACE(uuid_generate_v4()::TEXT,'-','');
	RETURN _GUID;
END
$$;


ALTER FUNCTION public.fn_get_uuid() OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ad_client; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_client (
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_client_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_client OWNER TO admin;

--
-- Name: ad_column; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_column (
    ad_column_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    ad_table_id character varying(32) NOT NULL,
    ad_datatype_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    action character varying(50),
    ispk character varying(1),
    isfk character varying(1),
    ref_table character varying(50),
    ref_table_key_field character varying(50),
    ref_table_text_field character varying(50),
    icon character varying(50),
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_column_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[]))),
    CONSTRAINT ad_column_isactive_check1 CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[]))),
    CONSTRAINT ad_column_isactive_check2 CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_column OWNER TO admin;

--
-- Name: ad_datatype; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_datatype (
    ad_datatype_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_datatype_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_datatype OWNER TO admin;

--
-- Name: ad_field; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_field (
    ad_field_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    ad_column_id character varying(32) NOT NULL,
    ad_field_group_id character varying(32) NOT NULL,
    ad_tab_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    "position" integer NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_field_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_field OWNER TO admin;

--
-- Name: ad_field_group; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_field_group (
    ad_field_group_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_field_group_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_field_group OWNER TO admin;

--
-- Name: ad_menu; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_menu (
    ad_menu_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    parent character varying(32),
    ad_window_id character varying(32),
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_menu_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_menu OWNER TO admin;

--
-- Name: ad_module; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_module (
    ad_module_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_module_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_module OWNER TO admin;

--
-- Name: ad_org; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_org (
    ad_org_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_org_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_org OWNER TO admin;

--
-- Name: ad_package; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_package (
    ad_package_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    ad_module_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_package_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_package OWNER TO admin;

--
-- Name: ad_tab; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_tab (
    ad_tab_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    ad_window_id character varying(32) NOT NULL,
    ad_tab_parent_id character varying(32),
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    "position" integer NOT NULL,
    isactive character varying(1),
    btn_getfield character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_tab_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_tab OWNER TO admin;

--
-- Name: ad_table; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_table (
    ad_table_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    ad_package_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    btn_getcol character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_table_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_table OWNER TO admin;

--
-- Name: ad_user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_user (
    ad_user_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    password character varying(150) NOT NULL,
    email character varying(50),
    first_name character varying(50),
    last_name character varying(50),
    phone_number character varying(50),
    birth_date timestamp without time zone,
    image character varying(255),
    device character varying(32),
    device_model character varying(50),
    so character varying(50),
    so_version character varying(20),
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_user_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_user OWNER TO admin;

--
-- Name: ad_window; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ad_window (
    ad_window_id character varying(32) NOT NULL,
    ad_client_id character varying(32) NOT NULL,
    ad_org_id character varying(32) NOT NULL,
    value character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    isactive character varying(1),
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby character varying(32) NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby character varying(32) NOT NULL,
    CONSTRAINT ad_window_isactive_check CHECK (((isactive)::text = ANY ((ARRAY['Y'::character varying, 'N'::character varying])::text[])))
);


ALTER TABLE public.ad_window OWNER TO admin;

--
-- Data for Name: ad_client; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_client (ad_client_id, ad_org_id, value, name, isactive, created, createdby, updated, updatedby) FROM stdin;
0	0	SYSTEM	System	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_column; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_column (ad_column_id, ad_client_id, ad_org_id, ad_table_id, ad_datatype_id, value, name, description, action, ispk, isfk, ref_table, ref_table_key_field, ref_table_text_field, icon, isactive, created, createdby, updated, updatedby) FROM stdin;
4b45f90281b449b1a2d0f9ccb2784cb3	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	ad_user_id	ID	ID user	\N	Y	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
7a2ca4eb9c39457898a6fb2608c64d34	0	0	01aa687608db447eae68d77cb234b910	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ID client	ID client	\N	N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8caf9285220b4478b1488d57be455894	0	0	01aa687608db447eae68d77cb234b910	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ID org	ID org	\N	N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
b3b8e399240f4e82b931b13d67cca0df	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	value	Code	Code	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
efb6443796904823b34bea3c56e09f40	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	name	Name	Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
49fbd4a9579a46cab2fec629ebba3093	0	0	01aa687608db447eae68d77cb234b910	fccded1452a64a2cb351d2c29b383ad8	password	Password	Password	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
db9d1c934def420b80a944f104253c93	0	0	01aa687608db447eae68d77cb234b910	796e76e276e949898c90163dcbd84287	isactive	IsActive	IsActive	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8a4cd935397c41ef949cce6fd7f6d458	0	0	01aa687608db447eae68d77cb234b910	79c645290d8b4ba5a73af4c980463455	email	Email	Email	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e52a80b14810413f9ef3f94299fd63cd	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	first_name	First Name	First Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
47cf9de049444bd990a7cedc88f6aae3	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	last_name	Last Name	Last Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
5d6ed5ebb70f41968b829c992f8a5bc1	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	phone_number	Phone Number	Phone Number	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
10ec83bd7bc34e438c66f5f3536d7b62	0	0	01aa687608db447eae68d77cb234b910	389bb1fda82f452cb8d0327c9e2a4896	birth_date	Birth Date	Birth Date	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
6da8f0d2749b4e039ad51a244f460cc5	0	0	01aa687608db447eae68d77cb234b910	7b5859460dfe47ada76f80939db9a9c6	image	Image	Image	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
a4f3e62bde64472f867026f575a1fa68	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	device	Device	Device	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
7272804ee5bb43348c4b6efaf57052a7	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	device_model	Device Model	Device Model	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
458a07b6d99c4214931b3399b9ecfd5b	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	so	SO	SO	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fe45e8930245418fa9f453e660ea9deb	0	0	01aa687608db447eae68d77cb234b910	0262cf88749e4a428e8d4d5867bad075	so_version	SO VERSION	SO VERSION	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
59d3853878e54ba19c97272b3915c9f8	0	0	34a4dc7c365441e9b6f3dc288c841fe6	0262cf88749e4a428e8d4d5867bad075	ad_table_id	ID	ID table	\N	Y	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
1973f5d6c0da44abab2bd1309f97ca42	0	0	34a4dc7c365441e9b6f3dc288c841fe6	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ID client	ID client	\N	N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
584c7861c90541c2ac5f5d11fa7b48d4	0	0	34a4dc7c365441e9b6f3dc288c841fe6	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ID org	ID org	\N	N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fc209d056cc646039900e41191673a2e	0	0	34a4dc7c365441e9b6f3dc288c841fe6	33d8c31ce64742fcb8192c2ba044cca4	ad_package_id	ID package	ID package	\N	N	Y	ad_package	ad_package_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
31ded288ba904edbbdf01be17fb0e123	0	0	34a4dc7c365441e9b6f3dc288c841fe6	0262cf88749e4a428e8d4d5867bad075	value	Code	Code	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c8e800496d7f4762a142d148fc4edda5	0	0	34a4dc7c365441e9b6f3dc288c841fe6	0262cf88749e4a428e8d4d5867bad075	name	Name	Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
11fa384a47da4dab9137a03ef23cc215	0	0	34a4dc7c365441e9b6f3dc288c841fe6	0262cf88749e4a428e8d4d5867bad075	description	Description	Description	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e7bd02ec298d4f2b8c21de785b1ba5f3	0	0	34a4dc7c365441e9b6f3dc288c841fe6	796e76e276e949898c90163dcbd84287	isactive	IsActive	IsActive	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9a3946d332564a9f9fa518ac05a0f8b1	0	0	34a4dc7c365441e9b6f3dc288c841fe6	03544dc6402a4a8e895ed85e34e02949	btn_getcol	Get Columns	Get Columns	getColumnService	N	N	\N	\N	\N	mdi-timer-sand-complete	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
4f33a4117cb04ba99f446d655834907b	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	ad_column_id	ID	ID column	\N	Y	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8589897ccb6546ce866841605a8c62b8	0	0	de77fe0291db495394df0780744e8cd7	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ID client	ID client	\N	N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8e28df78855348e79b6a28c1339b3f6e	0	0	de77fe0291db495394df0780744e8cd7	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ID org	ID org	\N	N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fd2ef6f742a64cb1bc8a9db3643afcd8	0	0	de77fe0291db495394df0780744e8cd7	33d8c31ce64742fcb8192c2ba044cca4	ad_table_id	ID table	ID table	\N	N	Y	ad_table	ad_table_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9d1912d5f5ab4be4a7c1cc17714985af	0	0	de77fe0291db495394df0780744e8cd7	33d8c31ce64742fcb8192c2ba044cca4	ad_datatype_id	ID datatype	ID datatype	\N	N	Y	ad_datatype	ad_datatype_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
36fdf53b11c74e3388892a5ce69ebfc7	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	value	Code	Code	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
4b106a6695d64e3cb9615e12360a0a5b	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	name	Name	Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
43767989c32b4e3ead937fb31a991a5b	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	description	Description	Description	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
196bd521d29c476a92ec7c759210e9cc	0	0	de77fe0291db495394df0780744e8cd7	796e76e276e949898c90163dcbd84287	ispk	IsPK	IsPK	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f5d1d581a20b4036a04268186671245f	0	0	de77fe0291db495394df0780744e8cd7	796e76e276e949898c90163dcbd84287	isfk	IsFK	IsFK	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
cdda0085a86746e8ab7ad8274c77b8ac	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	ref_table	Ref Table	Ref Table	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
46eec0876b3e4da39257e441df4a17e1	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	ref_table_key_field	Ref Key Field	Ref Key Field	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
53947f9576134369b8a25712c33d52d6	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	ref_table_text_field	Ref Text Field	Ref Text Field	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
629adb76a1cd42f8878a91d9c251b831	0	0	de77fe0291db495394df0780744e8cd7	796e76e276e949898c90163dcbd84287	isactive	IsActive	IsActive	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9255c9d1ee9240f68f6137f1b56c3a8c	0	0	de77fe0291db495394df0780744e8cd7	0262cf88749e4a428e8d4d5867bad075	icon	Icon	Icon	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e4b875481571429685f0e1949dc47035	0	0	15a93dc586fa495fa945701610d84ba5	0262cf88749e4a428e8d4d5867bad075	ad_window_id	ID	ID window	\N	Y	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c8b65cb84ea444cfb1bcd5ad6cdf67b1	0	0	15a93dc586fa495fa945701610d84ba5	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ID client	ID client	\N	N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
b56452f7147548dcb50361965ef93532	0	0	15a93dc586fa495fa945701610d84ba5	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ID org	ID org	\N	N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
1244106fead64bad8b4169b94f2bb030	0	0	15a93dc586fa495fa945701610d84ba5	0262cf88749e4a428e8d4d5867bad075	value	Code	Code	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
b2b7c0cf02144a1bbcf1b3974c18e9c7	0	0	15a93dc586fa495fa945701610d84ba5	0262cf88749e4a428e8d4d5867bad075	name	Name	Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
33683a10381f4ac7a5aa5e7047749b31	0	0	15a93dc586fa495fa945701610d84ba5	0262cf88749e4a428e8d4d5867bad075	description	Description	Description	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f4a852ed10f14f50a760f0ddfce66536	0	0	15a93dc586fa495fa945701610d84ba5	796e76e276e949898c90163dcbd84287	isactive	IsActive	IsActive	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
56c47e79025843c1bddbd16309bba214	0	0	ee34ecf058ee4a20a25067b444a61e2a	0262cf88749e4a428e8d4d5867bad075	ad_tab_id	ID	ID tab	\N	Y	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8577cd3acd144a8eb17fef9dfa160101	0	0	ee34ecf058ee4a20a25067b444a61e2a	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ID client	ID client	\N	N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
af66a3d23e6148e78f16310fe3b47b2c	0	0	ee34ecf058ee4a20a25067b444a61e2a	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ID org	ID org	\N	N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
0045f1295b45483f8a819e6c9c2eadb1	0	0	ee34ecf058ee4a20a25067b444a61e2a	33d8c31ce64742fcb8192c2ba044cca4	ad_window_id	ID window	ID window	\N	N	Y	ad_window	ad_window_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d0fd8405daae45d3aa2871313f7fe98e	0	0	ee34ecf058ee4a20a25067b444a61e2a	33d8c31ce64742fcb8192c2ba044cca4	ad_tab_parent_id	ID tab parent	ID tab_parent	\N	N	Y	ad_tab	ad_tab_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f2cbdc1fb7194c5697911a376f7c1d77	0	0	ee34ecf058ee4a20a25067b444a61e2a	0262cf88749e4a428e8d4d5867bad075	value	Code	Code	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
717c01f53a2048838e21740a401961e2	0	0	ee34ecf058ee4a20a25067b444a61e2a	0262cf88749e4a428e8d4d5867bad075	name	Name	Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
43f2ad4874ee4c07acd6c645277d48a9	0	0	ee34ecf058ee4a20a25067b444a61e2a	0262cf88749e4a428e8d4d5867bad075	description	Description	Description	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
03bee200f1614424aa510d53193119aa	0	0	ee34ecf058ee4a20a25067b444a61e2a	33ccf36802174a8a905becec23543a26	position	Position	Position	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8e5b66a22a1f42209e51090bf15ba65c	0	0	ee34ecf058ee4a20a25067b444a61e2a	796e76e276e949898c90163dcbd84287	isactive	IsActive	IsActive	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
02415f089fd74217a41d9bf719a3b0b8	0	0	ee34ecf058ee4a20a25067b444a61e2a	03544dc6402a4a8e895ed85e34e02949	btn_getfield	Get Fields	Get Fields	getFieldService	N	N	\N	\N	\N	mdi-timer-sand-complete	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d8a91e15cde74d50982631d791df87c5	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	0262cf88749e4a428e8d4d5867bad075	ad_field_id	ID	ID field	\N	Y	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
6a6b2e1df8814a21a0ce99373847e4fe	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ID client	ID client	\N	N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
246093d720d84fbdb71c49bd3d581f4c	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ID org	ID org	\N	N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e4fb47aaa8f7406d9eb097f4c72179fd	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	33d8c31ce64742fcb8192c2ba044cca4	ad_column_id	ID column	ID column	\N	N	Y	ad_column	ad_column_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d6938da26e134b849d26c174013d0b63	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	33d8c31ce64742fcb8192c2ba044cca4	ad_field_group_id	ID field group	ID field group	\N	N	Y	ad_field_group	ad_field_group_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
26f6a1161de8444595e0cdfdf74678d9	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	33d8c31ce64742fcb8192c2ba044cca4	ad_tab_id	ID tab	ID tab	\N	N	Y	ad_tab	ad_tab_id	name	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
bcef70d119f54d31ab12b7d9a1839f2b	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	0262cf88749e4a428e8d4d5867bad075	value	Code	Code	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
09951a5bed344b69a8d112caf67fe1cb	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	0262cf88749e4a428e8d4d5867bad075	name	Name	Name	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
688efbf57de149f9beac2f4cfe27ebff	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	0262cf88749e4a428e8d4d5867bad075	description	Description	Description	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c3652cf3a5d942f3bd0eb61001eebb4f	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	33ccf36802174a8a905becec23543a26	position	Position	Position	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
460fb7893c09459799853fb94ea00794	0	0	2a1ecc7de6334e83a1e88ec5ecad58e2	796e76e276e949898c90163dcbd84287	isactive	IsActive	IsActive	\N	N	N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
a35ce8a49f464f37be6d0fb53266d2c7	0	0	7fd5d83fe2454afaa624447e635716ac	0262cf88749e4a428e8d4d5867bad075	ad_menu_id	ad_menu_id	ad_menu_id		Y	N	\N	\N	\N	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
93cee3ab6fc14d0a9b61d85b26322dba	0	0	7fd5d83fe2454afaa624447e635716ac	33d8c31ce64742fcb8192c2ba044cca4	ad_client_id	ad_client_id	ad_client_id		N	Y	ad_client	ad_client_id	name	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
05bed1d68bab41b091e7436b65dc90b3	0	0	7fd5d83fe2454afaa624447e635716ac	33d8c31ce64742fcb8192c2ba044cca4	ad_org_id	ad_org_id	ad_org_id		N	Y	ad_org	ad_org_id	name	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
aae5bb18cb7743bab1fd96c402fdccba	0	0	7fd5d83fe2454afaa624447e635716ac	0262cf88749e4a428e8d4d5867bad075	parent	parent	parent		N	N	\N	\N	\N	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
cbd32d2f471142c89eb19316ecb01fb8	0	0	7fd5d83fe2454afaa624447e635716ac	33d8c31ce64742fcb8192c2ba044cca4	ad_window_id	ad_window_id	ad_window_id		N	Y	ad_window	ad_window_id	name	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
aec45d2119c940d4b9073fbb71b2e3fd	0	0	7fd5d83fe2454afaa624447e635716ac	0262cf88749e4a428e8d4d5867bad075	value	value	value		N	N	\N	\N	\N	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
537b0f0085d947fcb9e4eacc4ba26479	0	0	7fd5d83fe2454afaa624447e635716ac	0262cf88749e4a428e8d4d5867bad075	name	name	name		N	N	\N	\N	\N	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
9df61d74cefd4174b16a266a4ad03e84	0	0	7fd5d83fe2454afaa624447e635716ac	0262cf88749e4a428e8d4d5867bad075	description	description	description		N	N	\N	\N	\N	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
4e324698a01346988073fe5c8c0c98e2	0	0	7fd5d83fe2454afaa624447e635716ac	796e76e276e949898c90163dcbd84287	isactive	isactive	isactive		N	N	\N	\N	\N	\N	Y	2022-08-31 18:36:07.27509	0	2022-08-31 18:36:07.27509	0
\.


--
-- Data for Name: ad_datatype; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_datatype (ad_datatype_id, ad_client_id, ad_org_id, value, name, description, isactive, created, createdby, updated, updatedby) FROM stdin;
0262cf88749e4a428e8d4d5867bad075	0	0	TEXT	TEXT	TEXT	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
33ccf36802174a8a905becec23543a26	0	0	NUMBER	NUMBER	NUMBER	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
33d8c31ce64742fcb8192c2ba044cca4	0	0	SELECT	SELECT	SELECT	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
796e76e276e949898c90163dcbd84287	0	0	YESNO	YESNO	YESNO	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fccded1452a64a2cb351d2c29b383ad8	0	0	PASSWORD	PASSWORD	PASSWORD	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
79c645290d8b4ba5a73af4c980463455	0	0	EMAIL	EMAIL	EMAIL	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
389bb1fda82f452cb8d0327c9e2a4896	0	0	DATE	DATE	DATE	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
7b5859460dfe47ada76f80939db9a9c6	0	0	IMAGE	IMAGE	IMAGE	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
03544dc6402a4a8e895ed85e34e02949	0	0	BUTTON	BUTTON	BUTTON	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_field; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_field (ad_field_id, ad_client_id, ad_org_id, ad_column_id, ad_field_group_id, ad_tab_id, value, name, description, "position", isactive, created, createdby, updated, updatedby) FROM stdin;
4b45f90281b449b1a2d0f9ccb2784cb3	0	0	4b45f90281b449b1a2d0f9ccb2784cb3	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	ad_user_id	ID	ID user	10	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
7a2ca4eb9c39457898a6fb2608c64d34	0	0	7a2ca4eb9c39457898a6fb2608c64d34	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	ad_client_id	ID client	ID client	20	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8caf9285220b4478b1488d57be455894	0	0	8caf9285220b4478b1488d57be455894	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	ad_org_id	ID org	ID org	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
b3b8e399240f4e82b931b13d67cca0df	0	0	b3b8e399240f4e82b931b13d67cca0df	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	value	Code	Code	40	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
efb6443796904823b34bea3c56e09f40	0	0	efb6443796904823b34bea3c56e09f40	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	name	Name	Name	50	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
49fbd4a9579a46cab2fec629ebba3093	0	0	49fbd4a9579a46cab2fec629ebba3093	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	password	Password	Password	60	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
db9d1c934def420b80a944f104253c93	0	0	db9d1c934def420b80a944f104253c93	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	isactive	IsActive	IsActive	70	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8a4cd935397c41ef949cce6fd7f6d458	0	0	8a4cd935397c41ef949cce6fd7f6d458	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	email	Email	Email	80	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e52a80b14810413f9ef3f94299fd63cd	0	0	e52a80b14810413f9ef3f94299fd63cd	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	first_name	First Name	First Name	90	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
47cf9de049444bd990a7cedc88f6aae3	0	0	47cf9de049444bd990a7cedc88f6aae3	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	last_name	Last Name	Last Name	100	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
5d6ed5ebb70f41968b829c992f8a5bc1	0	0	5d6ed5ebb70f41968b829c992f8a5bc1	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	phone_number	Phone Number	Phone Number	110	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
10ec83bd7bc34e438c66f5f3536d7b62	0	0	10ec83bd7bc34e438c66f5f3536d7b62	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	birth_date	Birth Date	Birth Date	120	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
6da8f0d2749b4e039ad51a244f460cc5	0	0	6da8f0d2749b4e039ad51a244f460cc5	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	image	Image	Image	130	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
a4f3e62bde64472f867026f575a1fa68	0	0	a4f3e62bde64472f867026f575a1fa68	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	device	Device	Device	140	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
7272804ee5bb43348c4b6efaf57052a7	0	0	7272804ee5bb43348c4b6efaf57052a7	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	device_model	Device Model	Device Model	150	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
458a07b6d99c4214931b3399b9ecfd5b	0	0	458a07b6d99c4214931b3399b9ecfd5b	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	so	SO	SO	160	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fe45e8930245418fa9f453e660ea9deb	0	0	fe45e8930245418fa9f453e660ea9deb	7705c62370174b0981cabdfe668f0f18	fbf30447033e4edba8e4ca8a656a4839	so_version	SO Version	SO Version	170	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
59d3853878e54ba19c97272b3915c9f8	0	0	59d3853878e54ba19c97272b3915c9f8	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	ad_table_id	ID	ID table	10	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
1973f5d6c0da44abab2bd1309f97ca42	0	0	1973f5d6c0da44abab2bd1309f97ca42	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	ad_client_id	ID client	ID client	20	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
584c7861c90541c2ac5f5d11fa7b48d4	0	0	584c7861c90541c2ac5f5d11fa7b48d4	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	ad_org_id	ID org	ID org	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fc209d056cc646039900e41191673a2e	0	0	fc209d056cc646039900e41191673a2e	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	ad_package_id	ID package	ID package	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
31ded288ba904edbbdf01be17fb0e123	0	0	31ded288ba904edbbdf01be17fb0e123	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	value	Code	Code	40	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c8e800496d7f4762a142d148fc4edda5	0	0	c8e800496d7f4762a142d148fc4edda5	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	name	Name	Name	50	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
11fa384a47da4dab9137a03ef23cc215	0	0	11fa384a47da4dab9137a03ef23cc215	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	description	Description	Description	60	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e7bd02ec298d4f2b8c21de785b1ba5f3	0	0	e7bd02ec298d4f2b8c21de785b1ba5f3	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	isactive	IsActive	IsActive	70	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9a3946d332564a9f9fa518ac05a0f8b1	0	0	9a3946d332564a9f9fa518ac05a0f8b1	7705c62370174b0981cabdfe668f0f18	f4450e4e7db4403591eaf15e9ec61cc8	btn_getcol	Get Columns	Get Columns	80	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
4f33a4117cb04ba99f446d655834907b	0	0	4f33a4117cb04ba99f446d655834907b	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ad_column_id	ID	ID column	10	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8589897ccb6546ce866841605a8c62b8	0	0	8589897ccb6546ce866841605a8c62b8	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ad_client_id	ID client	ID client	20	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8e28df78855348e79b6a28c1339b3f6e	0	0	8e28df78855348e79b6a28c1339b3f6e	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ad_org_id	ID org	ID org	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fd2ef6f742a64cb1bc8a9db3643afcd8	0	0	fd2ef6f742a64cb1bc8a9db3643afcd8	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ad_table_id	ID table	ID table	40	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9d1912d5f5ab4be4a7c1cc17714985af	0	0	9d1912d5f5ab4be4a7c1cc17714985af	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ad_datatype_id	ID datatype	ID datatype	50	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
36fdf53b11c74e3388892a5ce69ebfc7	0	0	36fdf53b11c74e3388892a5ce69ebfc7	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	value	Code	Code	60	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
4b106a6695d64e3cb9615e12360a0a5b	0	0	4b106a6695d64e3cb9615e12360a0a5b	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	name	Name	Name	70	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
43767989c32b4e3ead937fb31a991a5b	0	0	43767989c32b4e3ead937fb31a991a5b	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	description	Description	Description	80	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
cdda0085a86746e8ab7ad8274c77b8ac	0	0	cdda0085a86746e8ab7ad8274c77b8ac	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ref_table	Ref Table	Ref Table	90	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
46eec0876b3e4da39257e441df4a17e1	0	0	46eec0876b3e4da39257e441df4a17e1	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ref_table_key_field	Ref Key	Ref Key	100	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
53947f9576134369b8a25712c33d52d6	0	0	53947f9576134369b8a25712c33d52d6	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ref_table_text_field	Ref Text	Ref Text	110	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
196bd521d29c476a92ec7c759210e9cc	0	0	196bd521d29c476a92ec7c759210e9cc	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	ispk	IsPK	IsPK	120	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f5d1d581a20b4036a04268186671245f	0	0	f5d1d581a20b4036a04268186671245f	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	isfk	IsFK	IsFK	130	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
629adb76a1cd42f8878a91d9c251b831	0	0	629adb76a1cd42f8878a91d9c251b831	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	isactive	IsActive	IsActive	140	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9255c9d1ee9240f68f6137f1b56c3a8c	0	0	9255c9d1ee9240f68f6137f1b56c3a8c	7705c62370174b0981cabdfe668f0f18	fb5780526a934fb0ac7d10cee5795dec	icon	Icon	Icon	150	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e4b875481571429685f0e1949dc47035	0	0	e4b875481571429685f0e1949dc47035	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	ad_window_id	ID	ID window	10	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c8b65cb84ea444cfb1bcd5ad6cdf67b1	0	0	c8b65cb84ea444cfb1bcd5ad6cdf67b1	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	ad_client_id	ID client	ID client	20	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
b56452f7147548dcb50361965ef93532	0	0	b56452f7147548dcb50361965ef93532	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	ad_org_id	ID org	ID org	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
1244106fead64bad8b4169b94f2bb030	0	0	1244106fead64bad8b4169b94f2bb030	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	value	Code	Code	60	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
b2b7c0cf02144a1bbcf1b3974c18e9c7	0	0	b2b7c0cf02144a1bbcf1b3974c18e9c7	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	name	Name	Name	70	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
33683a10381f4ac7a5aa5e7047749b31	0	0	33683a10381f4ac7a5aa5e7047749b31	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	description	Description	Description	80	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f4a852ed10f14f50a760f0ddfce66536	0	0	f4a852ed10f14f50a760f0ddfce66536	7705c62370174b0981cabdfe668f0f18	ec211bd6799b436da3422f2761005906	isactive	IsActive	IsActive	140	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
56c47e79025843c1bddbd16309bba214	0	0	56c47e79025843c1bddbd16309bba214	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	ad_tab_id	ID	ID tab	10	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8577cd3acd144a8eb17fef9dfa160101	0	0	8577cd3acd144a8eb17fef9dfa160101	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	ad_client_id	ID client	ID client	20	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
af66a3d23e6148e78f16310fe3b47b2c	0	0	af66a3d23e6148e78f16310fe3b47b2c	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	ad_org_id	ID org	ID org	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
0045f1295b45483f8a819e6c9c2eadb1	0	0	0045f1295b45483f8a819e6c9c2eadb1	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	ad_window_id	ID window	ID window	40	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d0fd8405daae45d3aa2871313f7fe98e	0	0	d0fd8405daae45d3aa2871313f7fe98e	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	ad_tab_parent_id	ID tab parent	ID tab_parent	50	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f2cbdc1fb7194c5697911a376f7c1d77	0	0	f2cbdc1fb7194c5697911a376f7c1d77	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	value	Code	Code	60	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
717c01f53a2048838e21740a401961e2	0	0	717c01f53a2048838e21740a401961e2	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	name	Name	Name	70	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
43f2ad4874ee4c07acd6c645277d48a9	0	0	43f2ad4874ee4c07acd6c645277d48a9	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	description	Description	Description	80	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
03bee200f1614424aa510d53193119aa	0	0	03bee200f1614424aa510d53193119aa	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	position	Position	Position	90	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8e5b66a22a1f42209e51090bf15ba65c	0	0	8e5b66a22a1f42209e51090bf15ba65c	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	isactive	IsActive	IsActive	140	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
02415f089fd74217a41d9bf719a3b0b8	0	0	02415f089fd74217a41d9bf719a3b0b8	7705c62370174b0981cabdfe668f0f18	f42b482240424709826fd30ecb607faa	btn_getfield	Get Fields	Get Fields	150	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d8a91e15cde74d50982631d791df87c5	0	0	d8a91e15cde74d50982631d791df87c5	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	ad_field_id	ID	ID field	10	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
6a6b2e1df8814a21a0ce99373847e4fe	0	0	6a6b2e1df8814a21a0ce99373847e4fe	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	ad_client_id	ID client	ID client	20	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
246093d720d84fbdb71c49bd3d581f4c	0	0	246093d720d84fbdb71c49bd3d581f4c	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	ad_org_id	ID org	ID org	30	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
e4fb47aaa8f7406d9eb097f4c72179fd	0	0	e4fb47aaa8f7406d9eb097f4c72179fd	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	ad_column_id	ID column	ID column	40	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d6938da26e134b849d26c174013d0b63	0	0	d6938da26e134b849d26c174013d0b63	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	ad_field_group_id	ID field_group	ID field_group	50	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
26f6a1161de8444595e0cdfdf74678d9	0	0	26f6a1161de8444595e0cdfdf74678d9	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	ad_tab_id	ID tab	ID tab	60	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
bcef70d119f54d31ab12b7d9a1839f2b	0	0	bcef70d119f54d31ab12b7d9a1839f2b	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	value	Code	Code	70	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
09951a5bed344b69a8d112caf67fe1cb	0	0	09951a5bed344b69a8d112caf67fe1cb	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	name	Name	Name	80	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
688efbf57de149f9beac2f4cfe27ebff	0	0	688efbf57de149f9beac2f4cfe27ebff	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	description	Description	Description	90	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c3652cf3a5d942f3bd0eb61001eebb4f	0	0	c3652cf3a5d942f3bd0eb61001eebb4f	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	position	Position	Position	100	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
460fb7893c09459799853fb94ea00794	0	0	460fb7893c09459799853fb94ea00794	7705c62370174b0981cabdfe668f0f18	1fa44e4ca0cc43619734bf0f4e9096c2	isactive	IsActive	IsActive	110	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
1d77224d76fb4f6a8a9342491f2da299	0	0	a35ce8a49f464f37be6d0fb53266d2c7	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	ad_menu_id	ad_menu_id	ad_menu_id	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
6cdf2c216c1e48bbaefcf06c6cbbbf3c	0	0	93cee3ab6fc14d0a9b61d85b26322dba	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	ad_client_id	ad_client_id	ad_client_id	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
a9e02e1f32074aeea5bb903b5d8a6d6d	0	0	05bed1d68bab41b091e7436b65dc90b3	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	ad_org_id	ad_org_id	ad_org_id	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
832a56fad077462cabf03d4a7f4a42ee	0	0	aae5bb18cb7743bab1fd96c402fdccba	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	parent	parent	parent	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
649d8b7c784c447b942af757557175d7	0	0	cbd32d2f471142c89eb19316ecb01fb8	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	ad_window_id	ad_window_id	ad_window_id	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
524cedc663484d59bbb449893907fb33	0	0	aec45d2119c940d4b9073fbb71b2e3fd	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	value	value	value	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
db7d2227dbb445c9aad24e25dc585061	0	0	537b0f0085d947fcb9e4eacc4ba26479	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	name	name	name	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
64c541b48d71484daf94c23b19502d92	0	0	9df61d74cefd4174b16a266a4ad03e84	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	description	description	description	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
d80099c5d6ed44f2a4239dcf377a7746	0	0	4e324698a01346988073fe5c8c0c98e2	7705c62370174b0981cabdfe668f0f18	fa9ba9235dd849ce939a9a3d3b71ca9a	isactive	isactive	isactive	0	Y	2022-08-31 18:37:20.776965	0	2022-08-31 18:37:20.776965	0
\.


--
-- Data for Name: ad_field_group; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_field_group (ad_field_group_id, ad_client_id, ad_org_id, value, name, description, isactive, created, createdby, updated, updatedby) FROM stdin;
7705c62370174b0981cabdfe668f0f18	0	0	General	General	Datos Generales	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_menu; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_menu (ad_menu_id, ad_client_id, ad_org_id, parent, ad_window_id, value, name, description, isactive, created, createdby, updated, updatedby) FROM stdin;
0	0	0	\N	\N	root	Menu	Menu principal	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
c0c6134388474b2d85c4eaa7a5d61f38	0	0	0	3cc1dbb5181d4e7b85f452f0e1993fac	ad_user	Usuario	Catalogo de Usuarios	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
9798ad8ec41b43d4b0206bac8d48770c	0	0	0	8b75a353e2414c749a156b5674a44640	ad_table	Tabla	Catalogo de Tablas	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
4f78919dff134cf2804b90a41b6cd940	0	0	0	2e33021dc2de4f3583e1d89912154bc7	ad_window	Ventana	Catalogo de Ventanas	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
90107394c4514732919689250eca4cde	0	0	0	d4200c5da37b45f1891a959f8c56c6a5	ad_menu	Menu	Catalogo de Menu	Y	2022-08-31 18:38:07.141669	0	2022-08-31 18:38:07.141669	0
\.


--
-- Data for Name: ad_module; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_module (ad_module_id, ad_client_id, ad_org_id, value, name, description, isactive, created, createdby, updated, updatedby) FROM stdin;
0	0	0	M00001	Core	Core Module	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_org; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_org (ad_org_id, ad_client_id, value, name, isactive, created, createdby, updated, updatedby) FROM stdin;
0	0	0	*	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_package; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_package (ad_package_id, ad_client_id, ad_org_id, ad_module_id, value, name, description, isactive, created, createdby, updated, updatedby) FROM stdin;
0	0	0	0	PKG001	Core Pkg	Core Pkg	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_tab; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_tab (ad_tab_id, ad_client_id, ad_org_id, ad_window_id, ad_tab_parent_id, value, name, description, "position", isactive, btn_getfield, created, createdby, updated, updatedby) FROM stdin;
fbf30447033e4edba8e4ca8a656a4839	0	0	3cc1dbb5181d4e7b85f452f0e1993fac	\N	ad_user	Usuario	Datos Generales	0	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f4450e4e7db4403591eaf15e9ec61cc8	0	0	8b75a353e2414c749a156b5674a44640	\N	ad_table	Tabla	Datos Tabla	0	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fb5780526a934fb0ac7d10cee5795dec	0	0	8b75a353e2414c749a156b5674a44640	f4450e4e7db4403591eaf15e9ec61cc8	ad_column	Columna	Datos Columna	0	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
ec211bd6799b436da3422f2761005906	0	0	2e33021dc2de4f3583e1d89912154bc7	\N	ad_window	Ventana	Datos Ventana	10	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
f42b482240424709826fd30ecb607faa	0	0	2e33021dc2de4f3583e1d89912154bc7	ec211bd6799b436da3422f2761005906	ad_tab	Pestana	Datos Pestana	20	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
1fa44e4ca0cc43619734bf0f4e9096c2	0	0	2e33021dc2de4f3583e1d89912154bc7	f42b482240424709826fd30ecb607faa	ad_field	Campo	Datos Campo	20	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
fa9ba9235dd849ce939a9a3d3b71ca9a	0	0	d4200c5da37b45f1891a959f8c56c6a5	\N	ad_menu	Menu	Menu Description	10	Y	\N	2022-08-31 18:37:15.435824	0	2022-08-31 18:37:15.435824	0
\.


--
-- Data for Name: ad_table; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_table (ad_table_id, ad_client_id, ad_org_id, ad_package_id, value, name, description, isactive, btn_getcol, created, createdby, updated, updatedby) FROM stdin;
01aa687608db447eae68d77cb234b910	0	0	0	ad_user	Usuario	Catalogo de Usuarios	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
34a4dc7c365441e9b6f3dc288c841fe6	0	0	0	ad_table	Tabla	Catalogo de Tablas	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
de77fe0291db495394df0780744e8cd7	0	0	0	ad_column	Columna	Catalogo de Columnas	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
15a93dc586fa495fa945701610d84ba5	0	0	0	ad_window	Window	Catalogo de Ventana	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
ee34ecf058ee4a20a25067b444a61e2a	0	0	0	ad_tab	Tab	Catalogo de Pestana	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
2a1ecc7de6334e83a1e88ec5ecad58e2	0	0	0	ad_field	Field	Catalogo de Campo	Y	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
7fd5d83fe2454afaa624447e635716ac	0	0	0	ad_menu	Menu	Menu Description	Y	\N	2022-08-31 18:36:03.919255	0	2022-08-31 18:36:03.919255	0
\.


--
-- Data for Name: ad_user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_user (ad_user_id, ad_client_id, ad_org_id, value, name, password, email, first_name, last_name, phone_number, birth_date, image, device, device_model, so, so_version, isactive, created, createdby, updated, updatedby) FROM stdin;
0	0	0	U00001	admin	$2a$10$ailMVjeYYsDs9YZ3t6ujG.KqbvVDXzaJNZR4Q.KXo8SWyCiSJsqN2	ejcarranzap@gmail.com	Administrador		\N	\N	\N	\N	\N	\N	\N	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
\.


--
-- Data for Name: ad_window; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ad_window (ad_window_id, ad_client_id, ad_org_id, value, name, description, isactive, created, createdby, updated, updatedby) FROM stdin;
3cc1dbb5181d4e7b85f452f0e1993fac	0	0	ad_user	Usuario	Catalogo de Usuarios	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
8b75a353e2414c749a156b5674a44640	0	0	ad_table	Tabla	Catalogo de Tablas	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
2e33021dc2de4f3583e1d89912154bc7	0	0	ad_window	Ventana	Catalogo de Ventana	Y	2022-08-31 18:34:48.606335	0	2022-08-31 18:34:48.606335	0
d4200c5da37b45f1891a959f8c56c6a5	0	0	ad_menu	Menu	Menu Description	Y	2022-08-31 18:36:43.459504	0	2022-08-31 18:36:43.459504	0
\.


--
-- Name: ad_client ad_client_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_client
    ADD CONSTRAINT ad_client_key PRIMARY KEY (ad_client_id);


--
-- Name: ad_column ad_column_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_column
    ADD CONSTRAINT ad_column_key PRIMARY KEY (ad_column_id);


--
-- Name: ad_column ad_column_unique; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_column
    ADD CONSTRAINT ad_column_unique UNIQUE (ad_table_id, value);


--
-- Name: ad_datatype ad_datatype_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_datatype
    ADD CONSTRAINT ad_datatype_key PRIMARY KEY (ad_datatype_id);


--
-- Name: ad_datatype ad_datatype_unique; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_datatype
    ADD CONSTRAINT ad_datatype_unique UNIQUE (value);


--
-- Name: ad_field_group ad_field_group_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field_group
    ADD CONSTRAINT ad_field_group_key PRIMARY KEY (ad_field_group_id);


--
-- Name: ad_field ad_field_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field
    ADD CONSTRAINT ad_field_key PRIMARY KEY (ad_field_id);


--
-- Name: ad_menu ad_menu_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_menu
    ADD CONSTRAINT ad_menu_key PRIMARY KEY (ad_menu_id);


--
-- Name: ad_module ad_module_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_module
    ADD CONSTRAINT ad_module_key PRIMARY KEY (ad_module_id);


--
-- Name: ad_org ad_org_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_org
    ADD CONSTRAINT ad_org_key PRIMARY KEY (ad_org_id);


--
-- Name: ad_package ad_package_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_package
    ADD CONSTRAINT ad_package_key PRIMARY KEY (ad_package_id);


--
-- Name: ad_tab ad_tab_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_tab
    ADD CONSTRAINT ad_tab_key PRIMARY KEY (ad_tab_id);


--
-- Name: ad_table ad_table_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_table
    ADD CONSTRAINT ad_table_key PRIMARY KEY (ad_table_id);


--
-- Name: ad_user ad_user_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_user
    ADD CONSTRAINT ad_user_key PRIMARY KEY (ad_user_id);


--
-- Name: ad_window ad_window_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_window
    ADD CONSTRAINT ad_window_key PRIMARY KEY (ad_window_id);


--
-- Name: ad_client ad_client_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_client
    ADD CONSTRAINT ad_client_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_column ad_column_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_column
    ADD CONSTRAINT ad_column_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_column ad_column_ad_datatype; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_column
    ADD CONSTRAINT ad_column_ad_datatype FOREIGN KEY (ad_datatype_id) REFERENCES public.ad_datatype(ad_datatype_id);


--
-- Name: ad_column ad_column_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_column
    ADD CONSTRAINT ad_column_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_column ad_column_ad_table; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_column
    ADD CONSTRAINT ad_column_ad_table FOREIGN KEY (ad_table_id) REFERENCES public.ad_table(ad_table_id);


--
-- Name: ad_datatype ad_datatype_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_datatype
    ADD CONSTRAINT ad_datatype_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_datatype ad_datatype_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_datatype
    ADD CONSTRAINT ad_datatype_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_field ad_field_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field
    ADD CONSTRAINT ad_field_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_field ad_field_ad_column; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field
    ADD CONSTRAINT ad_field_ad_column FOREIGN KEY (ad_column_id) REFERENCES public.ad_column(ad_column_id);


--
-- Name: ad_field ad_field_ad_field_group; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field
    ADD CONSTRAINT ad_field_ad_field_group FOREIGN KEY (ad_field_group_id) REFERENCES public.ad_field_group(ad_field_group_id);


--
-- Name: ad_field ad_field_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field
    ADD CONSTRAINT ad_field_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_field ad_field_ad_tab; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field
    ADD CONSTRAINT ad_field_ad_tab FOREIGN KEY (ad_tab_id) REFERENCES public.ad_tab(ad_tab_id);


--
-- Name: ad_field_group ad_field_group_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field_group
    ADD CONSTRAINT ad_field_group_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_field_group ad_field_group_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_field_group
    ADD CONSTRAINT ad_field_group_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_menu ad_menu_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_menu
    ADD CONSTRAINT ad_menu_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_menu ad_menu_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_menu
    ADD CONSTRAINT ad_menu_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_menu ad_menu_ad_window; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_menu
    ADD CONSTRAINT ad_menu_ad_window FOREIGN KEY (ad_window_id) REFERENCES public.ad_window(ad_window_id);


--
-- Name: ad_module ad_module_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_module
    ADD CONSTRAINT ad_module_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_module ad_module_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_module
    ADD CONSTRAINT ad_module_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_org ad_org_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_org
    ADD CONSTRAINT ad_org_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_package ad_package_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_package
    ADD CONSTRAINT ad_package_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_package ad_package_ad_module; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_package
    ADD CONSTRAINT ad_package_ad_module FOREIGN KEY (ad_module_id) REFERENCES public.ad_module(ad_module_id);


--
-- Name: ad_package ad_package_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_package
    ADD CONSTRAINT ad_package_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_tab ad_tab_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_tab
    ADD CONSTRAINT ad_tab_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_tab ad_tab_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_tab
    ADD CONSTRAINT ad_tab_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_tab ad_tab_ad_tab_parent; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_tab
    ADD CONSTRAINT ad_tab_ad_tab_parent FOREIGN KEY (ad_tab_parent_id) REFERENCES public.ad_tab(ad_tab_id);


--
-- Name: ad_tab ad_tab_ad_window; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_tab
    ADD CONSTRAINT ad_tab_ad_window FOREIGN KEY (ad_window_id) REFERENCES public.ad_window(ad_window_id);


--
-- Name: ad_table ad_table_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_table
    ADD CONSTRAINT ad_table_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_table ad_table_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_table
    ADD CONSTRAINT ad_table_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_table ad_table_ad_package; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_table
    ADD CONSTRAINT ad_table_ad_package FOREIGN KEY (ad_package_id) REFERENCES public.ad_package(ad_package_id);


--
-- Name: ad_user ad_user_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_user
    ADD CONSTRAINT ad_user_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_user ad_user_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_user
    ADD CONSTRAINT ad_user_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- Name: ad_window ad_window_ad_client; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_window
    ADD CONSTRAINT ad_window_ad_client FOREIGN KEY (ad_client_id) REFERENCES public.ad_client(ad_client_id);


--
-- Name: ad_window ad_window_ad_org; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ad_window
    ADD CONSTRAINT ad_window_ad_org FOREIGN KEY (ad_org_id) REFERENCES public.ad_org(ad_org_id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

