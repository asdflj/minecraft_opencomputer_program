local computer = require ("computer")
local component = require ("component")
local event = require ("event")
local reactor = require ("reactor_firstrun")
reactor.now_Heat={}
reactor.now_OutEU={}
reactor.now_Run={}
reactor.redstone_getOut={}
local a=0
proxy=component.proxy
for k,v in pairs(reactor.address)
do 
if proxy(reactor.address[k]) ~=nil and  --检测是否存在
proxy(reactor.redstone_address[k])~= nil  then
local rea_add=proxy(reactor.address[k])
local rea1=rea_add.getHeat()
local rea2=rea_add.getMaxHeat()
local reactor_now_Heat=math.modf(rea1/rea2*100) --获取反应堆当前温度百分比
local reactor_now_OutEU=math.modf(rea_add.getReactorEUOutput()) --获取反应堆当前输出
if reactor.statu[k]=='Off' then  --获取上次红石状态
a=0
else
a=15
end
local red_add=proxy(reactor.redstone_address[k]) --代理红石
red_add.setOutput(tonumber(reactor.sides[k]),a) --设置红石输出
if rea_add.producesEnergy() == true then --反应堆是否开启
reactor_Run1='打開'
else
reactor_Run1='關閉'
end
local red_add_getOut=red_add.getOutput(tonumber(reactor.sides[k])) --获得红石输出量
reactor.now_Heat[k]=reactor_now_Heat --当前温度
reactor.now_OutEU[k]=reactor_now_OutEU --当前输出
reactor.now_Run[k]=reactor_Run1  --当前是否运行
reactor.redstone_getOut[k]=red_add_getOut --当前红石输出
end
end
--print('a')
computer.pushSignal('end') --获取信息完毕，推信号
return reactor