local KeyConstants= require "scripts.luas.constants.Keyborad"


--@disabled 已弃用

--捕捉按键
local _pack = {
    data = {
        skill_casting = true,
        card_casting = true,

        keys = {},

        FLAG = {
            ["地面"]        = 1 << 1,
            ["空中"]        = 1 << 2,
            ["建筑"]        = 1 << 3,
            ["守卫"]        = 1 << 4,
            ["物品"]        = 1 << 5,
            ["树木"]        = 1 << 6,
            ["墙"]          = 1 << 7,
            ["残骸"]        = 1 << 8,
            ["装饰物"]      = 1 << 9,
            ["桥"]          = 1 << 10,
            ["位置"]        = 1 << 11,
            ["自己"]        = 1 << 12,
            ["玩家单位"]    = 1 << 13,
            ["联盟"]        = 1 << 14,
            ["中立"]        = 1 << 15,
            ["敌人"]        = 1 << 16,
            ["未知"]        = 1 << 17,
            ["未知"]        = 1 << 18,
            ["未知"]        = 1 << 19,
            ["可攻击的"]    = 1 << 20,
            ["无敌"]        = 1 << 21,
            ["英雄"]        = 1 << 22,
            ["非-英雄"]     = 1 << 23,
            ["存活"]        = 1 << 24,
            ["死亡"]        = 1 << 25,
            ["有机生物"]    = 1 << 26,
            ["机械类"]      = 1 << 27,
            ["非-自爆工兵"] = 1 << 28,
            ["自爆工兵"]    = 1 << 29,
            ["非-古树"]     = 1 << 30,
            ["古树"]        = 1 << 31,

            ["敌我判断"]    = (1 << 12) | (1 << 13) | (1 << 14) | (1 << 15) | (1 << 16),

            -- 本地消息的FLAG
            ["队列"] = 1 << 0,    -- 指令进入队列,相当于按住shift发布指令
            ["瞬发"] = 1 << 1,    -- 瞬发指令,该指令会立即触发发布命令事件(即使单位处于晕眩状态)
            ["独立"] = 1 << 2,    -- 单独施放,当选中多个单位时只有一个单位会响应该指令
            ["恢复"] = 1 << 5,    -- 恢复指令,该指令完成后会恢复之前的指令
        },

        jass_group = jass.CreateGroup()

    }
}

-- 判断单位是否符合技能的目标允许
local function target_filter(unit, flag, slk)
    local player = jass.GetOwningPlayer(jmessage.selection())
    -- 可见
    if jass.IsUnitInvisible(unit, player) then
        return false
    end
    -- 存活
    if flag & _pack.data.FLAG["死亡"] == 0 and jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    -- 无敌
    if flag & _pack.data.FLAG["无敌"] == 0 and jass.GetUnitAbilityLevel(unit, 1098282348 --[['Avul']]) == 1 then
        return false
    end
    -- 魔免
    if (not tonumber(jslk.reqLevel) or tonumber(jslk.reqLevel) <= 1) and jass.IsUnitType(unit, jass.UNIT_TYPE_MAGIC_IMMUNE) then
        return false
    end
    if flag & _pack.data.FLAG["敌我判断"] ~= 0 then
        -- 敌人
        if flag & _pack.data.FLAG["敌人"] == 0 and jass.IsUnitEnemy(unit, player) then
            return false
        end
        -- 自己
        if flag & _pack.data.FLAG["自己"] == 0 and unit == jmessage.selection() then
            return false
        end
        -- 玩家单位
        if flag & _pack.data.FLAG["玩家单位"] == 0 and jass.GetOwningPlayer(unit) == player then
            return false
        end
        -- 联盟
        if flag & _pack.data.FLAG["联盟"] == 0 and jass.IsUnitAlly(unit, player) then
            return false
        end
    end
    -- 非英雄
    if flag & _pack.data.FLAG["非-英雄"] ~= 0 and jass.IsHeroUnitId(unit) then
        return false
    end
    -- 英雄
    if flag & _pack.data.FLAG["英雄"] ~= 0 and not jass.IsHeroUnitId(unit) then
        return false
    end

    return true
end

-- 从鼠标位置处找出一个单位
local function find_target(ability, x, y)
    -- 读取技能的目标类型
    local data = jslk.ability[ability]
    if not data then
        return nil
    end
    local level = jass.GetUnitAbilityLevel(jmessage.selection(), ability)
    -- 取出技能的目标类型
    local target_type = japi.EXGetAbilityDataInteger(japi.EXGetUnitAbility(jmessage.selection(), ability), level, 0x64)
    local group = {}
    -- 选取单位组
    jass.GroupEnumUnitsInRange(_pack.data.jass_group, x, y, 200, nil)
    while true do
        local unit = jass.FirstOfGroup(_pack.data.jass_group)
        if not unit then 
            break
        end
        -- 判断是否符合目标允许
        if target_filter(unit, target_type, data) then
            table.insert(group, unit)
        end
        jass.GroupRemoveUnit(_pack.data.jass_group, unit)
    end
    -- 排序,找出最接近的那个单位
    table.sort(group, function(u1, u2)
        -- 英雄比非英雄优先
        local h1 = jass.IsHeroUnitId(u1)
        local h2 = jass.IsHeroUnitId(u2)
        if h1 and not h2 then
            -- 返回true表示u1排在u2前面
            return true
        end
        if h2 and not h1 then
            -- 返回false表示u2排在u1前面
            return false
        end
        -- 距离越近越优先
        local x1 = jass.GetUnitX(u1)
        local y1 = jass.GetUnitY(u1)
        local x2 = jass.GetUnitX(u2)
        local y2 = jass.GetUnitY(u2)
        return (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y) < (x2 - x) * (x2 - x) + (y2 - y) * (y2 - y)
    end)
    -- 返回单位组里的第一个单位
    return group[1]
end

-- 立即发动技能
local function cast_ability(ability, order, target_type)
    -- 鼠标当前指向的位置
    local x, y = jmessage.mouse()
    if target_type == 2 then
        -- 点目标命令
        jmessage.order_point(order, x, y, _pack.data.FLAG["独立"] | _pack.data.FLAG["恢复"])
        -- 返回false表示，这个消息会被扔掉(war3不会收到)
        return false
    elseif target_type == 4 then
        -- 单位目标命令
        -- 寻找技能目标
        local target = find_target(ability, x, y)
        if target then
            jmessage.order_target(order, x, y, target, _pack.data.FLAG["独立"] | _pack.data.FLAG["恢复"])
        end
        return false
    elseif target_type == 1 then
        -- 无目标命令
        jmessage.order_immediate(order, _pack.data.FLAG["独立"] | _pack.data.FLAG["恢复"])
        return false
    end
    return true
end

-- 按键回调
local function key_callback(key)
    if (_pack.data.keys[key])then
        local rt = false
        for _,v in pairs (_pack.data.keys[key]) do
            rt = rt or not v()
        end
        return not rt
    end

    return true
end

-- 根据技能快捷键找到技能 
-- qwer 123456
local function find_ability(key)
    local x,y

    if (key == KeyConstants['1']) then
        x,y = 0,2
    elseif (key == KeyConstants['2']) then
        x,y = 0,3
    elseif (key == KeyConstants['3']) then
        x,y = 1,0
    elseif (key == KeyConstants['4']) then
        x,y = 1,1
    elseif (key == KeyConstants['5']) then
        x,y = 1,2
    elseif (key == KeyConstants['6']) then
        x,y = 1,3
    elseif (key == KeyConstants['Q']) then
        x,y = 2,0
    elseif (key == KeyConstants['W']) then
        x,y = 2,1
    elseif (key == KeyConstants['E']) then
        x,y = 2,2
    elseif (key == KeyConstants['R']) then
        x,y = 2,3
    else
        return false
    end

    return jmessage.button(x, y)
end

local function isSkillKey(code)
    return code == KeyConstants['Q'] 
        or code == KeyConstants['W']
        or code == KeyConstants['E'] 
        or code == KeyConstants['R'] 
end

local function isCardKey(code)
    return code == KeyConstants['1']
        or code == KeyConstants['2'] 
        or code == KeyConstants['3'] 
        or code == KeyConstants['4'] 
        or code == KeyConstants['5'] 
        or code == KeyConstants['6'] 
end

-- 设置智能施法开关
-- @param type number  1skill 2card
-- @param flag boolean
function _pack.setCasting(type,flag)
    if (type ==1) then
        _pack.data.skill_casting= flag
    else
        _pack.data.card_casting= flag
    end
end

local function cardcasting(code)
    if (_pack.data.card_casting) then 
        local ability, order, target_type = find_ability(code)
        if (ability) then
            return cast_ability(ability, order, target_type)
        else
            return true
        end
    end
end

local function skillcasting(code)
    if (_pack.data.card_casting) then 
        local ability, order, target_type = find_ability(code)
        if (ability) then
            return cast_ability(ability, order, target_type)
        else
            return true
        end
    end
end

function _pack.registerEvent(key,callback)
    if (not _pack.data.keys[key]) then
        _pack.data.keys[key] = {}        
    end
    table.insert(_pack.data.keys[key],callback)
end

--@init
function _pack.init()
    -- jmessage.order_enable_debug()

    jmessage.hook = function (msg)
        if not jmessage.selection() then
            return true
        end

        if msg.type == 'key_down' then
            
            if (isSkillKey(msg.code) ) then
                -- qwer 
                return skillcasting(msg.code)

            elseif (isCardKey(msg.code)) then
                -- 123456
                return cardcasting(msg.code)

            else
                --其他按键
                return key_callback(msg.code)
            end
        end

        return true
    end
end

return _pack