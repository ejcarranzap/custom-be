import * as Path from 'path';

export = (app) => {
    const fs = require('fs');

    return {
        path: '/api/Upload',
        method: 'POST',
        options: {
            auth: false,
            cors: true,
            payload: {
                maxBytes: 1024 * 1024 * 5,
                multipart: {
                    output: "file"
                },
                parse: true
            }
        },
        handler: async (request, h) => {
            try {
                const res = request.payload;
                const params = request.params;
                var data: any = {};

                var basename = '';
                console.log(res, params);
                for (const key in res) {
                    const file = res[key];
                    if (!file) continue;
                    if (!file.path || file.path === undefined) { if (res[key] != 'null') data[key] = res[key]; else data[key] = null; continue; };

                    var source_file = file.path;
                    var ext = Path.join('.', Path.extname(file.filename));
                    var ok = app.upload.upload(source_file, ext);

                    basename = Path.basename(source_file) + ext;

                    if (!ok) {
                        throw new Error('No se puedo subir el archivo.');
                    }

                    data.filename = basename;
                }

                console.log('upload data: ', data)
                return { success: true, msg: 'Operación exitosa.', data: data };
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }

        }
    }
}