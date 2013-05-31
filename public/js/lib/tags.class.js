(function() {
  var elem, tags, tagsClass;

  tagsClass = (function() {
    var s;

    Array.prototype.unique = function() {
      var key, output, value, _i, _ref, _results;

      output = {};
      for (key = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; key = 0 <= _ref ? ++_i : --_i) {
        output[this[key]] = this[key];
      }
      _results = [];
      for (key in output) {
        value = output[key];
        _results.push(value);
      }
      return _results;
    };
    s = {};
    return {
      settings: {},
      init: function(elem, tags) {
        s = tagsClass.settings;
        s.elem = elem;
        s.tags = tags;
        return tagsClass.renderMultiple(s.tags.unique());
      },
      render: function(tags) {
        tagsClass.renderLabel(tags);
        return tagsClass.renderHiddenInput(tags);
      },
      renderLabel: function(tags) {
        var html;

        html = "<span class='badge'>" + tags + " <i class='icon-remove-sign'></i></span>&nbsp;\r\n";
        return $("#" + s.elem.label).append(html);
      },
      renderHiddenInput: function(tags) {
        var html;

        html = "<input type='hidden' name='tags[" + tags + "]' />\r\n";
        return $("#" + s.elem.hidden).append(html);
      },
      sanitizeOutput: function(tags) {
        var arr;

        arr = [];
        if (tags.indexOf("," === 0 || tags.indexOf("," === 0))) {
          arr = tags.split(/(?: ,|,| )+/);
          s.tags = s.tags.concat(arr);
        } else {
          s.tags.push(tags);
        }
        tagsClass.renderMultiple(s.tags.unique());
        return tagsClass.cleanUp();
      },
      renderMultiple: function(tags) {
        var t, _fn, _i, _len;

        _fn = function(t) {
          return tagsClass.render(t);
        };
        for (_i = 0, _len = tags.length; _i < _len; _i++) {
          t = tags[_i];
          _fn(t);
        }
        return tagsClass.bind();
      },
      bind: function() {
        return $("#" + s.elem.input).on("change", function(e) {
          e.preventDefault();
          return tagsClass.sanitizeOutput($(this).val());
        });
      },
      cleanUp: function() {
        $("#" + s.elem.input).val("");
        return $("#" + s.elem.input).select();
      }
    };
  })();

  elem = {
    label: "tagContainer",
    input: "tagInput",
    hidden: "tagHidden"
  };

  tags = [];

  tagsClass.init(elem, tags);

}).call(this);
