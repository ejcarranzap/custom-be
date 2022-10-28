'use strict';

export = (db) => {
    var model = db.sequelize.models['m_movementtype'];

    model.beforeCreate(async (row) => {
        console.log('beforeCreate m_movementtype');
        var ds;
        var t = await db.sequelize.transaction({ autocommit: false });

        db.sequelize.query('SELECT fn_gen_seq(\'MT\',\'m_movementtype\',\'value\');', { transaction: t });
        var ds = await db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();

        row.value = ds[0][0].seq;
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate m_movementtype');
        console.log(model);
    });
}