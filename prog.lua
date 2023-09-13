local forms = require("forms")

local Form = forms.addForm()

Form:setActive()

Title = Form:addLabel(0, 0, "Item Tracking")

forms.run(Form)