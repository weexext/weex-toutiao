const fs = require('fs')
const path = require('path')
const output = require('./output')
const validator = require('./validator')
const child_process = require('child_process')
// const os =require('os')
// const npm = require("npm");
const utils = {

  copyAndReplace(src, dest, replacements) {
    if (fs.lstatSync(src).isDirectory()) {
      if (!fs.existsSync(dest)) {
        fs.mkdirSync(dest)
      }
    } else {
      let content = fs.readFileSync(src, 'utf8')
      Object.keys(replacements).forEach(regex => {
        content = content.replace(new RegExp(regex, 'gm'), replacements[regex])
      })
      fs.writeFileSync(dest, content)
    }
  },
  exec(command,quiet){
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
  },
}


module.exports = Object.assign(utils, output, validator)
