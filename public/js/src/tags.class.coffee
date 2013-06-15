$ = jQuery
$ -> 
  do app = -> 
    window.tags = {}
    app = {}
    fixlabel = (id) -> 
      $('label').each -> 
        this.setAttribute 'for',"feauxinput_#{id}" if this.getAttribute('for') is id
    
    analyzetags = (input) -> 
      baseid = input.getAttribute('id').split('feauxinput_').pop()
      add tag, input.getAttribute 'id' for tag in input.value.split(',') when !(tag in window['tags'][baseid]) && tag isnt ""
      input.value = ""
      updateinput baseid
    
    add = (tag, inputid) -> 
      baseid = inputid.split('feauxinput_').pop()
      window['tags'][baseid].push tag if tag isnt ""
      span  =   createElem "span",  "",   { "class" : "badge" }
      i     =   createElem "i",     "",  { "class" : "icon-remove-sign" }
      i.onclick = -> removetag(this) 
      span.appendChild i
      span.appendChild document.createTextNode tag
      document.getElementById("iconcontainer_#{baseid}").appendChild span

    updateinput = (baseid) -> 
      tagscsv = ""
      tagscsv += (if index is 0 then tag else ",#{tag}") for tag, index in window['tags'][baseid]
      document.getElementById(baseid).value = tagscsv

    removetag = (i) ->
      baseid = i.parentNode.parentNode.getAttribute('id').split('iconcontainer_').pop()
      tagindex = window['tags'][baseid].indexOf $(i.parentNode).text()
      window['tags'][baseid].splice(tagindex,1) 
      updateinput baseid
      i.parentNode.parentNode.removeChild(i.parentNode)
    
    do init = -> 
      $('.taggable').each ->
        this.style.display = 'none'
        window['tags'][this.getAttribute('id')] = []        
        # create client-facing feaux inputs so we can cleanly store tags as CSV's within intended input:
        iconcontainer = createElem "div", "", { "id": "iconcontainer_#{this.getAttribute('id')}" }
        input = createElem "input", "", { "type": "text", "id": "feauxinput_#{this.getAttribute('id')}", "value": this.value }
        $(input).keyup (e) -> 
          if e.keyCode == 13 or e.keyCode == 188
            analyzetags this
            return false 
        $(input).keydown (e) -> 
          return false if e.keyCode == 13 or e.keyCode == 188
        input.onblur = -> analyzetags this
        this.parentNode.appendChild input
        this.parentNode.appendChild iconcontainer
        fixlabel this.getAttribute 'id'
        analyzetags input

createElem = (type,innards,attributes) -> 
  elem = document.createElement type
  elem.appendChild document.createTextNode innards if typeof innards isnt "undefined" and innards isnt "" 
  elem.setAttribute key,val for key,val of attributes if typeof attributes isnt "undefined"
  return elem