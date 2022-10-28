'use strict';

export = (db) => {
    var model = db.sequelize.models['m_movementline'];

    model.prototype.generateTotals = async function (row) {
        var m_product = db.sequelize.models['m_product'];
        var product = await m_product.findOne({ where: { m_product_id: row.m_product_id }, order: [] });
        var m_movement = db.sequelize.models['m_movement'];
        var movement = await m_movement.findOne({ where: { m_movement_id: row.m_movement_id } });
        if (movement.iscomplete == 'Y') {
            throw new Error('El movimiento esta completo no se puede modificar.');
        }

        row.price = product.price;
        row.cost = product.cost * row.qty;
    };

    model.prototype.validateIsComplete = async function (row) {
        if (row.previous('iscomplete') == 'Y') {
            throw new Error('El movimiento esta completo no se puede modificar.')
        }
    };

    model.beforeCreate(async (row) => {
        console.log('beforeCreate m_movementline');
        await row.generateTotals(row);
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate m_movementline');
        await row.generateTotals(row);
    });

    model.beforeDestroy(async (row) => {
        console.log('beforeDestroy m_movement');
        var m_movement = db.sequelize.models['m_movement'];
        var movement = await m_movement.findOne({ where: { m_movement_id: row.m_movement_id } });
        await row.validateIsComplete(movement);
    });
}