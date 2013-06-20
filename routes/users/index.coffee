express = require "express"
app = module.exports = express()
flash = require "connect-flash"

fs = require "fs"
path = require "path"

middle = require "./middleware"
routes = require "./routes"

pass = require "../../lib/passport"
passport = require "passport"

scripts = require "../../lib/assets"
nav = require "../../lib/menus"
conf = require "../../conf"

_views = path.join __dirname, "..", "..", "views"

app.set "views", _views
app.set "view engine", "mmm"
app.set "layout", "layout"

# auth routes
app.get "/login", nav.render, scripts.embed, routes.get.login
app.post "/login", passport.authenticate("local", failureRedirect: "/", failureFlash: false), (req, res) -> 
  res.redirect "/"
app.get "/logout", nav.render, scripts.embed, routes.get.logout
