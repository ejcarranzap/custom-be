import { App } from "../App";
import * as glob from 'glob';
import { v4 } from 'uuid'

class ModuleGen {
    private auth = { auth: false }

    constructor(private app: App) { }
    processAction = (data) => {
        switch (data.action) {
            case 'get_objects': return this.getDBObjects(data); break;
            default: return { msg: 'Action unidentified.' }; break;
        }
    }
    getDBObjects = async (data) => {
        var app = this.app;
        var t = await app.db.sequelize.transaction({ autocommit: false });
        var ds, dsCursor, dsRes, dsValues: any[] = [];
        try {
            if (data.table_name)
                ds = await app.db.sequelize.query('SELECT fn_get_table_data(\'' + data.table_name + '\',\'' + data.ref_action + '\');', { transaction: t });
            else
                ds = await app.db.sequelize.query('SELECT fn_get_table_data(NULL,\'' + data.ref_action + '\');', { transaction: t });
            dsCursor = ds[0];
            /*console.log(dsCursor);*/
            var ret = {};
            for (var i = 0; i < dsCursor.length; i++) {
                const element = dsCursor[i];
                dsRes = await app.db.sequelize.query('FETCH ALL IN "' + element.fn_get_table_data + '";', { transaction: t });
                ret[element.fn_get_table_data] = dsRes[0];
            };
            dsValues.push(ret);

            t.commit();
            /*console.log(dsValues[0].ref_table);*/
            return { data: dsValues[0] };
        } catch (e) {
            t.rollback();
            throw new Error(e.stack);
        }
    }

    registerRoutes = async (hooksPath: string) => {
        var me = this
        try {
            var tables: any = await this.getDBObjects({ ref_action: 'ONLY_TABLE' });
            tables = tables.data;
            /*console.log('tables: ',tables);*/
            for (var table of tables.ref_table) {
                me.registerRouteGetAll(table)
                me.registerRouteGet(table)
                me.registerRoutePost(table)
                me.registerRoutePatch(table)
                me.registerRouteDelete(table)
            }
        } catch (e) {
            console.log('Register Routes: ', e)
        }
    }

    registerRouteGetAll(table) {
        var app = this.app;
        var me = this;

        const table_name = table.table_name
        var fn = async function (request, h) {
            const db = app.db
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            try {
                var ds
                let model = app.db.sequelize.models[table_name]
                var modelKey = model.primaryKeyAttributes[0]
                var fields = model.rawAttributes
                var sort = []
                var query = request.query
                var sortprm = query.sort

                delete query.sort


                if(sortprm)
                sortprm.split(',').map(o => {
                    var osplit = o.split(":")
                    sort.push([osplit[0], osplit[1]])
                    return o
                })
                /*prms[modelKey] = request.params.id*/
                /*console.log('params: ', prms)*/
                /*console.log('query: ', request.query)*/
                /*console.log('fields:', fields.position)*/
                /*if (fields.position) {
                    sort.push(['position', 'ASC'])
                }*/
                ds = await model.findAll({ where: request.query, order: sort });

                /*t.commit();*/

                if (ds)
                    return { success: true, data: ds };
                else
                    return { success: true, data: [] }
            } catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e.message);
            }
        }

        app.server.route({
            method: 'GET',
            path: '/api/' + table_name,
            config: me.auth,
            handler: fn
        });

        console.log('Registered route GETALL: ', '/api/' + table.table_name)
    }

    registerRouteGet(table) {
        var app = this.app;
        var me = this;

        const table_name = table.table_name
        var fn = async function (request, h) {
            const db = app.db
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            try {
                var ds
                let model = db.sequelize.models[table_name];
                var modelKey = model.primaryKeyAttributes[0];
                var prms = {}
                prms[modelKey] = request.params.id
                /*console.log('params: ', prms)*/
                ds = await model.findOne({ /*transaction: t,*/ where: prms });

                /*t.commit();*/

                if (ds)
                    return { success: true, data: ds.dataValues };
                else
                    return { success: true, data: {} }
            } catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e.message);
            }
        }

        app.server.route({
            method: 'GET',
            path: '/api/' + table_name + '/{id}',
            config: me.auth,
            handler: fn
        });

        console.log('Registered route GET: ', '/api/' + table.table_name)
    }

    registerRoutePost(table) {
        var app = this.app;
        var me = this;

        const table_name = table.table_name
        var fn = async function (request, h) {
            const db = app.db
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            const jsontoken = app.JWT.decode(request.headers.authorization.split(' ')[1], app.secret)
            console.log('jsontoken', jsontoken)

            try {
                var ds
                let model = db.sequelize.models[table_name];
                var idata = request.payload

                delete idata.updated
                delete idata.created

                idata.updatedby = jsontoken.ad_user_id
                idata.createdby = jsontoken.ad_user_id

                /*console.log('params: ', prms)*/
                ds = await model.create(idata, { /*transaction: t,*/ hooks: true, individualHooks: true });

                /*t.commit();*/

                if (ds)
                    return { success: true, data: ds.dataValues };
                else
                    return { success: true, data: {} }
            } catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e.message);
            }
        }

        app.server.route({
            method: 'POST',
            path: '/api/' + table_name,
            config: me.auth,
            handler: fn
        });

        console.log('Registered route POST: ', '/api/' + table.table_name)
    }

    registerRoutePatch(table) {
        var app = this.app;
        var me = this;

        const table_name = table.table_name
        var fn = async function (request, h) {
            const db = app.db
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            const jsontoken = app.JWT.decode(request.headers.authorization.split(' ')[1], app.secret)
            console.log('jsontoken', jsontoken)
            try {
                var ds
                let model = db.sequelize.models[table_name];
                var idata = request.payload
                var modelKey = model.primaryKeyAttributes[0];
                var prms = {}
                prms[modelKey] = request.params.id

                /*console.log('params: ', prms)*/
                delete idata.updated
                delete idata.created

                idata.updated = jsontoken.ad_user_id

                /*console.log('idata: ', idata)*/
                await model.update(idata, { where: prms })
                ds = await model.findOne({ where: prms })

                /*t.commit();*/

                if (ds)
                    return { success: true, data: ds.dataValues };
                else
                    return { success: true, data: {} }
            } catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e.message);
            }
        }

        app.server.route({
            method: 'PATCH',
            path: '/api/' + table_name + '/{id}',
            config: me.auth,
            handler: fn
        });

        console.log('Registered route PATCH: ', '/api/' + table.table_name)
    }

    registerRouteDelete(table) {
        var app = this.app;
        var me = this;

        const table_name = table.table_name
        var fn = async function (request, h) {
            const db = app.db
            /*var t = await db.sequelize.transaction({ autocommit: false });*/
            try {
                var ds
                let model = db.sequelize.models[table_name];
                var modelKey = model.primaryKeyAttributes[0];
                var prms = {}
                prms[modelKey] = request.params.id

                /*console.log('params: ', prms)*/
                ds = await model.findOne({ where: prms })
                await model.destroy({ where: prms });

                /*t.commit();*/

                if (ds)
                    return { success: true, data: ds.dataValues };
                else
                    return { success: true, data: {} }
            } catch (e) {
                console.log(e.stack);
                /*t.rollback();*/
                throw new Error(e.message);
            }
        }

        app.server.route({
            method: 'DELETE',
            path: '/api/' + table_name + '/{id}',
            config: me.auth,
            handler: fn
        });

        console.log('Registered route DELETE: ', '/api/' + table.table_name)
    }

    registerModels = async (hooksPath: string) => {
        var app = this.app;
        var me = this;
        try {
            var tables: any = await this.getDBObjects({ ref_action: 'ONLY_TABLE' });
            tables = tables.data;
            /*console.log('tables: ',tables);*/
            for (var table of tables.ref_table) {
                var tabledata: any = await this.getDBObjects({ table_name: table.table_name, ref_action: '' });
                var cols: any, colsSeq: any;
                var constraint: any;
                tabledata = tabledata.data;
                cols = tabledata.ref_column;
                constraint = tabledata.ref_constraint;

                colsSeq = {};

                for (var col of cols) {
                    var colConstraint = constraint.filter((c) => { return c.column_name == col.column_name });
                    colConstraint = colConstraint[0];
                    colsSeq[col.column_name] = {};
                    if (colConstraint && colConstraint.constraint_type == 'PRIMARY KEY') {
                        colsSeq[col.column_name] = {
                            primaryKey: true,
                            type: app.db.types.STRING,
                            defaultValue: () => {
                                var id = v4().toString();
                                id = id.replace(/-/g, '');
                                return id;
                            },
                            allowNull: false
                        };
                    } else {
                        colsSeq[col.column_name] = {};
                        colsSeq[col.column_name].type = this.getColType(col);
                    }

                }

                /*console.log(table.table_name, colsSeq);*/
                app.db.sequelize.define(table.table_name, colsSeq);
                /*console.log(app.db.sequelize.models[table.table_name]);*/
                console.log('Model Register: ' + table.table_name);
            }

            for (var table of tables.ref_table) {
                var tabledata: any = await this.getDBObjects({ table_name: table.table_name, ref_action: '' });
                var cols: any, colsSeq: any;
                var constraint: any;
                tabledata = tabledata.data;
                cols = tabledata.ref_column;
                constraint = tabledata.ref_constraint;
                colsSeq = {};

                for (var col of cols) {
                    var colConstraint = constraint.filter((c) => { return c.column_name == col.column_name });
                    colConstraint = colConstraint[0];
                    //console.log(colConstraint, col);


                    if (colConstraint && colConstraint.constraint_type == 'FOREIGN KEY') {
                        app.db.sequelize.models[colConstraint.table_name].belongsTo(app.db.sequelize.models[colConstraint.references_table], {
                            alias: colConstraint.constraint_name,
                            foreignKey: colConstraint.references_field
                        });

                        var constraint_nameb = colConstraint.table_name + 's';

                        app.db.sequelize.models[colConstraint.references_table].hasMany(app.db.sequelize.models[colConstraint.table_name], {
                            alias: constraint_nameb,
                            foreignKey: colConstraint.references_field
                        });

                    }

                    /*if (colConstraint)
                        console.log('Constraint Register: ' + colConstraint.constraint_name);*/
                }

            }


            if (hooksPath)
                glob.sync(hooksPath + '/**/*.js', {
                    cwd: __dirname
                    /*root: __dirname */
                }).forEach(file => {
                    let filepath = file;
                    console.log(filepath);
                    require(filepath)(this.app.db);
                    console.log('loaded hook: ' + filepath);
                });
        } catch (e) {
            throw new Error(e.stack);
        }
    }

    getColType(col) {
        var app = this.app;
        let type = '';
        switch (col.data_type) {
            case 'character varying': type = this.app.db.types.STRING(col.character_maximum_length); break;
            case 'int': type = this.app.db.types.INTEGER; break;
            case 'timestamp': type = this.app.db.types.DATE; break;
        }
        return (type || app.db.types.STRING(100));
    }
}

export { ModuleGen };