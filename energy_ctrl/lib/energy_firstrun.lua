local component = require("component")
local term = require("term")
mfsu={}
mfe={}
cesu={}
bat={}
all_energy=0
--获取配置文件数据--
local function file_exists(path)
file = io.open(path, 'rb')
if file ~= nil then 
file:close() 
return file ~= nil
end
end

for k,v in pairs(component.list('mfsu'))
do
table.insert(mfsu,k)
all_energy=all_energy+40
end
for k,v in pairs(component.list('mfe'))
do
table.insert(mfe,k)
all_energy=all_energy+4
end
for k,v in pairs(component.list('cesu'))
do
table.insert(cesu,k)
all_energy=all_energy+0.3
end
for k,v in pairs(component.list('bat'))
do
table.insert(bat,k)
all_energy=all_energy+0.04
end

local function energy_w ()
while true do
print('請輸入，剩余多少打開紅石信號')
local value=term.read()
local line_name=string.find(value,"%%")
value=string.sub(value,1,-3)
value=tonumber(value)
if value==nil then
print('輸入數字錯誤！')
else
if line_name~=nil then

_G.energy_value={all_energy*(value/100)}
else
_G.energy_value={value/1000000}
end
file:write('切換='.._G.energy_value[1])
return
end
end
end
local function energy_r ()
for line in file:lines() 
do
  local line_name=string.find(line,"=")
  local energy_text=string.sub(line,line_name+1)
  local energy_text=string.sub(energy_text,0,-1)
  _G.energy_value={energy_text}
end
end
file_exists('energy.cfg') 
if  false  then --检测文件是否存在
file = io.open("energy.cfg","r")  
energy_r ()
else
e=1
--print('未找到配置文件，正在初始化程序！')
file = io.open("energy.cfg","w")
energy_w ()
end
_G.energy={all_energy}
file:close()