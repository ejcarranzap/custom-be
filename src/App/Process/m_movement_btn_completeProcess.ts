import { App } from "../App";

class m_movement_btn_completeProcess {
    constructor(private app: App) { }
    async run(params) {
        /*console.log('ad_table_btn_getcolProcess action called...', params)*/
        return await this.complete(params)
    }
    async complete(params) {
        var me = this
        var ds = await me.completeMovement(params)
        return ds
    }

    completeMovement = async (data) => {
        var app = this.app;
        try {
            /*await app.db.sequelize.query('SELECT fn_complete_order(\'' + data.data.c_order_id + '\',\'' + data.jsontoken.ad_user_id + '\');', {});*/
            return { success: true, data: [] };
        } catch (e) {
            console.log('Error completeMovement: ', e.original)
            throw new Error(e.original);
        }
    }
}

export { m_movement_btn_completeProcess }