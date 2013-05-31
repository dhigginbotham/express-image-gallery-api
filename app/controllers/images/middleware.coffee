# native modules
fs = require "fs"
path = require "path"

_images = module.exports =
  handle: (req, res, next) ->
    # for files in req.body.file
    #   do (files) ->
    #     console.log files
    #     fs.readFile files, (err, data) ->
    #       console.log data
    #       path = "#{__dirname}/../../../public/uploads/#{files}"
    #       fs.writeFile path, data, (err) ->
    #         console.log "creating #{path}" 
    #         if err
    #           console.log err
    #           req.flash "info", type: "error", title: "Oh Snap!", msg: "Looks like we had an issue uploading the image, try again."

    # console.log req.files
    process.nextTick () ->
      next()