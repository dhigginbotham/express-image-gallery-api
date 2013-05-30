trim = (str) -> str.replace(/^\s\s*/, '').replace /\s\s*$/, ''

stripVowelAccent = (str) ->
  s = str

  rExps = [
    /[\xC0-\xC4]/g, /[\xE0-\xE5]/g,
    /[\xC8-\xCB]/g, /[\xE8-\xEB]/g,
    /[\xCC-\xCF]/g, /[\xEC-\xEF]/g,
    /[\xD2-\xD6]/g, /[\xF2-\xF6]/g,
    /[\xD9-\xDC]/g, /[\xF9-\xFC]/g
  ]

  repChar = [ 'A', 'a', 'E', 'e', 'I', 'i', 'O', 'o', 'U', 'u' ]

  for i in [0..rExps.length]
    s = s.replace rExps[i], repChar[i]

  return s

slugify = (str) ->
  stripped = stripVowelAccent str
  return stripped.replace(/[^A-Za-z0-9 ]/g, "").replace(/[ ]+/g, "-").toLowerCase().substr 0, 81

module.exports =
  trim: trim
  slugify: slugify