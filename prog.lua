local forms = require("forms")
local component = require("component")
local gpu = component.gpu
local sub=require("unicode").sub
local padRight=require("text").padRight

meController = component.proxy(component.me_controller.address)

require("track")

local Form = forms.addForm()

Form:setActive()

local width = Form.W

Title = Form:addLabel(width / 2 - 5, 1, "Item Tracking")

function formatNum(n)
    if n >= 10^9 then
        return string.format("%.2fB", n/10^9)
    elseif n >= 10^6 then
        return string.format("%.2fM", n/10^6)
    elseif n >= 10^3 then
        return string.format("%.2fk", n/10^3)
    else
        return tostring(math.floor(n))
    end
end

------- TTable

local TTable=setmetatable({W=Form.W, H=Form.H, border=2, selColor=0x0000ff, sfColor=0xffff00, shift=0, index=0,
  type=function() return "Table" end},Form.__index)
TTable.__index=TTable

function TTable:paint()
  local b= self.border==0 and 0 or 1
  local w = math.floor(self.W / 3)

  gpu.set(self.X+b,self.Y+b, padRight(sub("Label",1,w - b),w - b))
  gpu.set(self.X+b + w,self.Y+b, padRight(sub("Count",1,w),w))
  gpu.set(self.X+b + 2 * w,self.Y+b, padRight(sub("Delta",1,w - b),w - b))

  for i=1,self.H-2*b do
    local line = self.lines[i+self.shift]
    if line then
        if i+self.shift==self.index then gpu.setForeground(self.sfColor) gpu.setBackground(self.selColor) end
        gpu.set(self.X+b,self.Y+i+b, padRight(sub(line.label,1,w - b),w - b))
        gpu.set(self.X+b + w,self.Y+i+b, padRight(sub(formatNum(line.count),1,w),w))
        gpu.set(self.X+b + 2 * w,self.Y+i+b, padRight(sub(formatNum(line.delta),1,w - b),w - b))
        if i+self.shift==self.index then gpu.setForeground(self.fontColor) gpu.setBackground(self.color) end
    end
  end
end

function TTable:clear()
  self.shift=0 self.index=0 self.lines={} self.items={}
  self:redraw()
end

function TTable:insert(pos,line)
  -- allow just insert(line)
  if type(pos)~="number" then pos,line=#self.lines+1,pos end
  table.insert(self.lines,pos,line)
  if self.index<1 then self.index=1 end
  if pos<self.shift+self.H-1 then self:redraw() end
end

function TTable:sort(comp)
  comp=comp or function(list,i,j) return list.lines[j].count > list.lines[i].count end
  for i=1,#self.lines-1 do
    for j=i+1,#self.lines do
      if comp(self,i,j) then
        if self.index==i then self.index=j
        elseif self.index==j then self.index=i end
        self.lines[i],self.lines[j]=self.lines[j],self.lines[i]
      end
    end
  end
  self:redraw()
end

function TTable:touch(x, y, btn, user)
--   local b= self.border==0 and 0 or 1
--   if x>b and x<=self.W-b and y>b and y<=self.H-b and btn==0 then
--     local i=self.shift+y-b
--     if self.index~=i and self.lines[i] then
--       self.index=i
--       self:redraw()
--       if self.onChange then self:onChange(self.lines[i],self.items[i],user) end
--     end
--   end
end

function TTable:scroll(x, y, sh, user)
  local b= self.border==0 and 0 or 1
  self.shift=self.shift-sh
  if self.shift>#(self.lines)-self.H+2*b then self.shift=#(self.lines)-self.H+2*b end
  if self.shift<0 then self.shift=0 end
  self:redraw()
end

-------

function Form:addTable(left, top)
    local obj={left=left, top=top, lines={}}
    self:makeChild(obj)
    return setmetatable(obj,TTable)
end

-- main loop

Table = Form:addTable(1, 2)
Memory = {}
First = 0

function run()
    for idx = 1, #main do
        name = main[idx][1]

        storedItems = meController.getItemsInNetwork({
            label = name
        })

        count = 0
        for idx = 1, #storedItems do
            count = count + storedItems[idx].size
        end

        if First == 0 then
            Memory[name] = { label = name, count = count, delta = 0 }
            Table:insert(Memory[name])
        else
            Memory[name].delta = (count - Memory[name].count)/10
            Memory[name].count = count
        end
    end

    First = 1
    Form:redraw()
end

while true do
    run()
    os.sleep(10)
end

-- while true:
--     forms.run(Form)
