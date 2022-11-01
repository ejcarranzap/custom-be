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
        row.password = row.generateHash(row.password);
        console.log('password: ' + row.password.toString());                
        var res = await db.sequelize.query('SELECT fn_get_user_code()');
        if (!row.value) row.value = res[0][0]['fn_get_user_code'];

    });

    model.beforeUpdate((row) => {
        console.log('beforeUpdate');
        var pass = row.generateHash(row.password);
        var passChanged = row.validPassword(row.password, pass);        
        if (passChanged)
            row.password = pass;        
        console.log('endBeforeUpdate');
    });

    return model;
}