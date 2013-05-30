express = require "express"
sockjs = require "sockjs"
flash = require "connect-flash"

if process.env.NODE_ENV == "development"
  # process.env.NODE_PASS = "some-pass"
  process.env.NODE_SEED = true
 
sockjs_opts = sockjs_url: "http://cdn.sockjs.org/sockjs-0.3.min.js"
sockjs_echo = sockjs.createServer sockjs_opts
 
sockjs_echo.on "connection", (conn) ->
  conn.on "data", (message) ->
    conn.write message
 
app = express()
server = require("http").createServer app
 
sockjs_echo.installHandlers server,
  prefix: "/echo"

# global connection sharing
shared_db = require "./app/models/db"

# native modules
fs = require "fs"
path = require "path"

# passport auth middleware
pass = require "./config/pass"
pass_facebook = require "./config/pass.facebook"
passport = require "passport"

# controllers / routes
userController = require "./app/controllers/user"
pagesController = require "./app/controllers/pages"
mainController = require "./app/controllers/main"

# route middleware
user_middleware = require "./app/controllers/user/middleware"
pages_middleware = require "./app/controllers/pages/middleware"
main_middleware = require "./app/controllers/main/middleware"

# middleware / helpers
scripts = require "./config/scripts"
forms = require "./config/forms"
nav = require "./config/nav"

# validation middleware
pages_validate = require "./app/controllers/pages/validate"
user_validate = require "./app/controllers/user/validate"

# default application configuration
app.configure () ->
  app.set "port", process.env.port
  app.set "views", "./app/views"
  app.set "view engine", "mmm"
  app.set "layout", "layout"
  app.use express.compress()
  if process.env.NODE_ENV == "development"
    app.set "port", 3001
    app.use express.logger "dev"
    app.use express.errorHandler 
      dumpExceptions: true
      showStack: true
  # app.use express.favicon(__dirname + "/public/img/icon.ico")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  # using cooking sessions to improve overall speed
  app.use express.cookieSession
    secret: "cookie-secret"
    cookie:
      maxAge: 60 * 60 * 1000
  app.use passport.initialize()
  app.use passport.session()
  app.use flash()
  app.use app.router
  app.use express.static path.join __dirname, "public"

# routes & middleware

# index route
app.get "/", scripts.embed, nav.render, mainController.index

# tests and shit
app.get "/tests", scripts.embed, nav.render, mainController.tests

# user routes
app.get "/login", scripts.embed, nav.render, userController.get.login
app.post "/login", 
  passport.authenticate "local",
    failureRedirect: "/login" 
    failureFlash: true
  (req, res) -> return res.redirect "/"
app.get "/logout", scripts.embed, nav.render, pass.ensureAuthenticated, userController.get.logout
app.get "/register", scripts.embed, nav.render, userController.get.register
app.post "/register", user_validate.register, user_middleware.Create, userController.post.register

# passport-facebook routes
app.get "/auth/facebook", passport.authenticate("facebook"), (req, res) ->
app.get "/auth/facebook/callback", passport.authenticate("facebook", failureRedirect: "/login"), (req, res) ->
  res.redirect req.get "Referer"

# users routes
app.get "/users/add", scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, nav.render, userController.get.make
app.post "/users/add", pass.ensureAuthenticated, pass.ensureAdmin, nav.render, user_middleware.Create, userController.post.make
app.get "/users/view", scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, nav.render, user_middleware.userPaging, userController.get.view
app.get "/users/view/:page", scripts.embed, pass.ensureAuthenticated, pass.ensureAdmin, nav.render, user_middleware.userPaging, userController.get.view
app.get "/users/edit", scripts.embed, pass.ensureAuthenticated, nav.render, userController.get.userEdit
app.post "/users/edit", scripts.embed, pass.ensureAuthenticated, nav.render, user_middleware.Update, userController.post.userEdit
app.get "/users/:user/edit", scripts.embed, pass.ensureAuthenticated, nav.render, pass.ensureAdmin, userController.get.edit
app.post "/users/:user/edit", scripts.embed, pass.ensureAuthenticated, nav.render, pass.ensureAdmin, user_middleware.Update, userController.post.edit
app.get "/users/:user/remove", scripts.embed, pass.ensureAuthenticated, nav.render, pass.ensureAdmin, userController.get.remove

# pages routes for basic cms stuff
app.get "/pages/view", scripts.embed, nav.render, pages_middleware.findAll, pagesController.view
app.get "/pages/add", pass.ensureAuthenticated, pass.ensureAdmin, nav.render, scripts.embed, pagesController.add
app.post "/pages/add", pass.ensureAuthenticated, pass.ensureAdmin, pages_validate.add, nav.render, pages_middleware.addPage, scripts.embed, pagesController.add
app.get "/pages/:id/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, pages_middleware.findOne, pagesController.edit
app.post "/pages/:id/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, pages_middleware.editPage, (req, res) ->
  res.redirect req.get "Referer"
app.get "/pages/:id", scripts.embed, nav.render, pages_middleware.findOne, pagesController.single 

# go!
server.listen app.get("port"), () ->
  console.log "Express server listening on port #{app.get("port")} in #{app.settings.env || process.env.NODE_ENV} mode"