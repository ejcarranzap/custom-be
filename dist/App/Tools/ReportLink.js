"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReportLink = void 0;
class ReportLink {
    constructor(app) {
        this.app = app;
    }
    generateReport(rptName, rptParams) {
        var me = this;
        var opsys = process.platform;
        var tempFolder = (opsys.toLowerCase().includes('win') && !opsys.toLowerCase().includes('dar') ? 'C://Temp//' : '//tmp//');
        /*var currentPath = me.app.rptsPath.replace('/', '//')
        var libsPath = me.app.libsPath.replace('/', '//')*/
        console.log(opsys);
        var currentPath = me.app.rptsPath;
        /*var comand = 'java -jar ./JCReportTool_V3.jar "' + currentPath + '" "' + tempFolder + '" "' + rptName + '" "{}"'*/
        var comand = 'java -jar ./JCReportTool_V3.jar "' + currentPath + '" "' + tempFolder + '" "' + rptName + '" "' + JSON.stringify(rptParams) + '"';
        console.log(comand);
        return comand;
    }
}
exports.ReportLink = ReportLink;
//# sourceMappingURL=ReportLink.js.map