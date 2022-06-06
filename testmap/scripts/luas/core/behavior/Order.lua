local Scoket = require 'scripts.luas.core.scoket.Scoket'
local Console= require 'scripts.luas.utils.envir.Console'

--指令
local _pack = {

    data = {
        event = {}

    }
}

-- 注册指令
-- @param name string
-- @param desp string 提示
-- @param callback function
function _pack.registerEvent(name,desp,callback)
    _pack.data.event[name] = {desp,callback}
end

--@init
function _pack.init ()
    --指令和聊天触发
    local trig = jass.CreateTrigger()

    for i=0,5,1 do
        jass.TriggerRegisterPlayerChatEvent( trig, jass.Player(i), "", true )
    end

    jass.TriggerAddAction(trig,function()
        local input = jass.GetEventPlayerChatString() or ""
        local id = jass.GetPlayerId(jass.GetTriggerPlayer())

        local order_prefix = string.split(input," ")
        for k,v in pairs(_pack.data.event) do
            if ( k==order_prefix[1]) then
                v[2](id,order_prefix[2])
                return
            end
        end

        if (string.startsWith(input,"-")) then
            Console.system('未识别的指令，输入"-help"查看指令列表',id)
            return
        end

        --聊天消息
        Console.talk(input,id)
    end)

    _pack.registerEvent("-help","显示指令列表",function()
        jass.ClearTextMessages()
        for k,v in pairs (_pack.data.event) do
            jass.DisplayTimedTextToPlayer(jass.GetLocalPlayer(),0,0,60,
                ("$order  $desp"):gsub("$order",k):gsub("$desp",v[1])
            )
        end
    end)

    _pack.registerEvent("-cls","清除屏幕消息",function(id,msg)
        if (jass.GetPlayerId(jass.GetLocalPlayer()) == id) then
            jass.ClearTextMessages()
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
            print("");
        end
    end)
end

return _pack
