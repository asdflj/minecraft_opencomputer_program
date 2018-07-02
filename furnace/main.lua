--熔炉监控器 版本 alpha 0.1
local component = require('component')
local graphic=require('graphic')
local color =require('color')
local thread = require("thread")
local computer = require('computer')
local event = require('event')
local proxy=component.proxy
function print_author()
	graphic.draw_text(1,50,16,'asdflj','center')
	graphic.display_refresh()
	os.sleep(3)
	graphic.clear_text_line(16)
end
local function find_furnace()
	furnace={}
	for k,v in pairs(component.list('furnace')) do
		table.insert(furnace,k)
	end
	return furnace
end
function furnace_monitor()
	while true do
		statu,address,item_type=event.pull('component')
		if statu=='component_removed' then
			for k,v in pairs(furnace) do
				if v==address then
					graphic.drawline(1,50,#furnace+2,color.black,color.white,' ')
					table.remove(furnace,k)
				end
			end
		elseif statu=='component_added' and item_type == 'furnace' then
			table.insert(furnace,address)
		end
	end
end
function listen()
	if _G.thread == nil then
		_G.thread=thread.create(furnace_monitor)
	elseif _G.thread:status() == 'dead' then
		_G.thread=thread.create(furnace_monitor)
	end
end
function display()
		k1=1
	for k,v in pairs(furnace) do
		a=proxy(v)
		if a~= nil then
			a_cooktime=a.getCookTime()
			graphic.drawline(8,36,k1+2,color.black,color.white,' ',nil,'true')
			if math.floor(a_cooktime/8)~=0 then
				graphic.drawline(8,8+math.floor(a_cooktime/8),k1+2,color.red,color.white,' ',nil,'true')
			end
			graphic.draw_text(2,5,k1+2,string.sub(v,1,4),'left',nil,'true')
			graphic.draw_text(37,42,k1+2,math.modf(a_cooktime/200*100)..' %','left',nil,'true')
			graphic.draw_text(45,50,k1+2,tostring(a.isBurning()),'left',nil,'true') 
			--启用新的局部刷新技术
			k1=k1+1
		end
	end
end
graphic.init(50,32,5) 
graphic.setresolution(50,16)
local x=50
local y=16
graphic.draw_text(1,50,1,'furnace','center',print_author)
graphic.draw_text(1,50,2,' name          progress         Percentage  burn','left')
furnace=find_furnace()
graphic.display_refresh()
event.listen('listen',listen)
computer.pushSignal('listen')
--graphic.draw_pause()
while true do
display()
-- graphic.display_refresh()
end

