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

# app.configure () ->
app.set "views", _views
app.set "view engine", "mmm"
app.set "layout", "layout"

# # pages routes for basic cms stuff
app.get "/view", scripts.embed, nav.render, middle.findAll, routes.view
app.get "/add", pass.ensureAuthenticated, pass.ensureAdmin, nav.render, scripts.embed, routes.add
app.post "/add", pass.ensureAuthenticated, pass.ensureAdmin, valid.add, nav.render, middle.addTag, scripts.embed, routes.add
app.get "/:slug/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.findOne, routes.edit
app.post "/:slug/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.editTag, (req, res) ->
  res.redirect req.get "Referer"
app.get "/:slug", scripts.embed, nav.render, middle.findOne, routes.single
