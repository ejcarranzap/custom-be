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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.fin_cashup_btn_printProcess = void 0;
const file_type_1 = __importDefault(require("file-type"));
class fin_cashup_btn_printProcess {
    constructor(app) {
        this.app = app;
        this.printDocument = (data) => __awaiter(this, void 0, void 0, function* () {
            var app = this.app;
            try {
                var file_ = 'rpt_' + data.table + '_' + data.action.name;
                var type_ = data.mimeType;
                var comand = app.report.generateReport(file_, data.data, type_);
                var exec = require('child_process').exec, buffer, mime;
                console.log(comand);
                return yield new Promise(function (resolve, reject) {
                    exec(comand, { cwd: app.libsPath }, (error, stdout, stderr) => __awaiter(this, void 0, void 0, function* () {
                        if (error) {
                            reject(error);
                            return;
                        }
                        buffer = Buffer.from(stdout, 'base64');
                        /*mime = 'application/pdf'*/
                        mime = yield file_type_1.default.fromBuffer(buffer);
                        resolve(buffer);
                    }));
                });
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        });
    }
    run(params) {
        return __awaiter(this, void 0, void 0, function* () {
            /*console.log('ad_table_btn_getcolProcess action called...', params)*/
            return yield this.print(params);
        });
    }
    print(params) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var ds = yield me.printDocument(params);
            return ds;
        });
    }
}
exports.fin_cashup_btn_printProcess = fin_cashup_btn_printProcess;
//# sourceMappingURL=fin_cashup_btn_printProcess.js.map