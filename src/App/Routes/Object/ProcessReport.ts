export = (app) => {
    return {
        method: 'POST',
        path: '/api/ProcessReport',
        config: { auth: false },
        handler: async (request, h) => {
            try {
                /*const jsontoken = app.JWT.decode(request.headers.authorization.split(' ')[1], app.secret)*/
                var res = request.payload

                /*res.jsontoken = jsontoken*/
                var ret = await app.callreport.run(res)
                return h.response(ret).header('Content-Type', 'application/pdf').header('Cache-Control', 'no-cache')
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}