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
    model.beforeCreate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeCreate c_orderline');
        var m_product = db.sequelize.models['m_product'];
        var product = yield m_product.findOne({ where: { m_product_id: row.m_product_id }, order: [] });
        row.price = product.price;
        row.cost = product.cost;
    }));
    model.beforeUpdate((row) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('beforeUpdate c_orderline');
        var m_product = db.sequelize.models['m_product'];
        var product = yield m_product.findOne({ where: { m_product_id: row.m_product_id }, order: [] });
        row.price = product.price;
        row.cost = product.cost;
    }));
};
//# sourceMappingURL=c_orderline_hook.js.map