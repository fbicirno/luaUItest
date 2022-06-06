local UUID = require 'scripts.luas.utils.id.UUID'
local Role = require 'scripts.luas.core.gamer.Role'
local Request = require "scripts.luas.po.Request"
local Scoket = require "scripts.luas.core.scoket.Scoket"
local Random = require 'scripts.luas.utils.id.Random'
local Context = require 'scripts.luas.core.applic.Context'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local UnitParam = require'scripts.luas.po.UnitParam'
local Camera = require "scripts.luas.utils.envir.Camera"

--玩家类
local _pack = {
    gamers = {}
}

function _pack.create(index)
    local  t = {
        type = "object@luas.core.gamer.Gamer",
        id = UUID.random(),
        data = {
            role = nil,
            isCreateRole = false,
            index = index,
            isGamer = false,

            gold = 0,        --金币
            lumber = 0,      --木头
            popul = 0,       --人口
            wy_money = 0, --商城币
            wy_token = 0, --商城代币
            
            level = 1,
            currentExp = 0, --当前经验值
            maxExp = 100,   --升级临界经验值

            --cd记录
            cdGroup = {},
            role_params = nil,
            save = {},
        }
    }
    --[[setmetatable(t,{
        __index =  function(mytable,key)
            if (key == "create" or key == "init") then
                return nil
            end

            if (type(_pack[key]) == "function")then
                return function(...)
                    return _pack[key](mytable,...)
                end
            end
            
            return _pack[key]
        end,
	
	    __newindex = function() end
    })]]

    t.isGamer = function()
        return t.data.isGamer
    end

    t.createRole = function(unit)
        t.data.role = Role.create(t.data.index,unit)
        t.data.isCreateRole = true

        t.data.role_params = UnitParam.create(jass.GetUnitTypeId(unit))

        --初始化 
        jass.ClearSelection()
        jass.SelectUnit(t.data.role.data.unit,true)
        Camera.release()
        Camera.moveUnit(t.data.role.data.unit)

        --更新hui
        Interface.GUI.update(t.data.role.data.unit)
        Interface.GUI.update_selfHead(t.data.role)
        --初始物品

        --同步
        local request = Request.create()
        request.head = "create_role"
        request.host = jass.GetPlayerId(jass.GetLocalPlayer())
        request.message ={
            unitTypeId = jass.GetUnitTypeId(unit),
            skinId = 0,
        }

        request.target = -2
        Scoket.send(request)
    end

    t.equals =function(obj) 
        return obj.type == "object@luas.core.gamer.Gamer" and obj.id == t.id
    end

    --设置某技能或物品的cd
    t.setCd = function(type)
        t.data.cdGroup[type] = true
        
        if (type == 31)then --药水cd
            CenterTimer.addTrace(nil,{
                delay = 10,
                loop = false,
                bind =  t,
                callback = function(obj)
                    obj.data.cdGroup[31] = false
                end
            })

        elseif (type == 33) then --每日
            t.data.cdGroup[33] = true 
            --记录云存档

        elseif(type ==34) then --每周
            t.data.cdGroup[34] = true 
            --记录云存档

        elseif(type == 35) then --每局
            t.data.cdGroup[35] = true 
        end
    end

    --获取某技能或物品的cd
    t.getCd = function(type)
        return t.data.cdGroup[type]
    end

    --选择英雄单位
    t.selectSelf = function()
        jass.ClearSelection()
        jass.SelectUnit(t.data.role.data.unit,true)
    end

    t.getResource = function()
        return math.floor(t.data.gold),math.floor(t.data.lumber)
    end

    t.addResource = function(gold,lumber)
        gold = tonumber(gold)
        lumber = tonumber(lumber)

        if(gold >= 99999 or lumber >=99999) then
            print("检测到资源波动")
            return 
        end

        t.data.gold = t.data.gold+gold
        t.data.lumber = t.data.lumber+lumber
    end

    t.deductResource = function(gold,lumber)
        gold = tonumber(gold)
        lumber = tonumber(lumber)
        t.data.gold =  t.data.gold -gold
        t.data.lumber = t.data.lumber -lumber
    end

    t.checkResource = function (gold,lumber)
        gold = tonumber(gold)
        lumber = tonumber(lumber)
        return  t.data.gold>=gold and  t.data.lumber>=lumber
    end

    _pack.gamers[index] = t
    return t
end

function _pack.getLocal()
    local index = jass.GetPlayerId(jass.GetLocalPlayer())
    return _pack.gamers[index]
end

-- 是否是玩家
function _pack.checkGamer(index)
    return jass.GetPlayerController(jass.Player(index)) == jass.MAP_CONTROL_USER and jass.GetPlayerSlotState(jass.Player(index)) == jass.PLAYER_SLOT_STATE_PLAYING
end

-- 检查主机玩家
function _pack.checkHost()
    --@TODO


    return 0
end

-- 检查单位是不是玩家角色
-- @param check unit 要检查的单位
function _pack.isGamerRole(check)
    for i=0,5,1 do
        local role = _pack.gamers[i].data.role
        if (role)then
            local unit = role.data.unit

            if (unit == check) then
                return true
            end
        end
    end

    return false;
end

--根据role对象获取gamer对象
function _pack.getInstanceByRole(role)
    if (not role) then return nil end

    local gid = role.data.index
    return  _pack.gamers[gid]
end

-- 检查单位是不是玩家伙伴
function _pack.isGamerPartner(check)
    for i=0,5,1 do
        local role = _pack.gamers[i].data.role
        if (role)then
            local unit = role.data.partner
            if (unit == check) then
                return true
            end
        end
    end

    return false
end

function _pack.exit()
end

function _pack.getNumber()
    local num = 0;
    for i=0,5,1 do
        if(jass.GetPlayerController(jass.Player(i)) == jass.MAP_CONTROL_USER --控制者是玩家
            and jass.GetPlayerSlotState(jass.Player(i)) == jass.PLAYER_SLOT_STATE_PLAYING --正在游戏
        ) then
            num = num+1
        end
        -- jass.GetPlayerSlotState(jass.Player(i)) == jass.PLAYER_SLOT_STATE_EMPTY --没有玩家
        -- jass.GetPlayerController(jass.Player(i)) == jass.MAP_CONTROL_COMPUTER --控制者是电脑
    end
    
    return num;
end

--@init
function _pack.init()
    for i=0,5,1 do
        local gamer = _pack.create(i)
        gamer.data.isGamer = _pack.checkGamer(i)
        _pack.gamers[i] = gamer
    end

    Context.put("Gamers",_pack.gamers)
    Context.put("GamerLocal",_pack.gamers[jass.GetPlayerId(jass.GetLocalPlayer())])

    Context.put("numberOfGamer",_pack.getNumber())
    -- Context.put("hostGamer",_pack.checkHost())

    local hostId = _pack.checkHost()
    Context.put("GamerHost",_pack.gamers[hostId])

    -- 监听其他玩家创建英雄事件
    Scoket.registerEvent("create_role",function(request,response)
        
    end)

    --注册随机数
    for i=0,5,1 do
        --物暴
        Random.registerEvent("player_pcp_"..i,0)
        --魔暴
        Random.registerEvent("player_mcp_"..i,0)
    end
end

return _pack
