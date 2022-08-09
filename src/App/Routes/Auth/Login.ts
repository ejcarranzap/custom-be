export = (app) => {
    return {
        method: 'POST',
        path: '/api/login',
        config: { auth: false },
        handler: async (request, h) => {
            const db = app.db
            var t = await db.sequelize.transaction({ autocommit: false });
            try {
                const res = request.payload
                var ds
                let model = db.sequelize.models['ad_user'];
                ds = await model.findOne({ transaction: t, where: { name: res.name } }).then((record) => {
                    if (record && record.validPassword(res.password)) {
                        return record;
                    }
                    return null;
                });

                if(!ds) {
                    throw new Error("Usuario/Password Invalido")
                }

                t.commit()

                delete ds.dataValues.password;
                return { success: true, accessToken: app.JWT.sign(ds.dataValues, app.secret), userToReturn: ds.dataValues };
            } catch (e) {
                console.log(e.stack);
                t.rollback();
                throw new Error(e.message);
            }
        }
    }
}