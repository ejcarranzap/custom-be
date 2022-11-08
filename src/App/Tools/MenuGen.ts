import { App } from "../App";
import * as glob from 'glob';
import { v4 } from 'uuid'
const { Op } = require('sequelize')

class MenuGen {
    constructor(private app: App) { }
    async getMenus() {
        var me = this
        var app = me.app

        try {
            var ds, ret = []
            ds = await app.db.sequelize.models['ad_menu'].findAll({ where: { parent: { [Op.eq]: null } }, order: [['position', 'ASC']] })

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

            for (var i = 0; i < ds.length; i++) {
                let o = ds[i]
                ret.push(await me.getMenu(o))
            }

            return { data: ret };
        } catch (e) {
            /*t.rollback();*/
            throw new Error(e.stack);
        }
    }

    async getMenu(o) {
        var me = this;
        var app = me.app;
        var dsWin, valuesWin, ds, values;

        if (o.ad_window_id != null) {
            dsWin = await app.db.sequelize.models['ad_window'].findOne({ where: { ad_window_id: o.ad_window_id } });
            valuesWin = dsWin.dataValues;
            ds = await app.db.sequelize.models['ad_windowtype'].findOne({ where: { ad_windowtype_id: valuesWin.ad_windowtype_id } });
            values = ds.dataValues;
        }

        var menu: any = {}
        menu.id = o.ad_menu_id
        menu.description = o.description
        menu.title = o.description
        menu.icon = 'mdi mdi-monitor-dashboard'
        menu.child = []
        await me.getMenuChild(menu)
        if (menu.child.length == 0) {
            if (values && values.name.toLowerCase().includes('report')) {
                menu.href = '/customviewrptV3/' + o.ad_window_id
            } else {
                menu.href = '/customviewV3/' + o.ad_window_id
            }
            delete menu.child
        }
        return menu
    }

    async getMenuChild(menu) {
        var me = this
        var app = me.app
        var ds = await app.db.sequelize.models['ad_menu'].findAll({ where: { parent: menu.id }, order: [['position', 'ASC']] })
        for (var i = 0; i < ds.length; i++) {
            let o = ds[i]
            menu.child.push(await me.getMenu(o))
        }
    }
}

export { MenuGen }