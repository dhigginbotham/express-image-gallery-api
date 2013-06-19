$ = jQuery
events = ['blur','focus','focusin','focusout','load','resize','scroll','unload','click','dblclick','mousedown','mouseup','mousemove','mouseover','mouseout','mouseenter','mouseleave','change','select','submit','keydown','keypress','keyup','error','contextmenu']

# proxy function for creator
window.create = (obj) -> 
	return creator obj

creator = (obj) -> 
	obj.contains ?= []
	obj.attributes ?= {}
	if obj.type?
		elem = createElem obj.type,obj.attributes
		for contentsObj in obj.contains
			innerElem = if typeof contentsObj is 'object' then create contentsObj else document.createTextNode contentsObj
			elem.appendChild innerElem
		return elem

createElem = (type,attributes) -> 
  elem = document.createElement type
  for key,val of attributes 
  	if key in events
  		elem = assignevents elem,key,val
  	else
  		elem.setAttribute key,val if typeof attributes isnt "undefined" 
  return elem

assignevents = (elem,handler,fn) -> 
	func = window[fn]
	$(elem).on handler, -> func this
	return elem

# elem = create
# 	type: 'body'
# 	contains: [
# 		{
# 			type: 'div'
# 			attributes: {
# 				'id': 'container'
# 				'class': 'main'
# 			}
# 			contains: [
# 				{
# 					type: 'h1'
# 					contains: ['Hello World!']
# 				},
# 				{
# 					type: 'div'
# 					contains: [
# 						{
# 							type: 'a'
# 							attributes: {
# 								'click': 'dosomething'
# 							}
# 							contains: [
# 								{
# 									type: 'i'
# 									attributes: {
# 										'class': 'badge'
# 									}
# 									contains: [ "Hello World" ]
# 								}
# 							]
# 						}
# 					]
# 				}
# 			]
# 		}
# 	]
# console.log elem
