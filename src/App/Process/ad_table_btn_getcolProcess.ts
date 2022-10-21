import { ValidationError } from "sequelize/types";
import { App } from "../App";

class ad_table_btn_getcolProcess {
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
            await app.db.sequelize.query('SELECT fn_generate_column2(\'' + data.data.ad_table_id + '\',\'' + data.action.name + '\');', {});
            return { success: true, data: [] };
        } catch (e) {
            console.log('Error getDBObjects: ', e.original)
            throw new Error(e.original);
        }
    }
}

export { ad_table_btn_getcolProcess }