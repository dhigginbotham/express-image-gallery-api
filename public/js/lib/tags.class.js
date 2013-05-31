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
        tagsClass.renderExistingTags(tags);
        return tagsClass.bind();
      },
      renderLabel: function(text) {
        var html;

        html = "<span class='badge'>" + text + " <i class='icon-remove-sign'></i></span>&nbsp;\r\n";
        $("#" + s.elem.label).append(html);
        return tagsClass.cleanUp();
      },
      renderExistingTags: function(tags) {
        var t, _i, _len, _results;

        _results = [];
        for (_i = 0, _len = tags.length; _i < _len; _i++) {
          t = tags[_i];
          _results.push((function(t) {
            return tagsClass.renderLabel(t);
          })(t));
        }
        return _results;
      },
      bind: function() {
        return $("#" + s.elem.input).on("change", function() {
          return tagsClass.renderLabel($(this).val());
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
    input: "tagInput"
  };

  tags = ["sample", "lip", "cool", "dive"];

  tagsClass.init(elem, tags);

}).call(this);
