import { App } from "../App";

class fin_cashup_btn_completeProcess {
    constructor(private app: App) { }
    async run(params) {
        /*console.log('ad_table_btn_getcolProcess action called...', params)*/
        return await this.complete(params)
    }
    async complete(params) {
        var me = this
        var ds = await me.completeDocument(params)
        return ds
    }

    completeDocument = async (data) => {
        var app = this.app;
        try {
            await app.db.sequelize.query('SELECT fn_complete_cashup(\'' + data.data.fin_cashup_id + '\',\'' + data.jsontoken.ad_user_id + '\',\'' + data.jsontoken.m_warehouse_id + '\');', {});
            return { success: true, data: [] };
        } catch (e) {
            console.log('Error completeDocument: ', e.original)
            throw new Error(e.original);
        }
    }
}

export { fin_cashup_btn_completeProcess }