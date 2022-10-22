'use strict';

export = (db) => {
    var model = db.sequelize.models['c_order'];

    model.beforeCreate(async (row) => {
        console.log('beforeCreate c_order');
        var ds;
        var t = await db.sequelize.transaction({ autocommit: false });

        db.sequelize.query('SELECT fn_gen_seq(\'SALE-\',\'' + row.constructor.name + '\',\'documentno\');', { transaction: t });
        var ds = await db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();

        row.documentno = ds[0][0].seq;
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate c_order');
        console.log(row.constructor.name);
    });
}