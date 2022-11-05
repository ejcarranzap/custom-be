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
            row.cost = product.cost;
            row.discount = 0.0;
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
    model.prototype.udpateTotalH = function (row, theader, op) {
        return __awaiter(this, void 0, void 0, function* () {
            var tlines = db.sequelize.models['c_orderline'];
            var header = yield theader.findOne({ where: { c_order_id: row.c_order_id } });
            var lines = yield tlines.findAll({ where: { c_order_id: row.c_order_id } });
            if (op === 'D')
                lines = lines.filter(o => {
                    return (o.c_orderline_id !== row.c_orderline_id);
                });
            header = header.dataValues;
            header.discount = 0.0;
            header.subtotal = 0.0;
            header.tax = 0.0;
            header.total = 0.0;
            for (var i = 0; i < lines.length; i++) {
                header.discount = parseFloat(header.discount) + parseFloat(lines[i].discount);
                header.subtotal = parseFloat(header.subtotal) + parseFloat(lines[i].subtotal);
                header.tax = parseFloat(header.tax) + parseFloat(lines[i].linetax);
                header.total = parseFloat(header.total) + parseFloat(lines[i].linetotal);
            }
            delete header.updated;
            delete header.created;
            yield theader.update(header, { where: { c_order_id: row.c_order_id } });
            /*console.log('header: ', header);*/
        });
    };
    model.afterCreate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('afterCreate c_orderline');
        var c_order = db.sequelize.models['c_order'];
        row.udpateTotalH(row, c_order);
    }));
    model.afterUpdate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('afterUpdate c_orderline');
        var c_order = db.sequelize.models['c_order'];
        row.udpateTotalH(row, c_order);
    }));
    model.afterDestroy((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('afterDestroy c_orderline');
        var c_order = db.sequelize.models['c_order'];
        row.udpateTotalH(row, c_order, 'D');
    }));
};
//# sourceMappingURL=c_orderline_hook.js.map