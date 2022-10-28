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
exports.m_movement_btn_completeProcess = void 0;
class m_movement_btn_completeProcess {
    constructor(app) {
        this.app = app;
        this.completeOrder = (data) => __awaiter(this, void 0, void 0, function* () {
            var app = this.app;
            try {
                /*await app.db.sequelize.query('SELECT fn_complete_order(\'' + data.data.c_order_id + '\',\'' + data.jsontoken.ad_user_id + '\');', {});*/
                return { success: true, data: [] };
            }
            catch (e) {
                console.log('Error completeOrder: ', e.original);
                throw new Error(e.original);
            }
        });
    }
    run(params) {
        return __awaiter(this, void 0, void 0, function* () {
            /*console.log('ad_table_btn_getcolProcess action called...', params)*/
            return yield this.complete(params);
        });
    }
    complete(params) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var ds = yield me.completeOrder(params);
            return ds;
        });
    }
}
exports.m_movement_btn_completeProcess = m_movement_btn_completeProcess;
//# sourceMappingURL=m_movement_btn_completeProcess.js.map