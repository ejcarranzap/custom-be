export = (app) => {
    return {
        method: 'POST',
        path: '/api/GetMenu',
        config: { auth: false },
        handler: async (request, h) => {
            const res = request.payload
            return app.menugen.getMenus()
        }
    }
}