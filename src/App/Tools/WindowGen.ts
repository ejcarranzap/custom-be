import { App } from "../App";

class WindowGen {
    constructor(private app: App){}
    async getWindowById(id){
        var me = this
        var app = me.app
        var t = await app.db.sequelize.transaction({ autocommit: false });
        try{
            var ds, ret, values
            ds = await app.db.sequelize.models['ad_window'].findOne({ transaction: t, where: { ad_window_id: id} })
            values = ds.dataValues
            ret = {}
            ret.id = values.ad_window_id
            ret.description = values.description
            ret.active = (values.isactive == 'Y' ? 1 : 0)
            ret.tabs = []

            ds = await app.db.sequelize.models['ad_tab'].findAll({ transaction: t, where: { ad_window_id: id } })

            for(var i = 0; i < ds.length; i++){
                let o = ds[i]
                let model = app.db.sequelize.models[o.value];
                var modelKey = model.primaryKeyAttributes[0];

                var tab: any = {}
                tab.id = o.id
                tab.restUrl = o.value
                tab.key = modelKey
                tab.description = o.description

                tab.tabs = []
            }

            t.commit();
            return { data: ret };
        }catch(e){
            t.rollback();
            throw new Error(e.stack);
        }
    }
}

export { WindowGen }