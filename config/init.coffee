# native modules
fs = require "fs"
path = require "path"
mkdirp = require "mkdirp"
util = require "util"

red = '\x1B[31m'
cyan = '\x1B[36m'
reset = '\x1B[39m'

_init =
  exists: (err, folder, fn) ->
    fs.exists folder, (exists) ->
      if !exists
        fn null, folder if fn?
      else
        fn "folder exists", null
  make: (err, folder, fn) ->
    if folder != null
      mkdirp folder, (err) ->
        fn err, null if err
        fn null, folder
    else
      fn "folder is null", null
  init: (folder) ->
    _init.exists null, folder, (err, data) ->
      _init.make null, data, (err, added) ->
        if added != null
          console.log "#{cyan}Creating:#{reset} #{added}"

module.exports = _init