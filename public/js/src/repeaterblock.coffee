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
		li = create nestableitem $(item).text()
		@nest.appendChild li

	setupnestable: -> 
		div = create 
			type: 'div'
			attributes: 
				'class': 'dd'
			contains: [
				type: 'ol'
				attributes: 
					'class': 'dd-list'
				contains: []
			]
		@nest = div.getElementsByTagName('ol')[0]
		# div = createElem 'div', '', { 'class': 'dd' }
		# @nest = createElem 'ol', '', { 'class': 'dd-list' } 
		# div.appendChild @nest
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

# define some html schemas:
nestableitem = (text) -> 
	return {
		type: 'li'
		attributes: { 
			'class': 'dd-item'
		}
		contains: [
			{
				type: 'div'
				attributes: {
					'class': 'dd-handle'
				}
				contains: [
					text,
				]
			},
			{
				type: 'select'
				attributes: {}
				contains: [
					{
						type: 'option'
						attributes: {}
						contains: ["HELLO WORLD 1"]
					},
					{
						type: 'option'
						attributes: {}
						contains: ["HELLO WORLD 2"]
					},
					{
						type: 'option'
						attributes: {}
						contains: ["HELLO WORLD 3"]
					}
				]
			},
			{
				type: 'i'
				attributes: {
					'class': 'icon-remove-circle'
				}
				contains: []
			}
		]
	}
