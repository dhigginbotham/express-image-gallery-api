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
  - `/app`
  - `--/controllers` - each controller should be inside a folder that includes: index, middleware & validation
  - `----/images`
  - `----/main`
  - `----/pages`
  - `----/tags`
  - `----/user`
  - `--/models` - this is where our schemas reside
  - `----/db` - this is where the main db is shared from
  - `----/images`
  - `----/pages`
  - `----/tags`
  - `----/users`
  - `--/views` - views, using mmm currently hogan/handlebars
  - `----/pages` - full pages, these will be indexed from controller routes ie ~ controllers/pages/index.coffee
  - `------/cms` ** to be renamed to match /pages controller & models **
  - `------/images`
  - `------/tags`
  - `------/tests` ** has some hackish stuff... nothing ever works in here
  - `------/users`
  - ``------/view``
  - `----/parts` - these are parts indexed inside the pages 
  - `------/nav`
  - `------/que`
  - `------/upload`
  - `/config` - general purpose config helpers -- passport, que, nav & forms call this home
  - `/helpers` - helper scripts along the way
  - `/public`
  - `--/css`
  - `----/vendor`
  - `--/js`
  - `----/vendor`
  - `----/lib`
  - `--/img`
  - `--/uploads` you really need this folder right now ,=.=);~

##recent
  - refactored `/config/scripts.coffee` added better debugging
  - working on tags client side

##todo
  - sockjs, csrf, ratelimiting, better user roles
  
##routes
  ```
  /users
    /add
    /view
    /:user
      /view
      /edit
      /remove - deprecated
  /tags
    /view
    /add
    /:slug
      /edit
  /images
    /:id
      /edit
    /:page
  /pages
    /view
    /add
    /:slug
      /edit
  ```