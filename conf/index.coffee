# first class fn for our config object
conf = ->

  @app = {}
  @cookie = {}
  @db = {}
  @users = {}
  @pass = {}
  @seed = {}
  @api = {}
  @debug = {}

  ### app settings: ###
  # dev environment is windows probably not the best assumption for 
  # `uploadDir`

  # @param  {title}  String  app name/title
  # @param  {host}  String  app url
  # @param  {port}  Number  app port
  # @param  {uploadDir}  String  default upload dir -we assume our 
  @app.title = "express-img-gal"
  @app.initials = "eig"
  @app.host = if process.env.NODE_ENV == "development" then "http://localhost:3003" else "http://#{@app.initials}.nodejitsu.com"
  @app.port = 3003
  @app.uploadDir = if process.env.NODE_ENV == "development" then "public\\uploads\\" else "public/uploads/"
  @app.welcome = "#{@app.title} server listening on port #{@app.port} in #{process.env.NODE_ENV} mode" if process.env.NODE_ENV == "development"

  # cookie settings:
  # this is a bit faster than redis when redis is not local to the 
  # server

  # @param  {key}  String  cookie name (key)
  # @param  {secret}  String  secret for cookies
  # @param  {maxAge}  Number  max age for login cookie
  @cookie.key = "_#{@app.initials}"
  @cookie.secret = if process.env.NODE_PASS? then process.env.NODE_PASS else "super-secret-passw0rd"
  @cookie.maxAge = 60 * 60 * 1000

  # seed settings:

  # @param  {init}  Boolean  set this to true to create an admin account
  # @param  {password}  String  default password for the app
  @seed.init = true
  @seed.password = if process.env.NODE_PASS? then process.env.NODE_PASS else "super-secret-passw0rd"

  # users settings:

  # @param  {roles}  Array  default user roles
  @users.roles = ['optin', 'user', 'facebook', 'editor', 'admin']

  # db settings:

  # @param  {mongo}  String  mgive mongodb url
  @db.mongo = {}
  @db.mongo.uri = process.env.MGIVE_STRING or "mongodb://localhost/#{@app.initials}"

  # debug setting for app specific modules:

  # @param  {self}  Boolean  Set this value to true to see the config debug to stdout  
  # @param  {que}  Boolean  Set this value to true to see the script loader debug to stdout  
  # @param  {mongo}  Boolean  Set this value to true to see the mongo debug to stdout
  # will override all the other debug settings
  @debug.override = if process.env.NODE_ENV == "production" then false 
  else false # set this to true to get overrides...

  if process.env.NODE_ENV == "development"
    
    @debug.self = if @debug.override == true then true
    else false # set this value to get output for each piece
    @debug.que = if @debug.override == true then true 
    else false # set this value to get output for each piece
    @debug.mongo = if @debug.override == true then true 
    else true # set this value to get output for each piece
    @debug.mgive = if @debug.override == true then true 
    else true # set this value to get output for each piece

  # passport.js settings:

  # @param  {registration}  Boolean  Set this to turn registration on or off
  @pass.registration = false # this will be a static way to open/close registrations

# colors prototype - big thanks to the npm module colors, i didnt
# feel like i needed a bunch of colors so I borrowed a few. :)

# usage: 

#   colors = conf.colors()
#   console.log(colors.red + "some string" + colors.reset)

# @param  {red}  Color  red color to stdout
# @param  {cyan}  Color  cyan color to stdout
# @param  {reset}  Color  reset color to stdout _must be supplied
# at the end of the string, otherwise all your stdouts will be 
# changed to the previous color.
conf::colors = ->
  @colors = {}
  @colors.red = '\x1B[31m'
  @colors.cyan = '\x1B[36m'
  @colors.reset = '\x1B[39m'
  @colors

# extended would be helpful if you are able to access (req, res)
# you can store helper strings here that depend on those two

# will inherit your conf object, like a boss 

# usage:

#   extended = conf.extended()
#   console.log(extended.ip) 

# @param  {registration}  Boolean  Set this to turn registration on or off
conf::extended = (req, res) ->
  false if req == null or typeof req == "undefined"
  @req = {}
  @req.ip = req.headers["x-forwarded-for"] or req.connection.remoteAddress
  @req.user = if req.user? then req.user.username else "anonymous"
  @req.engine = req.protocol + "://" + req.get('host')
  @

_c = new conf()
if _c.debug.self == true
  console.log _c

module.exports = _c
