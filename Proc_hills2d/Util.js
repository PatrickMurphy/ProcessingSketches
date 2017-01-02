var Util = {
  defaultValue: 
function defaultValue(value, newValue) {
  if (typeof (value) === 'undefined') {
    return newValue;
  } else {
    return value;
  }
}
}