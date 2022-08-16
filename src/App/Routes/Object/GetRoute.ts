export = (app) => {
    return {
        method: 'POST',
        path: '/api/GetRoute',
        config: { auth: false },
        handler: async (request, h) => {
            const res = request.payload
            return []
        }
    }
}