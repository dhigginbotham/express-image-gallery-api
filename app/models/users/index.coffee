# mongoose = require("../db").mongoose
# db = require("../db").db

string = require "../../../helpers"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

bcrypt = require "bcrypt"
SALT_WORK_FACTOR = 10

UserSchema = new Schema
  email:
    type: String
    default: false
  username:
    type: String
    unique: true
    required: true
  password:
    type: String
  admin: 
    type: Boolean
    default: false
  created: 
    type: Date
    default: Date.now
  ip: String
  first_name: String
  last_name: String
  token: String
  zip: String
  phone: String
  location: Object
  last_login: 
    type: Date
    default: Date.now
  source: String
  active: 
    type: Boolean
    default: true
  role:
    type: Number
    default: 0

UserSchema.pre "save", (next) ->
  user = this

  if user.token || !user.isModified "password"
    return next()
  else
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      if err
        return next(err)
      bcrypt.hash user.password, salt, (err, hash) ->
        if err
          return next(err)
        else
          user.password = hash
          return next()

UserSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, this.password, (err, isMatch) ->
    if err
      return cb(err)
    cb null, isMatch

User = module.exports = db.model "User", UserSchema

if process.env.NODE_SEED
  db.once "open", () ->
    User.findOne 
      username: "admin", (err, docs) ->
        return err if err
        if !docs
          admin = new User
            username: "admin"
            password: process.env.NODE_PASS
            admin: true
            email: "admin@localhost.it"
            ip: "admin.ipv6"

          admin.save (err) ->
            return err if err
