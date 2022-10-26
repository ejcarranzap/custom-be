'use strict';

export = (db) => {
    var model = db.sequelize.models['fin_cashup'];

    model.beforeCreate(async (row) => {
        console.log('beforeCreate fin_cashup');
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
    });

    model.beforeDestroy(async (row) => {
        console.log('beforeDestroy fin_cashup');
    });
}