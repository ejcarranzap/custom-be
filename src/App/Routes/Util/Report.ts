const FileType = require('file-type');

export = (app) => {
    const fs = require('fs')

    return {
        path: '/api/Report',
        method: 'GET',
        options: {
            auth: false,
            cors: true,
        },
        handler: async (request, h) => {
            try {
                var file_ = 'Report1Psql'
                var comand = app.report.generateReport(file_, {})
                var exec = require('child_process').exec, buffer, mime

                console.log(comand)

                return h.response(await new Promise(function(resolve, reject) {
                    exec(comand, { cwd: app.libsPath },
                        async (error, stdout, stderr) => {
                        if (error) {
                            reject(error);
                            return;
                        }
                        
                        buffer = Buffer.from(stdout, 'base64')
                        /*mime = 'application/pdf'*/
                        mime = await FileType.fromBuffer(buffer)
                        resolve(buffer);
                    });
                })).header('Content-Type', mime.mime).header('Cache-Control', 'no-cache')

            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}