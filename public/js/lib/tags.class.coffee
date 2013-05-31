tagsClass = (() ->
  s = {}
  return {
    settings: {}
    init: (elem, tags) ->
      s = tagsClass.settings
      s.elem = elem
      s.tags = tags
      tagsClass.renderMultiple tags
    render: (tags) ->
      tagsClass.renderLabel tags
      tagsClass.renderHiddenInput tags
    renderLabel: (tags) ->
      html = "<span class='badge'>#{tags} <i class='icon-remove-sign'></i></span>&nbsp;\r\n"
      $("#" + s.elem.label).append html
    renderHiddenInput: (tags) ->
      html = "<input type='hidden' name='tags[#{tags}]' />\r\n"
      $("#" + s.elem.hidden).append html
    eliminateDuplicates: (tags) ->
      out = []
      obj = {}
      for [i..tags.length]
        obj[arr[i]] = 0
      for i in obj
        out.push(i)
      return out
    sanitizeOutput: (tags) ->
      arr = []
      if tags.indexOf "," == 0 || tags.indexOf "," == 0
        arr = tags.split /(?: ,|,| )+/
        s.tags.push arr
        tagsClass.renderMultiple arr
      else
        s.tags.push tags
        tagsClass.render tags
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
  "sample"
  "lip"
  "cool"
  "dive"
]

tagsClass.init elem, tags