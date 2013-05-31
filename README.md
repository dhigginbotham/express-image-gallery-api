#express-image-gallery-api
needed an image gallery base app, kinda playing around you probably don't want any part of this.

##required
  - `process.env.NODE_ENV` this is tested against `"development" || "production"`
  - `process.env.DB_CONNECTION` this is used for mongodb, defaults to: `"mongodb://localhost/imgapi"`
  - `process.env.NODE_PASS` this **isn't** required, you can find a quick way of editing it in `server.coffee`
  - `process.env.FB_REDIRECT_URL` used for production fb redirect url defaults to `"http://localhost:3001"`
  - you will **need** to create a `/public/uploads` folder, I haven't gotten around to the `mkdirp module` yet.
  
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
##recent
  - refactored `/config/scripts.coffee` added better debugging

##todo
