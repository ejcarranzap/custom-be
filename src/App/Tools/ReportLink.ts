import { App } from "../App";

class ReportLink {
    private jasper;

    constructor(private app: App) { }
    generateReport(rptName, rptParams) {
        var me = this
        var opsys = process.platform;
        var tempFolder = (opsys.includes('win') ? 'C://Temp//' : '//tmp//');
        var exec = require('child_process').exec, child
        /*var currentPath = me.app.rptsPath.replace('/', '//')
        var libsPath = me.app.libsPath.replace('/', '//')*/

        var currentPath = '//home//jonatanc//node-projects//rpts//MyReports//'
        var libsPath = '//home//jonatanc//node-projects//libs//'

        const searchRegExp = /\\/g;
        const replaceWith = '//';

        /*currentPath = currentPath.replace(searchRegExp, replaceWith);*/
        console.log(currentPath, tempFolder, rptName, libsPath)

        var comand = 'java -jar ./JCReportTool_V3.jar "' + currentPath + '" "' + tempFolder + '" "' + rptName + '" "{}"'
        console.log(comand)

        return comand
    }
}


export { ReportLink }