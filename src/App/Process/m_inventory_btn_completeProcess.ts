import { App } from "../App";

class m_inventory_btn_completeProcess {
    constructor(private app: App) { }
    async run(params) {
        /*console.log('ad_table_btn_getcolProcess action called...', params)*/
        return await this.complete(params)
    }
    async complete(params) {
        var me = this
        var ds = await me.completeInventory(params)
        return ds
    }

    completeInventory = async (data) => {
        var app = this.app;
        try {
            await app.db.sequelize.query('SELECT fn_complete_inventory(\'' + data.data.m_inventory_id + '\',\'' + data.jsontoken.ad_user_id + '\',\'' + data.jsontoken.m_warehouse_id + '\');', {});
            return { success: true, data: [] };
        } catch (e) {
            console.log('Error completeInventory: ', e.original)
            throw new Error(e.original);
        }
    }
}

export { m_inventory_btn_completeProcess }