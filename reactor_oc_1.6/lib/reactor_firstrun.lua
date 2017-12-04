local component = require("component")
local term = require("term")
local event = require ("event")
local reactor1={}
local reactor_name={}
local reactor_address={}
local redstone_address={}
local redstone_side={}
local redstone_statu={}
local reactor_new={}
local reactor_now={}
local e=0
reactor={}

--声明部分--
for k,v in pairs(component.list('reactor'))
do
table.insert(reactor1,k)
end
 
--获取配置文件数据--
local function file_exists(path)
file = io.open(path, 'rb')
if file ~= nil then 
file:close() 
return file ~= nil
end
end


local function reactor_w (reactor_add)
for k,v in ipairs(reactor_add) 
do 
local a=component.proxy(v)
print('請在需要紅石信號輸出的面輸入紅石信號')
while true 
do
print('反應堆物理地址'..v)
print('等待紅石信號改變!')
_,redstone_add,redstone_side1=event.pull('redstone')
print('接受到信號物理地址'..redstone_add)
print('繼續請按回車，重新匹配請按其他任意鍵')
_,_,batton_x,batton_y=event.pull('key_down')
if batton_x == 13 and batton_y==28 then 
break
else
end
end
file:write('名稱=reactor'..k..'\r\n'..'反應堆物理地址='..v..'\r\n'..'紅石端口物理地址='..redstone_add..'\r\n'..
'紅石輸出面='..redstone_side1..'\r\n'..'開關状態='..'Off'..'\r\n')
if e==1 then
table.insert(reactor_name,'reactor'..k)
table.insert(reactor_address,v)
table.insert(redstone_address,redstone_add)
table.insert(redstone_side,redstone_side1)
table.insert(redstone_statu,'Off')
end
end
if e==1 then
else
reactor_r ()
end
end
local function f_read() --文件读取
local a=1
for line in file:lines() 
do
  local line_name=string.find(line,"=")
  local reactor_text=string.sub(line,line_name+1)
  local reactor_text=string.sub(reactor_text,0,-1)
  if a==1 then
  table.insert(reactor_name,reactor_text)
  else if a==2 then
  table.insert(reactor_address,reactor_text)
  else if a==3 then
  table.insert(redstone_address,reactor_text)
  else if a==4 then
  table.insert(redstone_side,reactor_text)
  else if a==5 then
  table.insert(redstone_statu,reactor_text)
  a=0
  end
  end
  end
  end
  end
  a=a+1
end
end

local function reactor_r ()
local b=0
  f_read() --读取文件完毕
  for _,v in pairs(reactor1) --reactor1=现在所有的反应堆
  do
 -- print(v)
   for _,v1 in pairs(reactor_address) --读取文件里面反应堆
   do 
  -- print(v1)
   if v==v1 then  
   b=1
   break
   end
   end 
   if b==0 then
   table.insert(reactor_new,v)
   end
   b=0
end

if next(reactor_new) ~=nil then
e=1
print('發現新的反應堆')
file = io.open("reactor.cfg","a")
reactor_w (reactor_new,e)
end
end
--实际程序--
file_exists('reactor.cfg') 
if  file ~= nil then --检测文件是否存在
file = io.open("reactor.cfg","r")  
reactor_r ()
else
e=1
print('未找到配置文件，正在初始化程序！')
file = io.open("reactor.cfg","w")
reactor_w (reactor1)
end
file:close()
--term.clear()
-------------地址读取完成------------

reactor.name=reactor_name
reactor.address=reactor_address
reactor.redstone_address=redstone_address
reactor.sides=redstone_side
reactor.statu=redstone_statu
return reactor