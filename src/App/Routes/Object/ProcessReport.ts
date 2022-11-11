const FileType = require('file-type');

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
                var mime = await FileType.fromBuffer(ret)

                if (mime == null) {
                    mime = {}
                    mime.ext = 'txt'
                    mime.mime = 'text/plain'
                    ret = ret.toString('base64')

                } else if (res.type == 'xls') {
                    mime.ext = 'xls'
                    mime.mime = 'application/vnd.ms-excel'
                    /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                } else if (res.type == 'doc') {
                    mime.ext = 'doc'
                    mime.mime = 'application/msword'
                    /*mime.mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'*/
                }

                console.log('mime:', mime)

                return h.response(ret).header('Content-Type', mime.mime).header('Cache-Control', 'no-cache')
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}