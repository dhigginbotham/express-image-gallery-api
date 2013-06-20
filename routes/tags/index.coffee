express = require "express"
app = module.exports = express()
flash = require "connect-flash"

fs = require "fs"
path = require "path"

middle = require "./middleware"
routes = require "./routes"
valid = require "./validate"

pass = require "../../lib/passport"

scripts = require "../../lib/assets"
nav = require "../../lib/menus"
conf = require "../../conf"

_views = path.join __dirname, "..", "..", "views"

app.set "views", _views
app.set "view engine", "mmm"
app.set "layout", "layout"

# # pages routes for basic cms stuff
app.get "/view", nav.render, scripts.embed, middle.findAll, routes.view
app.get "/add", nav.render, scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, routes.add
app.post "/add", nav.render, scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, valid.add, middle.addTag, routes.add
app.get "/:slug/edit", nav.render, scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, middle.findOne, routes.edit
app.post "/:slug/edit", nav.render, scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, middle.editTag, (req, res) ->
  res.redirect req.get "Referer"
app.get "/:slug", nav.render, scripts.embed, middle.findOne, routes.single
