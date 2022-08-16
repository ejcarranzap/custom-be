import { Server } from '@hapi/hapi'
import { Sequelize } from 'sequelize'
import * as Inert from '@hapi/inert';
import * as HapiJWT from 'hapi-auth-jwt2';
import * as Path from 'path';
import * as JWT from 'jsonwebtoken';
import * as glob from 'glob';
import * as axios from 'axios';
import * as bcrypt from 'bcrypt-nodejs';
import { ModuleGen } from './Tools/ModuleGen';
import { WindowGen } from './Tools/WindowGen';
import { MenuGen } from './Tools/MenuGen';

class App {
    public sequelize
    public server
    public db = { sequelize: null, types: null, bcrypt: null}
    public secret = 'EAAhnSTcGA7sBAJ4yxMddoOVYNI8yG0d'
    public modgen
    public wingen
    public menugen
    public JWT

    public publicPath: string = '';
    public routesPath: string = '';
    public hooksPath: string = '';

    constructor() {
        console.log('App constructor')
        this.init()
    }

    async init() {
        try {
            this.JWT = JWT;
            this.db.types = Sequelize
            this.db.bcrypt = bcrypt

            require('pg').types.setTypeParser(1114, function(stringValue) {
                /*console.log('stringValue: ', stringValue)*/
                return stringValue.substring(0, 10) + 'T' + stringValue.substring(11) + '.000Z';
            })

            this.db.sequelize = new Sequelize('test', 'admin', '1234', {
                host: 'localhost',
                port: 5436,
                dialect: 'postgres',
                /*logging: (...msg) => console.log(msg),*/
                logging: false,
                define: {
                    freezeTableName: true,
                    timestamps: false
                },
                timezone: '-06:00',
                dialectOptions: {
                    useUTC: false
                }
            });
            await this.db.sequelize.authenticate()
            await this.db.sequelize.query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp";', { raw: true })
            await this.db.sequelize.query('SELECT uuid_generate_v1();', { raw: true })

            this.modgen = new ModuleGen(this)
            this.wingen = new WindowGen(this)
            this.menugen = new MenuGen(this)

            await this.startServer()
        } catch (e) {
            throw e.message
        }
    }

    async startServer() {
        var me = this
        me.publicPath = Path.join(__dirname, '..//..//Public');
        me.routesPath = /*Path.join(__dirname, './/Routes//Auth')*/'./dist/App/Routes';
        me.hooksPath = Path.join(__dirname, './/Hooks');

        console.log('public path: ' + me.publicPath);
        console.log('routes path: ' + me.routesPath);


        me.server = new Server({
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

        await me.server.register([Inert, HapiJWT]);

        await me.server.route({
            method: 'GET',
            path: '/{file*}',
            config: { auth: false },
            handler: {
                directory: {
                    path: me.publicPath
                }
            }
        })

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

        const validate = async (decoded, request, h) => {
            let ds = await me.db.sequelize.models['ad_user'].findOne({ where: { ad_user_id: decoded.ad_user_id } });

            if (!ds) {
                return { isValid: false }
            } else {
                return { isValid: true }
            }
        }

        me.server.auth.strategy('jwt', 'jwt',
            {
                key: me.secret,
                validate: validate,
                verifyOptions: {
                    ignoreExpiration: true,
                    algorithms: ['HS256']
                }
            });

        me.server.auth.default('jwt');

        glob.sync(me.routesPath+'/**/*.js', {
            root: __dirname
        }).forEach(file => {
            console.log('File: ', file, ' __dirname ', __dirname);
            let basename = Path.basename(file);
            let filepath = '../../' + file;
            /*let filepath = Path.join(me.routesPath, basename);*/

            me.server.route(require(filepath)(me));
            console.log('loaded route: ' + filepath);
        });

        await this.modgen.registerModels(me.hooksPath)
        await this.modgen.registerRoutes(null)
        await this.server.start();


        console.log('Server running on %s', this.server.info.uri);
    }
}

export { App } 