const path = require('path')
const chalk = require('chalk')
const child_process = require('child_process')
// const inquirer = require('inquirer')
const fs = require('fs')
const utils = require('./utils')

/**
 * Remove directory recursively
 * @param {string} dir_path
 * @see https://stackoverflow.com/a/42505874/3027390
 */
function rimraf(dir_path) {
    if (fs.existsSync(dir_path)) {
        fs.readdirSync(dir_path).forEach(function(entry) {
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

/**
 *
 * */
function exec(command,quiet){
    return new Promise((resolve, reject)=> {
        try {
            let child = child_process.exec(command, {encoding: 'utf8'}, function () {
                resolve();
            })
            if(!quiet){
                child.stdout.pipe(process.stdout);
            }
            child.stderr.pipe(process.stderr);
        }catch(e){
            console.error('execute command failed :',command);
            reject(e);
        }
    })
}

/**
 * build
 * @param {Object} options
 */

function build(src,target) {
    //先清空原目录...
    rimraf(target)
    //同步文件...
    let command = 'rsync -r -v --delete-after '+ src +' '+target
    exec(command)
}

module.exports = build

//图片资源文件
const imgSrc ='src/assets/image/*'
const imgTarget = 'platforms/ios/Example/assets/image'
build(imgSrc,imgTarget)

//JS文件
const jsSrc ='dist/native/*'
const jsTarget = 'platforms/ios/Example/bundlejs'
build(jsSrc,jsTarget)


