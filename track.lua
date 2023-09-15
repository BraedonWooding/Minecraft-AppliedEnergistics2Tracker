-- creates a json array of every item that you have with more than minItems count

local Json = require("json")

-- you need at-least this many of that item to show it
local minItems = 10;

local component = require("component")

meController = component.proxy(component.me_controller.address)

-- this is expensive and will require a lot of open computers ram...
-- especially if you have a lot of items
local items = meController.getItemsInNetwork()

local output = {}

for i = 0, #items do
    local item = items[i]
    if item.count >= minItems then
        output:insert(item.label)
    end
end

local f = io.open("items.json", "w")

f:write(Json.encode(output))

f:close()
