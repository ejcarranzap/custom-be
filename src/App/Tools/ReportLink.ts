import { App } from "../App";

class ReportLink {
    private jasper;

    constructor(private app: App) { }
    generateReport(rptName, rptParams, rptExportType) {
        var me = this
        var opsys = process.platform;
        var tempFolder = (opsys.toLowerCase().includes('win') && !opsys.toLowerCase().includes('dar') ? 'C://Temp//' : '//tmp//');
        /*var currentPath = me.app.rptsPath.replace('/', '//')
        var libsPath = me.app.libsPath.replace('/', '//')*/
        console.log(opsys)

        var currentPath = me.app.rptsPath

        /*var comand = 'java -jar ./JCReportTool_V3.jar "' + currentPath + '" "' + tempFolder + '" "' + rptName + '" "{}"'*/
        var comand = 'java -jar ./JasperReportsV2.jar "' + currentPath + '" "' + tempFolder + '" "' + rptName + '" "' + JSON.stringify(rptParams).split('"').join('\\"') + '" "' + rptExportType + '"'
        /*var comand = 'java -jar ./JCReportTool_V3.jar "' + currentPath + '" "' + tempFolder + '" "' + rptName + '" "' + JSON.stringify(rptParams).split('"').join('\\"') + '" "' + rptExportType + '"'*/

        return comand
    }
}


export { ReportLink }