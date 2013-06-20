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

# pages routes for basic cms stuff
app.get "/pages/view", scripts.embed, nav.render, middle.findAll, routes.view
app.get "/pages/add", pass.ensureAuthenticated, pass.ensureAdmin, nav.render, scripts.embed, routes.add
app.post "/pages/add", pass.ensureAuthenticated, pass.ensureAdmin, valid.add, nav.render, middle.addPage, scripts.embed, routes.add
app.get "/pages/:slug/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.findOne, routes.edit
app.post "/pages/:slug/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.editPage, (req, res) ->
  res.redirect req.get "Referer"
app.get "/pages/:slug", scripts.embed, nav.render, middle.findOne, routes.single
