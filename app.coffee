### Express Image Gallery w/ API ###
conf = require "./conf"

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

# initialize our mongodb dev session store
SessionStore = require("session-mongoose")(express)
store = new SessionStore
  url: conf.db.mongoUrl
  interval: 120000 # expiration check worker run interval in millisec (default: 60000)

# native modules
fs = require "fs"
path = require "path"

passport = require "passport"
_passport = require "./lib/passport"

# init required folders
initPath = path.join __dirname, "public", "uploads"
init = require("./conf/helpers").init initPath

# routes, middleware, etc etc
home = require "./routes/home"
users = require "./routes/users"
images = require "./routes/images"
pages = require "./routes/pages"
tags = require "./routes/tags"

_views = path.join __dirname, "views"

# default application configuration
# app.configure () ->
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
# SESSION STORE THROUGH MONGODB
app.use express.session
  store: store
  secret: conf.seed.password
  cookie: maxAge: 900000
# SESSION STORE THROUGH COOKIES
# app.use express.cookieSession
#   key: conf.cookie.key
#   secret: conf.cookie.secret
#   cookie: maxAge: conf.cookie.maxAge
app.use passport.initialize()
app.use passport.session()
app.use flash()

#app.use on our routes.
app.use home
app.use users
app.use "/images", images
app.use "/pages", pages
app.use "/tags", tags

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
