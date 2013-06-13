Image = require "../../models/images"

# native modules
fs = require "fs"
path = require "path"

_images = module.exports =
  createFile: (req, res, next) ->
    req._path = path.join __dirname, "..", "..", "..", "public", "uploads", req.files.file.name
    console.log "im getting hit nigga"
    fs.readFile req.files.file.path, (err, data) ->
      fs.writeFile req._path, data, (err) ->
        next err, null if err?
        next null, data

  handle: (req, res, next) ->

    img = new Image
      name: req.files.file.name
      type: req.files.file.type
      lastModifiedDate: req.files.file.lastModifiedDate
      path: req._path
      size: req.files.file.size
      who: req.user
      tags: req.body.tags

    img.save (err, image) ->
      return next err, null if err
      next()

  editImg: (req, res, next) ->
    console.log req.body
    if req.body? && req.body.title?
      if req.body.published?
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
          req.flash "info", type: "success", title: "Awesome", msg: "Image data successfully updated!"
          req._img = img
        process.nextTick () ->
          next()
  findOne: (req, res, next) ->
    Image.findOne(_id: req.params.id).populate("who tags").exec (err, image) ->
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
    Image.findAll (err, image) ->
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
      .find()
      .sort(sort)
      .paginate {page: req.params.page, perPage: 5}, (err, pages) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to find any pages"
          next()
        else
          req._page = pages
          next()
