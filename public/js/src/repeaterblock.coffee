# moved this here for ease of access: define new options for the repeater block type here: 
# add an item here and the idea is it will auto-populate thru everything else unless it needs
# special activation like a nicEdit WYSIWYG editor, in which case use the switch statement in 
# repeaterblock.updateinputtype ->
repeatertypes =
	'heading':
		name: 'Heading or Sub-Heading/Category'
		obj: false 
	'gallery':  
    name: 'Insert Gallery/Image'
    obj: (id) -> 
    	return {
	      type: 'form'
		    attributes: { 'id': id, 'action': '/file-upload', 'class': 'dropzone' }
    	}
  'textlong': 
  	name: 'Long Text Entry'
  	obj: (id) -> 
  		return {
	  		type: 'textarea'
	  		attributes: { 
	  			'id': id 
	  			'cols': '500'
	  		}
  		}
  'textshort': 
  	name: 'Short Text Entry'
  	obj: (id) -> 
  		return {
	  		type: 'input'
				attributes:
					'id': id 
					'type': 'text'
					'value': ''
  		}
  'list': # utilize taggable and repeaterblock to create a simple organizable list w/ different numbering styles available
  	name: 'List of Items'
  	obj: (id) -> 
  		return {
	  		type: 'input'
				attributes:
					'id': id 
					'type': 'text'
					'class': 'taggable'
					'value': ''
  		}
  'tags':
  	name: 'Features'
  	obj: (id) -> 
  		return {
	  		type: 'input'
				attributes:
					'id': id 
					'type': 'text'
					'class': 'taggable'
  		}

# repeaters object helps us keep track of all repeaters used on a page: repeaters[.taggable.inputid]
repeaters = {}
repeateroptions = []
count = 0
window.populatenestable = (baseid) -> 
	# this callback is executed when the related '.taggable' input is updated
	do repeaters[baseid].update

window.removeicon = (elem) -> 
	# call the repeater function to remove the repeater element
	repeaters[elem.getAttribute 'data-repeaterid'].remove elem

window.updateinputtype = (elem) -> 
	repeaters[elem.getAttribute('data-repeater-id')].updateinputtype elem

class repeaterblock 

	constructor: (@inputid,@baseinput,@iconcontainer,@basecontainer,@repeaterstore) ->
		# store items (DOM: .badge) here: @items[inputid]
		@items = {}
		# store repeater data here: -> serialize this array and put it into the @repeaterstore
		@data = {}
		# init functions: 
		do @setupnestable
		do @update
		# other misc. setup: TODO: this should be done in the CSS of course of horse
		document.getElementById("feauxinput_#{@inputid}").style.float = 'left'
	update: -> 
			# Loop through 'span.badge' elements to find new additions.  Because the badges are invisible
			# to the user, we do not need to worry about them being removed through .taggable methods:
		newItems = []
		$(@iconcontainer).children('span.badge').each -> 
			# add to & check for '.already_nested' class to find the new inputs
			if !($(this).hasClass 'already_nested') 
				$(this).addClass 'already_nested'
				newItems.push this
		for item in newItems
			text = $(item).text()
			# dispatch the new items to repeaterblock.add function
			@add text 
			# store reference to each new item in repeaterblock.items (so we can programatically click the 'span.badge' and remove it from '.taggable')
			@items[text] = item
	add: (text) -> 
		# create a nestable item and append it to the @nest
		li = create nestableitem text, @inputid
		@nest.appendChild li
		# add this nestable item to @data w/ useful sub properties: 
		@data[text] = 'item': li, 'order': count, 'inputcontainer': $(li).children('.inputholder')[0]
		# remove this public testing variable: 
		window.x = @data # this can be used to see how data storage is going
		++count
	remove: (elem) -> 
		text = elem.getAttribute 'data-repeater-text'
		# remove 'tag' using built in 'taggable' methods: 
		$(@items[text].getElementsByTagName('i')[0]).click()
		# get & remove the nestable item itself: 
		listitem = document.getElementById "dd_item_#{text}"
		listitem.parentNode.removeChild listitem
		delete @data[text]
		--count
	updateinputtype: (elem) -> 
		text = elem.getAttribute 'data-repeater-text'
		@data[text]['inputcontainer'].innerHTML = ""
		append = repeatertypes[elem.value].obj
		if append isnt false 
			obj = create append "dd_item_value_#{text}"
			console.log obj
			@data[text]['inputcontainer'].appendChild obj

		switch elem.value
			when "gallery"
				console.log "GALLERY!"
				new Dropzone(obj, { url: "/file/post"})
			when "list" # TODO: change this to be a repeater type in addition to taggable
				window.taggable obj
			when "features"
				window.taggable obj
			when "textlong"
				new nicEditor({fullPanel:true}).panelInstance "dd_item_value_#{text}"
	setupnestable: -> 
		div = create 
			type: 'div'
			attributes: 
				'class': 'dd'
			contains: [
				type: 'ol'
				attributes: 
					'class': 'dd-list'
					'id': @inputid
				contains: []
			]
		@nest = div.getElementsByTagName('ol')[0]
		@basecontainer.appendChild div
		$(div).nestable()

# define some html schemas:
nestableitem = (text,id) -> 
	return {
		type: 'li'
		attributes: { 'class': 'dd-item', 'data-parent-id': id, 'id': "dd_item_#{text}" }
		contains: [
			{
				type: 'div'
				attributes: { 'class': 'dd-handle' }
				contains: [ text ]
			},
			{
				type: 'select'
				attributes: { 'change': 'updateinputtype', 'data-repeater-id': id, 'data-repeater-text': text }
				# repeater options is built at setup
				contains: repeateroptions 
			},
			{
				type: 'i'
				attributes: { 'class': 'icon-white icon-remove-circle', 'click': "removeicon", 'data-repeaterid': id, 'data-repeater-text': text }
			}, 
			{
				type: 'div'
				attributes: { 'class': 'inputholder', 'id': "inputholder_#{text}"}
			}
		]
	}

# setup all repeater blocks on DOM READY: 
$ = jQuery
$ -> 
	do init = -> 
		# setup the repeateroptions
		for key,val of repeatertypes
			repeateroptions.push 
				type: 'option'
				attributes: 
					'value': key
				contains: [ val.name ]
		# find all '.repeaterblock' elements: 
		$('.repeaterblock').each -> 
			inputid = false
			innerdivs = this.getElementsByTagName 'div'
			for div in innerdivs
					if div.getAttribute('id').indexOf 'icon_container' > -1
						iconcontainer = div
						div.style.display = 'none'
			innerinputs = this.getElementsByTagName 'input'
			for input in innerinputs
				if input.getAttribute('class') is 'taggable'
					inputid = input.getAttribute 'id' 
					theinput = input
			for textarea in this.getElementsByTagName 'textarea' 
				repeaterstore = textarea if textarea.getAttribute('data-repeater-rel') is inputid 
			if inputid then repeaters[inputid] = new repeaterblock inputid,theinput,iconcontainer,this,repeaterstore else console.log "Error setting up Repeater Block, missing '.taggable' input."