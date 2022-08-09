
DROP TABLE IF EXISTS ad_user;
CREATE TABLE ad_user(
	"id" CHARACTER VARYING(36),
	username CHARACTER VARYING(50),
	"password" CHARACTER VARYING(255),
	first_name CHARACTER VARYING(50),
	last_name CHARACTER VARYING(50),
	isactive CHARACTER VARYING(1),
	created TIMESTAMP,
	updated TIMESTAMP,
	createdby CHARACTER VARYING(50),
	updatedby CHARACTER VARYING(50)
);

INSERT INTO ad_user("id",username,"password",first_name,last_name,isactive,created,updated,createdby,updatedby)
VALUES(uuid_generate_v1(),'admin','1234','Administrador','','Y',NOW(),NOW(),'admin','admin');