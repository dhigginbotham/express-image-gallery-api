tagsClass = (() ->
  s = {}
  return {
    settings: {}
    init: (elem, tags) ->
      s = tagsClass.settings
      s.elem = elem
      s.tags = tags
      tagsClass.renderExistingTags tags
    renderLabel: (text) ->
      html = "<span class='badge'>#{text} <i class='icon-remove-sign'></i></span>&nbsp;\r\n"
      $("#" + s.elem.label).append html
      tagsClass.cleanUp()
    renderExistingTags: (tags) ->
      for t in tags
        do (t) ->
          tagsClass.renderLabel(t)
      tagsClass.bind()
    bind: () ->
      $("#" + s.elem.input).on "change", (e) ->
        e.preventDefault()
        tagsClass.renderLabel $(this).val()
    cleanUp: () ->
      $("#" + s.elem.input).val("")
      $("#" + s.elem.input).select()
  })()

elem =
  label: "tagContainer"
  input: "tagInput"

tags = [
  "sample"
  "lip"
  "cool"
  "dive"
]

tagsClass.init elem, tags