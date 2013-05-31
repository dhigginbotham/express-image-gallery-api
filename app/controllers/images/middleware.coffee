Image = require "../../models/images"

# native modules
fs = require "fs"
path = require "path"

_images = module.exports =
  handle: (req, res, next) ->
    console.log req.files.file.filename
    img = new Image
      name: req.files.file.name
      type: req.files.file.type
      lastModifiedDate: req.files.file.lastModifiedDate
      path: req.files.file.path
      size: req.files.file.size
      who: req.user

    img.save (err, image) ->
      return next err, null if err
      if image
        console.log image
      process.nextTick () ->
        next()
  findOne: (req, res, next) ->
    Image.findOne(_id: req.params.id).populate('who tags').exec (err, image) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
        next()
      if image
        req.findOne = image
        next()
      else
        req.flash "info", type: "error", title: "Oh Snap!", msg: "No image found... sorry, try again."
        next()
  findAll: (req, res, next) ->
    Image.find (err, image) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
        next()
      if image
        req.findAll = image
        next()
      else
        req.flash "info", type: "error", title: "Oh Snap!", msg: "No pages found... sorry, try again."
        next()
  pagesPagination: (req, res, next) ->
    sort = {ts: -1}

    Image
      .find({published: true})
      .sort(sort)
      .paginate {page: req.params.page, perPage: 5}, (err, pages) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to find any pages"
          next()
        else
          req._page = pages
          next()