// Generated by CoffeeScript 1.6.2
var $, createElem,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

$ = jQuery;

$(function() {
  var app;

  return (app = function() {
    var add, analyzetags, fixlabel, init, removetag, updateinput;

    window.tags = {};
    app = {};
    fixlabel = function(id) {
      return $('label').each(function() {
        if (this.getAttribute('for') === id) {
          return this.setAttribute('for', "feauxinput_" + id);
        }
      });
    };
    analyzetags = function(input) {
      var baseid, tag, _i, _len, _ref;

      baseid = input.getAttribute('id').split('feauxinput_').pop();
      _ref = input.value.split(',');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        if (!(__indexOf.call(window['tags'][baseid], tag) >= 0) && tag !== "") {
          add(tag, input.getAttribute('id'));
        }
      }
      input.value = "";
      return updateinput(baseid);
    };
    add = function(tag, inputid) {
      var baseid, i, span;

      baseid = inputid.split('feauxinput_').pop();
      window['tags'][baseid].push(tag);
      span = createElem("span", "", {
        "class": "badge"
      });
      i = createElem("i", "", {
        "class": "icon-remove-sign"
      });
      i.onclick = function() {
        return removetag(this);
      };
      span.appendChild(i);
      span.appendChild(document.createTextNode(tag));
      return document.getElementById("iconcontainer_" + baseid).appendChild(span);
    };
    updateinput = function(baseid) {
      var index, tag, tagscsv, _i, _len, _ref;

      tagscsv = "";
      _ref = window['tags'][baseid];
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        tag = _ref[index];
        tagscsv += (index === 0 ? tag : "," + tag);
      }
      return document.getElementById(baseid).value = tagscsv;
    };
    removetag = function(i) {
      var baseid, tagindex;

      baseid = i.parentNode.parentNode.getAttribute('id').split('iconcontainer_').pop();
      tagindex = window['tags'][baseid].indexOf($(i.parentNode).text());
      window['tags'][baseid].splice(tagindex, 1);
      updateinput(baseid);
      return i.parentNode.parentNode.removeChild(i.parentNode);
    };
    return (init = function() {
      return $('.taggable').each(function() {
        var iconcontainer, input;

        this.style.display = 'none';
        window['tags'][this.getAttribute('id')] = [];
        iconcontainer = createElem("div", "", {
          "id": "iconcontainer_" + (this.getAttribute('id'))
        });
        input = createElem("input", "", {
          "type": "text",
          "id": "feauxinput_" + (this.getAttribute('id'))
        });
        $(input).keyup(function(e) {
          if (e.keyCode === 13 || e.keyCode === 188) {
            analyzetags(this);
            return false;
          }
        });
        $(input).keydown(function(e) {
          if (e.keyCode === 13 || e.keyCode === 188) {
            return false;
          }
        });
        this.parentNode.appendChild(input);
        this.parentNode.appendChild(iconcontainer);
        return fixlabel(this.getAttribute('id'));
      });
    })();
  })();
});

createElem = function(type, innards, attributes) {
  var elem, key, val;

  elem = document.createElement(type);
  if (typeof innards !== "undefined" && innards !== "") {
    elem.appendChild(document.createTextNode(innards));
  }
  if (typeof attributes !== "undefined") {
    for (key in attributes) {
      val = attributes[key];
      elem.setAttribute(key, val);
    }
  }
  return elem;
};
