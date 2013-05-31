_images = module.exports =
  upload: (req, res) ->
    res.redirect req.get "Referer"
    