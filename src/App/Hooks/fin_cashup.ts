'use strict';

export = (db) => {
    var model = db.sequelize.models['fin_cashup'];

    model.prototype.validateIsComplete = async function (row) {
        if (row.previous('iscomplete') == 'Y') {
            throw new Error('El pedido esta completo no se puede modificar.')
        }
    };

    model.beforeCreate(async (row) => {
        console.log('beforeCreate fin_cashup');

        row.validateIsComplete(row);

        var ds;
        var t = await db.sequelize.transaction({ autocommit: false });

        db.sequelize.query('SELECT fn_gen_seq(\'CASH-\',\'' + row.constructor.name + '\',\'documentno\');', { transaction: t });
        var ds = await db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();

        row.documentno = ds[0][0].seq;
        row.series = 'CASH'
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate fin_cashup');
        await row.validateIsComplete(row);
    });

    model.beforeDestroy(async (row) => {
        console.log('beforeDestroy fin_cashup');
        await row.validateIsComplete(row);
    });

    model.afterUpdate(async (row) => {
        console.log('afterUpdate fin_cashup');
    });
}