local _pack = {}

local lasttime = nil;
local lastsign =0;
local old = {}

local function random()
    local currentTime = tonumber(tostring(os.time()):sub(4)) --丢弃前4位 (年范围) 32位2147483647

    if(currentTime == lasttime) then
        lastsign = lastsign + 1
    else
        lasttime = currentTime
        lastsign = 0
    end
    return currentTime .. lastsign
end

function _pack:random()
    local r = random()
    while( old[r] ~= nil ) do
        r = random
    end
    old[r] =1
    return tonumber(jass.GetPlayerId(jass.GetLocalPlayer())+1 .. r)
end

return _pack
