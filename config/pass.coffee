passport = require "passport"
LocalStrategy = require("passport-local").Strategy

User = require "../app/models/users"

# passport.serializeUser (user, done) ->
#   done null, user._id

# passport.deserializeUser (id, done) ->
#   User.findOne _id: id, (err, user) ->
#     done err, user

passport.use new LocalStrategy (username, password, done) ->
  User.findOne username: new RegExp(username, 'i'), (err, user) ->
    return done err if err
    return done null, false, message: "Unknown user " + username if !user
    user.comparePassword password, (err, isMatch) ->
      return done err if err
      if isMatch
        return done null, user 
      else 
        done null, false, message: "Invalid Password"

exports.ensureAuthenticated = ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  res.redirect "/login"

exports.ensureAdmin = ensureAdmin = (req, res, next) ->
  if req.user && req.user.admin == true 
    next() 
  else 
    res.send(403)