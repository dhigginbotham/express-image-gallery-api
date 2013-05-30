string = require "../../../helpers"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

Notes = new Schema
  _id: ObjectId
  title: String
  ts:
    type: Date
    default: Date.now
  note: String
  who: 
    type: String
    ref: "User"
PageSchema = new Schema
  _id: String
  title: String
  ts: 
    type: Date
    default: Date.now
  content: String
  published: 
    type: Boolean
    default: true
  notes: [Notes]
  who: 
    type: String
    ref: "User"

Page = module.exports = db.model "Page", PageSchema

PageSchema.pre "save", (next) ->
  if !this.isModified "title"
    next()
  else
    this._id = string.slugify this.title
    next() 

