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
    var model = db.sequelize.models['c_orderline'];
    model.prototype.generateTotals = function (row) {
        return __awaiter(this, void 0, void 0, function* () {
            var m_product = db.sequelize.models['m_product'];
            var product = yield m_product.findOne({ where: { m_product_id: row.m_product_id }, order: [] });
            var c_order = db.sequelize.models['c_order'];
            var order = yield c_order.findOne({ where: { c_order_id: row.c_order_id } });
            if (order.iscomplete == 'Y') {
                throw new Error('El pedido esta completo no se puede modificar.');
            }
            row.price = product.price;
            row.cost = product.cost * row.qty;
            row.linetotal = product.price * row.qty;
            row.linetax = row.linetotal * 0.12;
            row.subtotal = row.linetotal - row.linetax;
        });
    };
    model.prototype.validateIsComplete = function (row) {
        return __awaiter(this, void 0, void 0, function* () {
            if (row.previous('iscomplete') == 'Y') {
                throw new Error('El pedido esta completo no se puede modificar.');
            }
        });
    };
    model.beforeCreate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeCreate c_orderline');
        yield row.generateTotals(row);
    }));
    model.beforeUpdate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeUpdate c_orderline');
        yield row.generateTotals(row);
    }));
    model.beforeDestroy((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeDestroy c_order');
        var c_order = db.sequelize.models['c_order'];
        var order = yield c_order.findOne({ where: { c_order_id: row.c_order_id } });
        yield row.validateIsComplete(order);
    }));
};
//# sourceMappingURL=c_orderline_hook.js.map