# Minecraft-AppliedEnergistics2Tracker

Produces something like this;

## How to run

Run the following in the root directory of the OpenComputers terminal

```bash
wget https://github.com/BraedonWooding/Minecraft-AppliedEnergistics2Tracker/blob/main/prog.lua startup
wget https://github.com/BraedonWooding/Minecraft-AppliedEnergistics2Tracker/blob/main/track.lua lib/tracker.lua

wget https://raw.githubusercontent.com/rxi/json.lua/master/json.lua lib/lua.lua
wget https://raw.githubusercontent.com/OpenPrograms/OpenPrograms.ru/master/libforms/forms.lua lib/forms.lua

lib/tracker.lua
startup
```

`lib/tracker.lua` will generate a file called `items.json` this contains a list of every item that you have that you have more than 10 of.
