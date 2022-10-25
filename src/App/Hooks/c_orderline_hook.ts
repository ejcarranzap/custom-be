'use strict';

export = (db) => {
    var model = db.sequelize.models['c_orderline'];

    model.prototype.generateTotals = async function (row) {
        var m_product = db.sequelize.models['m_product'];
        var product = await m_product.findOne({ where: { m_product_id: row.m_product_id }, order: [] });
        var c_order = db.sequelize.models['c_order'];
        var order = await c_order.findOne({ where: { c_order_id: row.c_order_id } });
        if (order.iscomplete == 'Y') {
            throw new Error('El pedido esta completo no se puede modificar.');
        }

        row.price = product.price;
        row.cost = product.cost * row.qty;

        row.linetotal = product.price * row.qty;
        row.linetax = row.linetotal * 0.12;
        row.subtotal = row.linetotal - row.linetax;
    };

    model.prototype.validateIsComplete = async function (row) {
        if (row.previous('iscomplete') == 'Y') {
            throw new Error('El pedido esta completo no se puede modificar.')
        }
    };

    model.beforeCreate(async (row) => {
        console.log('beforeCreate c_orderline');
        await row.generateTotals(row);
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate c_orderline');
        await row.generateTotals(row);
    });

    model.beforeDestroy(async (row) => {
        console.log('beforeDestroy c_order');
        var c_order = db.sequelize.models['c_order'];
        var order = await c_order.findOne({ where: { c_order_id: row.c_order_id } });
        await row.validateIsComplete(order);
    });
}