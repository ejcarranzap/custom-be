export = (app) => {
    return {
        method: 'POST',
        path: '/api/login',
        config: { auth: false },
        handler: async (request, h) => {
            const db = app.db
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            try {
                console.log('Login')
                const res = request.payload
                var ds, dsOrg
                let model = db.sequelize.models['ad_user'];
                let modelOrg = db.sequelize.models['ad_org'];

                ds = await model.findOne({ /*transaction: t,*/ where: { name: res.name } }).then((record) => {
                    if (record && record.validPassword(res.password)) {
                        return record;
                    }
                    return null;
                });

                if (!ds) {
                    throw new Error("Login failed")
                }

                /*t.commit()*/

                dsOrg = await modelOrg.findOne({ where: { ad_org_id: (res.ad_org_id || '') } });

                if (!dsOrg) {
                    throw new Error("Invalid Organization...")
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
            } catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e);
            }
        }
    }
}