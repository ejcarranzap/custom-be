import { App } from "../App";

class ad_tab_btn_getcolProcess {
    constructor(private app: App) { }
    async run(params) {
        /*console.log('ad_table_btn_getcolProcess action called...', params)*/
        return await this.generateCols(params)
    }
    async generateCols(params) {
        var me = this
        var ds = await me.getDBObjects(params)
        return ds
    }

    getDBObjects = async (data) => {
        var app = this.app;
        try {
            await app.db.sequelize.query('SELECT fn_generate_field(\'' + data.data.ad_tab_id + '\',\'' + data.action.name + '\');', {});
            return { success: true, data: [] };
        } catch (e) {
            console.log(e.message)
            throw new Error(e.stack);
        }
    }
}

export { ad_tab_btn_getcolProcess }