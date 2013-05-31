Tag = require "../../models/tags"
###
TagSchema = new Schema
  _id: ObjectId
  title: String
  ts: 
    type: Date
    default: Date.now
  desc: String
  published:
    type: Boolean
    default: true
  who: 
    type: String
    ref: "User"
  slug: String
###
_tags = module.exports =
  addTag: (req, res, next) ->
    if req.body? && req.body.title?

      if req.body.published? && req.body.published == "on"
        published = true
      else
        published = true

      tag = new Tag
        title: req.body.title
        desc: req.body.desc
        who: req.user._id
        slug: req.body.slug
        published: published
        
      tag.save (err, tag) ->
        if err?
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if tag?
          req.flash "info", type: "success", title: "Awesome", msg: "You made a tag!"
          req._tag = tag
          next()
        else
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error creating your tag"
          next()        
  editTag: (req, res, next) ->
    if req.body? && req.body.title?

      if req.body.published? && req.body.published == "on"
        published = true
      else
        published = true

      tag =
        slug: req.body.slug
        title: req.body.title
        desc: req.body.desc
        who: req.user._id
        published: published

      Tag.update _id: req.params.id, tag, safe: true, (err, tag) ->
        if err?
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if tag?
          req.flash "info", type: "success", title: "Awesome", msg: "You made a tag!"
          req._tag = tag
          next()
  findOne: (req, res, next) ->
    Tag.findOne _id: req.params.id, (err, tag) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
        next()
      if tag
        req._tag = tag
        next()
      else
        req.flash "info", type: "error", title: "Oh Snap!", msg: "No tag found... sorry, try again."
        next()
  findAll: (req, res, next) ->
    Tag.find (err, tag) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if tag
          req._tag = tag
          next()
        else
          req.flash "info", type: "error", title: "Oh Snap!", msg: "No pages found... sorry, try again."
          next()
  pagesPagination: (req, res, next) ->
    sort = {created: -1}

    Tag
      .find({})
      .sort(sort)
      .paginate {page: req.params.page, perPage: 25}, (err, pages) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to find any pages"
          next()
        else
          req._page = pages
          next()