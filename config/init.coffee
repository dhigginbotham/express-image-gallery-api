# native modules
fs = require "fs"
path = require "path"
mkdirp = require "mkdirp"
util = require "util"

_init =
  exists: (folder, fn) ->
    fs.exists folder, (exists) ->
      if !exists
        console.log "no folder found!"
        fn folder if fn?
      else
        fn null
  make: (folder, fn) ->
    if folder != null
      mkdirp folder, (err) ->
        fn err if err
        fn folder if fn?
    else
      fn "nope.."
  init: (folder) ->
    _init.exists folder, (data) ->
      _init.make folder, (data2) ->

module.exports = _init