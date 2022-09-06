import * as Path from 'path';

export = (app) => {
    const fs = require('fs');

    return {
        path: '/api/Uploads/{file}',
        method: 'GET',
        options: {
            auth: false,
            cors: true
        },
        handler: async (request, h) => {
            try {
                var res = request.params
                console.log('Uploads', res)

                return h.file('files/'+res.file, { confine: false });
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }

        }
    }
}