local Context = require 'scripts.luas.core.applic.Context'
local Console= require 'scripts.luas.utils.envir.Console'
local Object = require 'scripts.luas.utils.object.ObjectUtils'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
local Id = require 'scripts.luas.utils.id.Id'
local UUID = require 'scripts.luas.utils.id.UUID'
local Inventory = require "scripts.luas.core.grap.Inventory"
local Items = require 'scripts.luas.core.entity.Items'
local Request = require 'scripts.luas.po.Request'
local Scoket = require 'scripts.luas.core.scoket.Scoket'
local ItemGameTypeContants = require 'scripts.luas.constants.ItemGameType'

local _pack = {
    data = {
        backp = {},

        backpDrop = {}, 
        backpCell = {},
        backpText = {},
        backpBtn  = {},
        
        backpAbandonDialog = {},
        backpSeparateDialog = {},
        backpSeparateTimer = jass.CreateTimer(),

        isOpen = false,
        isEnable = true,

        allowUseCheckFlag = true,
        allowTimer = jass.CreateTimer(),
        
        separate = {
            index = 0,
            item = nil,
            num = 0,
            max = 0,

            dialogs = {},
            timer = jass.CreateTimer(),

        },

        abandon = {
            index = 0,
            item = nil,

            dialogs = {}
        },
        
        grabup = {
            isGrabup = false,
            index = 0,
            item = nil,
            from = 0,  --来自  0背包 1物品栏
        },

        invtFrames = {},

    }

}

local function getCellIndeByFrame(frame)
    for k,v in pairs (_pack.data.backpBtn) do
        if (v==frame)  then
            return k
        end
    end
end

local function getInvtIndeByFrame(frame)
    for k,v in pairs (_pack.data.invtFrames) do
        if (v == frame) then
            return k
        end
    end
end

function _pack.toggle()
    if (not _pack.data.isEnable) then return end

    if (_pack.data.isOpen) then
        _pack.close()
    else
        _pack.open()
    end
end

function _pack.close()
    if (not _pack.data.isEnable) then return end
    dzapi.FrameSetPoint(_pack.data.backp[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",1,1);
    dzapi.FrameShow(_pack.data.backp[1],false);
    _pack.data.isOpen = false;
end

function _pack.open()
    if (not _pack.data.isEnable) then return end
    dzapi.FrameSetPoint(_pack.data.backp[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",0.2,0.07);
    dzapi.FrameShow(_pack.data.backp[1],true);
    _pack.data.isOpen = true;
end

function _pack.reset()
end

function _pack.update()
    for i=0,63,1 do
        local item = Items.data.backpack[i]

        if (item) then
            --@TEST不渲染抓取中的物品
            local slk = jslk.item[ Id.id2string(jass.GetItemTypeId(item)) ]

            if(slk) then
                --读取图标
                local icon = slk.Art
                dzapi.FrameSetTexture(_pack.data.backpDrop[i],icon,0);

                --读取数量
                -- local uses = tonumber(slk.uses)
                local charges = jass.GetItemCharges(item)

                if (charges >=1) then
                    dzapi.FrameSetText(_pack.data.backpText[i],tostring(charges));
                else
                    dzapi.FrameSetText(_pack.data.backpText[i],"");
                end
            else
                print("error:","","读取slk出错",i,jass.GetItemName(item))
            end
        else
            dzapi.FrameSetTexture(_pack.data.backpDrop[i],"img\\alpha.blp",0);
            dzapi.FrameSetText(_pack.data.backpText[i],"");
        end
    end

    --更新资源
    local gamer = Context.get("GamerLocal")
    local gold,lumber = gamer.getResource()

    dzapi.FrameSetText(_pack.data.backp[3],tostring(gold))
    dzapi.FrameSetText(_pack.data.backp[4],tostring(lumber))
end

function _pack.haveSpace()
    for i = 0,63,1 do
        local item = Items.data.backpack[i]
        if (item == nil) then
            return i
        end
    end
    return false
end

function _pack.cancelGrabup()
    print("backp","cancelGrabup","取消抓取状态")
    
    if (_pack.data.grabup.isGrabup) then

        if (_pack.data.grabup.from ==1) then
            --物品栏抓取状态
            bj.appendExecute(function()
                Trigger.pause("unit_abandon")
                -- local item = jass.UnitRemoveItemFromSlot(unit,_pack.data.grabup.index)
                local unit = Context.get("GamerLocal").data.role.data.unit
                jass.SetItemPosition(_pack.data.grabup.item,580,2480)
                jass.UnitAddItem(unit,_pack.data.grabup.item)
                jass.IssueTargetOrderById( unit, 852002+_pack.data.grabup.index, _pack.data.grabup.item); --移动到正确的位置
                Trigger.continue("unit_abandon")

                _pack.data.grabup = {
                    isGrabup = false,
                    index = 0,
                    item = nil,
                    from = 0, 
                }
            end)
        else
            Interface.Mouse.normal()
            _pack.data.grabup = {
                isGrabup = false,
                index = 0,
                item = nil,
                from = 0, 
            }
        end
    end
end

function _pack.addItem(item)
    return Object.orElse( _pack.haveSpace(),
        function(index)
            --保存到current表
            local itemHandleId = jass.GetHandleId(item)
            Items.data.current[itemHandleId] = Items.data.common[itemHandleId] 
            Items.data.common[itemHandleId] = nil

            --保存到背包
            Items.data.backpack[index] = item
            _pack.update()
            jass.StartSound(jglobals.gg_snd_MouseClick1)

            Console.system(('获取物品"$name"')
                :gsub("$name",jass.GetItemName(item) or "?")
            );
            return true
        end,
        function()
            jass.StartSound(jglobals.gg_snd_Error)
            Console.system('背包已满,获取物品失败');
            return false
        end)
end

local function showSeparateDialog()
    _pack.data.isEnable = false;

    --重置滑轴
    dzapi.FrameSetText(_pack.data.separate.dialogs[1],tostring(_pack.data.separate.max));
    dzapi.FrameSetValue(_pack.data.separate.dialogs[2],1);

    jass.TimerStart(_pack.data.separate.timer,0.1,true,function()
        local step = dzapi.FrameGetValue(_pack.data.separate.dialogs[2]);
        local currentNum  = math.floor(_pack.data.separate.max *step);
        
        --防止溢出
        if (currentNum> _pack.data.separate.max) then
            _pack.data.separate.num = _pack.data.separate.max;
        elseif (currentNum<1) then
            _pack.data.separate.num = 1
        else
            _pack.data.separate.num = currentNum
        end
        
        --设置text
        dzapi.FrameSetText(_pack.data.separate.dialogs[1],tostring(_pack.data.separate.num));
    end);

    dzapi.FrameShow(_pack.data.separate.dialogs[0],true);
end

function _pack.closeSeparateDialog()
    _pack.data.isEnable = true;
    jass.PauseTimer(_pack.data.separate.timer);
    _pack.data.separate.index = -1
    _pack.data.separate.item = nil
    dzapi.FrameShow(_pack.data.separate.dialogs[0],false);
end

local function showAbandonDialog()
    _pack.data.isEnable = false;
    dzapi.FrameShow(_pack.data.abandon.dialogs[0],true);
end

function _pack.closeAbandonDialog()
    jass.StartSound(jglobals.gg_snd_MouseClick1)
    _pack.data.isEnable = true;
    _pack.data.abandon.index = -1
    _pack.data.abandon.item = nil
    dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
end

-- 交换物品 调用switch前不能清除grabup表
-- @param index  目标index
-- @param itype  目标类型   0背包 1物品栏
-- 抓取信息 在_pack.data.grabup
local function switch(targetIndex,itype)
    local grabupItem = _pack.data.grabup.item 
    local grabupIndex = _pack.data.grabup.index
    local from = _pack.data.grabup.from

    --背包之间交换
    if (itype == 0 and from ==0) then
        _pack.cancelGrabup()

        --原地交换
        if (targetIndex == grabupIndex) then
            print("switch","from背包","to背包","原地交换")
            return   
         end

        local targetItem = Items.data.backpack[targetIndex]

        -- targetItem为空
        if (targetItem == nil) then
            Items.data.backpack[grabupIndex] = nil
            Items.data.backpack[targetIndex] = grabupItem
            _pack.update()

            print("switch","from背包","to背包","空交换")
            return
        end

        --是否可叠加
        local targetItemTypeId = jass.GetItemTypeId(targetItem)
        local grabupItemTypeId = jass.GetItemTypeId(grabupItem)
        
        if (targetItemTypeId == grabupItemTypeId) then
            if (Items.getItemGameBaseType(targetItem) >=30) then
                local uses = tonumber(jslk.item[Id.id2string(targetItemTypeId)].uses)
                local targetItemCharges = jass.GetItemCharges(targetItem)
                local grabupItemCharges = jass.GetItemCharges(grabupItem)

                if (targetItemCharges + grabupItemCharges> uses) then
                    --@goto: 直接交换

                else  
                    --targetItemCharges + grabupItemCharges<= uses   可叠加
                    jass.SetItemCharges(targetItem,targetItemCharges+grabupItemCharges) --设置target新的次数
                    Items.remove(grabupItem,true) --同步删除grabup

                    --背包删除grabup
                    Items.data.backpack[grabupIndex] = nil
                    _pack.update()

                    print("switch","from背包","to背包","叠加")
                    return
                end
            end
        end

        --直接交换
        Items.data.backpack[grabupIndex] = targetItem
        Items.data.backpack[targetIndex] = grabupItem
        _pack.update()
        print("switch","from背包","to背包","交换")
        return
    end

    --from物品栏 to背包
    if (itype ==0 and from ==1) then
        local unit = Context.get("GamerLocal").data.role.data.unit
        local targetItem = Items.data.backpack[targetIndex]

        print("from物品栏 to背包 1111",targetItem)

        Trigger.pause("unit_abandon")
        jass.SetItemPosition(grabupItem,580,2480) --先移走 防止玩家其他操作
        print("from物品栏 to背包 2222",grabupItem)
        Trigger.continue("unit_abandon")

        Items.data.backpack[targetIndex] = grabupItem --背包设置grabup
        _pack.update()
        Interface.GUI.update_invt(unit)
        -- _pack.cancelGrabup()
        _pack.data.grabup = {
            isGrabup = false,
            index = 0,
            item = nil,
            from = 0, 
        }

        if (targetItem ~= nil) then
            print("from物品栏 to背包 333",targetItem)

            --背包的物品 移动到 物品栏
            local unit = Context.get("GamerLocal").data.role.data.unit
            jass.UnitAddItem(unit,targetItem)
            jass.IssueTargetOrderById( unit, 852002+grabupIndex, targetItem); --移动到正确的位置
        end

        --同步玩家物品
        --Items.resetUnitSlot()
        return
    end

    --from背包 to物品栏
    if(itype ==1 and from ==0) then
        local unit = Context.get("GamerLocal").data.role.data.unit
        local targetItem = jass.UnitItemInSlot(unit,targetIndex)

        print("from背包","to物品栏","交换物品",grabupItem,targetItem)

        if (targetItem ~= nil) then
            Trigger.pause("unit_abandon")
            jass.SetItemPosition(targetItem,580,2480)
            Trigger.continue("unit_abandon")
        end
        
        Items.data.backpack[grabupIndex] = targetItem
        _pack.update()
        Interface.GUI.update_invt(unit)
        _pack.cancelGrabup()

        --直接添加会导致： 左键使用物品 右键拿起物品
        jass.TimerStart(bj.data.commonTimer,0.3,false,function()
            jass.UnitAddItem(unit,grabupItem)
            jass.IssueTargetOrderById( unit, 852002+targetIndex, grabupItem); --移动到正确的位置

            --同步玩家物品
            --Items.resetUnitSlot()
        end)

        -- bj.appendExecute(function()
        -- end)
        return
    end
end

-- 分离物品 生效
function _pack.separate()
    local item = _pack.data.separate.item

    if (_pack.data.separate.num == _pack.data.separate.max) then
        _pack.closeSeparateDialog()
        return
    end

    local newCharges = _pack.data.separate.num
    local oldCharges = _pack.data.separate.max - newCharges

    jass.SetItemCharges(item,oldCharges)
    _pack.closeSeparateDialog()

    Items.copyItem(item,newCharges,function(newItem)
        print("separate scoket callback",newItem)
        local newItemHandlId = jass.GetHandleId(newItem)
        local newIndex = _pack.haveSpace()

        --添加到current 删除common
        Items.data.current[newItemHandlId] = Items.data.common[newItemHandlId]
        Items.data.common[newItemHandlId] = nil

        --添加到背包
        Items.data.backpack[newIndex] = newItem   
        _pack.update()
    end)
end

-- 分离物品 判断
local function separateCheck(index)
    local item = Items.data.backpack[index]
    local currentCharges = jass.GetItemCharges(item)
    
    --是否可分离
    if(currentCharges <=1) then
       return
    end

    --是否有空位
    if(not _pack.haveSpace()) then
        Console.system("不可分离物品,背包已满!")
        return
    end

    _pack.data.separate.index = index
    _pack.data.separate.item = item
    _pack.data.separate.num = currentCharges
    _pack.data.separate.max = currentCharges

    showSeparateDialog()
end

-- 丢弃物品 生效
function _pack.abandon()
    if (_pack.data.abandon.from == 0) then
        jass.StartSound(jglobals.gg_snd_MouseClick1)
        --背包移除物品
        Items.data.backpack[_pack.data.abandon.index] = nil
        _pack.update()
    else
        --先移走 防止玩家其他操作
        --此时物品已经在地上了
        jass.SetItemPosition(_pack.data.abandon.item,580,2480) 
    end

    --同步物品删除
    Items.remove(_pack.data.abandon.item,true)
    _pack.closeAbandonDialog()
end

-- 丢弃物品 取消
function _pack.deabandon()
    if (_pack.data.abandon.from == 0) then
        --背包取消移出 
        --不用动
    else
        --物品栏取消移出
        --同步 把物品重新添加给单位 
        Items.addToUnit(nil,_pack.data.abandon.item,_pack.data.abandon.index,true)
    end
    _pack.closeAbandonDialog()
end

-- 丢弃物品 判断
--@param from 0背包 1物品栏
local function abandonCheck(index,item,from) 
    local level= jass.GetItemLevel(item)

    if (level <3) then
        --丢弃物品
        jass.StartSound(jglobals.gg_snd_MouseClick1);

        if (from == 0) then
            --背包移除物品
            Items.data.backpack[index] = nil
            _pack.update()
        else
           --物品栏移出物品
           --此时物品已经在 (580,2480)了 
        end

        --同步物品坐标
        local itemHid = jass.GetHandleId(item)
        local unit = Context.get("GamerLocal").data.role.data.unit

        Items.data.common[itemHid] = Items.data.current[itemHid] --移动到common表
        Items.data.current[itemHid] = nil

        Items.setPosition(item,{
            jass.GetUnitX(unit),
            jass.GetUnitY(unit)
        },true)
    else
        --询问是否摧毁
        _pack.data.abandon.item = item
        _pack.data.abandon.index = index
        _pack.data.abandon.from = from
        showAbandonDialog()
    end
end

-- 背包使用物品
-- @return number  1使用成功 2cd中
local function useItem(item,index)
    local gamer = Context.get("GamerLocal")
    local itemGameExType = Items.getItemGameExType(item)
    local isCd = true

    print("useItem","itemGameExType",itemGameExType)

    if(itemGameExType == ItemGameTypeContants.EX_TYPE.C_LMDC)then --药水
        isCd = gamer.getCd(ItemGameTypeContants.EX_TYPE.C_LMDC)

    elseif (itemGameExType == ItemGameTypeContants.EX_TYPE.C_DOSE) then --药剂
        isCd = true

    elseif (itemGameExType == ItemGameTypeContants.EX_TYPE.C_DAY) then --每日
        isCd = gamer.getCd(ItemGameTypeContants.EX_TYPE.C_DAY)

    elseif (itemGameExType == ItemGameTypeContants.EX_TYPE.C_WEEK) then --每周
        isCd = gamer.getCd(ItemGameTypeContants.EX_TYPE.C_WEEK)

    elseif (itemGameExType == ItemGameTypeContants.EX_TYPE.C_ONE) then --每局
        isCd = gamer.getCd(ItemGameTypeContants.EX_TYPE.C_ONE)
    
    else
        print("useItem","未知的使用类型")
    end
    
    if (isCd) then
        --cd提示 同步提示
        print("useItem","cd中")
    else
        if(jass.GetItemCharges(item) -1 <=0)then
            --如果使用后物品消失，背包中先删除物品  真正删除物品在同步后
            local itemHid = jass.GetHandleId(item)
            Items.data.backpack[index] = nil --背包中删除物品
            _pack.update()
            Items.data.common[itemHid] = Items.data.current[itemHid] --移动到common表中 方便后续删除
            Items.data.current[itemHid] = nil
        end

        --同步后续操作
        Items.use(item,0,true) --true 异步转同步
    end
end

-- 背包使用物品 判断
-- 装备或宝石 - 打开强化面板(强化 镶嵌)
-- 消耗品 - 同步使用
local function useItemCheck(item,index)
    --判断延迟
    if (not _pack.data.allowUseCheckFlag)then
        return;
    else
        _pack.data.allowUseCheckFlag = false
        jass.TimerStart(_pack.data.allowTimer,0.3,false,function()
            _pack.data.allowUseCheckFlag = true
        end)
    end

    local itemGameBaseType = Items.getItemGameBaseType(item)

    --镶嵌页面
    if (itemGameBaseType == ItemGameTypeContants.BASE_TYPE.EQUIP
        or itemGameBaseType == ItemGameTypeContants.BASE_TYPE.EQUIP_USABLE
        or itemGameBaseType == ItemGameTypeContants.BASE_TYPE.INGEM) then

        print("打开强化面板");
        return
    end
    
    --消耗品
    if(itemGameBaseType == ItemGameTypeContants.BASE_TYPE.CONSUM) then
        print("useItemCheck","使用物品");

        useItem(item)
        return
    end
end

function _pack.backpItemOver(frame)
    local index = getCellIndeByFrame(frame)
    local item = Items.data.backpack[index]

    if (item ~= nil) then
        Interface.GUI.showTip(4,0,item) --4物品
    end
end

function _pack.backpItemLeft(frame)
    if ( Interface.Bank.bankGrabup().isGrabup ) then
        Interface.Bank.cancelGrabup()
        return
    end

    if (not _pack.data.isEnable) then
        return
    end

    local index = getCellIndeByFrame(frame)
    local item = Items.data.backpack[index]

    -- 如果是grabup 则放下物品
    if (_pack.data.grabup.isGrabup) then
        jass.StartSound(jglobals.gg_snd_MouseClick1);

        -- if (Interface.Mouse) then
        --     Interface.Mouse.normal()
        -- end

        print("交换物品")
        switch(index,0)
        return
    end

    if (item == nil) then
        return
    end

    -- 如果按下alt键 弹出分离界面
    if (Context.get("key_alt"))then
        jass.StartSound(jglobals.gg_snd_MouseClick1);
        separateCheck(index)
        return
    end

    --使用物品判断
    useItemCheck(item,index)
end

function _pack.backpItemRight(frame)
    if ( Interface.Bank.bankGrabup().isGrabup ) then
        Interface.Bank.cancelGrabup()
        return
    end

    if (not _pack.data.isEnable) then
        print("isEnable return ")
        return
    end

    local index = getCellIndeByFrame(frame)
    local item = Items.data.backpack[index]

    -- 如果是grabup 则放下物品
    if (_pack.data.grabup.isGrabup) then
        jass.StartSound(jglobals.gg_snd_MouseClick1);

        -- if (Interface.Mouse) then
        --     Interface.Mouse.normal()
        -- end

        print("交换物品")
        switch(index,0)
        return
    end

    if (item == nil) then
        return
    end

    -- 如果按下alt键 弹出分离界面
    if (Context.get("key_alt"))then
        jass.StartSound(jglobals.gg_snd_MouseClick1);
        separateCheck(index)
        return
    end

    --抓取物品
    jass.StartSound(jglobals.gg_snd_MouseClick1);
    _pack.data.grabup = {
        isGrabup = true,
        index = index,
        item = item,
        from = 0,
    }
    
    if (Interface.Mouse)then
        local path = jslk.item[Id.id2string(jass.GetItemTypeId(item))].Art
        Interface.Mouse.grabup(path)
    end

    print("抓取物品 背包")
end

function _pack.backpInvtOver(frame)
    local index = getInvtIndeByFrame(frame)
    local unit = jmessage.selection()
    local item = jass.UnitItemInSlot(unit,index)
    if(item ~= nil) then
        Interface.GUI.showTip(4,1,item) --4物品
    end
end

function _pack.backpInvtLeft(frame)
    if ( Interface.Bank.bankGrabup().isGrabup ) then
        Interface.Bank.cancelGrabup()
    end

    if (not _pack.data.isEnable) then
        return
    end
    
    local unit = jmessage.selection()
    local role = Context.get("GamerLocal").data.role.data.unit

    if (unit ~= role) then
        --当前选择单位不是角色时
        if(_pack.data.grabup.isGrabup) then
            print("不是本地角色 取消抓取")
            _pack.cancelGrabup()
        end
        return
    end

    local index = getInvtIndeByFrame(frame);

    if(_pack.data.grabup.isGrabup and _pack.data.grabup.from ==1)then
        print("from物品栏","to物品栏")
        -- _pack.cancelGrabup()

        _pack.data.grabup = {
            isGrabup = false,
            index = 0,
            item = nil,
            from = 0, 
        }
        return
    end

    if (_pack.data.grabup.isGrabup and _pack.data.grabup.from ==0)then
        --判断交换物品
        print("判断交换物品")
        jass.StartSound(jglobals.gg_snd_MouseClick1)
        switch(index,1)
        return
    end

    if(not _pack.data.grabup.isGrabup)then
        print("物品栏 使用物品")
    end

end

function _pack.backpInvtRight(frame)
    if ( Interface.Bank.bankGrabup().isGrabup ) then
        Interface.Bank.cancelGrabup()
    end

    if (not _pack.data.isEnable) then
        return
    end

    local unit = jmessage.selection()
    local role = Context.get("GamerLocal").data.role.data.unit
    local index = getInvtIndeByFrame(frame);

    if (unit ~= role) then
        --当前选择单位不是角色时
        if(_pack.data.grabup.isGrabup) then
            print("不是本地角色 取消抓取")
            _pack.cancelGrabup()
        end
        return
    end

    if(_pack.data.grabup.isGrabup and _pack.data.grabup.from ==1)then
        print("from物品栏","to物品栏","交换")
        _pack.cancelGrabup()
        return
    end

    if (_pack.data.grabup.isGrabup and _pack.data.grabup.from ==0)then
        --判断交换物品
        print("判断交换物品")
        jass.StartSound(jglobals.gg_snd_MouseClick1)
        switch(index,1)
        return
    end

    local item = jass.UnitItemInSlot(role,index)
    if (item == nil) then
        print("没有物品",index)
    else
        --进入抓取状态
        print("抓取物品 物品栏")
        _pack.data.grabup = {
            isGrabup = true,
            index = index,
            item = item,
            from = 1,
        }
    end
end

function _pack.setResource(gold,lumber)
    if (gold)then
        dzapi.FrameSetText(BackpControl.data.backp[3],tostring(gold));
    end

    if (lumber)then
        dzapi.FrameSetText(BackpControl.data.backp[4],tostring(lumber));
    end
end

function _pack.backpMouseLeft()
    if (not _pack.data.isEnable) then
        return
    end

    -- 如果是背包grabup 判断丢弃物品
    if (_pack.data.grabup.isGrabup and _pack.data.grabup.from ==0) then
        local index = _pack.data.grabup.index
        local item = _pack.data.grabup.item
        _pack.cancelGrabup()
        abandonCheck(index,item,0)
        return
    end

    --如果是物品栏grabup
    --仅取消grabup状态  丢弃判断推迟到触发单位丢弃物品事件
    if (_pack.data.grabup.isGrabup and _pack.data.grabup.from ==1)then
        _pack.cancelGrabup()
        return
    end
end

function _pack.backpMouseRight()
    if (_pack.data.grabup.isGrabup)then
        _pack.cancelGrabup()
    end
end

--@init Backpack
function _pack.init()
    -- 英雄满格拾取
    -- 同步触发 准备释放技能
    Trigger.registerEvent("spell_channel",function()
        if (not jass.GetSpellAbilityId() == Id.string2id("A000")) then 
            return
        end

        local unit = jass.GetTriggerUnit()
        local item = jass.GetSpellTargetItem()

        if (not item) then return end

        local posi = {
            jass.GetItemX(item),
            jass.GetItemY(item)
        }

        jass.SetItemPosition(item,580,2480) --移动到物品区域
       
        bj.appendExecute(function()
            jass.UnitRemoveAbility(unit,'A000' )
            jass.UnitAddAbility(unit,'A000' )
        end)

        -- 异步处理
        if (jass.GetLocalPlayer() == jass.GetOwningPlayer(unit) ) then
            if (not _pack.addItem(item))then
                --拾取失败 还原位置
                Items.setPosition(item,posi,true) --转同步
            end
        end
    end);

    --从物品栏丢弃物品
    --添加给单位 不允许丢弃
    Trigger.registerEvent("unit_abandon",function()
        print("触发丢弃物品")

        local item = jass.GetManipulatedItem()
        local unit = jass.GetTriggerUnit()
        local index = bj.GetInventoryIndexOfItem(unit,item) --获取丢弃时在物品栏的位置
        
        --使用后消失的物品也会触发事件
        --可以获取到handle name charges等信息
        local ItemGameType = Items.getItemGameBaseType(item)
        if (ItemGameType >=30 and jass.GetItemCharges(item) <=0) then
           return
        end

        --丢弃判断
        bj.appendExecute(function()
            Interface.GUI.update_invt(unit)
            jass.SetItemPosition(item,580,2480) -- 先移走 防止其他玩家操作

            --本地玩家判断丢弃还是删除
            -- 如果是丢弃 用同步移动位置
            -- 如果是删除 同步删除物品
            if (jass.GetLocalPlayer() == jass.GetOwningPlayer(unit)) then
                abandonCheck(index,item,1) --from 1物品栏
            end
        end)

        --禁止丢弃物品
        -- bj.appendExecute(function()
        --     jass.UnitAddItem(unit,item)
        --     jass.IssueTargetOrderById( unit, 852002+index, item); --移动到正确的位置
        -- end)
    end)

    --物品栏使用物品
    -- 同步触发
    -- Trigger.registerEvent("unit_use",function()
    --     print("触发使用物品")
    --     local item = jass.GetManipulatedItem()
    --     local unit = jass.GetTriggerUnit()

    -- end)

    --物品栏内交换物品 更新图标
    Trigger.registerEvent("local_order",function()
        local id = jass.GetIssuedOrderId()
        local unit = jass.GetTriggerUnit()

        if (id >=852002 and id <=852007) then
            bj.appendExecute(function()
                Interface.GUI.update_invt(unit)
            end)
            return 
        end
    end)

    --@Interface
    Interface.Backpack = {}
    
    Interface.Backpack.show   = _pack.show
    Interface.Backpack.close  = _pack.close
    Interface.Backpack.toggle = _pack.toggle
    Interface.Backpack.reset  = _pack.reset
    Interface.Backpack.setResource = _pack.setResource
end

return _pack
