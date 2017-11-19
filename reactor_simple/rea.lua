-- 声明部分
local component = require ("component")
local sides     = require ("sides")
local term      = require ("term")
local computer = require ("computer")

-- 初始化程序

print('正在初始化程序')    
if not component.isAvailable('redstone') then --检测模块是否存在
print('未发现红石I/O端口')
return
else
print('发现红石I/O端口')
end
if not component.isAvailable('inventory_controller') then
print('未发现高级物品栏升级模块')
return
else
print('发现高级物品栏升级模块')
end
reactor_add={}
for address,name in pairs (component.list('reactor')) 
do  
  reactor_add[1]=address
end
if not reactor_add[1] then
print('未发现反应堆')
return
else
print('发现反应堆')
end

-- 实际程序

local inv = component.inventory_controller --物品管理
local red = component.redstone --红石块
local reactor = component.proxy(reactor_add[1]) --反应堆
local gpu = component.gpu --显卡

reactor_heat=reactor.getHeat() --获取反应堆初始温度
reactor_maxheat=reactor.getMaxHeat()
reactor_euout=reactor.getReactorEUOutput()
n=inv.getInventorySize(sides.top)-4 --获取反应堆初始物品栏数量

function sanreqitihuan (a,lnq)  --散热器替换
  if n1['damage']>=10000-lnq then
  gpu.set(65,22,'暂停替换散热器')
  red.setOutput(sides.top,0)
  os.sleep(3)
  n1=inv.getStackInSlot(sides.top,a)
  if n1['damage']>=10000-lnq then
        term.clear()
        print('散热器未替换！')
        allend=1
        return allend
        else
        red.setOutput(sides.top,15)
        gpu.set(65,22,'            ')
        end
  end
  end

function lengningqi() --冷凝器检测
  if n1['damage']>=10000-lnq then
  print('冷凝器器耐久小于'..lnq)
  red.setOutput(sides.top,0)
  c=1
  return c
  end
end 

function zheshilengningqi() --冷凝器耐久设置
while lnq==0
do
print('发现冷凝器请设置冷凝器 最小耐久值默认为1000')
lnq=term.read()
if lnq=="\n" then
lnq=1000
end
lnq=tonumber(lnq)
if lnq~=nil then
return lnq
end
end
end

r=reactor_heat/reactor_maxheat    --获取反应堆温度百分比
r=r*100
r=math.modf(r)
lnq=0
print('反应堆初始温度:'..r..'%')
for a=1,n   --初始化耐久
  do
  n1=inv.getStackInSlot(sides.top,a)
  if n1 ~=nil then
  if n1['name'] == "IC2:reactorCondensatorLap" then --对比名字
  zheshilengningqi()
  lengningqi(n1)
  elseif n1['name'] == "IC2:reactorCondensator" then
  zheshilengningqi()
  lengningqi(n1)
  end
  end
  end
  



if c==1 then
return
else
print('设置显示界面')
term.clear()
gpu.set(30,1,'检测反应堆数据1.0')
gpu.set(68,24,'作者：asdflj')
gpu.set(1,21,'提示:XX=散热器,1U=单铀棒,4X=4联MOX,以此类推 数值越大损耗越高!')
gpu.set(1,23,'强制重启红石信号依旧在发出！从红石I/O端口的上方发出强度为15')
gpu.set(1,25,'添加冷凝器的时候请重启程序，否则程序无法正常检测冷凝器')
if lnq~=0 then
gpu.set(55,17,'冷凝器最低耐久  ：'..lnq)
end
gpu.setResolution(80,25)  --绘制框架
for a1=0,9
do
gpu.fill(5+a1*5,3,1,17,'|')
end
for a1=0,6
do
gpu.fill(6,2+a1*3,44,1,'-')
end
red.setOutput(sides.top,15)
while true
do
n=inv.getInventorySize(sides.top)-4 --获取反应堆物品栏数量
seconds = math.floor(computer.uptime()) --启动时间
minutes,hours =0,0

a1=1
a2=1
for a=1,n   
  do
  n1=inv.getStackInSlot(sides.top,a)  --获取反应堆物品栏数量
  a1=a1+1     --自动换行
  if a1>n/6+1 then 
  a2=a2+1
  a1=2
  end
  
  if n1 ~=nil then    --检测物品名字并显示耐久
  if n1['name'] == "IC2:reactorUraniumQuad" then
  gpu.set(-3+a1*5,a2*3,'4U')
  elseif n1['name'] == "IC2:reactorMOXQuad" then
  gpu.set(-3+a1*5,a2*3,'4X')
  elseif n1['name'] == "IC2:reactorUraniumDual" then
  gpu.set(-3+a1*5,a2*3,'2U')
  elseif n1['name'] == "IC2:reactorMOXDual" then
  gpu.set(-3+a1*5,a2*3,'2X')
  elseif n1['name'] == "IC2:reactorUraniumSimple" then
  gpu.set(-3+a1*5,a2*3,'1U')
  elseif n1['name'] == "IC2:reactorMOXSimple" then
  gpu.set(-3+a1*5,a2*3,'1X')
  ----------------------可自行添加-------------------------
  --[[格式
  elseif n1['name'] == "IC2:reactorMOXSimple(物品名字)" then 
  gpu.set(-3+a1*5,a2*3,'显示名字(最多不超过4个不然会出BUG)')
  ]]--
  else 
  gpu.set(-3+a1*5,a2*3,'XX')
  end
  gpu.set(-4+a1*5,a2*3+1,'    ')  
  
  
  n2=tostring(n1['damage']) --检测物品耐久
  gpu.set(-4+a1*5,a2*3+1,n2)
  
  if n1['name'] == "IC2:reactorCondensatorLap" then --检测冷凝器耐久
  sanreqitihuan (a,lnq) --散热器替换
  if allend==1 then   --是否替换成功1=失败
  return
  end
  elseif n1['name'] == "IC2:reactorCondensator" then --检测冷凝器耐久
  sanreqitihuan (a,lnq) --散热器替换
  if allend==1 then --是否替换成功1=失败
  return
  end
  end
  else
  gpu.set(-4+a1*5,a2*3+1,'    ')
  gpu.set(-4+a1*5,a2*3,'    ')
  end
  end

  reactor_heat_now=reactor.getHeat()--获取反应堆温度
  if reactor_heat_now <= reactor_heat then --对比温度
  else
  term.clear()
  print('危险，温度提升！')
  red.setOutput(sides.top,0)
  return
  end
  
  
if seconds >= 60 then --时间计算
  minutes =math.floor(seconds / 60)
  seconds =seconds % 60
end
if minutes >= 60 then
  hours = math.floor(minutes / 60)
  minutes = minutes %60
end 


reactor_euout=reactor.getReactorEUOutput()  --获取反应堆输出电量
if reactor.producesEnergy()==true then --获取反应堆是否启动
run='是'
else
run='否'
end

gpu.set(55,5,'                         ')
gpu.set(55,7,'                         ')
gpu.set(55,9,'                         ')
gpu.set(55,11,'                         ')
gpu.set(55,13,'                         ')
gpu.set(55,15,'                         ')
gpu.set(55,5,'反应堆扩展仓数  ：'..n/6-3)
gpu.set(55,7,'反应堆输出      ：'..math.modf(reactor_euout)..' EU')
gpu.set(55,9,'反应堆最大温度  ：'..reactor_maxheat)
gpu.set(55,11,'反应堆当前温度  ：'..reactor_heat_now)
gpu.set(55,13,'反应堆温度百分比：'..math.modf(reactor_heat_now/reactor_maxheat*100)..' %')
gpu.set(55,15,'反应堆正在运行  ：'..run)
gpu.set(63,25,string.format("连续开机:".."".."%02d:%02d:%02d", hours, minutes,seconds))
end
end

