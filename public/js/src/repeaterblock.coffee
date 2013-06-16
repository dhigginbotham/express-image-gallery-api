repeaters = {}

window.populatenestable = (baseid) -> 
	do repeaters[baseid].update

class repeaterblock 
	items: []
	constructor: (@inputid,@baseinput,@iconcontainer,@basecontainer) ->
		# init: 
		do @setupnestable
		do @update
		# other misc. setup: 
		document.getElementById("feauxinput_#{@inputid}").style.float = 'left'
	update: -> 
		newItems = []
		$(@iconcontainer).children('span.badge').each -> 
			if !($(this).hasClass 'already_nested') 
				$(this).addClass 'already_nested'
				newItems.push this
		@add item for item in newItems
	add: (item) -> 
		console.log 'hello'
		li = createElem 'li', '', { 'class': 'dd-item' }
		div = createElem 'div', $(item).text(), { 'class': 'dd-handle' } 
		li.appendChild div
		@nest.appendChild li
		console.log @nest
	setupnestable: -> 
		div = createElem 'div', '', { 'class': 'dd' }
		@nest = createElem 'ol', '', { 'class': 'dd-list' } 
		div.appendChild @nest
		@basecontainer.appendChild div
		$(div).nestable()


$ = jQuery
$ -> 
	do init = -> 
		$('.repeaterblock').each -> 
			inputid = false
			innerdivs = this.getElementsByTagName 'div'
			for div in innerdivs
					if div.getAttribute('id').indexOf 'icon_container' > -1
						iconcontainer = div
						div.style.display = 'none'
			div.style.display = 'none' if div.getAttribute('id').indexOf 'icon_container' > -1 for div in innerdivs
			innerinputs = this.getElementsByTagName 'input'
			for input in innerinputs
				if input.getAttribute('class') is 'taggable'
					inputid = input.getAttribute 'id' 
					theinput = input
			if inputid then repeaters[inputid] = new repeaterblock inputid,theinput,iconcontainer,this else console.log "Error setting up Repeater Block, missing '.taggable' input."

createElem = (type,innards,attributes) -> 
  elem = document.createElement type
  elem.appendChild document.createTextNode innards if typeof innards isnt "undefined" and innards isnt "" 
  elem.setAttribute key,val for key,val of attributes if typeof attributes isnt "undefined"
  return elem