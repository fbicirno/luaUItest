local Request = require 'scripts.luas.po.Request'
local Response = require 'scripts.luas.po.Response'
local UUID = require 'scripts.luas.utils.id.UUID'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local Context = require 'scripts.luas.core.applic.Context'
local Object = require 'scripts.luas.utils.object.ObjectUtils'

-- 通讯控制器
local _pack = {
    data = {
        trigger = jass.CreateTrigger(),
        events = {},
        hangup = {}, --挂起的线程 
    },
    target_constant = {
        [0] = 0,
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 5,
        [-1] = -1,
        [-2] = -2,

        all = -1,
        other = -2,
    }
}

--[[
    hangup 
    {
        request = request,
        delay = number
        wait={
            [0] = false,       index-玩家索引  false回执内容 默认为false 接受到确认时设置为message
            [1] = false,
            [2] = false,
            [3] = false,
            [4] = false,
        },
        callback(list,flag)
    }

    每次接受到type=4 时 扫描hangup表=》匹配request=》设置wait内容
    
    计时器每两秒扫描扫描hangup表：
        1 当wait里面所有属性不为false时 执行callback()  执行后清空
            list为wait对象   
            flag  true正常触发 flag超时触发
            
        2 每次扫描都检查delay 如果超时则直接执行callback
]]

-- 初始化wait表 不包括本地玩家
local function initWaitListOhter()
    local t = {}
    local localId = jass.GetPlayerId(jass.GetLocalPlayer())
    for i=0,5,1 do
        if (i~= localId) then
            local gamer = Context.get("Gamers")[i]
            if (gamer.isGamer()) then
                t[i] = false
            end
        end
    end

    return t
end

-- 初始化wait表 包括本地玩家
local function initWaitList()
    local t = {}
    for i=0,5,1 do
        local gamer = Context.get("Gamers")[i]
        if (gamer.isGamer()) then
            t[i] = false
        end
    end

    return t
end

function _pack.clearHangup()
    for k,v in pairs (_pack.data.hangup) do
        if(v.runing) then
            _pack.data.hangup[k] = nil
        end
    end
end

-- 发送同步消息
--@param request
--@param hangup  等待回执的挂起任务
function _pack.send(request,hangup)
    --检查参数
    request.type = request.type or 1
    request.target = _pack.target_constant[request.target] 

    if(request.type ==2 or request.type ==3 )then
        --强制分配date host rid
        -- request.date = request.date or tostring(os.time())
        request.host = request.host or jass.GetPlayerId(jass.GetLocalPlayer())
        request.rid = request.rid or UUID.random()
    end

    local msg = Object.serialize(request)

    jass.FlushChildHashtable(jglobals.lua_engine,100);
    jass.SaveStr(jglobals.lua_engine,100,1,msg);
    jass.ExecuteFunc("SyncData")

    if (hangup)then
        local wait

        if(request.target == -1) then
            wait = initWaitList()
        end

        if (request.target == -2) then
            wait = initWaitListOhter()
        end

        local t={
            request = request,
            runing = false,
            wait = wait,
            callback= hangup
        }

        t.trace = CenterTimer.addTrace(nil,{
            delay = 5000,
            loop = false,
            bind = t,
            callback = function(bind)
                if(t.runing) then
                    return 
                end

                t.runing = true --标记为已经运行了
                bind.callback(bind.wait,"overtime")
                _pack.clearHangup()--调用表清理
            end
        })

        table.insert(_pack.data.hangup,t)
    end
end

-- 注册事件响应
function _pack.registerEvent(event,callback)
    _pack.data.events[event] = callback
end

-- 根据接收到同步信息实例化一个响应
local function getResponseBySyncMessage(str,request)
    local response = Response.create()
    --TODO
    return response
end

function _pack.onMessage(gid,msg)
    print("Scoket.onMessage","接收同步消息:",gid,msg)

    local request = Object.unserialize(msg)
    local localId = jass.GetPlayerId(jass.GetLocalPlayer())
    
    if (request.target == -1  
        or (request.target == -2 and request.host ~=localId)
        or string.find(tostring(request.target),tostring(localId))
    ) then

        -- 判断消息类型
        if (request.type == 1) then
            --普通消息
            local callback = _pack.data.events[request.head]
            if (callback)then
                callback(request,null)
            end

        elseif (request.type==2)then
            --需要回复
            local callback = _pack.data.events[request.head]
            
            local response = Request.create()
            response.head = request.head --匹配head
            response.rid = request.rid   --匹配rid
            response.type = 4            --类型为回执
            response.host = localId
            response.message = true
            response.target= request.host

            if (callback)then
                callback(request,response)
            end

            _pack.send(response) --回复

        elseif (request.type==3) then
            --直接回复 
            local response = Request.create()
            response.rid = request.rid 
            response.type = 4   
            response.host = jass.GetPlayerId(jass.GetLocalPlayer)
            response.message = true
            response.target= request.host

            _pack.send(response)

        elseif(request.type==4)then
            --接收到回执
            --是否有匹配的挂起线程
            for _,v in pairs (_pack.data.hangup) do
                local checkReq = v.request
                if (checkReq.head == request.head and checkReq.rid == request.rid) then
                    --发现匹配  设置wait
                    v.wait[request.host] = request.message

                    --检查是否可运行
                    local flag = true
                    for k1,v1 in pairs(v.wait) do
                        if (v1==false)then
                            flag = false
                            break
                        end
                    end

                    if (flag) then
                        v.runing = true
                        v.trace.remove()   --删除延时等待函数
                        v.callback(v.wait) --执行挂起函数
                        
                        _pack.clearHangup()
                    end

                    return
                end
            end
        end
    end
end

--@init
function _pack.init()
    -- 接口
    Interface.Scoket = {}
    Interface.Scoket.message = _pack.onMessage

    --覆盖接口
    if(Interface.dzevent and Interface.dzevent.syncEvent)then
        local old = Interface.dzevent.syncEvent
        Interface.dzevent.syncEvent = _pack.onMessage
    end
end

return _pack
