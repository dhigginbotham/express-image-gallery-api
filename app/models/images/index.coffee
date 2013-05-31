string = require "../../../helpers"
path = require "path"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

Tags = new Schema
  _id: String
  title: String
  ts:
    type: Date
    default: Date.now
  desc: String
  who: 
    type: String
    ref: "User"

ImageSchema = new Schema
  _id: ObjectId
  title: String
  file: Object
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
  tags: [Tags]
  who: 
    type: String
    ref: "User"

Image = module.exports = db.model "Image", ImageSchema

ImageSchema.pre "save", (next) ->
  this.unique = this.path.replace "public\\uploads\\", ""
  next()