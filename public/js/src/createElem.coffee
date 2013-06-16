window.create = (obj) -> 
	if obj.type? && obj.attributes? && obj.contains? 
		elem = createElem obj.type,obj.attributes
		for contentsObj in obj.contains
			innerElem = if typeof contentsObj is 'object' then create contentsObj else document.createTextNode contentsObj
			elem.appendChild innerElem
		return elem

createElem = (type,attributes) -> 
  elem = document.createElement type
  elem.setAttribute key,val for key,val of attributes if typeof attributes isnt "undefined"
  return elem

 $ = jQuery
 $ -> 
	elem = create 
		'type': 'div'
		'attributes': 
			'class': 'someclass0'
			'id': 'someid0'
		'contains': [
			{ 
				'type': 'h1'
				'attributes': 
					'class': 'someclass1'
					'id': 'someid1'
				'contains': [ 'Hello World' ]
			},
			{
				'type': 'h2'
				'attributes': 
					'class': 'someclass2'
					'id': 'someid2'
				'contains': [ 'Hello Universe' ]
			}	
		]
	console.log elem