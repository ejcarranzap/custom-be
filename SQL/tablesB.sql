CREATE TABLE c_location
(
    c_location_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT c_location_key PRIMARY KEY(c_location_id),
    CONSTRAINT c_location_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_location_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE m_warehouse
(
    m_warehouse_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
	c_location_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT m_warehouse_key PRIMARY KEY(m_warehouse_id),
    CONSTRAINT m_warehouse_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_warehouse_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_warehouse_c_location FOREIGN KEY (c_location_id) REFERENCES c_location(c_location_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE m_inventorytype
(
    m_inventorytype_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT m_inventorytype_key PRIMARY KEY(m_inventorytype_id),
    CONSTRAINT m_inventorytype_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventorytype_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION	
);

CREATE TABLE m_inventory(
	m_inventory CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,
	m_warehouse_id CHARACTER VARYING(32) NOT NULL,
	m_inventorytype CHARACTER VARYING(32) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	movementdate TIMESTAMP NOT NULL DEFAULT NOW(),	
	documentno CHARACTER VARYING(32),
	number CHARACTER VARYING(32), 
	series CHARACTER VARYING(32),	
	comment CHARACTER VARYING(255) NOT NULL,
	iscomplete CHARACTER VARYING(1) CHECK(iscomplete IN('Y','N')), 
	btn_complete CHARACTER VARYING(1),
	CONSTRAINT m_inventory_key PRIMARY KEY(m_inventory_id),
	CONSTRAINT m_inventory_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventory_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT m_inventory_m_warehouse FOREIGN KEY (m_warehouse_id) REFERENCES m_warehouse(m_warehouse_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT m_inventory_m_inventorytype FOREIGN KEY (m_inventorytype_id) REFERENCES m_inventorytype(m_inventorytype_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION	
);

CREATE TABLE m_inventoryline(
	m_inventoryline_id CHARACTER VARYING(32) NOT NULL,
	m_inventory_id CHARACTER VARYING(32) NOT NULL,
	ad_org_id CHARACTER VARYING(32) NOT NULL,
	ad_client_id CHARACTER VARYING(32) NOT NULL,		
	m_product_id CHARACTER VARYING(32) NOT NULL,	
	reference CHARACTER VARYING(32) NOT NULL,	
	c_uom_id CHARACTER VARYING(32) NOT NULL,		
	c_location_id CHARACTER VARYING(32) NOT NULL,
	c_locationfrom CHARACTER VARYING(32) NOT NULL,
	isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
	created TIMESTAMP NOT NULL DEFAULT NOW(),
	createdby CHARACTER VARYING(32) NOT NULL,
	updated TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedby CHARACTER VARYING(32) NOT NULL,
	qty NUMERIC(19,10) NOT NULL,
	cost NUMERIC(19,10) NOT NULL,
	price NUMERIC(19,10) NOT NULL,	
	CONSTRAINT m_inventoryline_key PRIMARY KEY(c_orderline_id),
	CONSTRAINT m_inventoryline_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id) 
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventoryline_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventoryline_m_inventory FOREIGN KEY (m_inventory_id) REFERENCES m_inventory(m_inventory_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventoryline_m_product FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventoryline_c_uom FOREIGN KEY (c_uom_id) REFERENCES c_uom(c_uom_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventoryline_c_location FOREIGN KEY (c_location_id) REFERENCES c_location(c_location_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_inventoryline_c_locationfrom FOREIGN KEY (c_location_id) REFERENCES c_location(c_location_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_currency
(
    c_currency_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT c_currency_key PRIMARY KEY(c_currency_id),
    CONSTRAINT c_currency_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_currency_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_bankmtype
(
    c_bankmtype_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT c_bankmtype_key PRIMARY KEY(c_bankmtype_id),
    CONSTRAINT c_bankmtype_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankmtype_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_bank
(
    c_bank_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
	balance NUMERIC(19,10) NOT NULL,
    CONSTRAINT c_bank_key PRIMARY KEY(c_bank_id),
    CONSTRAINT c_bank_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bank_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_bankaccount
(
    c_bankaccount_id CHARACTER VARYING(32) NOT NULL,
	c_bank_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
	c_currency_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT c_bankaccount_key PRIMARY KEY(c_bankaccount_id),
    CONSTRAINT c_bankaccount_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankaccount_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankaccount_c_bank FOREIGN KEY (c_bank_id) REFERENCES c_bank(c_bank_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankaccount_c_currency FOREIGN KEY (c_currency_id) REFERENCES c_currency(c_currency_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_bankmovement
(
	c_bankmovement CHARACTER VARYING(32) NOT NULL,    
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
	c_bankaccount_id CHARACTER VARYING(32) NOT NULL,
	c_bankmtype_id CHARACTER VARYING(32) NOT NULL,
	c_bankstatement_id CHARACTER VARYING(32) NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    movementdate TIMESTAMP NOT NULL DEFAULT NOW(),
	comment CHARACTER VARYING(255) NOT NULL,
	amount NUMERIC(19,10) NOT NULL,
    CONSTRAINT c_bankmovement_key PRIMARY KEY(c_bankmovement_id),
    CONSTRAINT c_bankmovement_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankmovement_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankmovement_c_bankaccount FOREIGN KEY (c_bankaccount_id) REFERENCES c_bankaccount(c_bankaccount_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankmovement_c_bankmtype FOREIGN KEY (c_bankmtype_id) REFERENCES c_bankmtype(c_bankmtype_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankmovement_c_bankstatement FOREIGN KEY (c_bankstatement_id) REFERENCES c_bankstatement(c_bankstatement_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE c_bankstatement
(
    c_bankstatement_id CHARACTER VARYING(32) NOT NULL,	
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
	c_bankaccount_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
	balance NUMERIC(19,10) NOT NULL,
	prevbalance NUMERIC(19,10) NOT NULL,
    CONSTRAINT c_bankstatement_key PRIMARY KEY(c_bankstatement_id),
    CONSTRAINT c_bankstatement_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankstatement_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_bankstatement_c_bankaccount FOREIGN KEY (c_bankaccount_id) REFERENCES c_bankaccount(c_bankaccount_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE fin_expensetype
(
    fin_expensetype_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT fin_expensetype_key PRIMARY KEY(fin_expensetype_id),
    CONSTRAINT fin_expensetype_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_expensetype_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE fin_expense
(
	fin_expense CHARACTER VARYING(32) NOT NULL,    
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
	fin_expensetype_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
    value CHARACTER VARYING(50) NOT NULL,
    name CHARACTER VARYING(100) NOT NULL,
	comment CHARACTER VARYING(255) NOT NULL,
	amount NUMERIC(19,10) NOT NULL,
    CONSTRAINT fin_expense_key PRIMARY KEY(fin_expense_id),
    CONSTRAINT fin_expense_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_expense_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fin_expense_fin_expensetype FOREIGN KEY (fin_expensetype_id) REFERENCES fin_expensetype(fin_expensetype_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);




