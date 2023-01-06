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
const Path = __importStar(require("path"));
module.exports = (app) => {
    const fs = require('fs');
    return {
        path: '/api/Upload',
        method: 'POST',
        options: {
            auth: false,
            cors: true,
            payload: {
                maxBytes: 1024 * 1024 * 5,
                multipart: {
                    output: "file"
                },
                parse: true
            }
        },
        handler: (request, h) => __awaiter(void 0, void 0, void 0, function* () {
            try {
                const res = request.payload;
                const params = request.params;
                var data = {};
                var basename = '';
                console.log(res, params);
                for (const key in res) {
                    const file = res[key];
                    if (!file)
                        continue;
                    if (!file.path || file.path === undefined) {
                        if (res[key] != 'null')
                            data[key] = res[key];
                        else
                            data[key] = null;
                        continue;
                    }
                    ;
                    var source_file = file.path;
                    var ext = Path.join('.', Path.extname(file.filename));
                    var ok = app.upload.upload(source_file, ext);
                    basename = Path.basename(source_file) + ext;
                    if (!ok) {
                        throw new Error('No se puedo subir el archivo.');
                    }
                    data.filename = basename;
                }
                console.log('upload data: ', data);
                return { success: true, msg: 'Operación exitosa.', data: data };
            }
            catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        })
    };
};
//# sourceMappingURL=Upload.js.map