'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
module.exports = (db) => {
    var model = db.sequelize.models['ad_user'];
    model.prototype.generateHash = function (password) {
        var salt = db.bcrypt.genSaltSync(10);
        return db.bcrypt.hashSync(password, salt);
    };
    model.prototype.validPassword = function (password) {
        console.log('password compare: ', password, this.password);
        return db.bcrypt.compareSync(password, this.password);
    };
    model.beforeCreate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeCreate');
        row.password = row.generateHash(row.password);
        console.log('password: ' + row.password.toString());
        var res = yield db.sequelize.query('SELECT fn_get_user_code()');
        if (!row.value)
            row.value = res[0][0]['fn_get_user_code'];
    }));
    model.beforeUpdate((row) => {
        console.log('beforeUpdate');
        var pass = row.generateHash(row.password);
        var passChanged = row.validPassword(row.password, pass);
        if (passChanged)
            row.password = pass;
        console.log('endBeforeUpdate');
    });
    return model;
};
//# sourceMappingURL=ad_user_hook.js.map