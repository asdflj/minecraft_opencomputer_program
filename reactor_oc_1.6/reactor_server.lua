local shell = require('shell')
local args = shell.parse(...)
if #args < 1 then
  io.write("使用方法: service start or end \n")
  io.write("使其打開或停止")
  return
end
local component = require('component')
if component.isAvailable('redstone') ~= true then
  io.write("未發現紅石模塊 \n")
return
end
reactor_add={}
for address,name in pairs (component.list('reactor')) 
do  
  reactor_add[1]=address
end
if not reactor_add[1] then
print('未發現反應堆')
return
end

local thread = require("thread")
local computer = require('computer')
local event = require('event')
require('public')
package.loaded['reactor_firstrun'] = nil
package.loaded['reactor_load'] = nil
local reactor = require('reactor_load')

function reactor_info_timer ()
shell.execute('/lib/reactor_load.lua')
end

--[[function modem_send()
local m= component.modem
channel=math.random(1,100)
m.open(233)
m.broadcast(233,channel)
_,my_modem_address,target_modem_address=event.pull('modem')
m.open(channel)
for k,v in pairs(reactor.address)
if proxy(reactor.address[k]) ~=nil and  --检测是否存在
proxy(reactor.redstone_address[k])~= nil  then
m.send(target_modem_address,'name='..reactor.name[k])
m.send(target_modem_address,'Heat='..reactor.now_Heat[k])
m.send(target_modem_address,'OutEU='..reactor.now_OutEU[k])
m.send(target_modem_address,'Run='..reactor.now_Run[k])
end
end
--]]
function modem_get()
while true do
_,_,_,_,_,message=event.pull('modem')
if message~=nil then
for k,v in pairs(reactor.redstone_address)
do
if message ~='關閉' then
reactor.statu[k]='On'
else
reactor.statu[k]='Off'
end
end
end
end
end

function modem_get_message()
local m= component.modem
m.open(233)
if _G.thread == nil then
_G.thread=thread.create(modem_get)
--_,_,_,_,_,message=event.pull('modem')
--print(message)
end
end

function Draw()
if  _G.end_id[1] == nil then
end_id=event.timer(3,reactor_info_timer,math.huge)
--print(end_id)
event.listen('end',info_end)
_G.end_id={end_id}
end
end
function info_end ()
local k=1
local reactor_all_OutEU=0
for e,v in pairs(reactor.address) 
do
if proxy(reactor.address[e]) ~=nil and 
proxy(reactor.redstone_address[e])~= nil  then
local screen_y_work=screen_y_start+(k*2)
if screen_y_work<screen_y-2 then 
gpu.set(1,screen_y_work,string.sub(reactor.name[e],0,10))
gpu.setBackground(gray)
gpu.fill(11,screen_y_work,screen_x-42,1," ")
gpu.setBackground(red)
gpu.fill(11,screen_y_work,math.modf((screen_x-42)*(reactor.now_Heat[e]/100)),1," ")
gpu.setBackground(black)
gpu.setForeground(white)
gpu.set(screen_x-25,screen_y_work,'     ')
gpu.set(screen_x-30,screen_y_work,'堆温:'..reactor.now_Heat[e]..'%')
gpu.set(screen_x-16,screen_y_work,'        ')
gpu.set(screen_x-21,screen_y_work,'輸出:'..tostring(reactor.now_OutEU[e])..'EU/t')
gpu.setBackground(green)
gpu.fill(screen_x-8,screen_y_work,8,1," ")
gpu.setForeground(red)
if reactor.now_Run[e]=='關閉' then 
gpu.setForeground(black)
end
gpu.set(screen_x-6,screen_y_work,reactor.now_Run[e])
gpu.setBackground(black)
gpu.setForeground(white)
reactor_show[k]=reactor.redstone_address[e]
reactor_all_OutEU=reactor_all_OutEU+tostring(reactor.now_OutEU[e])
k=k+1
end
end
end
gpu.fill(1,screen_y-2,screen_x,1,' ')
gpu.set(screen_x-30,screen_y-2,'所有反應堆輸出:'..reactor_all_OutEU..'EU/t')
local memory = computer.freeMemory()
memory = math.modf(memory / 1000)
local memory1 = computer.totalMemory()
memory1 = math.modf(memory1 / 1000)
gpu.set(1,screen_y,"總内存:"..memory1.."K".."  ".."剩余内存:"..memory.."K")
end
function wait ()
  event.cancel(G_end_id[1])
  event.listen('Draw',Draw)
  _G.end_id={}
end
function save()
file = io.open("reactor.cfg","w")
for k,v in pairs(reactor.redstone_address)
do
file:write('名稱='..reactor.name[k]..'\r\n'..'反應堆物理地址='..reactor.address[k]..'\r\n'..
'紅石端口物理地址='..reactor.redstone_address[k]..'\r\n'..
'紅石輸出面='..reactor.sides[k]..'\r\n'..'開關状態='..reactor.statu[k]..'\r\n')
end
file:close()
end


if  args[1]== 'start' then
print('開始註冊服務')
if event.listen('Draw',Draw) then
--print(event.listen('Draw',Draw))
--event.listen('wait',wait)
event.listen('save',save)
event.listen('get',modem_get_message)
--event.listen('send',modem_send)
--event.listen('end',info_end)
_G.end_id={}
_G.reactor_show={}
else
print('已經註冊服務了')
end
print('註冊服務完成')
elseif args[1]== 'end' then
event.ignore('end',info_end)
--event.ignore('wait',wait)
event.ignore('save',save)
event.ignore('Draw',Draw)
event.ignore('get',modem_get_message)
--event.ignore('send',modem_send)
if _G.end_id[1] ~= nil then
event.cancel(_G.end_id[1])
--_G.thread:kill()
_G.end_id={}
end
print('已經停止服務')
else 
print('輸入錯誤！')
print("使用方法: service start or end")
end