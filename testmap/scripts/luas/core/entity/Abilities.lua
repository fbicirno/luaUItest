local Damage = require 'scripts.luas.core.entity.Damage'
local Context = require 'scripts.luas.core.applic.Context'
local abiContants = require 'scripts.luas.constants.Ability'
local Id = require 'scripts.luas.utils.id.Id'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'

local AbiOrbs = require 'scripts.luas.core.entity.Ability.AbiOrbs'
local AbiHandle = require 'scripts.luas.core.entity.Ability.AbiHandle'
local AbiTalent = require 'scripts.luas.core.entity.Ability.AbiTalent'
local AbiItems = require 'scripts.luas.core.entity.Ability.AbiItems'

-- 技能系统
--[[
    玩家释放技能
    玩家天赋触发
    玩家发球触发
    玩家物品技能
    npc释放技能
    地图机制技能
]]
local _pack = {
    data = {
        --法球处理
        orbHandle = {},
        talHandle = {},
        abiHandle = {},
    }
}

--TODO处理技能id冲突  禁用其他技能。释放。恢复

-- 释放技能 需要同步环境
--@param target 目标：  nil  unit item destruct posi
--@param gid    使用者
--@param entity 使用技能    item_handle 或 gamer.abilityEntity
function _pack.cast(loc,aim,gid,entity)
    --检测技能
    if (type(entity)=="table") then
        --获取技能config索引
        local index = 0
        _pack.data.abiHandle[index](loc,aim,gid,entity)

    --检测物品
    elseif(type(entity)=="userdata") then
        -- local itemGameExType = Items.getItemGameExType(entity)
        -- AbiItems[itemGameExType](gid,entity)
    end
end

--根据技能获取一个模板技能
--[[
    1 敌对单位
    2 友军单位
    3 任意单位
    4 点目标
    5 圈目标
    6 无目标
    7 开关
]]
function _pack.getTemplateAbility(entity)
    local sType = entity.stype
    if (sType == 1) then
        return 0

    elseif (sType == 2) then
        return 0

    elseif (sType == 3) then
        return 0

    elseif (sType == 4) then
        return 0

    elseif (sType == 5) then
        return 0

    elseif (sType == 6) then
        return 0

    elseif (sType == 7) then
        return 0

    else
        return nil
    end
end

--根据entity修改abiTemplate数据
--需要同步环境
function _pack.updateAbiTemplate(abi,gid,entity)
    --释放距离
    --冷却时间
    --蓝耗
    --影响范围
end

--根据释放的模板技能 查找entity
function _pack.getAbilityEntityByTemplate(abi,role)
    for i =1,4,1 do
        if (role.data.abiTemplate[i] == abi)then
            return role.data.abilities.ability[i]
        end
    end
end

--玩家添加技能
--先同步再调用
function _pack.add(gid,entity)
end

--玩家移除技能
--先同步再调用
function _pack.remove()
end

--@init
function _pack.init()

    AbiOrbs.init(_pack.data)
    AbiHandle.init(_pack.data)
    AbiTalent.init(_pack.data)

    --法球
    Damage.registerEvent("onDamage","orb",function(dmgUnit,srcUnit,dmg,params)

        local gid = jass.GetPlayerId(jass.GetOwningPlayer(srcUnit))
        local orbId,orbDmg

        if (type(params) == "table") then
            orbId = params.type --法球类型
            orbDmg = params.dmg
        else
            orbId = params
            orbDmg = abiContants.orb.dmg[orbId]
        end

        print("Randoms-key=","player_orb_"..gid)
        
        local random = Context.get("Randoms")["player_orb_"..gid]
        if (random.getResult())then
            --触发法球 根据类型实现效果
            dmg = _pack.data.orbHandle[orbId](dmgUnit,srcUnit,dmg)
        end

        return dmg
    end)

    --捕捉玩家释放技能
    Trigger.registerEvent("spell",function()
        local unit = jass.GetTriggerUnit()
        local gid = jass.GetOwningPlayer(unit) 
        local aid = jass.GetSpellAbilityId()  --技能id
        local aim = jass.GetSpellTargetUnit() --技能释放目标
        local loc = jass.GetSpellTargetLoc()  --技能释放点

        local gamer = Context.get("Gamer")[gid]
        local role = gamer.data.role
        
        --根据aid找到entity
        local entity = _pack.getAbilityEntityByTemplate(aid,role)

        _pack.cast(loc,aim,gid,entity)
    end)
end

return _pack
