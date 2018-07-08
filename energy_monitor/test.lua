local component = require('component')
internet = component.internet

mfsu = {}
for k,v in pairs(component.list('ic2'))do
    table.insert(mfsu,k)
end
mfsu =component.proxy(mfsu[1]) 
while true do
    local e = mfsu.getEnergy()
    local c = mfsu.getCapacity()
    local message = 'type=1&username=1&password=456&apiKey=b6e60e0827d2623526e69915f96fae33&power='..e..'&name=RoomEnergy&powerTotal='..c
    result = internet.request('http://193.112.220.208:8000/getMessage',message)
    print(result.read())
    os.sleep(1)
end
