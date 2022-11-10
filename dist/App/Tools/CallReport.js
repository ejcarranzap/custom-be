"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CallReport = void 0;
class CallReport {
    constructor(app) {
        this.app = app;
    }
    run(params) {
        var me = this;
        /*console.log('CallProcess', params)*/
        return me.app['rpt_' + params.action + 'Report'].run(params);
    }
}
exports.CallReport = CallReport;
//# sourceMappingURL=CallReport.js.map