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

        row.discount = 0.0;
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

    model.prototype.udpateTotalH = async function (row, theader, op) {
        var tlines = db.sequelize.models['c_orderline'];
        var header = await theader.findOne({ where: { c_order_id: row.c_order_id } });
        var lines = await tlines.findAll({ where: { c_order_id: row.c_order_id } });

        if (op === 'D')
            lines = lines.filter(o => {
                return (o.c_orderline_id !== row.c_orderline_id)
            });


        header = header.dataValues;

        header.discount = 0.0;
        header.subtotal = 0.0;
        header.tax = 0.0;
        header.total = 0.0;
        for (var i = 0; i < lines.length; i++) {
            header.discount = parseFloat(header.discount) + parseFloat(lines[i].discount);
            header.subtotal = parseFloat(header.subtotal) + parseFloat(lines[i].subtotal);
            header.tax = parseFloat(header.tax) + parseFloat(lines[i].linetax);
            header.total = parseFloat(header.total) + parseFloat(lines[i].linetotal);
        }

        delete header.updated;
        delete header.created;
        await theader.update(header, { where: { c_order_id: row.c_order_id } });
        /*console.log('header: ', header);*/
    };


    model.afterCreate(async (row) => {
        console.log('afterCreate c_orderline');
        var c_order = db.sequelize.models['c_order'];
        row.udpateTotalH(row, c_order);
    });

    model.afterUpdate(async (row) => {
        console.log('afterUpdate c_orderline');
        var c_order = db.sequelize.models['c_order'];
        row.udpateTotalH(row, c_order);
    });

    model.afterDestroy(async (row) => {
        console.log('afterDestroy c_orderline');
        var c_order = db.sequelize.models['c_order'];
        row.udpateTotalH(row, c_order, 'D');
    });
}