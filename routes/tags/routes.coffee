_tags = module.exports =
  add: (req, res) ->
    
    res.render "pages/tags/add",
      user: req.user
      flash: req.flash "info"
      nav: req._navObj
      que: req.loaded
  edit: (req, res) ->
    res.render "pages/tags/add",
      user: req.user
      edit: req._tag
      flash: req.flash "info"
      nav: req._navObj
      que: req.loaded
  view: (req, res) ->

    res.render "pages/tags/view",
      user: req.user
      tags: req._tag
      flash: req.flash "info"
      que: req.loaded
      nav: req._navObj
      prefix: "tags"
  single: (req, res) ->

    res.render "pages/tags/single",
      user: req.user
      tags: req._tag
      flash: req.flash "info"
      que: req.loaded
      nav: req._navObj
      prefix: "tags"
