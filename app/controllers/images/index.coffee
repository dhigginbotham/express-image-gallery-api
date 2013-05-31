_images = module.exports =
  upload: (req, res) ->
    
    res.redirect req.get "Referer"
  view: (req, res) ->

    res.render "pages/images/view",
      user: req.user
      nav: req._navObj
      flash: req.flash "info"
      que: req.loaded
      images: req._page
      prefix: "images"

  edit: (req, res) ->

    res.render "pages/images/edit",
      user: req.user
      nav: req._navObj
      flash: req.flash "info"
      que: req.loaded
      images: req.findOne
      tags: req._tag
      prefix: "images"