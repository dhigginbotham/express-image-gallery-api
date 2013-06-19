$ = jQuery
$ -> 
  do app = -> 
    window.tags = {}

    fixlabel = (id) -> 
      $('label').each -> 
        this.setAttribute 'for',"feauxinput_#{id}" if this.getAttribute('for') is id
    
    analyzetags = (input, excludecallback = false) -> 
      baseid = input.getAttribute('id').split('feauxinput_').pop()
      # console.log input
      # console.log "BASE ID IS: '#{baseid}'"
      add tag, input.getAttribute 'id' for tag in input.value.split(',') when !(tag in window['tags'][baseid]) && tag isnt ""
      input.value = ""
      updateinput baseid
      callback = document.getElementById(baseid).getAttribute('data-taggable-callback')
      (execute callback, baseid if callback?) if excludecallback is false
    
    add = (tag, inputid) -> 
      baseid = inputid.split('feauxinput_').pop()
      window['tags'][baseid].push tag if tag isnt ""
      span = create { 
        type: 'span'
        attributes: {
          'class': 'badge'
        }
        contains: [
          {
            type: 'i'
            attributes: {
              'class': 'icon-remove-sign'
              'click': 'removetag'              
            }
            contains: [ tag ]
          }
        ]
      }
      document.getElementById("iconcontainer_#{baseid}").appendChild span

    updateinput = (baseid) -> 
      # console.log "BADEID: '#{baseid}'"
      tagscsv = ""
      tagscsv += (if index is 0 then tag else ",#{tag}") for tag, index in window['tags'][baseid]
      document.getElementById(baseid).value = tagscsv

    window.removetag = (i) ->
      baseid = i.parentNode.parentNode.getAttribute('id').split('iconcontainer_').pop()
      tagindex = window['tags'][baseid].indexOf $(i.parentNode).text()
      window['tags'][baseid].splice(tagindex,1) 
      updateinput baseid
      i.parentNode.parentNode.removeChild(i.parentNode)

    execute = (functionName,baseid) -> 
      fn = window[functionName]
      if typeof fn is 'function' then fn baseid else console.log "Taggable Error: Callback Undefined"

    window.taggable = (elem) -> setup elem

    setup = (elem) -> 
      elem.style.display = 'none'
      window['tags'][elem.getAttribute('id')] = []        
      # create client-facing feaux inputs so we can cleanly store tags as CSV's within intended input:
      iconcontainer = create {
        type: 'div'
        attributes: {
          'id': "iconcontainer_#{elem.getAttribute('id')}"            
        }          
        contains: []
      }
      input = create {
        type: 'input'
        attributes: {
          'type': 'text'
          'id': "feauxinput_#{elem.getAttribute('id')}"
          'value': elem.value
        }
        contains: []
      }
      $(input).keyup (e) -> 
        if e.keyCode == 13 or e.keyCode == 188
          analyzetags this
          return false 
      $(input).keydown (e) -> 
        return false if e.keyCode == 13 or e.keyCode == 188
      input.onblur = -> analyzetags this if this.value isnt ""
      elem.parentNode.appendChild input
      elem.parentNode.appendChild iconcontainer
      fixlabel elem.getAttribute 'id'
      analyzetags input,true

    
    do init = -> 
      $('.taggable').each ->
        setup this