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
                var exec = require('child_process').exec, child;
                var comand = app.report.generateReport(file_, {});
                child = exec(comand, { cwd: '//home//jonatanc//node-projects//libs//' }, function (error, stdout, stderr) {
                    try {
                        //console.log('stdout: ' + stdout);
                        console.log('stderr: ' + stderr);
                        if (error !== null) {
                            console.log('exec error: ' + error);
                        }
                        const buf = Buffer.from(stdout, 'base64');
                        return buf;
                    }
                    catch (e) {
                        throw new Error(e.message);
                    }
                });
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=Report.js.map