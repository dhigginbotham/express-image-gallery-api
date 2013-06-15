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
    # console.log req
    theTags = ""
    theTags += (if index is 0 then tag.name else ",#{tag.name}") for tag,index in req.findOne.tags
    res.render "pages/images/edit",
      user: req.user
      nav: req._navObj
      flash: req.flash "info"
      que: req.loaded
      images: req.findOne
      tags: theTags
      prefix: "images"