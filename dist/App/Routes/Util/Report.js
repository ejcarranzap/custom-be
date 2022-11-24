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
const FileType = require('file-type');
module.exports = (app) => {
    const fs = require('fs');
    return {
        path: '/api/Report',
        method: 'GET',
        options: {
            auth: false,
            cors: true,
        },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            try {
                var file_ = 'Report1Psql';
                var comand = app.report.generateReport(file_, {}, 'pdf');
                var exec = require('child_process').exec, buffer, mime;
                mime = {
                    mime: 'application/pdf'
                };
                console.log(comand);
                return h.response(yield new Promise(function (resolve, reject) {
                    exec(comand, { cwd: app.libsPath }, (error, stdout, stderr) => __awaiter(this, void 0, void 0, function* () {
                        if (error) {
                            reject(error);
                            return;
                        }
                        buffer = Buffer.from(stdout, 'base64');
                        /*mime = 'application/pdf'*/
                        /*mime = await FileType.fromBuffer(buffer)*/
                        resolve(buffer);
                    }));
                })).header('Content-Type', mime.mime).header('Cache-Control', 'no-cache');
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=Report.js.map