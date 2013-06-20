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

# images routes
app.get "/", scripts.embed, nav.render, middle.pagesPagination, routes.view
app.get "/:id/edit", scripts.embed, nav.render, middle.findOne, routes.edit
app.post "/:id/edit", middle.storeTags, middle.editImg, (req, res) ->
  res.redirect req.get "Referer"

app.get "/:page", scripts.embed, nav.render, middle.pagesPagination, routes.view

app.post "/upload", middle.saveImg, middle.handle, routes.upload
