export = (app) => {
    return {
        method: 'POST',
        path: '/api/GetWhs',
        config: { auth: false },
        handler: async (request, h) => {
            try {
                const res = request.payload
                var model = app.db.sequelize.models['m_warehouse'];
                var data = await model.findAll({ where: {}, order: [] });

                return { success: true, data: data, msg: 'GetWhs' };
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}