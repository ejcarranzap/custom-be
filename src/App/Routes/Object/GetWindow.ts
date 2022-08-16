export = (app) => {
    return {
        method: 'POST',
        path: '/api/GetWindow',
        config: { auth: false },
        handler: async (request, h) => {
            const res = request.payload
            /*console.log('/api/GetWindow', res.id)*/
            return app.wingen.getWindowById(res.id)
        }
    }
}