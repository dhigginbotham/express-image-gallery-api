string = require "../../../helpers"
path = require "path"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

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

Tag = module.exports = db.model "Tag", TagSchema