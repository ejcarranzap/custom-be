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
exports.ad_table_btn_getcolProcess = void 0;
class ad_table_btn_getcolProcess {
    constructor(app) {
        this.app = app;
        this.getDBObjects = (data) => __awaiter(this, void 0, void 0, function* () {
            var app = this.app;
            try {
                yield app.db.sequelize.query('SELECT fn_generate_column(\'' + data.data.ad_table_id + '\',\'' + data.action.name + '\');', {});
                return { success: true, data: [] };
            }
            catch (e) {
                console.log(e.message);
                throw new Error(e.stack);
            }
        });
    }
    run(params) {
        return __awaiter(this, void 0, void 0, function* () {
            /*console.log('ad_table_btn_getcolProcess action called...', params)*/
            return yield this.generateCols(params);
        });
    }
    generateCols(params) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var ds = yield me.getDBObjects(params);
            return ds;
        });
    }
}
exports.ad_table_btn_getcolProcess = ad_table_btn_getcolProcess;
//# sourceMappingURL=ad_table_btn_getcolProcess.js.map