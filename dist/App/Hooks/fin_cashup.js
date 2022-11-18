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
    var model = db.sequelize.models['fin_cashup'];
    model.prototype.validateIsComplete = function (row) {
        return __awaiter(this, void 0, void 0, function* () {
            if (row.previous('iscomplete') == 'Y') {
                throw new Error('El pedido esta completo no se puede modificar.');
            }
        });
    };
    model.beforeCreate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeCreate fin_cashup');
        row.validateIsComplete(row);
        var ds;
        var t = yield db.sequelize.transaction({ autocommit: false });
        db.sequelize.query('SELECT fn_gen_seq(\'CASH-\',\'' + row.constructor.name + '\',\'documentno\');', { transaction: t });
        var ds = yield db.sequelize.query('FETCH ALL IN "ref_data";', { transaction: t });
        t.commit();
        row.documentno = ds[0][0].seq;
        row.series = 'CASH';
    }));
    model.beforeUpdate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeUpdate fin_cashup');
        yield row.validateIsComplete(row);
    }));
    model.beforeDestroy((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeDestroy fin_cashup');
        yield row.validateIsComplete(row);
    }));
    model.afterUpdate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('afterUpdate fin_cashup');
    }));
};
//# sourceMappingURL=fin_cashup.js.map