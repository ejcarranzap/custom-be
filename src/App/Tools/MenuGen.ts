import { App } from "../App";
import * as glob from 'glob';
import { v4 } from 'uuid'
const { Op } = require('sequelize')

class MenuGen {
    constructor(private app: App) { }
    async getMenus(){
        var me = this
        var app = me.app

        try {
            var ds, ret = []
            ds = await app.db.sequelize.models['ad_menu'].findAll({ where: { parent: {[Op.eq]: null} } })

            ret.push({
                "id": 1,
                "description": "Main Title",
                "title": "Navegación",
                "header": true,
                "hiddenOnCollapse": true
              },
              {
                "href": "/",
                "title": "Home",
                "icon": "mdi mdi-monitor-dashboard"
              },
              {
                "href": "/about",
                "title": "About",
                "icon": "mdi mdi-chart-bar"
              })

            for(var i = 0; i < ds.length; i++){
                let o = ds[i]
                ret.push(await me.getMenu(o))
            }

            return { data: ret };
        } catch (e) {
            /*t.rollback();*/
            throw new Error(e.stack);
        }
    }

    async getMenu(o){
        var me = this
        var menu: any = {}
        menu.id = o.ad_menu_id
        menu.description = o.description
        menu.title = o.description
        menu.icon = 'mdi mdi-monitor-dashboard'
        menu.child = []
        await me.getMenuChild(menu)
        if(menu.child.length == 0){
            menu.href = '/customviewV3/' + o.ad_window_id
            delete menu.child
        }
        return menu
    }

    async getMenuChild(menu){
        var me = this
        var app = me.app
        var ds = await app.db.sequelize.models['ad_menu'].findAll({ where: { parent: menu.id } })
        for(var i = 0; i < ds.length; i++){
            let o = ds[i]
            menu.child.push(await me.getMenu(o))
        }
    }
}

export { MenuGen }