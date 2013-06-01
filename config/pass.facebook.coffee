express = require "express"
app = module.exports = express()

passport = require "passport"
util = require "util"
FacebookStrategy = require("passport-facebook").Strategy

# require user schema
User = require "../app/models/users"

if process.env.NODE_ENV == "development"
  FACEBOOK_APP_ID = "146621755523749"
  FACEBOOK_APP_SECRET = "86fb768ad010b4d3615e393872c4fe74"

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

if process.env.NODE_ENV is "development"
  redirect_url = "http://localhost:3001"
else
  redirect_url = process.env.FB_REDIRECT_URL

passport.use new FacebookStrategy
  clientID: FACEBOOK_APP_ID
  clientSecret: FACEBOOK_APP_SECRET
  callbackURL: "#{redirect_url}/auth/facebook/callback"
  scope: "email, user_location, user_likes, publish_actions"
  (accessToken, refreshToken, profile, done) ->
    User.findOne username: profile._json.username, (err, user) ->
      if err
        # console.log "err"
        return done err, null 
      if user
        # console.log "found user passing profile"
        updateUser =
          last_login: new Date profile._json.updated_time
          token: accessToken

        User.update username: profile._json.username, updateUser, (err) ->
            # console.log "updated user"
          if err
            # console.log "updated user error"
            return done err, null 

          # console.log "updated user success"
          process.nextTick () ->
            return done null, user
      else
        # console.log "gonna create user.."
        user = new User
          username: profile._json.username
          token: accessToken
          first_name: profile._json.first_name
          last_name: profile._json.last_name
          email: profile._json.email
          location: profile._json.location
          role: "facebook"
        
        user.save (err, newUser) ->
          if err
            # console.log "error @ create user.."
            return done err, null 
          if newUser
            # console.log "gonna create user.."
            return done null, newUser          
    
      # process.nextTick () ->
      #   done null, profile
      