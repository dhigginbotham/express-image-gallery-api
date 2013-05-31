form = require "express-form"
filter = form.filter
validate = form.validate

_validate = module.exports =
  add:
    form(
      filter("title").trim()
      validate("title").required()
      validate("desc").required()
    )
