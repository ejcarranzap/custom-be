export = (app) => {
    return {
        method: 'POST',
        path: '/api/GetOrg',
        config: { auth: false },
        handler: async (request, h) => {
            try {
                const res = request.payload
                var model = app.db.sequelize.models['ad_org'];
                var data = await model.findAll({ where: {}, order: [] });

                return { success: true, data: data, msg: 'GetOrg' };
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}