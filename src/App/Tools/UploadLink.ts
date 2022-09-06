import * as Path from 'path';
class UploadLink {
    constructor(private path: string) {

    }

    public async upload(source_file, ext) {
        try {
            var fs = require('fs');

            /*const resizeImg = require('resize-img');
            const image = await resizeImg(fs.readFileSync(source_file), {
                width: 128,
                height: 128
            });*/
            const image = fs.readFileSync(source_file)

            fs.unlinkSync(source_file);
            fs.writeFileSync(source_file, image);

            var is = fs.createReadStream(source_file)
            var basename = Path.basename(source_file) + ext;
            var os = fs.createWriteStream(Path.join(__dirname, '../..//..//Public//files//' + basename));
            await is.pipe(os);
            fs.unlinkSync(source_file);
            return true;
        } catch (e) {
            console.log(e.stack);
            return false;
        }
    }
}

export { UploadLink }