$ = jQuery
$ -> 
  do app = -> 
    window.tags = []
    app = {}
    fixlabel = (id) -> 
      $('label').each -> 
        this.setAttribute 'for',"feauxinput_#{id}" if this.getAttribute('for') is id
    
    analyzetags = (input) -> 
      add tag, input.getAttribute 'id' for tag in input.value.split(',') when !(tag in window.tags) && tag isnt ""
      input.value = ""
      updateinput input.getAttribute('id').split('feauxinput_').pop()
    
    add = (tag, inputid) -> 
      window.tags.push tag
      baseid = inputid.split('feauxinput_').pop()
      span  =   createElem "span",  "",   { "class" : "badge" }
      i     =   createElem "i",     "",  { "class" : "icon-remove-sign" }
      i.onclick = -> removetag(this) 
      span.appendChild i
      span.appendChild document.createTextNode tag
      document.getElementById("iconcontainer_#{baseid}").appendChild span

    updateinput = (baseid) -> 
      tagscsv = ""
      tagscsv += (if index is 0 then tag else ",#{tag}") for tag, index in window.tags
      document.getElementById(baseid).value = tagscsv

    removetag = (i) ->
      tagindex = window.tags.indexOf $(i.parentNode).text()
      window.tags.splice(tagindex,1) 
      updateinput i.parentNode.parentNode.getAttribute('id').split('iconcontainer_').pop()
      i.parentNode.parentNode.removeChild(i.parentNode)
    
    do init = -> 
      $('.taggable').each ->
        this.style.display = 'none'
        # create client-facing feaux inputs so we can clearnly store tags as CSV's within intended input:
        iconcontainer = createElem "div", "", { "id": "iconcontainer_#{this.getAttribute('id')}" }
        input = createElem "input", "", { "type": "text", "id": "feauxinput_#{this.getAttribute('id')}"}
        $(input).keyup (e) -> 
          if e.keyCode == 13 or e.keyCode == 188
            analyzetags this
            return false 
        this.parentNode.appendChild input
        this.parentNode.appendChild iconcontainer
        fixlabel this.getAttribute 'id'

createElem = (type,innards,attributes) -> 
  elem = document.createElement type
  elem.appendChild document.createTextNode innards if typeof innards isnt "undefined" and innards isnt "" 
  elem.setAttribute key,val for key,val of attributes if typeof attributes isnt "undefined"
  return elem