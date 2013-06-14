Image = require "../../models/images"
helpers = require "../../../helpers"

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

  saveImg: (req, res, next) ->
    if req.files.file? && req.files.file.length > 0
      if req.files.file.name.match /\.(jpe?g|gif|png)$/gi
        reg = /^(.*\/)?[^\/]+\.(jpe?g|gif|png)$/i
        repChar = "$1#{helpers.uniqueId(30)}.$2"
        newImageName = req.files.file.name.replace reg, repChar

        imagePath = path.join __dirname, "..", "..", "..", "public", "uploads", newImageName
        fs.readFile req.files.file.path, (err, data) ->
          fs.writeFile imagePath, data, (err) ->
            next err, null if err?
            console.log err
            req._imgName = newImageName
            req.files.file.name = newImageName
            next()
      else
        next "unsupported image format uploaded, try again.", null
    else
      req._imgName = null
      next()

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
      published = if req.body.published? then true else false
      tags = if req.body.tagInput? then req.body.tagInput.split ',' else []
      console.log "THESE ARE THE TAGS >>> "
      console.log tags
      img =
        title: req.body.title
        published: published
        tags: tags

      Image.update _id: req.params.id, img, safe: true, (err, img) ->
        if err?
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if img?
          req.flash "info", type: "success", title: "Awesome", msg: "Image data successfully updated!"
          req._img = img
          next()
  findOne: (req, res, next) ->
    Image.findOne(_id: req.params.id).populate("who tags").exec (err, image) ->
      if err?
        console.log "ERROR::::::"
        console.log err.message
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
