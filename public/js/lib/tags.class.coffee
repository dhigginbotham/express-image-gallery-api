tagsClass = (() ->
  Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output      
  s = {}
  return {
    settings: {}
    init: (elem, tags) ->
      s = tagsClass.settings
      s.elem = elem
      s.tags = tags
      tagsClass.renderMultiple s.tags.unique()
    render: (tags) ->
      tagsClass.renderLabel tags
      tagsClass.renderHiddenInput tags
    renderLabel: (tags) ->
      html = "<span class='badge'>#{tags} <i class='icon-remove-sign'></i></span>&nbsp;\r\n"
      $("#" + s.elem.label).append html
    renderHiddenInput: (tags) ->
      html = "<input type='hidden' name='tags[#{tags}]' />\r\n"
      $("#" + s.elem.hidden).append html
    sanitizeOutput: (tags) ->
      arr = []
      if tags.indexOf "," == 0 || tags.indexOf "," == 0
        arr = tags.split /(?: ,|,| )+/
        s.tags = s.tags.concat arr
      else
        s.tags.push tags
      tagsClass.renderMultiple s.tags.unique()
      tagsClass.cleanUp()
    renderMultiple: (tags) ->
      for t in tags
        do (t) ->
          tagsClass.render(t)
      tagsClass.bind()
    bind: () ->
      $("#" + s.elem.input).on "change", (e) ->
        e.preventDefault()
        tagsClass.sanitizeOutput $(this).val()
    cleanUp: () ->
      $("#" + s.elem.input).val("")
      $("#" + s.elem.input).select()
  })()

elem =
  label: "tagContainer"
  input: "tagInput"
  hidden: "tagHidden"

tags = [
]

tagsClass.init elem, tags
