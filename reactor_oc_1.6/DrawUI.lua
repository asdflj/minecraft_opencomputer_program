local event = require ("event")
local component = require("component")
local computer = require('computer')
local term =require('term')
local unicode = require('unicode')
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
	gpu.setBackground(green)
	gpu.set(screen_x-10,screen_y," 關閉所有 ")
	gpu.set(screen_x-22,screen_y," 打開所有 ")
	gpu.setForeground(white)
	if component.isAvailable('modem') == true then
    gpu.set(screen_x-34,screen_y," 通信控制 ")
	end
	if component.isAvailable('internet') == true then
    gpu.set(screen_x-46,screen_y," 聯網控制 ")
	end
	end
local function reactor_swich()
for k,v in pairs(reactor.redstone_address)
do
if v==reactor_show[mouse_y_a] then

if reactor.now_Run[k] =='關閉' then
reactor.statu[k]='On'
else
reactor.statu[k]='Off'
end
end
end
--computer.pushSignal('wait')
computer.pushSignal('save')
--computer.pushSignal('Draw')
end
local function reactor_all_swich(swich)
for k,v in pairs(reactor.address)
do 
reactor.statu[k]=swich
end
computer.pushSignal('save')
end



term.clear()

centerF(1,  "反應堆服務器版控制器V1",red)
gpu.set(screen_x-20,1,'作者：asdflj')

print()
background_line(gray)
frame_top()
frame_down()
Draw_end ()
computer.pushSignal('Draw')
while true 
do
--x 79~72
--y 5开始
_,_,mouse_x,mouse_y=event.pull('touch')
if mouse_x >=screen_x_1*2-1 and mouse_x <=screen_x_1*2+3 and mouse_y==3 then 
term.clear()
computer.pushSignal('wait')
return
end
mouse_y_a,mouse_y_beishu=math.modf((mouse_y-3)/2)
if mouse_y_beishu ==0 and mouse_x >= screen_x-8 and mouse_y <=screen_y-1 then
reactor_swich()
end
if mouse_x >= screen_x-10 and mouse_y == screen_y then
reactor_all_swich('Off')
end
if mouse_x >= screen_x-22 and mouse_x <= screen_x-12 and mouse_y == screen_y then
reactor_all_swich('On')
end

if mouse_x >= screen_x-34 and mouse_x <= screen_x-24 and mouse_y == screen_y then --通讯控制
if _G.thread ==nil then
gpu.setBackground(green)
gpu.setForeground(red)
gpu.set(screen_x-34,screen_y," 通信控制 ")
gpu.setForeground(white)
computer.pushSignal('get')
end
end
--[[
if mouse_x >= screen_x-46 and mouse_x <= screen_x-36 and mouse_y == screen_y then
end
--]]
end




