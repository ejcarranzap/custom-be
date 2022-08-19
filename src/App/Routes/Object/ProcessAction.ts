export = (app) => {
    return {
        method: 'POST',
        path: '/api/ProcessAction',
        config: { auth: false },
        handler: async (request, h) => {
            try {
                const res = request.payload

                var data = await app.callprocess.run(res)

                return { success: true, data: data, msg: 'ProcessAction' };
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}