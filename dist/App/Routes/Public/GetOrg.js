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
    return {
        method: 'POST',
        path: '/api/GetOrg',
        config: { auth: false },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            try {
                const res = request.payload;
                var model = app.db.sequelize.models['ad_org'];
                var data = yield model.findAll({ where: {}, order: [] });
                return { success: true, data: data, msg: 'GetOrg' };
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=GetOrg.js.map