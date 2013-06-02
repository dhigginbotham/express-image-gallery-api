(function() {
  var TagsClass, elem, tags;

  TagsClass = (function() {
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
        s = TagsClass.settings;
        s.elem = elem;
        s.tags = tags;
        TagsClass.bind();
        return TagsClass.render(s.tags);
      },
      render: function(tags) {
        TagsClass.renderSpans(s.tags);
        return TagsClass.renderHiddenInput(s.tags);
      },
      renderSpans: function(tags) {
        var html, t, _i, _len;

        html = "";
        for (_i = 0, _len = tags.length; _i < _len; _i++) {
          t = tags[_i];
          html += "<span class='badge'>" + t + " <i class='icon-remove-sign'></i></span>&nbsp;\r\n";
        }
        return $("#" + s.elem.container).html(html);
      },
      renderHiddenInput: function() {
        var html;

        html = "<input type='hidden' name='tags' value='" + s.tags + "' />\r\n";
        return $("#" + s.elem.hidden).html(html);
      },
      sanitizeOutput: function(tags) {
        var arr;

        arr = [];
        arr = tags.split(/(?: ,|,)+/);
        if (arr.length > 0) {
          s.tags = s.tags.concat(arr);
        }
        s.tags = s.tags.unique();
        TagsClass.render(s.tags);
        return TagsClass.cleanUp();
      },
      bind: function() {
        return $("#" + s.elem.input).on("change", function(e) {
          e.preventDefault();
          return TagsClass.sanitizeOutput($(this).val());
        });
      },
      cleanUp: function() {
        $("#" + s.elem.input).val("");
        $("#" + s.elem.input).select();
        return console.log(s.tags);
      }
    };
  })();

  elem = {
    container: "tagContainer",
    input: "tagInput",
    hidden: "tagHidden"
  };

  tags = [];

  TagsClass.init(elem, tags);

}).call(this);
