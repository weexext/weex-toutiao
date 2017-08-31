//https://github.com/archiverjs/node-archiver
const path = require('path')
const fs = require('fs');
const archiver = require('archiver');
var rootpath = path.resolve();
var crypto = require('crypto');
var archive = archiver('zip');
/**
 * Remove directory recursively
 * @param {string} dir_path
 * @see https://stackoverflow.com/a/42505874/3027390
 */
function rimraf(dir_path) {
    if (fs.existsSync(dir_path)) {
        fs.readdirSync(dir_path).forEach(function (entry) {
            let entry_path = path.join(dir_path, entry);
            if (fs.lstatSync(entry_path).isDirectory()) {
                rimraf(entry_path);
            } else {
                fs.unlinkSync(entry_path);
                console.log("delete file : " + entry_path);
            }
        });
        fs.rmdirSync(dir_path);
    }
}


var tagetPath = rootpath + '/dist/package'
//清除之前package
rimraf(tagetPath)

if (!fs.existsSync(rootpath + '/dist')) {
    fs.mkdirSync(rootpath + '/dist');
}
if (!fs.existsSync(tagetPath)) {
    fs.mkdirSync(tagetPath);
}
//-----------------------------
//当前时间
var date = new Date();
var month = date.getMonth() + 1;
var strDate = date.getDate();
if (month >= 1 && month <= 9) {
    month = "0" + month;
}
if (strDate >= 0 && strDate <= 9) {
    strDate = "0" + strDate;
}
var currentdate = date.getFullYear() + month + strDate + date.getHours() + date.getMinutes() + date.getSeconds();

console.log(currentdate);

//----------------------

//---------------------
const manifastpath = rootpath + '/src/manifast.json'
var data = fs.readFileSync(manifastpath, "utf-8");
var manifast = JSON.parse(data);
console.log('manifast= ' + manifast.appName)

//------------------------

var fileName = manifast.appName + "_" + manifast.versionCode + "_" + currentdate;

var zipFile = tagetPath + '/' + fileName + ".so";
var zipFileSize = 0;

function packZip() {

    var output = fs.createWriteStream(zipFile);

// listen for all archive data to be written
    output.on('close', function () {
        zipFileSize = archive.pointer();
        buildManiFast();
        console.log(archive.pointer() + ' total bytes');
        console.log('archiver has been finalized and the output file descriptor has closed.');
    });

// good practice to catch warnings (ie stat failures and other non-blocking errors)
    archive.on('warning', function (err) {
        if (err.code === 'ENOENT') {
            // log warning
        } else {
            // throw error
            throw err;
        }
    });

// good practice to catch this error explicitly
    archive.on('error', function (err) {
        throw err;
    });

// pipe archive data to the file
    archive.pipe(output);

// append a file from stream
// var file1 = __dirname + '/file1.txt';
// archive.append(fs.createReadStream(file1), { name: 'file1.txt' });

// append files from a sub-directory, putting its contents at the root of archive
// 打入jsBundle
    var jsSrc = rootpath + "/dist/native"
    console.log(jsSrc)
    archive.directory(jsSrc, "/jsBundle");
// 打入jsBundle
    var assets = rootpath + "/src/assets"
    console.log(assets)
    archive.directory(assets, "/res");

// const manifastpath = rootpath +'/src/manifast.json'
// console.log(manifastpath)
// //打入 清单文件
// archive.file(manifastpath, { name: 'manifast.json' });
// //打入签名校验META-INF
// archive.append('签名!', { name: '/META-INF/rst.txt' });

    archive.finalize();


}
function buildManiFast() {
    var rs = fs.createReadStream(zipFile);
    var zipFilemd5;
    var hash = crypto.createHash('md5');
    rs.on('data', hash.update.bind(hash));

    rs.on('end', function () {
        zipFilemd5 = hash.digest('hex');
        console.log('zipFilemd5=' + zipFilemd5);
        //------------------------
        var manifseFile = tagetPath + '/' + fileName + ".json";

        manifast.md5 = zipFilemd5;
        manifast.length = zipFileSize;
        manifast.time = currentdate;
        manifast.path = fileName;

        fs.writeFile(manifseFile, JSON.stringify(manifast), {
            flag: 'w',
            encoding: 'utf-8',
            mode: '0666'
        }, function (err) {
            if (err) {
                console.log("文件写入失败")
            } else {
                console.log("文件写入成功");

            }
        });
    });

}
packZip();
module.exports = packZip;

//--------------------------
