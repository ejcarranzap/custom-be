"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WindowGen = void 0;
class WindowGen {
    constructor(app) {
        this.app = app;
    }
    getWindowById(id) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var app = me.app;
            var t = yield app.db.sequelize.transaction({ autocommit: false });
            try {
                var ds, ret, values;
                ds = yield app.db.sequelize.models['ad_window'].findOne({ transaction: t, where: { ad_window_id: id } });
                values = ds.dataValues;
                ret = {};
                ret.id = values.ad_window_id;
                ret.description = values.description;
                ret.active = (values.isactive == 'Y' ? 1 : 0);
                t.commit();
                return { data: ret };
            }
            catch (e) {
                t.rollback();
                throw new Error(e.stack);
            }
        });
    }
}
exports.WindowGen = WindowGen;
//# sourceMappingURL=WindowGen.js.map