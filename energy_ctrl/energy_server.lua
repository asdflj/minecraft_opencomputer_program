local shell = require('shell')
local component=require('component')
local args = shell.parse(...)
if #args < 1 then
  io.write("使用方法: service start or end \n")
  io.write("使其打開或停止")
  return
end
--[[
ic2={}
for address,name in pairs (component.list('ic2')) 
do  
  ic2[1]=address
end
if not ic2[1] then
print('沒發現儲電設備')
return
end
]]--
local thread = require("thread")
local computer = require('computer')
local event = require('event')
require('public')
require('energy_firstrun')

function modem_sendmessage()  --发送信息
local m= component.modem
m.open(233)
m.broadcast(233,_G.send[1])
end


function bat_change()   --储电设备改变
while true 
do
statu,address,bat_type=event.pull('component')
if statu=='component_removed' then
for k,v in pairs(bat) do
if v==address then
table.remove(bat,k)
_G.total_energy=_G.total_energy-0.04
end
end
for k,v in pairs(cesu) do
if v==address then
table.remove(cesu,k)
_G.total_energy=_G.total_energy-0.3
end
end
for k,v in pairs(mfe) do
if v==address then
table.remove(mfe,k)
_G.total_energy=_G.total_energy-4
end
end
for k,v in pairs(mfsu) do
if v==address then
table.remove(mfsu,k)
_G.total_energy=_G.total_energy-40
end
end
elseif statu=='component_added'then
if string.find(bat_type,'batbox')~=nil then
table.insert(bat,address)
_G.total_energy=_G.total_energy+0.04
end
if string.find(bat_type,'cesu')~=nil then
table.insert(cesu,address)
_G.total_energy=_G.total_energy+0.3
end
if string.find(bat_type,'mfe')~=nil then
table.insert(mfe,address)
_G.total_energy=_G.total_energy+4
end
if string.find(bat_type,'mfsu')~=nil then
table.insert(mfsu,address)
_G.total_energy=_G.total_energy+40
end
end
computer.pushSignal('Draw')  --绘制右侧信息
end
end

function bat_out_stuta()
while true do

for k,v in pairs(bat) do
local a=component.proxy(v)
if  a ~= nil then 
_G.now_energy=_G.now_energy+a.getEnergy()
end
end
for k,v in pairs(cesu) do
local a=component.proxy(v)
if  a ~= nil then 
_G.now_energy=_G.now_energy+a.getEnergy()
end
end
for k,v in pairs(mfe) do
local a=component.proxy(v)
if  a ~= nil then 
_G.now_energy=_G.now_energy+a.getEnergy()
end
end
for k,v in pairs(mfsu) do
local a=component.proxy(v)
if  a ~= nil then 
_G.now_energy=_G.now_energy+a.getEnergy()
end
end
local now_energy1=_G.now_energy
_G.now_energy=string.format("%0.2f", _G.now_energy/1000000)
i=(screen_y-10)*(_G.now_energy/_G.total_energy)

for k,v in pairs(_G.energy.log_percentage) do
local ii=k
end
if ii==nil then 
ii=1
end

if ii>screen_y-10 then 
table.remove(_G.energy.log_percentage)
table.remove(_G.energy.t)
table.remove(_G.energy.msg)
end
table.insert(_G.energy.t,1,computer.uptime())
table.insert(_G.energy.log_percentage,1,i)
table.insert(_G.energy.msg,1,now_energy1)
gpu.fill(1,6,screen_x-12,screen_y-9,' ')--竖
gpu.setBackground(red)
for k,v in pairs(_G.energy.log_percentage)do
gpu.set(screen_x-11-k,screen_y-4-_G.energy.log_percentage[k],' ')
end
gpu.setBackground(black)
gpu.set(2,screen_y-1,'当前能源百分比:'..string.format("%0.1f",_G.now_energy/_G.total_energy*100)..'%'..'    ')
if _G.energy.log_percentage[2] ~= nil then
local eu =string.format("%0.0f",(_G.energy.msg[1]-_G.energy.msg[2]))
--local s=math.ceil(_G.t[1])-math.floor(_G.t[2])
local s=(_G.energy.t[1]-_G.energy.t[2])*20
if  tonumber(eu) >0 then 
gpu.set(2,screen_y-2,'当前能源状態  :+'..string.format("%0.0f",eu/s)..'eu/t'..'           ')
else
gpu.set(2,screen_y-2,'当前能源状態  :'..string.format("%0.0f",eu/s)..'eu/t'..'           ')
end
end
local memory = computer.freeMemory()
memory = math.modf(memory / 1000)
local memory1 = computer.totalMemory()
memory1 = math.modf(memory1 / 1000)
gpu.set(2,screen_y,"總内存:"..memory1.."K".."  ".."剩余内存:"..memory.."K     ")
os.sleep(1)
end
end

function listen()
if _G.thread == nil then
_G.thread=thread.create(bat_change)
_G.thread1=thread.create(bat_out_stuta)
end
end

function modem_send_timer ()  --自动输出信息
while true do
if tonumber(_G.now_energy) <= tonumber(_G.energy_value) then
_G.send[1]='打開'
computer.pushSignal('send')
else
_G.send[1]='關閉'
computer.pushSignal('send')
end
os.sleep(5)
end
end
function auto()
if _G.thread2==nil then 
_G.thread2=thread.create(modem_send_timer)
end
if _G.auto==0 then 
_G.thread2:suspend()
elseif _G.auto==1 then 
_G.thread2:resume()
end
end

function Draw() --绘制右侧信息
gpu.setBackground(black)
gpu.set(screen_x-8,6,'          ')
gpu.set(screen_x-8,6,_G.total_energy..'M')
local a=string.format("%0.2f",1/((screen_y-10)/8))
for i=1,(screen_y-10)/8-1 do
local b=string.format("%0.2f", _G.total_energy*(a*i))
gpu.set(screen_x-8,screen_y-4-8*i,'          ')
gpu.set(screen_x-8,screen_y-4-8*i,b..'M')
end
gpu.set(screen_x-8,screen_y-4,'          ')
gpu.set(screen_x-8,screen_y-4,'0M')
end

if  args[1]== 'start' then
print('開始註冊服務')
if event.listen('Draw',Draw) then

_G.now_energy=0
_G.energy={}
_G.energy.t={}
_G.energy.msg={}
_G.energy.log_x={}
_G.energy.log_y={}
_G.energy.log_percentage={}
_G.energy.log={_G.energy.log_x,_G.energy.log_y,_G.energy.log_percentage}
event.listen('listen',listen)
event.listen('send',modem_sendmessage)
event.listen('auto',auto)
else
print('已經註冊服務了')
end
print('註冊服務完成')
elseif args[1]== 'end' then
event.ignore('listen',listen)
event.ignore('send',modem_sendmessage)
event.ignore('auto',auto)
_G.thread:kill()
_G.thread1:kill()
_G.thread2:kill()
print('已經停止服務')
else
print('輸入錯誤！')
print("使用方法: service start or end")
end
