local forms = require("forms")
local component = require("component")

meController = component.proxy(component.me_controller.address)

require("track")

local Form = forms.addForm()

Form:setActive()

local width = Form.W

Title = Form:addLabel(width / 2 - 5, 1, "Item Tracking")

for item in main do
    name = item[1]

    print(name)
end

Form:redraw()

-- while true:
--     forms.run(Form)
