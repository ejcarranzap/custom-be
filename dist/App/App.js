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
exports.App = void 0;
const hapi_1 = require("@hapi/hapi");
const sequelize_1 = require("sequelize");
const Inert = __importStar(require("@hapi/inert"));
const HapiJWT = __importStar(require("hapi-auth-jwt2"));
const Path = __importStar(require("path"));
const JWT = __importStar(require("jsonwebtoken"));
const glob = __importStar(require("glob"));
const bcrypt = __importStar(require("bcrypt-nodejs"));
const ModuleGen_1 = require("./Tools/ModuleGen");
const WindowGen_1 = require("./Tools/WindowGen");
const MenuGen_1 = require("./Tools/MenuGen");
const CallProcess_1 = require("./Tools/CallProcess");
const UploadLink_1 = require("./Tools/UploadLink");
const ReportLink_1 = require("./Tools/ReportLink");
class App {
    constructor() {
        this.db = { sequelize: null, types: null, bcrypt: null };
        this.secret = 'EAAhnSTcGA7sBAJ4yxMddoOVYNI8yG0d';
        this.publicPath = '';
        this.routesPath = '';
        this.hooksPath = '';
        this.processPath = '';
        this.libsPath = '';
        this.rptsPath = '';
        console.log('App constructor');
        this.init();
    }
    init() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                this.JWT = JWT;
                this.db.types = sequelize_1.Sequelize;
                this.db.bcrypt = bcrypt;
                require('pg').types.setTypeParser(1114, function (stringValue) {
                    /*console.log('stringValue: ', stringValue)*/
                    return stringValue.substring(0, 10) + 'T' + stringValue.substring(11) + '.000Z';
                });
                this.db.sequelize = new sequelize_1.Sequelize('test', 'admin', '1234', {
                    host: 'localhost',
                    port: 5436,
                    dialect: 'postgres',
                    /*logging: (...msg) => console.log(msg),*/
                    logging: false,
                    define: {
                        freezeTableName: true,
                        timestamps: false,
                        hooks: {
                            beforeCreate: (model, options) => {
                                /*console.log(model.constructor.name);*/
                                console.log('created hook');
                                if (model.constructor.name == 'ad_user') {
                                    return;
                                }
                                var current = this.db.sequelize.fn('NOW');
                                model.updated = current;
                                model.created = current;
                                model.updatedby = '0';
                                model.createdby = '0';
                            },
                            beforeUpdate: (model, options) => {
                                console.log('updated hook');
                                if (model.constructor.name == 'ad_user') {
                                    return;
                                }
                                var current = this.db.sequelize.fn('NOW');
                                model.updated = current;
                                model.updatedby = '0';
                            },
                            beforeBulkUpdate: function (options) {
                                options.individualHooks = true;
                            }
                        }
                    },
                    timezone: '-06:00',
                    dialectOptions: {
                        useUTC: false
                    }
                });
                yield this.db.sequelize.authenticate();
                yield this.db.sequelize.query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp";', { raw: true });
                yield this.db.sequelize.query('SELECT uuid_generate_v1();', { raw: true });
                this.modgen = new ModuleGen_1.ModuleGen(this);
                this.wingen = new WindowGen_1.WindowGen(this);
                this.menugen = new MenuGen_1.MenuGen(this);
                this.callprocess = new CallProcess_1.CallProcess(this);
                this.report = new ReportLink_1.ReportLink(this);
                yield this.startServer();
            }
            catch (e) {
                throw e.message;
            }
        });
    }
    startServer() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                var me = this;
                me.publicPath = Path.join(__dirname, '..//..//Public');
                me.routesPath = './dist/App/Routes';
                me.processPath = './dist/App/Process';
                me.hooksPath = Path.join(__dirname, './/Hooks');
                me.libsPath = Path.join(__dirname, '..//..//..//libs');
                me.rptsPath = Path.join(__dirname, '..//..//..//rpts//MyReports//');
                console.log('public path: ' + me.publicPath);
                console.log('routes path: ' + me.routesPath);
                console.log('libs path: ' + me.libsPath);
                console.log('rpts path: ' + me.rptsPath);
                me.server = new hapi_1.Server({
                    port: 3001,
                    host: 'localhost',
                    routes: {
                        files: {
                            relativeTo: me.publicPath
                        },
                        /*cors: {
                            'origin': ['http://localhost:3002'],
                            'headers': ['Accept', 'Content-Type'],
                            'additionalHeaders': ['X-Requested-With']
                        }*/
                        cors: true
                    }
                });
                me.imgUrl = me.server.info.uri + '/Public/files/';
                me.upload = new UploadLink_1.UploadLink(me);
                yield me.server.register([Inert, HapiJWT]);
                yield me.server.route({
                    method: 'GET',
                    path: '/{file*}',
                    config: { auth: false },
                    handler: {
                        directory: {
                            path: me.publicPath
                        }
                    }
                });
                me.server.ext('onPreResponse', function (request, h) {
                    const response = request.response;
                    /*console.log(request);*/
                    if (request.response.isBoom) {
                        const err = request.response;
                        const errMsg = (err.output.payload.message + ' ' + err.data);
                        const errName = (err.output.payload.error);
                        const statusCode = (err.output.payload.statusCode);
                        console.log('ERROR ONPRERESPONSE', statusCode, errMsg, errName, request.response);
                        console.log(err);
                        err.output.payload.message = err;
                    }
                    return h.continue;
                });
                const validate = (decoded, request, h) => __awaiter(this, void 0, void 0, function* () {
                    let ds = yield me.db.sequelize.models['ad_user'].findOne({ where: { ad_user_id: decoded.ad_user_id } });
                    if (!ds) {
                        return { isValid: false };
                    }
                    else {
                        return { isValid: true };
                    }
                });
                me.server.auth.strategy('jwt', 'jwt', {
                    key: me.secret,
                    validate: validate,
                    verifyOptions: {
                        ignoreExpiration: true,
                        algorithms: ['HS256']
                    }
                });
                me.server.auth.default('jwt');
                glob.sync(me.routesPath + '/**/*.js', {
                    root: __dirname
                }).forEach(file => {
                    console.log('File: ', file, ' __dirname ', __dirname);
                    let basename = Path.basename(file);
                    let filepath = '../../' + file;
                    /*let filepath = Path.join(me.routesPath, basename);*/
                    me.server.route(require(filepath)(me));
                    console.log('loaded route: ' + filepath);
                });
                glob.sync(me.processPath + '/**/*.js', {
                    root: __dirname
                }).forEach(file => {
                    console.log('File: ', file, ' __dirname ', __dirname);
                    let basename = Path.basename(file).replace('.js', '');
                    let filepath = '../../' + file;
                    /*let filepath = Path.join(me.routesPath, basename);*/
                    let cls = require(filepath);
                    console.log(cls[Object.keys(cls)[0]], basename);
                    me[basename] = new cls[Object.keys(cls)[0]](me);
                    console.log('loaded process: ' + filepath);
                });
                yield this.modgen.registerModels(me.hooksPath);
                yield this.modgen.registerRoutes(null);
                yield this.server.start();
                console.log('Server running on %s', this.server.info.uri);
            }
            catch (e) {
                console.log(e.stack);
                console.log(e.message);
            }
        });
    }
}
exports.App = App;
//# sourceMappingURL=App.js.map