import * as path from 'path'

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
                var exec = require('child_process').exec, child
                var comand = app.report.generateReport(file_, {})
                child = exec(comand, { cwd: '//home//jonatanc//node-projects//libs//' },
                    function (error, stdout, stderr) {
                        try {
                            //console.log('stdout: ' + stdout);
                            console.log('stderr: ' + stderr);
                            if (error !== null) {
                                console.log('exec error: ' + error);
                            }
                            const buf = Buffer.from(stdout, 'base64');
                            return buf
                        } catch (e) {
                            throw new Error(e.message);
                        }
                    });
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}