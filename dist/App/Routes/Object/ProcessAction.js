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
        path: '/api/ProcessAction',
        config: { auth: false },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            try {
                const jsontoken = app.JWT.decode(request.headers.authorization.split(' ')[1], app.secret);
                var res = request.payload;
                res.jsontoken = jsontoken;
                var data = yield app.callprocess.run(res);
                if (Buffer.isBuffer(data)) {
                    var mime = yield FileType.fromBuffer(data);
                    if (mime == null) {
                        mime = {};
                        mime.ext = 'txt';
                        mime.mime = 'text/plain';
                        data = data.toString('base64');
                    }
                    else if (res.mimeType == 'xls') {
                        mime.ext = 'xls';
                        mime.mime = 'application/vnd.ms-excel';
                        /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                    }
                    else if (res.mimeType == 'doc') {
                        mime.ext = 'doc';
                        mime.mime = 'application/msword';
                        /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                    }
                    return h.response(data).header('Content-Type', mime.mime).header('Cache-Control', 'no-cache');
                }
                else {
                    return { success: true, data: data, msg: 'ProcessAction' };
                }
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=ProcessAction.js.map