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
        path: '/api/Uploads',
        method: 'GET',
        options: {
            auth: false,
            cors: true
        },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            try {
                var res = request.payload;
                console.log('Uploads', res);
                return h.file('files/ic_user.png', { confine: false });
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=Uploads.js.map