const FileType = require('file-type');

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

                if (Buffer.isBuffer(data)) {
                    var mime = await FileType.fromBuffer(data)
                    if (mime == null) {
                        mime = {}
                        mime.ext = 'txt'
                        mime.mime = 'text/plain'
                        data = data.toString('base64')

                    } else if (res.mimeType == 'xls') {
                        mime.ext = 'xls'
                        mime.mime = 'application/vnd.ms-excel'
                        /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                    } else if (res.mimeType == 'doc') {
                        mime.ext = 'doc'
                        mime.mime = 'application/msword'
                        /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                    }

                    return h.response(data).header('Content-Type', mime.mime).header('Cache-Control', 'no-cache')
                } else {
                    return { success: true, data: data, msg: 'ProcessAction' }
                }
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}