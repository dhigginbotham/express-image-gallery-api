TagsClass = (() ->
  Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output
  s = {}
  return {
    settings: {}
    init: (elem, tags) ->
      s = TagsClass.settings
      s.elem = elem
      s.tags = tags
      TagsClass.bind()
      TagsClass.render s.tags
    render: (tags) ->
      TagsClass.renderSpans s.tags
      TagsClass.renderHiddenInput s.tags
    renderSpans: (tags) ->
      html = ""
      for t in tags
        html += "<span class='badge'>#{t} <i class='icon-remove-sign'></i></span>&nbsp;\r\n"
      $("#" + s.elem.container).html html
    renderHiddenInput: () ->
      html = "<input type='hidden' name='tags' value='#{s.tags}' />\r\n"
      $("#" + s.elem.hidden).html html
    sanitizeOutput: (tags) ->
      arr = []
      arr = tags.split /(?: ,|,)+/
      s.tags = s.tags.concat arr if arr.length > 0
      s.tags = s.tags.unique()
      TagsClass.render s.tags
      TagsClass.cleanUp()
    bind: () ->
      $("#" + s.elem.input).on "change", (e) ->
        e.preventDefault()
        TagsClass.sanitizeOutput $(this).val()
    cleanUp: () ->
      $("#" + s.elem.input).val("")
      $("#" + s.elem.input).select()
      console.log s.tags
  })()

elem =
  container: "tagContainer"
  input: "tagInput"
  hidden: "tagHidden"

tags = [
]

TagsClass.init elem, tags
