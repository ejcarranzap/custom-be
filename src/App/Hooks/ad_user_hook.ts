'use strict';

export = (db) => {
    var model = db.sequelize.models['ad_user'];

    model.prototype.generateHash = function (password) {
        var salt = db.bcrypt.genSaltSync(10);
        return db.bcrypt.hashSync(password, salt);
    };

    model.prototype.validPassword = function (password) {
        console.log('password compare: ', password, this.password);
        return db.bcrypt.compareSync(password, this.password);
    };


    model.beforeCreate(async (row) => {
        console.log('beforeCreate');
        /*row.id = db.uuid();*/
        row.password = row.generateHash(row.password);
        console.log('password: ' + row.password.toString());
        row.createdby = row.id;
        row.updatedby = row.id;
        if (!row.ad_org_id) row.ad_org_id = '0';
        if (!row.ad_client_id) row.ad_client_id = '0';
        if (!row.createdby) row.createdby = '0';
        if (!row.updatedby) row.updatedby = '0';
        var res = await db.sequelize.query('SELECT fn_get_user_code()');
        /*console.log('value: ', res);*/
        if (!row.value) row.value = res[0][0]['fn_get_user_code'];

    });

    model.beforeUpdate((row) => {
        console.log('beforeUpdate');
        var pass = row.generateHash(row.password);
        var passChanged = row.validPassword(row.password, pass);
        console.log('beforeUpdate 0');
        var current = db.sequelize.fn('NOW');
        console.log('beforeUpdate 1');
        var previous = row._previousDataValues;
        console.log('beforeUpdate 2');
        if (passChanged)
            row.password = pass;
        row.created = previous.created;
        row.updated = current;
        console.log('endBeforeUpdate');
    });

    return model;
}