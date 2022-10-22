DROP TABLE IF EXISTS m_movementline;
DROP TABLE IF EXISTS m_movement;
DROP TABLE IF EXISTS m_movementtype;
DROP TABLE IF EXISTS fin_cashupline;
DROP TABLE IF EXISTS fin_cashup;
DROP TABLE IF EXISTS fin_cashupmtype;
DROP TABLE IF EXISTS c_orderline;
DROP TABLE IF EXISTS c_order;
DROP TABLE IF EXISTS m_product;
DROP TABLE IF EXISTS m_product_category;
DROP TABLE IF EXISTS c_uom;
DROP TABLE IF EXISTS fin_paymentmethod;
DROP TABLE IF EXISTS c_bpartner;

CREATE TABLE c_uom(
	c_uom_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,	
	CONSTRAINT c_uom_key PRIMARY KEY(c_uom_id),
	CONSTRAINT c_uom_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_uom_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE m_product_category(
	m_product_category_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,	
	CONSTRAINT m_product_category_key PRIMARY KEY(m_product_category_id),
	CONSTRAINT m_product_category_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_product_category_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE m_product(
	m_product_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	m_product_category_id CHARACTER VARYING(32) NOT NULL,
	c_uom_id CHARACTER VARYING(32) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	price NUMERIC(19,10) NOT NULL,
	cost NUMERIC(19,10) NOT NULL,
	qty NUMERIC(19,10) NOT NULL,
	image CHARACTER VARYING(255) NOT NULL,
	CONSTRAINT m_product_key PRIMARY KEY(m_product_id),
	CONSTRAINT m_product_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_product_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_product_m_product_category FOREIGN KEY (m_product_category_id) REFERENCES m_product_category (m_product_category_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_product_c_uom FOREIGN KEY (c_uom_id) REFERENCES c_uom (c_uom_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE fin_paymentmethod(
	fin_paymentmethod_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,	
	CONSTRAINT fin_paymentmethod_key PRIMARY KEY(fin_paymentmethod_id),
	CONSTRAINT fin_paymentmethod_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_paymentmethod_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_bpartner(
	c_bpartner_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,	
	last CHARACTER VARYING(100) NOT NULL,
	taxid CHARACTER VARYING(20) NOT NULL,
	uid CHARACTER VARYING(50) NOT NULL,
	email CHARACTER VARYING(50) NOT NULL,
	iscustomer CHARACTER VARYING(1) CHECK(iscustomer IN('Y','N')),
	isvendor CHARACTER VARYING(1) CHECK(isvendor IN('Y','N')),
	CONSTRAINT c_bpartner_key PRIMARY KEY(c_bpartner_id),
	CONSTRAINT c_bpartner_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bpartner_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_order(
	c_order_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	c_bpartner_id CHARACTER VARYING(32) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	issotrx CHARACTER VARYING(1) CHECK(issotrx IN('Y','N')), 
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	dateordered TIMESTAMP NOT NULL DEFAULT NOW(),	
	documentno CHARACTER VARYING(32),
	number CHARACTER VARYING(32), 
	series CHARACTER VARYING(32),
	uuid CHARACTER VARYING(255),
	xml XML,
	subtotal NUMERIC(19,10),
	discount NUMERIC(19,10),
	tax NUMERIC(19,10),
	total NUMERIC(19,10),
	comment CHARACTER VARYING(255) NOT NULL,
	iscomplete CHARACTER VARYING(1) CHECK(iscomplete IN('Y','N')), 
	CONSTRAINT c_order_key PRIMARY KEY(c_order_id),
	CONSTRAINT c_order_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_order_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_order_c_bpartner FOREIGN KEY (c_bpartner_id) REFERENCES c_bpartner(c_bpartner_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_orderline(
	c_orderline_id CHARACTER VARYING(32) NOT NULL,
	c_order_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,		
	m_product_id CHARACTER VARYING(32) NOT NULL,		
	c_uom_id CHARACTER VARYING(32) NOT NULL,		
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	qty NUMERIC(19,10) NOT NULL,
	cost NUMERIC(19,10) NOT NULL,
	price NUMERIC(19,10) NOT NULL,
	subtotal NUMERIC(19,10),
	discount NUMERIC(19,10),
	linetax NUMERIC(19,10),
	linetotal NUMERIC(19,10),
	CONSTRAINT c_orderline_key PRIMARY KEY(c_orderline_id),
	CONSTRAINT c_orderline_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_orderline_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_orderline_c_order FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_orderline_m_product FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_orderline_c_uom FOREIGN KEY (c_uom_id) REFERENCES c_uom(c_uom_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE m_movementtype(
	m_movementtype_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,	
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	CONSTRAINT m_movementtype_key PRIMARY KEY(m_movementtype_id),
	CONSTRAINT m_movementtype_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movementtype_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE m_movement(
	m_movement_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	m_movementtype_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	movementdate TIMESTAMP NOT NULL DEFAULT NOW(),	
	documentno CHARACTER VARYING(32) NOT NULL,
	series CHARACTER VARYING(32) NOT NULL,	
	comment CHARACTER VARYING(255) NOT NULL,
	iscomplete CHARACTER VARYING(1) CHECK(iscomplete IN('Y','N')), 
	CONSTRAINT m_movement_key PRIMARY KEY(m_movement_id),
	CONSTRAINT m_movement_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movement_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movement_m_movementtype FOREIGN KEY (m_movementtype_id) REFERENCES m_movementtype(m_movementtype_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION	
);

CREATE TABLE m_movementline(
	m_movementline_id CHARACTER VARYING(32) NOT NULL,
	m_movement_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,		
	m_product_id CHARACTER VARYING(32) NOT NULL,		
	c_uom_id CHARACTER VARYING(32) NOT NULL,		
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	qty NUMERIC(19,10) NOT NULL,
	cost NUMERIC(19,10) NOT NULL,
	price NUMERIC(19,10) NOT NULL,	
	CONSTRAINT m_movementline_key PRIMARY KEY(m_movementline_id),
	CONSTRAINT m_movementline_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movementline_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movementline_m_movement FOREIGN KEY (m_movement_id) REFERENCES m_movement(m_movement_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movementline_m_product FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_movementline_c_uom FOREIGN KEY (c_uom_id) REFERENCES c_uom(c_uom_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE fin_cashupmtype(
	fin_cashupmtype_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,	
	value CHARACTER VARYING(50) NOT NULL,
	name CHARACTER VARYING(100) NOT NULL,
	CONSTRAINT fin_cashupmtype_key PRIMARY KEY(fin_cashupmtype_id),
	CONSTRAINT fin_cashupmtype_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_cashupmtype_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE fin_cashup(
	fin_cashup_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,	
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	cashupdate TIMESTAMP NOT NULL DEFAULT NOW(),	
	documentno CHARACTER VARYING(32) NOT NULL,
	series CHARACTER VARYING(32) NOT NULL,	
	comment CHARACTER VARYING(255) NOT NULL,
	CONSTRAINT fin_cashup_key PRIMARY KEY(fin_cashup_id),
	CONSTRAINT fin_cashup_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_cashup_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION	
);

CREATE TABLE fin_cashupline(
	fin_cashupline_id CHARACTER VARYING(32) NOT NULL,
	fin_cashup_id CHARACTER VARYING(32) NOT NULL,
	fin_cashupmtype_id CHARACTER VARYING(32) NOT NULL,
	fin_paymentmethod_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	reference CHARACTER VARYING(32) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	amount NUMERIC(19,10) NOT NULL,
	comment CHARACTER VARYING(255) NOT NULL,
	CONSTRAINT fin_cashupline_key PRIMARY KEY(fin_cashupline_id),
	CONSTRAINT fin_cashupline_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_cashupline_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_cashupline_fin_cashup FOREIGN KEY (fin_cashup_id) REFERENCES fin_cashup(fin_cashup_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT fin_cashupline_fin_cashupmtype FOREIGN KEY (fin_cashupmtype_id) REFERENCES fin_cashupmtype(fin_cashupmtype_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_cashupline_fin_paymentmethod FOREIGN KEY (fin_paymentmethod_id) REFERENCES fin_paymentmethod(fin_paymentmethod_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION	
);

