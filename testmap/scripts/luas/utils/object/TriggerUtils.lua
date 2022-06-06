local CameraContants = require 'scripts.luas.constants.Camera'

--封装触发器
-- 事件相同的触发器合并
local _pack = {
    data = {

        damageActions = {}
    },
    group = jass.CreateGroup(),
}

function _pack.registerEvent(name,func)
    if(_pack.data[name]) then
        jass.TriggerAddAction(_pack.data[name],func)
    end

    if (name == "damage") then
        table.insert(_pack.data.damageActions,func)
    end
end

function _pack.pause(event)
    if (event and _pack.data[event])then
        jass.DisableTrigger(_pack.data[event])
    end
end

function _pack.continue(event)
    if (event and _pack.data[event])then
        jass.EnableTrigger(_pack.data[event])
    end
end

local function resetDamageTrigger()
    jass.DisableTrigger(_pack.data["damage"])
    jass.DestroyTrigger(_pack.data["damage"])

    _pack.data["damage"] = jass.CreateTrigger()
    --重新添加动作
    for _,func in pairs(_pack.data.damageActions) do
        jass.TriggerAddAction(_pack.data["damage"],func)
    end

    --重新注册事件
    for i=0,15,1 do
        jass.GroupEnumUnitsOfPlayer(_pack.group,jass.Player(i),nil)
        jass.ForGroup(_pack.group, function()
            local unit = jass.GetEnumUnit()
            jass.TriggerRegisterUnitEvent(_pack.data["damage"], unit, jass.EVENT_UNIT_DAMAGED )
        end)
    end
end

--@init
function _pack.init()
    local trig = jass.CreateTrigger()

    --游戏开始0秒
    jass.TriggerRegisterTimerEvent(trig, 0, false)
    _pack.data["game_start"] = trig

    --本地玩家选择单位
    trig = jass.CreateTrigger()
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_UNIT_SELECTED, nil)
    _pack.data["select_local"] = trig

    --本地玩家取消选择单位
    trig = jass.CreateTrigger()
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_UNIT_DESELECTED, nil)
    _pack.data["deselect_local"] = trig

    --任意玩家选择单位
    trig = jass.CreateTrigger()
    for i=0,5,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_SELECTED, nil)
    end
    _pack.data["select"] = trig

    --任意玩家取消选择
    trig = jass.CreateTrigger()
    for i=0,5,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_DESELECTED, nil)
    end
    _pack.data["deselect"] = trig

    --接受伤害 动态注册
    _pack.data["damage"] = jass.CreateTrigger()
    local region = jass.CreateRegion()
    jass.RegionAddRect(region, CameraContants.Rects.Map)
    trig = jass.CreateTrigger()
    jass.TriggerRegisterEnterRegion(trig, region, null)
    jass.TriggerAddAction(trig,function()
        local unit = jass.GetTriggerUnit()
        jass.TriggerRegisterUnitEvent(_pack.data["damage"], unit, jass.EVENT_UNIT_DAMAGED )
    end)
    jass.RemoveRegion(region)
    resetDamageTrigger()
    --每10分钟重置触发器
    jass.TimerStart(jass.CreateTimer(),60*10,true,function()
        resetDamageTrigger()
    end)

    --任意单位 准备释放技能
    trig = jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig,jass.Player(i),jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL,nil)
    end
    _pack.data["spell_channel"] = trig

    --任意单位 开始释放技能
    trig = jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig,jass.Player(i),jass.EVENT_PLAYER_UNIT_SPELL_CAST,nil)
    end
    _pack.data["spell"] = trig

    --任意单位 停止释放技能
    trig = jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig,jass.Player(i),jass.EVENT_PLAYER_UNIT_SPELL_ENDCAST,nil)
    end
    _pack.data["spell_stop"] = trig

    --发动技能效果EVENT_PLAYER_UNIT_SPELL_EFFECT

    --释放技能结束 EVENT_PLAYER_UNIT_SPELL_FINISH

    --任意单位被攻击
    trig =jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_ATTACKED, nil)
    end
    _pack.data["attack"] = trig

    --任意单位死亡
    trig =jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_DEATH, nil)
    end
    _pack.data["death"] = trig

    --任意单位丢弃物品
    trig =jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_DROP_ITEM, nil)
    end
    _pack.data["unit_abandon"] = trig

    --任意单位使用物品
    trig =jass.CreateTrigger()
    for i=0,14,1 do
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_USE_ITEM, nil)
    end
    _pack.data["unit_use"] = trig

    --捕捉命令id 本地任意单位
    trig =jass.CreateTrigger()
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil)
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, nil)
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_UNIT_ISSUED_ORDER, nil)
    _pack.data["local_order"] = trig
end

return _pack
