local ColorContants = require 'scripts.luas.constants.Color'

-- 控制台消息
local _pack = {
    gamerNames = {},
    gamerTitle = {},
}

--@init
_pack.init = function ()
    for i=0,3,1 do
        _pack.gamerNames[i] = jass.GetPlayerName(jass.Player(i))
        _pack.gamerTitle[i] = ("$color[玩家$index $name]|r ")
                    :gsub("$color",ColorContants.GAMER[i])
                    :gsub("$index",i+1)
                    :gsub("$name",_pack.gamerNames[i])
    end

    _pack.gamerTitle[4] = ColorContants.SYSTEM .."[系统消息]|r "
    _pack.gamerTitle[5] = ColorContants.WARN .."[系统警告]|r "
end

-- 系统消息
function _pack.system(msg,id)
    if (type(msg) == "table") then
        msg = string:tableConcat(msg)
    end

    if(id and jass.GetPlayerId(jass.GetLocalPlayer()) ~= id) then
        return
    end
    jass.DisplayTimedTextToPlayer(jass.GetLocalPlayer(),0,0,60, _pack.gamerTitle[4] .. msg);
end

-- 系统警告
function _pack.warn(msg,id)
    if (type(msg) == "table") then
        msg = string:tableConcat(msg)
    end

    if(id and jass.GetPlayerId(jass.GetLocalPlayer()) ~= id) then
        return
    end
    jass.DisplayTimedTextToPlayer(jass.GetLocalPlayer(),0,0,60, _pack.gamerTitle[5] .. msg);
end

-- 玩家聊天消息
function _pack.talk(msg,id)
    jass.DisplayTimedTextToPlayer(jass.GetLocalPlayer(),0,0,60, _pack.gamerTitle[id] .. msg);
end

return _pack
