--版本 alpha 0.3 添加局部刷新技术
local component = require('component')
local computer =require('computer')
local event = require('event')
local serialization =require('serialization')
gpu = component.gpu
ui={}
local function text_alignment(x_min,x_max,text_len,alignment)
	x={x_min,x_max}
	if alignment=='right' then 
		x.x_min=x_max-text_len+1
		x.x_max=x_max
	elseif alignment=='left' then 
		x.x_min=x_min
		x.x_max=x_max
	elseif alignment == 'center' then
		x.x_min=math.ceil((x_max-text_len)/2)
		x.x_max=x_max
	else
		x.x_min=x_min
		x.x_max=x_max
	end
	return x
end
local function refresh_screen()
	ui.display_refresh()
end
local function write_tab(screen)
	tab=serialization.serialize(show_display)
	file = io.open(screen..'.cfg',"w")
	file:write(tab)
	file:close()
end 
local function read_tab(screen)
	file = io.open(screen..'.cfg',"w")
	tab=file:read('*a')
	show_display=serialization.unserialize(tab)
end
local function text_split(text)
	local unicode = require('unicode')
	txt={text={},wide={},tlen=0}
	while true do
		text_len=string.len(text)
		if text_len~=0 then
			if unicode.isWide(text) then
				t=string.sub(text,1,3)
				text=string.sub(text,4,text_len)
				table.insert(txt['wide'],2)
				txt['tlen']=txt['tlen']+2
			else
				t=string.sub(text,1,1)
				text=string.sub(text,2,text_len)
				table.insert(txt['wide'],1)
				txt['tlen']=txt['tlen']+1
			end
		table.insert(txt['text'],t)
		else
			return txt
		end
	end
end
local function draw_ui()
	if display_pause ~= 1 then
		ui.display_refresh()
	end
end
local function mouse_click(__,__,x,y)
	if show_display[x][y].run~=nil then
		show_display[x][y].run()
	end
end
local function mouse_scroll(__,__,__,__,r)
	if r==1 then 
		if show_display[show_display_area['x_min']][show_display_area['y_min']-1]~=nil then
		show_display_area['y_min']=show_display_area['y_min']-1
		show_display_area['y_max']=show_display_area['y_max']-1
		show_display_area['scroll']=show_display_area['scroll']+1
		end
	elseif r==-1 and show_display[show_display_area['x_max']][show_display_area['y_max']+1] ~=nil then 
		show_display_area['y_min']=show_display_area['y_min']+1
		show_display_area['y_max']=show_display_area['y_max']+1
		show_display_area['scroll']=show_display_area['scroll']-1
	end
	refresh_screen() --刷新界面
end
local function local_refresh(x_min,x_max,y,show_display,gpu)
	local now_foreground=gpu.getForeground()
	local now_background=gpu.getBackground()
	for x = x_min,x_max do 
		gpu.setForeground(show_display[x][y]['foreground_color'])
		gpu.setBackground(show_display[x][y]['background_color'])
		gpu.set(x,y,show_display[x][y]['text'])
	end
	gpu.setForeground(now_foreground)
	gpu.setBackground(now_background)
end
function ui.init(x,y,r)
	show_display={}
	display_pause=1
	show_display_area={
	['x_min']=1,['x_max']=x,['y_min']=1,['y_max']=y,['scroll']=0
	}
	if r==nil or tonumber(r)==nil then
		show_display_refresh=3
	else
		show_display_refresh=r
	end
	for i=1,x do
		table.insert(show_display,{})
		for ii=1,y do
			table.insert(show_display[i],{
				background_color=0x000000,
				foreground_color=0xFFFFFF,
				text=' ',
				run=nil
			})		
		end
	end
	if show_display_statu==nil then
		show_display_statu=event.timer(show_display_refresh,draw_ui,math.huge)
		event.listen('touch',mouse_click)
		event.listen('gpu_bound',refresh_screen)
		event.listen('scroll',mouse_scroll)
	end
end
function ui.uninit()
	if show_display_statu~= nil then
		event.cancel(show_display_statu)
		event.ignore('touch',mouse_click)
		event.ignore('scroll',mouse_scroll)
		event.ignore('gpu_bound',refresh_screen)
		show_display={}
		display_pause=0
	end
end
function ui.drawline(x_min,x_max,y,background_color,foreground_color,text,run,refresh)
	for x=x_min,x_max do
		show_display[x][y]['background_color']=background_color
		show_display[x][y]['foreground_color']=foreground_color
		if text~=nil then 
			show_display[x][y]['text']=text
		end
		if run~= nil then
			show_display[x][y]['run']=run
		end
	end
	if refresh ~= nil then
		local_refresh(x_min,x_max,y,show_display,gpu)
	end
end
function ui.fill_background_color(background_color)
	for k,v in pairs(show_display) do
		for k1,v1 in pairs(show_display[k])do
			v1['background_color']=background_color
		end
	end
end
function ui.fill_foreground_color(foreground_color)
	for k,v in pairs(show_display) do
		for k1,v1 in pairs(show_display[k])do
			v1['foreground_color']=foreground_color
		end
	end
end
function ui.clear_text()
	for k,v in pairs(show_display) do
		for k1,v1 in pairs(show_display[k])do
			v1['text']=' '
		end
	end
end
function ui.setresolution(x,y)
	gpu.setResolution(x,y)
	show_display_area['x_min']=1
	show_display_area['x_max']=x
	show_display_area['y_min']=1
	show_display_area['y_max']=y
end
function ui.draw_simple(x,y,background_color,foreground_color,text,run)
	show_display[x][y]['background_color']=background_color
	show_display[x][y]['foreground_color']=foreground_color
	show_display[x][y]['text']=text
	show_display[x][y]['run']=run
end
function ui.draw_text(x_min,x_max,y,text,alignment,run,refresh)
	txt=text_split(text)
	s=1
	jump=0
	for x=x_min,x_max do
		if show_display[x]~=nil then
			show_display[x][y]['text']=' '
		end
	end
	x1=text_alignment(x_min,x_max,txt['tlen'],alignment)
	for x=x['x_min'],x['x_max'] do
		if jump==0 then
			if txt['text'][s]~=nil and show_display[x]~=nil then
				if run~=nil then
				show_display[x][y]['run']=run
				end
				show_display[x][y]['text']=txt['text'][s]
				if txt['wide'][s]==2 then
					jump=1
				else
					s=s+1
				end
			end
		else
			if show_display[x]~=nil then
				show_display[x][y]['text']=' '
				show_display[x][y]['background_color']=show_display[x-1][y]['background_color']
				show_display[x][y]['foreground_color']=show_display[x-1][y]['foreground_color']
				show_display[x][y]['run']=show_display[x-1][y]['run']
			end
			jump=0
			s=s+1
		end
	end
	if refresh ~= nil then
		local_refresh(x_min,x_max,y,show_display,gpu)
	end
end
function ui.change_display_tab(file1,file2)
	event.cancel(show_display_statu)
	write_tab(file1)
	read_tab(file2)
	show_display_statu=event.timer(show_display_refresh,draw_ui,math.huge)
end
function ui.display_tab_save(file)
	write_tab(file)
end
function ui.display_tab_read(file)
	event.cancel(show_display_statu)
	show_display={}
	read_tab(file)
	show_display_statu=event.timer(show_display_refresh,draw_ui,math.huge)
end
function ui.draw_pause()
	if display_pause == 0 then
		display_pause=1
		return true
	else
		display_pause=0
		return false
	end
end
function ui.draw_pause_statu()
	if display_pause == 0 then
		return 'runing'
	else
		return 'dead'
	end
end
function ui.change_refresh(refresh)
	refresh=tonumber(refresh)
	if refresh~=nil then
		show_display_refresh=refresh
		event.cancel(show_display_statu)
		show_display_statu=event.timer(show_display_refresh,draw_ui,math.huge)
		return true
	else
		return false
	end
end
function ui.setdisplay_area(x_min,x_max,y_min,y_max)
	local x_min=tonumber(x_min)
	local y_min=tonumber(y_min)
	local x_max=tonumber(x_max)
	local y_max=tonumber(y_max)
	if x_min ~= nil and x_max ~=nil and y_min~=nil and y_max ~=nil  then
		show_display_area['x_min']=x_min
		show_display_area['x_max']=x_max
		show_display_area['y_min']=y_min
		show_display_area['y_max']=y_max
		return true
	else
		return false
	end
end
function ui.getdisplay_statu()
	if #show_display[1]~=nil then
		local s='当前画布大小'..#show_display..'X'..#show_display[1]..',显示区域'..
		show_display_area['x_max']..'X'..show_display_area['y_max']..'开始位置于显示区域的X:'..show_display_area['x_min']..
		' Y:'..show_display_area['y_min']
		return s
	else
		return false
	end
end
function ui.display_refresh()
	local gpu = component.gpu
	local now_foreground=gpu.getForeground()
	local now_background=gpu.getBackground()
	local x=1
	for x_min=show_display_area['x_min'],show_display_area['x_max'] do
		local y=1
		for y_min=show_display_area['y_min'],show_display_area['y_max'] do
			if show_display[x_min][y_min]~=nil then
				gpu.setForeground(show_display[x_min][y_min]['foreground_color'])
				gpu.setBackground(show_display[x_min][y_min]['background_color'])
				gpu.set(x,y,show_display[x_min][y_min]['text'])
			end
		y=y+1
		end
	x=x+1
	end
	gpu.setForeground(now_foreground)
	gpu.setBackground(now_background)
end
function ui.clear_text_line(y)
	local y=tonumber(y)
	if  y ~=nil and show_display[1] then
		for x=1,#show_display[1] do
			show_display[x][y]['text']=' '
		end
	end
end
return ui
