scripts = module.exports =
  items: [
    # defaults and such
    {src: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css', name: 'bootstrap.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome.css', name: 'font-awesome.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '/css/style.css', name: 'style.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js', name: 'jquery.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js', name: 'bootstrap.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: 'http://cdn.sockjs.org/sockjs-0.3.min.js', name: 'sockjs', where: 'foot', uri: null, type: 'js', exclude: null}
    # pages routes
    {src: '/js/vendor/nicEdit.js', name: 'nicEdit.js', where: 'foot', uri: '/pages/add', type: 'js', exclude: null}
    {src: '/js/vendor/nicEdit.js', name: 'nicEdit.js', where: 'foot', uri: '/pages/:id/edit', type: 'js', exclude: null}
    {src: '/js/lib/pages.client.js', name: 'pages.client.js', where: 'foot', uri: '/pages/add', type: 'js', exclude: null}
    {src: '/js/lib/pages.client.js', name: 'pages.client.js', where: 'foot', uri: '/pages/:id/edit', type: 'js', exclude: null}
    # test routes
    if process.env.NODE_ENV == "development"
      {src: 'http://jashkenas.github.com/coffee-script/extras/coffee-script.js', name: 'coffee-script.js', where: 'foot', uri: null, type: 'js', exclude: null}
  ]

  embed: (req, res, next) ->

    # -- 5/17/13 --
    # needs the ability to have uri arrays for multiple 
    # pages to remove line duplications for such a small
    # change in the routes. @dh

    # scratch that, this is fine -- @dl

    # colors, thanks to the colors module library
    # i didn't feel the need for a dependency only 
    # development - so thank you, in advance
    red = '\x1B[31m'
    cyan = '\x1B[36m'
    reset = '\x1B[39m'

    script = scripts.items
    
    Object.create embed =
      head:
        js: []
        css: []
      foot:
        js: []
        css: []

    for ctx in script
      do (ctx) ->
        if embed.head[ctx.type] || embed.foot[ctx.type]
          console.log "#{red}Excluding:#{reset} #{ctx.name}" if ctx.exclude == req.route.path and process.env.NODE_ENV is "development"
          if ( ctx.uri == req.route.path || ctx.uri == null ) and ctx.exclude != req.route.path
            console.log "#{cyan}Including:#{reset} #{ctx.name} into #{ctx.where}er" if process.env.NODE_ENV is "development"
            embed[ctx.where][ctx.type].push ctx

    process.nextTick () ->
      req.loaded = embed
      next()