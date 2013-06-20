### Express Image Gallery w/ API ###

# get this party started
express = require "express"
flash = require "connect-flash"
# get this party started

sockjs = require "sockjs"
sockjs_conf = require "./lib/sockjs/config"
sockjs_app = require "./lib/sockjs"

app = express()
server = require("http").createServer app

sockjs_app.install sockjs_conf.server_opts, server

# global connection sharing
_db = require "./models/db"

# native modules
fs = require "fs"
path = require "path"

conf = require "./conf"
passport = require "passport"
_passport = require "./lib/passport"


# init required folders
initPath = path.join __dirname, "public", "uploads"
init = require("./conf/helpers").init initPath

# routes, middleware, etc etc
users = require "./routes/users"
home = require "./routes/home"
images = require "./routes/images"
pages = require "./routes/pages"
tags = require "./routes/tags"

#app.use on our routes.
app.use users
app.use home
app.use "/images", images
app.use pages
app.use tags

_views = path.join __dirname, "views"

# default application configuration
app.configure () ->
  app.set "port", conf.app.port || process.env.port
  app.use express.logger "dev"
  app.use express.compress()
  if process.env.NODE_ENV == "development"
    app.set "port", conf.app.port
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true
  app.use express.favicon()
  app.use express.bodyParser 
    keepExtensions: true
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.cookieSession
    key: conf.cookie.key
    secret: conf.cookie.secret
    cookie: maxAge: conf.cookie.maxAge
  app.use passport.initialize()
  app.use passport.session()
  app.use flash()
  app.use app.router
  app.use express.static path.join __dirname, "public"
  app.use express.errorHandler()
  # app.use (req, res) ->
  #   res.status 404
  #   res.render "pages/404", 
  #     title: "404: File Not Found"
  # app.use (err, req, res, next) ->
  #   res.status 500
  #   res.render "pages/404", 
  #     title: "500: Internal Server Error"
  #     err: err

# go!
server.listen conf.app.port, () ->
  col = conf.colors()
  console.log "#{col.cyan}::#{col.reset} starting engine #{col.cyan}::#{col.reset} #{conf.app.welcome} #{col.cyan}::#{col.reset} "

process.on "SIGINT", () ->
  db.close()
  server.close()
  process.exit()
