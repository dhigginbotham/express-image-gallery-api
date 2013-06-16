// Generated by CoffeeScript 1.6.3
(function() {
  var createElem;

  window.create = function(obj) {
    var contentsObj, elem, innerElem, _i, _len, _ref;
    if ((obj.type != null) && (obj.attributes != null) && (obj.contains != null)) {
      elem = createElem(obj.type, obj.attributes);
      _ref = obj.contains;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        contentsObj = _ref[_i];
        innerElem = typeof contentsObj === 'object' ? create(contentsObj) : document.createTextNode(contentsObj);
        elem.appendChild(innerElem);
      }
      return elem;
    }
  };

  createElem = function(type, attributes) {
    var elem, key, val;
    elem = document.createElement(type);
    if (typeof attributes !== "undefined") {
      for (key in attributes) {
        val = attributes[key];
        elem.setAttribute(key, val);
      }
    }
    return elem;
  };

}).call(this);
