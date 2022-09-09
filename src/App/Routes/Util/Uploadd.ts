export = (app) => {
    const fs = require('fs');

    return {
        path: '/api/Uploadd/{file}',
        method: 'GET',
        options: {
            auth: false,
            cors: true
        },
        handler: async (request, h) => {
            try {
                var res = request.params
                console.log('Uploadd', res)

                fs.unlinkSync(app.publicPath + '//files//' + res.file)

                return { success: true, msg: 'Operación exitosa...', data: [] }
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }

        }
    }
}