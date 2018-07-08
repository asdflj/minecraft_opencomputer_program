local component = require('component')
local graphic = require('graphic')
local color = require('color')
local thread = require("thread")
local event = require('event')

function listen(fun)
	if _G.thread == nil then
		_G.thread=thread.create(fun)
	elseif _G.thread:status() == 'dead' then
		_G.thread=thread.create(fun)
	end
end

if not component.isAvailable('internet') then
    print('not find internet card')
end
if not component.isAvailable('modem') then
    print('not find modem card')
end

--绘制UI界面
local function extends()
    --当有英特网卡和猫的时候做额外的扩展功能
    if not component.isAvailable('internet') then
    end
    if not component.isAvailable('modem') then
        --做额外的扩展功能
    end
end

--

