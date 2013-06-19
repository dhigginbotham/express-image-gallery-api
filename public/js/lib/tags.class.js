// Generated by CoffeeScript 1.6.3
(function() {
  var $,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  $ = jQuery;

  $(function() {
    var app;
    return (app = function() {
      var add, analyzetags, execute, fixlabel, init, setup, updateinput;
      window.tags = {};
      fixlabel = function(id) {
        return $('label').each(function() {
          if (this.getAttribute('for') === id) {
            return this.setAttribute('for', "feauxinput_" + id);
          }
        });
      };
      analyzetags = function(input, excludecallback) {
        var baseid, callback, tag, _i, _len, _ref;
        if (excludecallback == null) {
          excludecallback = false;
        }
        baseid = input.getAttribute('id').split('feauxinput_').pop();
        _ref = input.value.split(',');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tag = _ref[_i];
          if (!(__indexOf.call(window['tags'][baseid], tag) >= 0) && tag !== "") {
            add(tag, input.getAttribute('id'));
          }
        }
        input.value = "";
        updateinput(baseid);
        callback = document.getElementById(baseid).getAttribute('data-taggable-callback');
        if (excludecallback === false) {
          if (callback != null) {
            return execute(callback, baseid);
          }
        }
      };
      add = function(tag, inputid) {
        var baseid, span;
        baseid = inputid.split('feauxinput_').pop();
        if (tag !== "") {
          window['tags'][baseid].push(tag);
        }
        span = create({
          type: 'span',
          attributes: {
            'class': 'badge'
          },
          contains: [
            {
              type: 'i',
              attributes: {
                'class': 'icon-remove-sign',
                'click': 'removetag'
              },
              contains: [tag]
            }
          ]
        });
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
      window.removetag = function(i) {
        var baseid, tagindex;
        baseid = i.parentNode.parentNode.getAttribute('id').split('iconcontainer_').pop();
        tagindex = window['tags'][baseid].indexOf($(i.parentNode).text());
        window['tags'][baseid].splice(tagindex, 1);
        updateinput(baseid);
        return i.parentNode.parentNode.removeChild(i.parentNode);
      };
      execute = function(functionName, baseid) {
        var fn;
        fn = window[functionName];
        if (typeof fn === 'function') {
          return fn(baseid);
        } else {
          return console.log("Taggable Error: Callback Undefined");
        }
      };
      window.taggable = function(elem) {
        return setup(elem);
      };
      setup = function(elem) {
        var iconcontainer, input;
        elem.style.display = 'none';
        window['tags'][elem.getAttribute('id')] = [];
        iconcontainer = create({
          type: 'div',
          attributes: {
            'id': "iconcontainer_" + (elem.getAttribute('id'))
          },
          contains: []
        });
        input = create({
          type: 'input',
          attributes: {
            'type': 'text',
            'id': "feauxinput_" + (elem.getAttribute('id')),
            'value': elem.value
          },
          contains: []
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
        input.onblur = function() {
          if (this.value !== "") {
            return analyzetags(this);
          }
        };
        elem.parentNode.appendChild(input);
        elem.parentNode.appendChild(iconcontainer);
        fixlabel(elem.getAttribute('id'));
        return analyzetags(input, true);
      };
      return (init = function() {
        return $('.taggable').each(function() {
          return setup(this);
        });
      })();
    })();
  });

}).call(this);
