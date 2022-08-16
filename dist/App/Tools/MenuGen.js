"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MenuGen = void 0;
const { Op } = require('sequelize');
class MenuGen {
    constructor(app) {
        this.app = app;
    }
    getMenus() {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var app = me.app;
            try {
                var ds, ret = [];
                ds = yield app.db.sequelize.models['ad_menu'].findAll({ where: { parent: { [Op.eq]: null } } });
                ret.push({
                    "id": 1,
                    "description": "Main Title",
                    "title": "Navegación",
                    "header": true,
                    "hiddenOnCollapse": true
                }, {
                    "href": "/",
                    "title": "Home",
                    "icon": "mdi mdi-monitor-dashboard"
                }, {
                    "href": "/about",
                    "title": "About",
                    "icon": "mdi mdi-chart-bar"
                });
                for (var i = 0; i < ds.length; i++) {
                    let o = ds[i];
                    ret.push(yield me.getMenu(o));
                }
                return { data: ret };
            }
            catch (e) {
                /*t.rollback();*/
                throw new Error(e.stack);
            }
        });
    }
    getMenu(o) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var menu = {};
            menu.id = o.ad_menu_id;
            menu.description = o.description;
            menu.title = o.description;
            menu.icon = 'mdi mdi-monitor-dashboard';
            menu.child = [];
            yield me.getMenuChild(menu);
            if (menu.child.length == 0) {
                menu.href = '/customviewV3/' + o.ad_window_id;
                delete menu.child;
            }
            return menu;
        });
    }
    getMenuChild(menu) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var app = me.app;
            var ds = yield app.db.sequelize.models['ad_menu'].findAll({ where: { parent: menu.id } });
            for (var i = 0; i < ds.length; i++) {
                let o = ds[i];
                menu.child.push(yield me.getMenu(o));
            }
        });
    }
}
exports.MenuGen = MenuGen;
//# sourceMappingURL=MenuGen.js.map