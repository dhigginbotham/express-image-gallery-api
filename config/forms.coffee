forms = module.exports = {}

forms.donate = [
  {name: "first_name", type: "text", level: null, req: true, label: "First Name:", active: true, value: null},
  {name: "last_name", type: "text", level: null, req: true, label: "Last Name:", active: true, value: null},
  {name: "zip", type: "text", level: null, req: true, label: "Zip:", active: true, value: null},
  {name: "email", type: "text", level: null, req: true, label: "Email:", active: true, value: null},
  {name: "message", type: "textarea", level: null, label: "Message:", active: true, value: null},
  {name: "cell_number", type: "text", level: null, label: "Mobile Number:", active: true, value: null},
  {name: "receive_text", type: "checkbox", level: null, label: "Would you like to receive text messages in the future?", active: false, value: null},
  {name: "receive_email", type: "checkbox", level: null, label: "Would you like to receive emails in the future?", active: true, value: null},
]

# form middleware
forms.renderForm = (req, res, next) ->
  req._form = Object.create
    text: []
    textarea: []
    checkbox: []
    button: []
    amounts: []

  for form in forms.donate
    do (form) ->

      if form["active"] is true
        # add inputs
        req._form.text.push form if form["type"] is "text"
        # add textareas
        req._form.textarea.push form if form["type"] is "textarea"
        # add checkboxes
        req._form.checkbox.push form if form["type"] is "checkbox"
        # add buttons
        req._form.button.push form if form["type"] is "button"
        # add amounts
        req._form.amounts.push form if form["type"] is "amounts"
  next()