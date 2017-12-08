local event = require ("event")
local component = require("component")
local computer = require('computer')
local term =require('term')
local unicode = require('unicode')
local shell = require('shell')
require('public')

--声明部分--
local function centerF(row, msg,colors,...)
  local mLen = unicode.wlen(msg)
  screen_x, screen_y = gpu.getResolution()
  term.setCursor((screen_x - mLen)/2,row)
  gpu.setForeground(colors)
  print(msg:format(...))
  gpu.setForeground(white)
end

local function background_line(colors)
  gpu.setBackground(colors)
  _,Cursor_y=term.getCursor()
  gpu.fill(1,Cursor_y,screen_x,1," ")
  --gpu.setBackground(black)
  term.setCursor(1,Cursor_y+1)
end

local function frame_top()
	gpu.setForeground(red)
	screen_x_1=screen_x/3 
	gpu.set(screen_x_1*1,3,"主頁")
	gpu.set(screen_x_1*2,3,"退出")
end
local function Draw_end ()
	gpu.setBackground(black)
	gpu.setForeground(white)
end
local function frame_down()
	if component.isAvailable('modem') == true then
	gpu.setBackground(green)
	gpu.set(screen_x-10,screen_y," 關閉所有 ")
	gpu.set(screen_x-22,screen_y," 打開所有 ")
	gpu.setForeground(white)
	gpu.set(screen_x-34,screen_y," 自動控制 ")
	
	end
	if component.isAvailable('internet') == true then
    gpu.set(screen_x-46,screen_y," 聯網控制 ")
	end
	end
local function Manual (swich)
_G.auto=0
_G.send[1]=swich
gpu.setForeground(white)
gpu.setBackground(green)
gpu.set(screen_x-34,screen_y," 自動控制 ")
gpu.setBackground(black)
gpu.set(screen_x-10,screen_y-2,'          ')
computer.pushSignal('auto')
computer.pushSignal('send')
end	




term.clear()

centerF(1,  "能源監控器V1",red)
gpu.set(screen_x-20,1,'作者：asdflj')
gpu.setBackground(white)
--gpu.fill(1,5,screen_x,1,' ')
gpu.fill(screen_x-10,6,1,screen_y-8,' ')--竖
gpu.fill(1,screen_y-3,screen_x,1,' ') --横
gpu.setBackground(black)
print()
background_line(gray)
frame_top()
frame_down()
Draw_end ()
computer.pushSignal('listen')
computer.pushSignal('Draw')
_G.send={}
_G.auto=0
while true 
do


--x 79~72
--y 5开始
_,_,mouse_x,mouse_y=event.pull('touch')
if mouse_x >=screen_x_1*2-1 and mouse_x <=screen_x_1*2+3 and mouse_y==3 then 
shell.execute('reboot')
term.clear()
_G.thread:kill()
_G.thread1:kill()
_G.thread2:kill()
_G.thread=nil
_G.thread1=nil
_G.thread2=nil
computer.pushSignal('wait')
return
end

if mouse_x >= screen_x-10 and mouse_y == screen_y then
Manual ('關閉')
end
if mouse_x >= screen_x-22 and mouse_x <= screen_x-12 and mouse_y == screen_y then
Manual ('打開')
end
if mouse_x >= screen_x-34 and mouse_x <= screen_x-24 and mouse_y == screen_y then --自动控制
if _G.auto==0 then
gpu.setBackground(green)
gpu.setForeground(red)
gpu.set(screen_x-34,screen_y," 自動控制 ")
gpu.setForeground(white)
gpu.set(screen_x-10,screen_y-2,'切換:'.._G.energy_value..'M')
_G.auto=1
gpu.setBackground(black)
computer.pushSignal('auto')
computer.pushSignal('send')
end
end
if _G.auto==1 then
if mouse_x >= screen_x-10 and mouse_y == screen_y-2  then
_G.thread1:suspend()
centerF(screen_y/2,  "請輸入 單位M",red)
term.setCursor(screen_x/2,screen_y/2+1)
while true do
term.setCursor(screen_x/2,screen_y/2+1)
e_vlaue=term.read()
if tonumber(e_vlaue)==nil then
centerF(screen_y/2+2,  "輸入錯誤",red)
else
_G.energy_value=tonumber(e_vlaue)
gpu.set(screen_x-10,screen_y-2,'           ')
gpu.setBackground(green)
gpu.set(screen_x-10,screen_y-2,'切換:'.._G.energy_value..'M')
gpu.setBackground(black)
local file=io.open("energy.cfg","w")
file:write('切換='.._G.energy_value)
file:close()
_G.thread1:resume()
computer.pushSignal('Draw')
break
end
end
end
end

--[[if _G.thread ==nil then
gpu.setBackground(green)
gpu.setForeground(red)
gpu.set(screen_x-34,screen_y," 通信控制 ")
gpu.setForeground(white)
computer.pushSignal('get')
end
--]]
--[[end

if mouse_x >= screen_x-46 and mouse_x <= screen_x-36 and mouse_y == screen_y then
end
--]]
end




