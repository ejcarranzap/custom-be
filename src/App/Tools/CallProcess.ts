import { App } from "../App";

class CallProcess {
    constructor(private app: App) { }
    run(params) {
        var me = this
        /*console.log('CallProcess', params)*/
        return me.app[params.table + '_' + params.action.name + 'Process'].run(params)
    }
}

export { CallProcess }