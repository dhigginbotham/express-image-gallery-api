express = require "express"
app = module.exports = express()
flash = require "connect-flash"

fs = require "fs"
path = require "path"

middle = require "./middleware"
routes = require "./routes"
valid = require "./validate"

pass = require "../../lib/passport"
passport = require "passport"

scripts = require "../../lib/assets"
nav = require "../../lib/menus"
conf = require "../../conf"

_views = path.join __dirname, "..", "..", "views"

app.configure () ->
  app.set "views", _views
  app.set "view engine", "mmm"
  app.set "layout", "layout"
  app.use express.bodyParser 
    keepExtensions: true
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.cookieSession
    key: conf.cookie.key
    secret: conf.cookie.secret
    cookie: maxAge: conf.cookie.maxAge
  # app.use passport.initialize()
  # app.use passport.session()
  app.use flash()

# images routes
app.get "/", scripts.embed, nav.render, middle.pagesPagination, routes.view
app.get "/:id/edit", scripts.embed, nav.render, middle.findOne, routes.edit
app.post "/:id/edit", middle.storeTags, middle.editImg, (req, res) ->
  res.redirect req.get "Referer"

app.get "/:page", scripts.embed, nav.render, middle.pagesPagination, routes.view

app.post "/upload", middle.saveImg, middle.handle, routes.upload
