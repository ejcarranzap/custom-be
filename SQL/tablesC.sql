--ALTER TABLE m_warehouse ADD CONSTRAINT UNIQUE(m_warehouse_id);

DROP TABLE IF EXISTS m_warehouse_stock;

CREATE TABLE m_warehouse_stock
(
    m_warehouse_stock_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
	m_warehouse_id CHARACTER VARYING(32) NOT NULL,
	m_product_id CHARACTER VARYING(32) NOT NULL,
	qty NUMERIC(19,10),
    CONSTRAINT m_warehouse_stock_key PRIMARY KEY(m_warehouse_stock_id),
    CONSTRAINT m_warehouse_stock_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_warehouse_stock_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_warehouse_stock_m_warehouse FOREIGN KEY (m_warehouse_id) REFERENCES m_warehouse(m_warehouse_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_warehouse_stock_m_product FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT m_warehouse_stock_unique UNIQUE(m_warehouse_id,m_product_id)
);

DROP TABLE IF EXISTS ad_windowtype;

CREATE TABLE ad_windowtype
(
    ad_windowtype_id CHARACTER VARYING(32) NOT NULL,
    ad_org_id CHARACTER VARYING(32) NOT NULL,
    ad_client_id CHARACTER VARYING(32) NOT NULL,
    isactive CHARACTER VARYING(1) CHECK(isactive IN('Y','N')),
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    createdby CHARACTER VARYING(32) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedby CHARACTER VARYING(32) NOT NULL,
	value CHARACTER VARYING(50) NULL,
	name CHARACTER VARYING(100) NULL,
    CONSTRAINT ad_windowtype_key PRIMARY KEY(ad_windowtype_id),
    CONSTRAINT ad_windowtype_ad_client FOREIGN KEY (ad_client_id) REFERENCES ad_client(ad_client_id)
    MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT ad_windowtype_ad_org FOREIGN KEY (ad_org_id) REFERENCES ad_org(ad_org_id)
	MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);