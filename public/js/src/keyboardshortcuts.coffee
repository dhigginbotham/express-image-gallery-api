# Store Keyboard Shortcut Javascript Such as Ctrl+S in here: 
$ = jQuery
$ -> 
	ctrlPressed = false

	# define some useful keycodes 
	ctrl = 17
	skey = 83

	# keydown detection is for modifier keys, use ctrl as example: 
	$(document).keydown (e) -> switch e.keyCode
		when ctrl then ctrlPressed = true
		when skey then save e if ctrlPressed
		# else console.log "Key Code: '#{e.keyCode}' was pressed."

	# keyup is for single-key and key-combination detection, see ctrl+s example
	$(document).keyup (e) -> switch e.keyCode
		when ctrl then ctrlPressed = false
		# else console.log "Key Code: '#{e.keyCode}' was released."

	save = (e) -> 
		form = $(e.currentTarget.activeElement).parents('form')[0] ? $('form')[0]
		form.submit() if form?
		return false