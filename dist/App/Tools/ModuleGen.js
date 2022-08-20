"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
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
exports.ModuleGen = void 0;
const glob = __importStar(require("glob"));
const uuid_1 = require("uuid");
class ModuleGen {
    constructor(app) {
        this.app = app;
        this.auth = { auth: false };
        this.processAction = (data) => {
            switch (data.action) {
                case 'get_objects':
                    return this.getDBObjects(data);
                    break;
                default:
                    return { msg: 'Action unidentified.' };
                    break;
            }
        };
        this.getDBObjects = (data) => __awaiter(this, void 0, void 0, function* () {
            var app = this.app;
            var t = yield app.db.sequelize.transaction({ autocommit: false });
            var ds, dsCursor, dsRes, dsValues = [];
            try {
                if (data.table_name)
                    ds = yield app.db.sequelize.query('SELECT fn_get_table_data(\'' + data.table_name + '\',\'' + data.ref_action + '\');', { transaction: t });
                else
                    ds = yield app.db.sequelize.query('SELECT fn_get_table_data(NULL,\'' + data.ref_action + '\');', { transaction: t });
                dsCursor = ds[0];
                /*console.log(dsCursor);*/
                var ret = {};
                for (var i = 0; i < dsCursor.length; i++) {
                    const element = dsCursor[i];
                    dsRes = yield app.db.sequelize.query('FETCH ALL IN "' + element.fn_get_table_data + '";', { transaction: t });
                    ret[element.fn_get_table_data] = dsRes[0];
                }
                ;
                dsValues.push(ret);
                t.commit();
                /*console.log(dsValues[0].ref_table);*/
                return { data: dsValues[0] };
            }
            catch (e) {
                t.rollback();
                throw new Error(e.stack);
            }
        });
        this.registerRoutes = (hooksPath) => __awaiter(this, void 0, void 0, function* () {
            var me = this;
            try {
                var tables = yield this.getDBObjects({ ref_action: 'ONLY_TABLE' });
                tables = tables.data;
                /*console.log('tables: ',tables);*/
                for (var table of tables.ref_table) {
                    me.registerRouteGetAll(table);
                    me.registerRouteGet(table);
                    me.registerRoutePost(table);
                    me.registerRoutePatch(table);
                    me.registerRouteDelete(table);
                }
            }
            catch (e) {
                console.log('Register Routes: ', e);
            }
        });
        this.registerModels = (hooksPath) => __awaiter(this, void 0, void 0, function* () {
            var app = this.app;
            var me = this;
            try {
                var tables = yield this.getDBObjects({ ref_action: 'ONLY_TABLE' });
                tables = tables.data;
                /*console.log('tables: ',tables);*/
                for (var table of tables.ref_table) {
                    var tabledata = yield this.getDBObjects({ table_name: table.table_name, ref_action: '' });
                    var cols, colsSeq;
                    var constraint;
                    tabledata = tabledata.data;
                    cols = tabledata.ref_column;
                    constraint = tabledata.ref_constraint;
                    colsSeq = {};
                    for (var col of cols) {
                        var colConstraint = constraint.filter((c) => { return c.column_name == col.column_name; });
                        colConstraint = colConstraint[0];
                        colsSeq[col.column_name] = {};
                        if (colConstraint && colConstraint.constraint_type == 'PRIMARY KEY') {
                            colsSeq[col.column_name] = {
                                primaryKey: true,
                                type: app.db.types.STRING,
                                defaultValue: () => {
                                    var id = (0, uuid_1.v4)().toString();
                                    id = id.replace(/-/g, '');
                                    return id;
                                },
                                allowNull: false
                            };
                        }
                        else {
                            colsSeq[col.column_name] = {};
                            colsSeq[col.column_name].type = this.getColType(col);
                        }
                    }
                    /*console.log(table.table_name, colsSeq);*/
                    app.db.sequelize.define(table.table_name, colsSeq);
                    /*console.log(app.db.sequelize.models[table.table_name]);*/
                    /*console.log('Model Register: ' + table.table_name);*/
                }
                for (var table of tables.ref_table) {
                    var tabledata = yield this.getDBObjects({ table_name: table.table_name, ref_action: '' });
                    var cols, colsSeq;
                    var constraint;
                    tabledata = tabledata.data;
                    cols = tabledata.ref_column;
                    constraint = tabledata.ref_constraint;
                    colsSeq = {};
                    for (var col of cols) {
                        var colConstraint = constraint.filter((c) => { return c.column_name == col.column_name; });
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
            }
            catch (e) {
                throw new Error(e.stack);
            }
        });
    }
    registerRouteGetAll(table) {
        var app = this.app;
        var me = this;
        const table_name = table.table_name;
        var fn = function (request, h) {
            return __awaiter(this, void 0, void 0, function* () {
                const db = app.db;
                /*var t = await db.sequelize.transaction({ autocommit: false });*/
                try {
                    var ds;
                    let model = db.sequelize.models[table_name];
                    var modelKey = model.primaryKeyAttributes[0];
                    var prms = {};
                    /*prms[modelKey] = request.params.id*/
                    /*console.log('params: ', prms)*/
                    /*console.log('query: ', request.query)*/
                    ds = yield model.findAll({ where: request.query });
                    /*t.commit();*/
                    if (ds)
                        return { success: true, data: ds };
                    else
                        return { success: true, data: [] };
                }
                catch (e) {
                    console.log(e.stack);
                    /*t.rollback();*/
                    throw new Error(e.message);
                }
            });
        };
        app.server.route({
            method: 'GET',
            path: '/api/' + table_name,
            config: me.auth,
            handler: fn
        });
        console.log('Registered route GETALL: ', '/api/' + table.table_name);
    }
    registerRouteGet(table) {
        var app = this.app;
        var me = this;
        const table_name = table.table_name;
        var fn = function (request, h) {
            return __awaiter(this, void 0, void 0, function* () {
                const db = app.db;
                /*var t = await db.sequelize.transaction({ autocommit: false });*/
                try {
                    var ds;
                    let model = db.sequelize.models[table_name];
                    var modelKey = model.primaryKeyAttributes[0];
                    var prms = {};
                    prms[modelKey] = request.params.id;
                    /*console.log('params: ', prms)*/
                    ds = yield model.findOne({ /*transaction: t,*/ where: prms });
                    /*t.commit();*/
                    if (ds)
                        return { success: true, data: ds.dataValues };
                    else
                        return { success: true, data: {} };
                }
                catch (e) {
                    console.log(e.stack);
                    /*t.rollback();*/
                    throw new Error(e.message);
                }
            });
        };
        app.server.route({
            method: 'GET',
            path: '/api/' + table_name + '/{id}',
            config: me.auth,
            handler: fn
        });
        console.log('Registered route GET: ', '/api/' + table.table_name);
    }
    registerRoutePost(table) {
        var app = this.app;
        var me = this;
        const table_name = table.table_name;
        var fn = function (request, h) {
            return __awaiter(this, void 0, void 0, function* () {
                const db = app.db;
                /*var t = await db.sequelize.transaction({ autocommit: false });*/
                try {
                    var ds;
                    let model = db.sequelize.models[table_name];
                    var idata = request.payload;
                    /*console.log('params: ', prms)*/
                    ds = yield model.create(idata, { /*transaction: t,*/ hooks: true, individualHooks: true });
                    /*t.commit();*/
                    if (ds)
                        return { success: true, data: ds.dataValues };
                    else
                        return { success: true, data: {} };
                }
                catch (e) {
                    console.log(e.stack);
                    /*t.rollback();*/
                    throw new Error(e.message);
                }
            });
        };
        app.server.route({
            method: 'POST',
            path: '/api/' + table_name,
            config: me.auth,
            handler: fn
        });
        console.log('Registered route POST: ', '/api/' + table.table_name);
    }
    registerRoutePatch(table) {
        var app = this.app;
        var me = this;
        const table_name = table.table_name;
        var fn = function (request, h) {
            return __awaiter(this, void 0, void 0, function* () {
                const db = app.db;
                /*var t = await db.sequelize.transaction({ autocommit: false });*/
                try {
                    var ds;
                    let model = db.sequelize.models[table_name];
                    var idata = request.payload;
                    var modelKey = model.primaryKeyAttributes[0];
                    var prms = {};
                    prms[modelKey] = request.params.id;
                    /*console.log('params: ', prms)*/
                    delete idata.updated;
                    delete idata.created;
                    /*console.log('idata: ', idata)*/
                    yield model.update(idata, { where: prms });
                    ds = yield model.findOne({ where: prms });
                    /*t.commit();*/
                    if (ds)
                        return { success: true, data: ds.dataValues };
                    else
                        return { success: true, data: {} };
                }
                catch (e) {
                    console.log(e.stack);
                    /*t.rollback();*/
                    throw new Error(e.message);
                }
            });
        };
        app.server.route({
            method: 'PATCH',
            path: '/api/' + table_name + '/{id}',
            config: me.auth,
            handler: fn
        });
        console.log('Registered route PATCH: ', '/api/' + table.table_name);
    }
    registerRouteDelete(table) {
        var app = this.app;
        var me = this;
        const table_name = table.table_name;
        var fn = function (request, h) {
            return __awaiter(this, void 0, void 0, function* () {
                const db = app.db;
                /*var t = await db.sequelize.transaction({ autocommit: false });*/
                try {
                    var ds;
                    let model = db.sequelize.models[table_name];
                    var modelKey = model.primaryKeyAttributes[0];
                    var prms = {};
                    prms[modelKey] = request.params.id;
                    /*console.log('params: ', prms)*/
                    ds = yield model.findOne({ where: prms });
                    yield model.destroy({ where: prms });
                    /*t.commit();*/
                    if (ds)
                        return { success: true, data: ds.dataValues };
                    else
                        return { success: true, data: {} };
                }
                catch (e) {
                    console.log(e.stack);
                    /*t.rollback();*/
                    throw new Error(e.message);
                }
            });
        };
        app.server.route({
            method: 'DELETE',
            path: '/api/' + table_name + '/{id}',
            config: me.auth,
            handler: fn
        });
        console.log('Registered route DELETE: ', '/api/' + table.table_name);
    }
    getColType(col) {
        var app = this.app;
        let type = '';
        switch (col.data_type) {
            case 'character varying':
                type = this.app.db.types.STRING(col.character_maximum_length);
                break;
            case 'int':
                type = this.app.db.types.INTEGER;
                break;
            case 'timestamp':
                type = this.app.db.types.DATE;
                break;
        }
        return (type || app.db.types.STRING(100));
    }
}
exports.ModuleGen = ModuleGen;
//# sourceMappingURL=ModuleGen.js.map