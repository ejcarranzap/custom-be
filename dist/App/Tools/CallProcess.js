"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CallProcess = void 0;
class CallProcess {
    constructor(app) {
        this.app = app;
    }
    run(params) {
        var me = this;
        /*console.log('CallProcess', params)*/
        return me.app[params.table + '_' + params.action.name + 'Process'].run(params);
    }
}
exports.CallProcess = CallProcess;
//# sourceMappingURL=CallProcess.js.map