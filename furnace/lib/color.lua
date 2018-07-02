-- 基础颜色表
local color={
	black=0x000000,--黑色 
	maroon=0x800000,--栗色
	green=0x008000,--绿色
	olive=0x808000,--橄榄色
	navy=0x000080,--藏青色
	purple=0x800080,--紫色
	teal=0x008080,--凫蓝
	gray=0x808080,--灰色
	silver=0xC0C0C0,--银色
	red=0xFF0000,--红色
	lime=0x00FF00,
	yellow=0xFFFF00,--黄色
	blue=0x0000FF,--蓝色
	fuchsia=0xFF00FF,--紫红
	aqua=0x00FFFF,--浅绿色
	white=0xFFFFFF --白色
}
local metatable = getmetatable(color) or {}
function metatable.__tostring(color)
	local r=''
	for k,v in pairs(color) do
		r='colour name:'..k..' identifier'..v..'\n'..r
	end
	return r
end
setmetatable(color,metatable)  
return color
