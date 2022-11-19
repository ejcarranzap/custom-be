import { App } from "../App";
import FileType from "file-type";

class fin_cashup_btn_printProcess {
    constructor(private app: App) { }
    async run(params) {
        /*console.log('ad_table_btn_getcolProcess action called...', params)*/
        return await this.print(params)
    }
    async print(params) {
        var me = this
        var ds = await me.printDocument(params)
        return ds
    }

    printDocument = async (data) => {
        var app = this.app;
        try {
            var file_ = 'rpt_' + data.table + '_' + data.action.name
            var type_ = data.mimeType
            var comand = app.report.generateReport(file_, data.data, type_)
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

export { fin_cashup_btn_printProcess }