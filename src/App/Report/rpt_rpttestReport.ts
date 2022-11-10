import { App } from "../App";
import FileType from "file-type";

class rpt_rpttestReport {
    constructor(private app: App) { }
    async run(params, h) {
        /*console.log('ad_table_btn_getcolProcess action called...', params)*/
        return await this.generateRpt(params)
    }
    async generateRpt(params) {
        var me = this
        var ds = await me.getRpt(params)
        return ds
    }

    getRpt = async (data) => {
        var app = this.app;
        try {
            var file_ = 'Report1Psql'
            var comand = app.report.generateReport(file_, {})
            var exec = require('child_process').exec, buffer, mime

            console.log(comand)

            return await new Promise(function (resolve, reject) {
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
            })

        } catch (e) {
            console.log(e.stack);
            throw new Error(e.message);
        }
    }
}

export { rpt_rpttestReport }