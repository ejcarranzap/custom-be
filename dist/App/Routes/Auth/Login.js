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
        path: '/api/login',
        config: { auth: false },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            const db = app.db;
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            try {
                console.log('Login');
                const res = request.payload;
                var ds, dsOrg;
                let model = db.sequelize.models['ad_user'];
                let modelOrg = db.sequelize.models['ad_org'];
                ds = yield model.findOne({ /*transaction: t,*/ where: { name: res.name } }).then((record) => {
                    if (record && record.validPassword(res.password)) {
                        return record;
                    }
                    return null;
                });
                if (!ds) {
                    throw new Error("Login failed");
                }
                /*t.commit()*/
                dsOrg = yield modelOrg.findOne({ where: { ad_org_id: (res.ad_org_id || '') } });
                if (!dsOrg) {
                    throw new Error("Invalid Organization...");
                }
                delete ds.dataValues.password;
                delete ds.dataValues.ad_org_id;
                delete ds.dataValues.ad_client_id;
                delete ds.dataValues.m_warehouse_id;
                ds.dataValues.ad_org_id = res.ad_org_id;
                ds.dataValues.ad_client_id = res.ad_client_id;
                ds.dataValues.ad_package_id = '0';
                ds.dataValues.org = dsOrg.dataValues.name;
                ds.dataValues.m_warehouse_id = res.m_warehouse_id;
                return { success: true, accessToken: app.JWT.sign(ds.dataValues, app.secret), user: ds.dataValues };
            }
            catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e);
            }
        })
    };
};
//# sourceMappingURL=Login.js.map