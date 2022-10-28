'use strict';

export = (db) => {
    var model = db.sequelize.models['m_movement'];

    model.beforeCreate(async (row) => {
        console.log('beforeCreate m_movement');
        var ds;
        var t = await db.sequelize.transaction({ autocommit: false });

        db.sequelize.query('SELECT fn_gen_seq(\'M\',\'m_movement\',\'documentno\');', { transaction: t });
        var ds = await db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();

        row.documentno = ds[0][0].seq;
        row.series = 'M';
    });

    model.beforeUpdate(async (row) => {
        console.log('beforeUpdate m_movement');
        console.log(model);
    });
}