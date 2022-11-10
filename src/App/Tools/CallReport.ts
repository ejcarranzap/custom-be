import { App } from "../App";

class CallReport {
    constructor(private app: App) { }
    run(params) {
        var me = this
        /*console.log('CallProcess', params)*/
        return me.app['rpt_' + params.action + 'Report'].run(params)
    }
}

export { CallReport }