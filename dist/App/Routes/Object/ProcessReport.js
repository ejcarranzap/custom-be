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
    return {
        method: 'POST',
        path: '/api/ProcessReport',
        config: { auth: false },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            try {
                /*const jsontoken = app.JWT.decode(request.headers.authorization.split(' ')[1], app.secret)*/
                var res = request.payload;
                /*res.jsontoken = jsontoken*/
                var ret = yield app.callreport.run(res);
                var mime = yield FileType.fromBuffer(ret);
                if (mime == null) {
                    mime = {};
                    mime.ext = 'txt';
                    mime.mime = 'text/plain';
                    ret = ret.toString('base64');
                }
                else if (res.type == 'xls') {
                    mime.ext = 'xls';
                    mime.mime = 'application/vnd.ms-excel';
                    /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                }
                else if (res.type == 'doc') {
                    mime.ext = 'doc';
                    mime.mime = 'application/msword';
                    /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                }
                console.log('mime:', mime);
                return h.response(ret).header('Content-Type', mime.mime).header('Cache-Control', 'no-cache');
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=ProcessReport.js.map