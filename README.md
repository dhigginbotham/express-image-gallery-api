#express-image-gallery-api
needed an image gallery base app, kinda playing around you probably don't want any part of this.

##required
  - `process.env.NODE_ENV` this is tested against `"development" || "production"`
  - `process.env.DB_CONNECTION` this is used for mongodb, defaults to: `"mongodb://localhost/imgapi"`
  - `process.env.NODE_PASS` this **isn't** required, you can find a quick way of editing it in `server.coffee`
  - `process.env.FB_REDIRECT_URL` used for production fb redirect url defaults to `"http://localhost:3001"`
    - you'll need to create your own facebook app:
      ```
        ~/config/pass.facebook.coffee:

        if process.env.NODE_ENV == "development"
          FACEBOOK_APP_ID = "146621755523749"
          FACEBOOK_APP_SECRET = "86fb768ad010b4d3615e393872c4fe74"

      ```
  - you will **need** to create a `/public/uploads` folder, I haven't gotten around to the `mkdirp module` yet.

##folder structure
- `app`
  - `controllers` - each controller should be inside a folder that includes: index, middleware & validation
    - `images` `res.render` for `images` routes
    - `main` `res.render` for `main` routes
    - `pages` `res.render` for `pages` routes
    - `tags` `res.render` for `tags` routes
    - `user` `res.render` for `user` routes
  - `models` this is where our schemas reside
    - `db` this is where the main db is shared from
    - `images` images model still heavily `WIP`
    - `pages` basic pages model with notes subdoc
    - `tags` tag schema, rather than subdocs I'll populate collections
    - `users` users schema
  - `views` views, using [mmm](https://github.com/techhead/mmm) Mustache Marked Media
    - `pages` full pages, these will be indexed from controller routes ie ~ controllers/pages/index.coffee
      - `pages` has all the crud stuff for creating pages/archives
      - `images` will have all the crud/views for `images` routes
      - `tags` `WIP` I need a good way of handling tags for images
      - `tests` __has some hackish stuff... nothing ever works in here__
      - `users` has the `login` and `register` pages
      - `view` **deprecated**, no longer sharing this view, messy
    - `parts` these are parts indexed inside the pages
      - `nav` navigation parts, this is still under heavy work
      - `que` you can find the script loader templates, they are included in the `layout.mmm` file
      - `upload` different upload parts for experimenting / dropping in upload components
- `config` general purpose config helpers -- passport, que, nav & forms call this home
- `helpers` helper scripts along the way
- `public`
  - `css`
    - `vendor`
  - `js`
    - `vendor`
    - `lib`
  - `img`
  - `uploads` **(you really need this folder right now)**

##recent
  - refactored `/config/scripts.coffee` added better debugging
    - added `scripts.settings.verbose` output mode
    - added `scripts.logging` fn to get a pre-count of the files about to be loaded -- was dealing with high latency issues and massive post requests, so I figure it was a good time to run through them.
  - working on tags client side

##todo
  - sockjs, csrf, ratelimiting, better user roles
  - add cdn hosted image support
