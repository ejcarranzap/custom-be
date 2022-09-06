import * as Path from 'path';

export = (app) => {
    const fs = require('fs');

    return {
        path: '/api/Uploads',
        method: 'GET',
        options: {
            auth: false,
            cors: true
        },
        handler: async (request, h) => {
            try {
                var res = request.payload
                console.log('Uploads', res)

                return h.file('files/ic_user.png', { confine: false });
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }

        }
    }
}