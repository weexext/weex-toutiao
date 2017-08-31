function js(jsURL) {
    let bundleUrl = weex.config.bundleUrl
    let baseURL = bundleUrl.substring(0, bundleUrl.lastIndexOf("/"))
    //是否在同级目录，若不在，则需要以下处理
    let flag = jsURL.indexOf('../') !== -1
    if (flag) {
      let arr = jsURL.split('../')
      for (let index = 0; index < arr.length - 1; index++) {
          baseURL = baseURL.substring(0, baseURL.lastIndexOf('/'))
      }
      jsURL = arr[arr.length - 1]
    }
    return baseURL + '/' + jsURL
}

function params(key) {
    let bundleUrl = weex.config.bundleUrl;
    let reg = new RegExp('[?|&]' + key + '=([^&]+)')
    let match = bundleUrl.match(reg)
    return match && match[1]
}

function getUrlParam() {
    let paramsJson = params('params');
    if (paramsJson) {
        return JSON.parse(paramsJson);
    }
    return ''
}
function toParams(obj) {
    let param = ""
    for (const name in obj) {
        if (typeof obj[name] != 'function') {
            param += "&" + name + "=" + encodeURI(obj[name])
        }
    }
    return param.substring(1)
}

/**
 *
 * */
export function image(imgURL) {
    // if (weex.config.env.platform == 'android') {
    //     return "assets:///image/" + imgURL;
    // } else {
    //     return "assets:///image/" + imgURL
    // }
    return "assets:///image/" + imgURL
}

export default {
    js,
    image,
    params,
    toParams,
    getUrlParam
}
