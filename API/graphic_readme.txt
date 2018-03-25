使用讲解
首先导入模块 
local graphic=require('graphic')
函数讲解
init(x,y,r) 初始化幕布 x y 为大小，r 是刷新率 默认为3 大小不宜过大，否则会内存不足 必运行 否则其他函数不起作用
uninit() 卸载幕布，清理内存
drawline(x_min,x_max,y,background_colour,foreground_colour,text,run)画一条线 x_min,x_max 为X轴的最小和最大值，
y=y轴 background_colour=背景颜色 foreground_colour=字体颜色 text=文字 run=函数 
fill_background_colour(background_colour)填充所有背景颜色 background_colour=背景颜色
fill_foreground_colour(foreground_colour)填充所有字体颜色 foreground_colour=字体颜色
clear_text() 清除所有文字
setresolution(x,y) 设置显示大小 
draw_simple(x,y,background_colour,foreground_colour,text,run) 设置单个位置 text只能为单英文或者数字
draw_text(x_min,x_max,y,text,alignment,run) 填充文字 x_min,x_max 为X轴的最小和最大值 alignment=对齐方式 支持
左对齐 右对齐 居中对齐 run=填充该位置的函数
display_tab_save(file) 把当前幕布存储起来 file=文件名
display_tab_read(file) 把当前幕布读取出来 file=文件名
change_display_tab(file1,file2) 切换当前幕布 ，file1=存储幕布文件名 file2=读取幕布文件名  可实现幕布的快速切换
draw_pause() 暂停或者开启自动刷新 刷新速度根据刷新率
draw_pause_statu() 获取当前自动刷新状态
change_refresh(refresh) 更改刷新率 refresh=刷新速度 单位秒
setdisplay_area(x_min,x_max,y_min,y_max) 设置幕布的显示范围 
getdisplay_statu() 得到幕布状态
display_refresh() 立即刷新幕布
clear_text_line(y) 清除一行文字
自动启用函数
mouse_click() 获取鼠标点击的位置，去找对应位置的幕布函数启动 比如在X=1 Y=1的地方用
draw_simple(x_min,x_max,y,background_colour,foreground_colour,text,run)
run=你定义的函数 鼠标左键点击上去就会自动启动函数，省去写触摸代码
mouse_scroll() 鼠标滚轮事件 当幕布大小大于显示范围的时候 使用鼠标滚轮会自动切换渲染位置
省去写滚动条代码，即可实现滚动
