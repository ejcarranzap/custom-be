'use strict';

export = (db) => {
    var model = db.sequelize.models['c_bpartner'];

    model.beforeCreate(async (row) => {
        console.log('beforeCreate c_bpartner');
        var ds;
        var t = await db.sequelize.transaction({ autocommit: false });

        db.sequelize.query('SELECT fn_gen_seq(\'C\',\'' + row.constructor.name + '\',\'value\');', { transaction: t });
        var ds = await db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();

        row.value = ds[0][0].seq;
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate c_bpartner');
        console.log(row.constructor.name);
    });
}