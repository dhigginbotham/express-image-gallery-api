(function() {
  var elem, tags, tagsClass;

  tagsClass = (function() {
    var s;

    s = {};
    return {
      settings: {},
      init: function(elem, tags) {
        s = tagsClass.settings;
        s.elem = elem;
        s.tags = tags;
        return tagsClass.renderMultiple(tags);
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
      eliminateDuplicates: function(tags) {
        var i, obj, out, _i, _j, _len, _ref;

        out = [];
        obj = {};
        for (_i = i, _ref = tags.length; i <= _ref ? _i <= _ref : _i >= _ref; i <= _ref ? _i++ : _i--) {
          obj[arr[i]] = 0;
        }
        for (_j = 0, _len = obj.length; _j < _len; _j++) {
          i = obj[_j];
          out.push(i);
        }
        return out;
      },
      sanitizeOutput: function(tags) {
        var arr;

        arr = [];
        if (tags.indexOf("," === 0 || tags.indexOf("," === 0))) {
          arr = tags.split(/(?: ,|,| )+/);
          s.tags.push(arr);
          tagsClass.renderMultiple(arr);
        } else {
          s.tags.push(tags);
          tagsClass.render(tags);
        }
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

  tags = ["sample", "lip", "cool", "dive"];

  tagsClass.init(elem, tags);

}).call(this);
