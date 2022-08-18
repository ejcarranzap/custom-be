import { App } from "../App";
const { Op } = require('sequelize')

class WindowGen {
    constructor(private app: App) { }
    async getWindowById(id) {
        var me = this
        var app = me.app

        /*var t = await app.db.sequelize.transaction({ autocommit: false });*/
        try {
            var ds, ret, values
            ds = await app.db.sequelize.models['ad_window'].findOne({ where: { ad_window_id: id } })
            values = ds.dataValues
            ret = {}
            ret.id = values.ad_window_id
            ret.description = values.description
            ret.active = (values.isactive == 'Y' ? 1 : 0)
            ret.tabs = []

            ds = await app.db.sequelize.models['ad_tab'].findAll({ where: { ad_window_id: id, ad_tab_parent_id: { [Op.eq]: null } } })

            for (var i = 0; i < ds.length; i++) {
                let o = ds[i]
                ret.tabs.push(await me.getTab(o, null))
            }

            /*t.commit();*/
            return { data: ret };
        } catch (e) {
            /*t.rollback();*/
            throw new Error(e.stack);
        }
    }

    async getTab(o, parent) {
        var me = this
        let model = me.app.db.sequelize.models[o.value];
        var modelKey = model.primaryKeyAttributes[0];
        var tab: any = {}
        tab.id = o.ad_tab_id
        tab.restUrl = 'api/' + o.value
        tab.key = modelKey
        if (parent) tab.parentkey = parent.key
        tab.description = o.description
        await me.getTable(tab, o)
        tab.groupkey = null
        tab.groups = []
        tab.fields = []
        tab.tabs = []
        await me.getFields(tab)
        await me.getTabs(tab)
        return tab
    }

    async getTabs(tab) {
        var me = this
        let ds = await me.app.db.sequelize.models['ad_tab'].findAll({ where: { ad_tab_parent_id: { [Op.eq]: tab.id } } })
        for (var i = 0; i < ds.length; i++) {
            let o = ds[i]
            tab.tabs.push(await me.getTab(o, tab))
        }
    }

    async getFields(tab) {
        var me = this
        let ds = await me.app.db.sequelize.models['ad_field'].findAll({ where: { ad_tab_id: { [Op.eq]: tab.id } } })
        for (var i = 0; i < ds.length; i++) {
            let o = ds[i]
            let dsGroup = await me.app.db.sequelize.models['ad_field_group'].findOne({ where: { ad_field_group_id: o.ad_field_group_id } })
            var valuesGroup = dsGroup.dataValues
            var group: any = {}
            group.id = valuesGroup.ad_field_group_id
            group.name = valuesGroup.name
            group.description = valuesGroup.description

            if (!tab.groupkey) {
                tab.groupkey = 'ad_field_group_id'
            }

            if (me.groupExists(tab.groups, group) == false) {
                tab.groups.push(group)
            }

            var field: any = {}
            field.id = o.ad_field_id
            field.order = o.position
            field.group = group

            await me.getColumn(field, o)

            field.default = null
            field.visible = true
            field.visible_grid = true

            tab.fields.push(field)
        }
    }

    async getTable(tab, o) {
        var me = this
        let dsTable = await me.app.db.sequelize.models['ad_table'].findOne({ where: { value: o.value } })
        var valuesTable = dsTable.dataValues
        var table: any = {}
        table.id = valuesTable.ad_table_id
        table.name = valuesTable.name
        table.description = valuesTable.description
        table.active = (valuesTable.isactive == 'Y' ? 1 : 0)
        tab.table = table
    }

    async getColumn(field, o) {
        var me = this
        let dsColumn = await me.app.db.sequelize.models['ad_column'].findOne({ where: { ad_column_id: o.ad_column_id } })
        var valuesColumn = dsColumn.dataValues
        var col: any = {}
        col.id = valuesColumn.ad_column_id
        col.name = valuesColumn.value
        col.description = valuesColumn.description
        col.label = valuesColumn.name
        await me.getDataType(col, valuesColumn)
        col.is_pk = (valuesColumn.ispk == 'Y' ? 1 : 0)
        field.column = col
    }

    async getDataType(col, o) {
        var me = this
        let dsDataType = await me.app.db.sequelize.models['ad_datatype'].findOne({ where: { ad_datatype_id: o.ad_datatype_id } })
        var valuesDataType = dsDataType.dataValues
        var type = valuesDataType.value
        col.type = await me.getObjDataType(type)
        if (col.type == 'select') {
            col.restUrl = 'api/' + o.ref_table
            col.field_key = o.ref_table_key_field
            col.field_text = o.ref_table_text_field
        }

        if (col.type == 'action') {
            col.okLabel = 'Ok'
            col.cancelLabel = 'Cancel'
            col.icon = o.icon
        }

    }

    async getObjDataType(type) {
        var type_ = ''
        switch (type) {
            case 'TEXT': type_ = 'text'; break;
            case 'NUMBER': type_ = 'number'; break;
            case 'SELECT': type_ = 'select'; break;
            case 'YESNO': type_ = 'yesno'; break;
            case 'PASSWORD': type_ = 'password'; break;
            case 'EMAIL': type_ = 'email'; break;
            case 'DATE': type_ = 'date'; break;
            case 'IMAGE': type_ = 'image'; break;
            case 'BUTTON': type_ = 'action'; break;
            default: type_ = 'text'
        }
        return type_
    }

    groupExists(groups, group) {
        for (var i = 0; i < groups.length; i++) {
            let g = groups[i]
            if (g.id == group.id) {
                return true
            }
        }
        return false
    }
}

export { WindowGen }