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
exports.WindowGen = void 0;
const { Op } = require('sequelize');
class WindowGen {
    constructor(app) {
        this.app = app;
    }
    getWindowById(id) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            var app = me.app;
            /*var t = await app.db.sequelize.transaction({ autocommit: false });*/
            try {
                var ds, ret, values;
                ds = yield app.db.sequelize.models['ad_window'].findOne({ where: { ad_window_id: id } });
                values = ds.dataValues;
                ret = {};
                ret.id = values.ad_window_id;
                ret.description = values.description;
                ret.active = (values.isactive == 'Y' ? 1 : 0);
                ret.tabs = [];
                ds = yield app.db.sequelize.models['ad_tab'].findAll({ where: { ad_window_id: id, ad_tab_parent_id: { [Op.eq]: null } } });
                for (var i = 0; i < ds.length; i++) {
                    let o = ds[i];
                    ret.tabs.push(yield me.getTab(o));
                }
                /*t.commit();*/
                return { data: ret };
            }
            catch (e) {
                /*t.rollback();*/
                throw new Error(e.stack);
            }
        });
    }
    getTab(o) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            let model = me.app.db.sequelize.models[o.value];
            var modelKey = model.primaryKeyAttributes[0];
            var tab = {};
            tab.id = o.ad_tab_id;
            tab.restUrl = o.value;
            tab.key = modelKey;
            tab.description = o.description;
            tab.groupkey = null;
            tab.groups = [];
            tab.fields = [];
            tab.tabs = [];
            yield me.getFields(tab);
            yield me.getTabs(tab);
            return tab;
        });
    }
    getTabs(tab) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            let ds = yield me.app.db.sequelize.models['ad_tab'].findAll({ where: { ad_tab_parent_id: { [Op.eq]: tab.id } } });
            for (var i = 0; i < ds.length; i++) {
                let o = ds[i];
                tab.tabs.push(yield me.getTab(o));
            }
        });
    }
    getFields(tab) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            let ds = yield me.app.db.sequelize.models['ad_field'].findAll({ where: { ad_tab_id: { [Op.eq]: tab.id } } });
            for (var i = 0; i < ds.length; i++) {
                let o = ds[i];
                let dsGroup = yield me.app.db.sequelize.models['ad_field_group'].findOne({ where: { ad_field_group_id: o.ad_field_group_id } });
                var valuesGroup = dsGroup.dataValues;
                var group = {};
                group.id = valuesGroup.ad_field_group_id;
                group.name = valuesGroup.name;
                group.description = valuesGroup.description;
                if (!tab.groupkey) {
                    tab.groupkey = 'ad_field_group';
                }
                if (me.groupExists(tab.groups, group) == false) {
                    tab.groups.push(group);
                }
                var field = {};
                field.id = o.ad_field_id;
                field.order = o.position;
                field.group = group;
                yield me.getColumn(field);
                field.default = null;
                field.visible = true;
                field.visible_grid = true;
                tab.fields.push(field);
            }
        });
    }
    getColumn(field) {
        return __awaiter(this, void 0, void 0, function* () {
            var me = this;
            let dsColumn = yield me.app.db.sequelize.models['ad_column'].findOne({ where: { ad_field_id: field.ad_field_id } });
            var valuesColumn = dsColumn.dataValues;
            var col = {};
            col.id = valuesColumn.ad_column_id;
            col.name = valuesColumn.value;
            col.description = valuesColumn.description;
            col.label = valuesColumn.name;
            col.type = 'text';
            col.is_pk = (valuesColumn.ispk == 'Y' ? 1 : 0);
            field.column = col;
        });
    }
    groupExists(groups, group) {
        for (var i = 0; i < groups.length; i++) {
            let g = groups[i];
            if (g.id == group.id) {
                return true;
            }
        }
        return false;
    }
}
exports.WindowGen = WindowGen;
//# sourceMappingURL=WindowGen.js.map