string = require "../../conf/helpers"
mongoose = require "mongoose"
Schema = mongoose.Schema

image = Schema
  title: String
  path: String
  ts:
    type: Date
    default: Date.now 
  uploadedby: 
    type: Schema.Types.ObjectId
    ref: 'User'
  reviewReferences: [
    type: Schema.Types.ObjectId
    ref: 'Review'
  ] 
  strainReferences: [
    type: Schema.Types.ObjectId
    ref: 'Strain' 
  ]
  postReferences: [
    type: Schema.Types.ObjectId 
    ref: 'Post'
  ]
  tags: [
    type: Schema.Types.ObjectId
    ref: 'Tag'
  ]

tagSchema = Schema
  title: String,
  description: String

reviewSchema = Schema
  _id: ObjectId
  title: String
  author: String
  date: String
  article: String
  tags: [
    type: Schema.Types.ObjectId
    ref: "Tag"
  ]
  images: [
    type: Schema.Types.ObjectId
    ref: "Image"
  ]
  attr: { 
    "appearance": String
    "aroma": String
    "buzzlength": String
    "buzztype": String
    "consumptionmethod": String
    "dosage": String
    "flavor": String
    "from": String
    "grade": String
    "lineage": String
    "medicinalqualities": String
    "name": String
    "overall": String
    "packaging": String
    "pickupdate": String
    "price": String
    "reason": String
    "story": String
    "type": String
  }
  _fallbackHTML: String
  _oldURL: String

Review = module.exports = mongoose 'Review', reviewSchema
Tag = module.exports = mongoose 'Tag', tagSchema
Image = module.exports = mongoose 'Strain', reviewSchema