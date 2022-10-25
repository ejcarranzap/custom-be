'use strict';

export = (db) => {
    var model = db.sequelize.models['fin_cashupmtype'];

    model.beforeCreate(async (row) => {
        console.log('beforeCreate fin_cashupmtype');
        var ds;
        var t = await db.sequelize.transaction({ autocommit: false });

        db.sequelize.query('SELECT fn_gen_seq(\'CT\',\'' + row.constructor.name + '\',\'value\');', { transaction: t });
        var ds = await db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();

        row.value = ds[0][0].seq;
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate fin_cashupmtype');
    });

    model.beforeDestroy(async (row) => {
        console.log('beforeDestroy fin_cashup');
    });
}