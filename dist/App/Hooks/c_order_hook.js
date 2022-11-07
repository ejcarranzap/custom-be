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
    var model = db.sequelize.models['c_order'];
    model.prototype.validateIsComplete = function (row) {
        return __awaiter(this, void 0, void 0, function* () {
            if (row.previous('iscomplete') == 'Y') {
                throw new Error('El pedido esta completo no se puede modificar.');
            }
        });
    };
    model.beforeCreate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeCreate c_order');
        var ds;
        var t = yield db.sequelize.transaction({ autocommit: false });
        if (row.isstrx == 'Y') {
            db.sequelize.query('SELECT fn_gen_seq(\'SALE-\',\'' + row.constructor.name + '\',\'documentno\');', { transaction: t });
        }
        else {
            db.sequelize.query('SELECT fn_gen_seq(\'PRCH-\',\'' + row.constructor.name + '\',\'documentno\');', { transaction: t });
        }
        var ds = yield db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();
        row.documentno = ds[0][0].seq;
    }));
    model.beforeUpdate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeUpdate c_order');
        yield row.validateIsComplete(row);
    }));
    model.beforeDestroy((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeDestroy c_order');
        yield row.validateIsComplete(row);
    }));
};
//# sourceMappingURL=c_order_hook.js.map