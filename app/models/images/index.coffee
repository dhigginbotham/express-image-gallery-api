string = require "../../../helpers"
path = require "path"

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

ImageSchema.pre "save", (next) ->
  this.unique = this.path.replace "public\\uploads\\", ""
  next()