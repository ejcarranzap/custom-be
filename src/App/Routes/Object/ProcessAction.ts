export = (app) => {
    return {
        method: 'POST',
        path: '/api/ProcessAction',
        config: { auth: false },
        handler: async (request, h) => {
            try {
                const jsontoken = app.JWT.decode(request.headers.authorization.split(' ')[1], app.secret)
                var res = request.payload

                res.jsontoken = jsontoken

                var data = await app.callprocess.run(res)

                return { success: true, data: data, msg: 'ProcessAction' }
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}