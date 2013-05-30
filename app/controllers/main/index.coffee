_main = module.exports =
  index: (req, res) ->
    
    res.render "pages/home",
      user: req.user
      flash: req.flash "info"
      que: req.loaded
      nav: req._navObj
  tests: (req, res) ->
    
    res.render "pages/tests/tests",
      user: req.user
      flash: req.flash "info"
      que: req.loaded
      nav: req._navObj
