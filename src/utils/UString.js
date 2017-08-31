
/** eslint linebreak-style: [0] */
function _trim(str, isGlobal) {
  let result = str.replace(/(^\s+)|(\s+$)/g, '')
  if (isGlobal) {
    result = result.replace(/\s/g, '')
  }
  return result
}

function _isNumber (o) {
  return ! isNaN (o-0) && o !== null && o !== "" && o !== false;
}


function _encodeURIComponent(item){
  let json = JSON.stringify(item);
  return(encodeURIComponent(json));
}

function _decodeURIComponent(item){
  return(JSON.parse(decodeURIComponent(item)));
}

export default {
	//
  isNumber:_isNumber,
  trim:_trim,
  encodeURIComponent:_encodeURIComponent,
  decodeURIComponent:_decodeURIComponent,

}
