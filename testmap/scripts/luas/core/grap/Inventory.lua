local KeyConstants= require "scripts.luas.constants.Keyborad"
local Id = require 'scripts.luas.utils.id.Id'
local Context = require 'scripts.luas.core.applic.Context'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
local Items = require 'scripts.luas.core.entity.Items'


-- 物品栏
local _pack = {
    data = {
        index = 0, --当前物品栏序号
    }
}

-- 将保存的item添加给单位
-- @param index number 第几个物品栏
function _pack.UnitAddItem(index)
    local unit = Context.get("GamerLocal").data.role.data.unit
    local offset = index * 6 

    for i=1,6,1 do
        -- 先移出
        local item = jass.UnitRemoveItemFromSlot(unit, i-1)
        jass.SetItemPosition(item,580,2480)

        --移入
        item = Items.data.invt[i+offset]
        if(item) then
            jass.UnitAddItem(unit, item)
            jass.IssueTargetOrderById( unit, 852001+i, item ) --移动到正确的位置
        end
    end
end

-- 重新设定 backpack_items 物品栏变量
-- @param flag boolean 是否同步
function _pack.reset()
    local unit = Context.get("GamerLocal").data.role.data.unit
    local offset = _pack.data.index * 6

    for i =1,6,1 do 
        local item = jass.UnitItemInSlot(unit,i-1)
        if (item) then
            Items.data.invt[i+offset] = item
        else
            Items.data.invt[i+offset] = nil
        end
    end
end

-- 切换物品栏
function _pack.switch()
    local selection = jmessage.selection()
    local unit = Context.get("GamerLocal").data.role.data.unit

    if (unit ~= selection) then
        return
    end 
    
    Trigger.pause("unit_abandon")
    _pack.reset()-- 记录切换前的物品(重新赋值)

    if(_pack.data.index == 1) then
        _pack.data.index = 0
        _pack.UnitAddItem(0)
    else
        _pack.data.index = 1
        _pack.UnitAddItem(1)
    end

    Trigger.continue("unit_abandon")
    Items.resetUnitSlot()   --同步1

    Interface.GUI.update_invt(unit)

    --计算新的属性
    -- 同步2
end

--@init start
function _pack.init()

    --按键D
    dzapi.RegisterKeyEvent(jmessage.keyboard.D,1,_pack.switch) 
end

return _pack
