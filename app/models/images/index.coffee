string = require "../../../helpers"
path = require "path"

moment = require "moment"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

ImageSchema = new Schema
  _id: ObjectId
  title: String
  ts: 
    type: Date
    default: Date.now
  unique: String
  name: String
  type: String
  lastModifiedDate: Date
  path: String
  size: String
  published: 
    type: Boolean
    default: true
  tags: 
    type: ObjectId
    ref: "Tag"
  who: 
    type: String
    ref: "User"

Image = module.exports = db.model "Image", ImageSchema

ImageSchema.statics.process = processImg = (image) ->
  image['tags-count'] = image.tags.length
  image['created-date'] = moment(new Date(image.ts)).fromNow()
  image['image-id'] = image._id

ImageSchema.statics.processImgs = (images) ->
  images.forEach processImg

ImageSchema.pre "save", (next) ->
  this.unique = this.path.replace "public\\uploads\\", ""
  next()