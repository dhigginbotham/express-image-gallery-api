// Generated by CoffeeScript 1.6.3
(function() {
  var $, count, nestableitem, repeaterblock, repeateroptions, repeaters, repeatertypes;

  repeatertypes = {
    'heading': {
      name: 'Heading or Sub-Heading/Category',
      obj: false
    },
    'gallery': {
      name: 'Insert Gallery/Image',
      obj: function(id) {
        return {
          type: 'form',
          attributes: {
            'id': id,
            'action': '/file-upload',
            'class': 'dropzone'
          }
        };
      }
    },
    'textlong': {
      name: 'Long Text Entry',
      obj: function(id) {
        return {
          type: 'textarea',
          attributes: {
            'id': id,
            'cols': '500',
            'class': 'nicEditable'
          }
        };
      }
    },
    'textshort': {
      name: 'Short Text Entry',
      obj: function(id) {
        return {
          type: 'div',
          attributes: {
            'class': 'someclass'
          },
          contains: [
            {
              type: 'label',
              attributes: {
                'for': id
              },
              contains: ["Insert Value Here:"]
            }, {
              type: 'input',
              attributes: {
                'type': 'text',
                'id': id,
                'value': ''
              }
            }
          ]
        };
      }
    },
    'list': {
      name: 'List of Items',
      obj: function(id) {
        return {
          type: 'input',
          attributes: {
            'id': id,
            'type': 'text',
            'class': 'taggable',
            'value': ''
          }
        };
      }
    },
    'features': {
      name: 'Features',
      obj: function(id) {
        return {
          type: 'input',
          attributes: {
            'id': id,
            'type': 'text',
            'class': 'taggable'
          }
        };
      }
    }
  };

  repeaters = {};

  repeateroptions = [];

  count = 0;

  window.populatenestable = function(baseid) {
    return repeaters[baseid].update();
  };

  window.removeicon = function(elem) {
    return repeaters[elem.getAttribute('data-repeaterid')].remove(elem);
  };

  window.updateinputtype = function(elem) {
    return repeaters[elem.getAttribute('data-repeater-id')].updateinputtype(elem);
  };

  repeaterblock = (function() {
    function repeaterblock(inputid, baseinput, iconcontainer, basecontainer, repeaterstore) {
      this.inputid = inputid;
      this.baseinput = baseinput;
      this.iconcontainer = iconcontainer;
      this.basecontainer = basecontainer;
      this.repeaterstore = repeaterstore;
      this.items = {};
      this.data = {};
      this.setupnestable();
      this.update();
      document.getElementById("feauxinput_" + this.inputid).style.float = 'left';
    }

    repeaterblock.prototype.update = function() {
      var item, newItems, text, _i, _len, _results;
      newItems = [];
      $(this.iconcontainer).children('span.badge').each(function() {
        if (!($(this).hasClass('already_nested'))) {
          $(this).addClass('already_nested');
          return newItems.push(this);
        }
      });
      _results = [];
      for (_i = 0, _len = newItems.length; _i < _len; _i++) {
        item = newItems[_i];
        text = $(item).text();
        this.add(text);
        _results.push(this.items[text] = item);
      }
      return _results;
    };

    repeaterblock.prototype.add = function(text) {
      var li;
      li = create(nestableitem(text, this.inputid));
      this.nest.appendChild(li);
      this.data[text] = {
        'item': li,
        'order': count,
        'inputcontainer': $(li).children('.inputholder')[0]
      };
      window.x = this.data;
      return ++count;
    };

    repeaterblock.prototype.remove = function(elem) {
      var listitem, text;
      text = elem.getAttribute('data-repeater-text');
      $(this.items[text].getElementsByTagName('i')[0]).click();
      listitem = document.getElementById("dd_item_" + text);
      listitem.parentNode.removeChild(listitem);
      delete this.data[text];
      return --count;
    };

    repeaterblock.prototype.updateinputtype = function(elem) {
      var append, obj, text;
      text = elem.getAttribute('data-repeater-text');
      this.data[text]['inputcontainer'].innerHTML = "";
      append = repeatertypes[elem.value].obj;
      if (append !== false) {
        obj = create(append("dd_item_value_" + text));
        console.log(obj);
        this.data[text]['inputcontainer'].appendChild(obj);
      }
      switch (elem.value) {
        case "gallery":
          console.log("GALLERY!");
          return new Dropzone(obj, {
            url: "/file/post"
          });
        case "list":
          return window.taggable(obj);
        case "features":
          return window.taggable(obj);
        case "textlong":
          return new nicEditor({
            fullPanel: true
          }).panelInstance("dd_item_value_" + text);
      }
    };

    repeaterblock.prototype.setupnestable = function() {
      var div;
      div = create({
        type: 'div',
        attributes: {
          'class': 'dd'
        },
        contains: [
          {
            type: 'ol',
            attributes: {
              'class': 'dd-list',
              'id': this.inputid
            },
            contains: []
          }
        ]
      });
      this.nest = div.getElementsByTagName('ol')[0];
      this.basecontainer.appendChild(div);
      return $(div).nestable();
    };

    return repeaterblock;

  })();

  nestableitem = function(text, id) {
    return {
      type: 'li',
      attributes: {
        'class': 'dd-item',
        'data-parent-id': id,
        'id': "dd_item_" + text
      },
      contains: [
        {
          type: 'div',
          attributes: {
            'class': 'dd-handle'
          },
          contains: [text]
        }, {
          type: 'select',
          attributes: {
            'change': 'updateinputtype',
            'data-repeater-id': id,
            'data-repeater-text': text
          },
          contains: repeateroptions
        }, {
          type: 'i',
          attributes: {
            'class': 'icon-remove-circle repeater-remover',
            'click': "removeicon",
            'data-repeaterid': id,
            'data-repeater-text': text
          }
        }, {
          type: 'div',
          attributes: {
            'class': 'inputholder',
            'id': "inputholder_" + text
          }
        }
      ]
    };
  };

  $ = jQuery;

  $(function() {
    var init;
    return (init = function() {
      var key, val;
      for (key in repeatertypes) {
        val = repeatertypes[key];
        repeateroptions.push({
          type: 'option',
          attributes: {
            'value': key
          },
          contains: [val.name]
        });
      }
      return $('.repeaterblock').each(function() {
        var div, iconcontainer, innerdivs, innerinputs, input, inputid, repeaterstore, textarea, theinput, _i, _j, _k, _len, _len1, _len2, _ref;
        inputid = false;
        innerdivs = this.getElementsByTagName('div');
        for (_i = 0, _len = innerdivs.length; _i < _len; _i++) {
          div = innerdivs[_i];
          if (div.getAttribute('id').indexOf('icon_container' > -1)) {
            iconcontainer = div;
            div.style.display = 'none';
          }
        }
        innerinputs = this.getElementsByTagName('input');
        for (_j = 0, _len1 = innerinputs.length; _j < _len1; _j++) {
          input = innerinputs[_j];
          if (input.getAttribute('class') === 'taggable') {
            inputid = input.getAttribute('id');
            theinput = input;
          }
        }
        _ref = this.getElementsByTagName('textarea');
        for (_k = 0, _len2 = _ref.length; _k < _len2; _k++) {
          textarea = _ref[_k];
          if (textarea.getAttribute('data-repeater-rel') === inputid) {
            repeaterstore = textarea;
          }
        }
        if (inputid) {
          return repeaters[inputid] = new repeaterblock(inputid, theinput, iconcontainer, this, repeaterstore);
        } else {
          return console.log("Error setting up Repeater Block, missing '.taggable' input.");
        }
      });
    })();
  });

}).call(this);
