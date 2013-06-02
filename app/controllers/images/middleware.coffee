Image = require "../../models/images"

# native modules
fs = require "fs"
path = require "path"

_images = module.exports =
  handle: (req, res, next) ->

    img = new Image
      name: req.files.file.name
      type: req.files.file.type
      lastModifiedDate: req.files.file.lastModifiedDate
      path: req.files.file.path
      size: req.files.file.size
      who: req.user
      tags: req.body.tags

    img.save (err, image) ->
      return next err, null if err
      next()
  editImg: (req, res, next) ->
    console.log req.body
    if req.body? && req.body.title?
      if req.body.published? && req.body.published == "on"
        published = true
      else
        published = false

      img =
        title: req.body.title
        published: published

      Image.update _id: req.params.id, img, safe: true, (err, img) ->
        if err?
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if img?
          req.flash "info", type: "success", title: "Awesome", msg: "You made a img!"
          req._img = img
        process.nextTick () ->
          next()
  findOne: (req, res, next) ->
    Image.findOne(_id: req.params.id, published: true).populate("who tags").exec (err, image) ->
      if err?
        req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
        next()
      if image?
        req.findOne = image
        next()
      else
        req.flash "info", type: "error", title: "Oh Snap!", msg: "No image found... sorry, try again."
        next()
  findAll: (req, res, next) ->
    Image.findAll published: true, (err, image) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
        next()
      if image?
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