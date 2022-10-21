'use strict';

export = (db) => {
    var model = db.sequelize.models['c_orderline'];    
    
    model.beforeCreate(async (row) => {
        console.log('beforeCreate c_orderline');
        var m_product = db.sequelize.models['m_product'];
        var product = await m_product.findOne({ where: {m_product_id:  row.m_product_id }, order: [] });
        row.price = product.price;
        row.cost = product.cost;
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate c_orderline');
        var m_product = db.sequelize.models['m_product'];
        var product = await m_product.findOne({ where: {m_product_id:  row.m_product_id }, order: [] });
        row.price = product.price;
        row.cost = product.cost;
    });
}