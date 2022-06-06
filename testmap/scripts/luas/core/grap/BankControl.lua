local Items = require 'scripts.luas.core.entity.Items'
local Id = require 'scripts.luas.utils.id.Id'
local Context = require 'scripts.luas.core.applic.Context'
local Console= require 'scripts.luas.utils.envir.Console'
local BackpControl = require 'scripts.luas.core.grap.BackpControl'
local Object =require 'scripts.luas.utils.object.ObjectUtils'


local _pack = {
    data = {
        drop = {},
        btn = {},
        bankCell = {},
        bankDrop = {},
        bankBtn = {},
        bankText = {},
        bankCd = {},

        isEnable = true,
        isOpen = false,
        isSkinOpen = false,

        bankGrabup = {
            isGrabup = false,
            index = 0,
            item = nil, 
        },

        separate ={
            index = 0,
            item = nil,
            num = 0,
            max = 0,
            
            dialogs={},
            timer = jass.CreateTimer(),
        },

        addItem = {
            index = 0,   --点击的银行格子index
            item = nil,  --背包grab的物品 要存入的物品
            dialogs = {},
        },

        abandon = {
            index = 0,
            item = nil,

            dialogs={},
        },
    }
}

local function getCellIndeByFrame(frame)
    for k,v in pairs (_pack.data.bankBtn) do
        if (v==frame)  then
            return k
        end
    end
end

function _pack.itemInBank(item)
    for _,v in pairs (Items.data.bank)do
        if (v == item) then
            return true
        end
    end
end

function _pack.itemInLastbank(item)
    for _,v in pairs (Items.data.last_bank)do
        if (v == item) then
            return true
        end
    end
end

function _pack.update()
    local gamer = Context.get("GamerLocal")

    for i=0,43,1 do
        local item = Items.data.bank[i]
        if (item) then
             --@TEST不渲染抓取中的物品

            if (i<=39) then
                local slk = jslk.item[ Id.id2string(jass.GetItemTypeId(item)) ]
                --读取图标
                local icon = slk.Art
                dzapi.FrameSetTexture(_pack.data.bankDrop[i],icon,0);

                --读取数量
                -- local uses = tonumber(slk.uses)
                local charges = jass.GetItemCharges(item)
                if (charges >=1) then
                    dzapi.FrameSetText(_pack.data.bankText[i],tostring(charges));
                else
                    dzapi.FrameSetText(_pack.data.bankText[i],"");
                end
                

                --读取cd
                if(i>=24 and i<=39 )then
                    local itemExType = Items.getItemGameExType(item)
                    if (gamer.getCd(itemExType)) then
                         
                    else
                         
                    end
                end
            else
                --天赋  item为abilityId
                local slk = jslk.ability[ Id.id2string(item) ]
                --读取图标
                local icon = slk.Art
                dzapi.FrameSetTexture(_pack.data.bankDrop[i],icon,0);
                dzapi.FrameSetText(_pack.data.bankText[i],"");
            end
        else
            dzapi.FrameSetTexture(_pack.data.bankDrop[i],"img\\alpha.blp",0);
            dzapi.FrameSetText(_pack.data.bankText[i],"");
        end
    end
end

function _pack.open()
    if (not _pack.data.isEnable) then return end

    Interface.Shop.close()
    BackpControl.open()

    _pack.update()
    dzapi.FrameSetPoint( _pack.data.drop[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",-0.25,0.07);
    dzapi.FrameShow(_pack.data.drop[1],true);
    
    _pack.data.isOpen = true
end

function _pack.close()
    if (not _pack.data.isEnable) then return end

    BackpControl.close()
    BackpControl.cancelGrabup()

    dzapi.FrameSetPoint( _pack.data.drop[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",1,1);
    dzapi.FrameShow(_pack.data.drop[1],false);

    --关闭弹出框
    dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    _pack.cancelGrabup()

    _pack.data.isOpen = false
end

function _pack.toggle()
    if (not _pack.data.isEnable) then return end

    if (_pack.data.isOpen) then
        _pack.close()
    else
        _pack.open()
    end
end

function _pack.btnSkin()
    if (not _pack.data.isEnable) then return end

    print("bank btnSkin")
    
    if (_pack.isSkinOpen) then

    else

    end
end

function _pack.btnSave()
    _pack.showSaveDialog()
end

function _pack.btnRollback()
    _pack.showRollbackDialog()
end

-- 确认保存
local function tosave()
    Object.iterator(Items.data.last_bank,0,23).some(function(element,index)
        --检查last_bank中的物品bank是否存在  如果不存在则删除
        Object.ofNullable(element,function(element)
            if (not  _pack.itemInBank(element)) then
                --删除物品
                Items.remove(element,true)
            end
        end)

        --把bank复制给last_bank
        Items.data.last_bank[index] = Items.data.bank[index] 

         --赋值后如果非空 更新charges
        Object.ofNullable(Items.data.last_bank[index],function(item)
            Object.orElse(Items.data.common[jass.GetHandleId(item)][2],function(bind)
                bind.charges = jass.GetItemCharges(item)
            end,function()
                bind = {
                    charges = jass.GetItemCharges(item)
                }
            end)
        end)
    end)

    -- 调用存档接口@TODO
    -- Interface.Save.saveBank()
end

function _pack.showSaveDialog()
    _pack.data.isEnable = false;

    -- local warnMsg = Interface.Save.getBeforeSaveBankMessage() --@TOD
    local warnMsg = "确定要覆盖已保存的存档？"

    dzapi.FrameSetText(_pack.data.abandon.dialogs[3],warnMsg)
    dzapi.RegisterFrameEvent( _pack.data.abandon.dialogs[1],nil,nil,function()
        tosave()

        _pack.data.isEnable = true;
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false)
    end)
    dzapi.RegisterFrameEvent(_pack.data.abandon.dialogs[2],nil,nil,function()
        _pack.data.isEnable = true;
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    end)

    dzapi.FrameShow(_pack.data.abandon.dialogs[0],true);
end

-- 确认还原
local function rollback()
    Object.iterator(Items.data.bank,0,23).some(function(element,index)
        --检查bank中的物品last_bank是否存在  如果不存在则删除
        Object.ofNullable(element,function(element)
            if (not  _pack.itemInLastbank(element)) then
                --删除物品
                Items.remove(element,true)
            end
        end)

        --把last_bank复制给bank
        Items.data.bank[index] = Items.data.last_bank[index] 

         --赋值后如果非空 更新charges
        Object.ofNullable(Items.data.last_bank[index],function(item)
            print("rollback",item,Items.data.common[jass.GetHandleId(item)],Items.data.common[jass.GetHandleId(item)][2])
            local charges = Items.data.common[jass.GetHandleId(item)][2].charges
            jass.SetItemCharges(item,charges)
        end)
    end)

    _pack.update()
end

function _pack.showRollbackDialog()
    _pack.data.isEnable = false;

    dzapi.FrameSetText(_pack.data.abandon.dialogs[3],"确定要还原到上次保存状态吗？")
    dzapi.RegisterFrameEvent(_pack.data.abandon.dialogs[1],nil,nil,function()
        rollback()

        _pack.data.isEnable = true;
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false)
    end)
    dzapi.RegisterFrameEvent(_pack.data.abandon.dialogs[2],nil,nil,function()
        _pack.data.isEnable = true;
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    end)

    dzapi.FrameShow(_pack.data.abandon.dialogs[0],true);
end

-- 抓取丢弃
local function abandon()
    Items.data.bank[_pack.data.abandon.index] = nil
    _pack.update()
    --如果last_bank有此物品不删除 
    if(not _pack.itemInLastbank(_pack.data.abandon.item )) then
        Items.remove(_pack.data.abandon.item,true)
    end
end

function _pack.showAbandonDialog()
    _pack.data.isEnable = false;

    dzapi.FrameSetText(_pack.data.abandon.dialogs[3],"确定要移除物品吗？")
    dzapi.RegisterFrameEvent( _pack.data.abandon.dialogs[1],nil,nil,function()
        --确定丢弃
        jass.StartSound(jglobals.gg_snd_MouseClick1)
        abandon()
        _pack.data.isEnable = true;
        _pack.data.abandon.index = -1
        _pack.data.abandon.item = nil
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    end)
    dzapi.RegisterFrameEvent(_pack.data.abandon.dialogs[2],nil,nil,function()
        --取消丢弃
        jass.StartSound(jglobals.gg_snd_MouseClick1)
        _pack.data.isEnable = true;
        _pack.data.abandon.index = -1
        _pack.data.abandon.item = nil
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    end)

    dzapi.FrameShow(_pack.data.abandon.dialogs[0],true);
end

local function addItemCheckEmpty()
    local grabItem = _pack.data.addItem.item
    local grabCharges = jass.GetItemCharges(grabItem)
    local grabId = jass.GetItemUserData(grabItem)
    local grabTypeId = jass.GetItemTypeId(grabItem)
    local grabBaseId = Items.getItemGameBaseType(grabItem)

    local flag = false

    if (grabBaseId >=30) then
        --是可叠加物品 判断是否存在
        Object.iterator(Items.data.bank,0,23).some(function(element,index)
            return Object.ofNullable(element,function(checkItem)
                if(grabTypeId== jass.GetItemTypeId(checkItem)) then
                    jass.StartSound(jglobals.gg_snd_Error)
                    Console.system("已存在相同种类的可叠加物品,只能放入更多叠加数量的物品来覆盖")
                    flag = true
                    return true
                end
            end)
        end)

    else
        --非叠加物品 检查bind.from
        Object.iterator(Items.data.bank,0,23).some(function(element,index)
            return Object.ofNullable(element,function(checkItem)
                local bind = Items.data.common[jass.GetHandleId(checkItem)][2]
                if (bind.from == grabId) then
                    jass.StartSound(jglobals.gg_snd_Error)
                    Console.system("该物品已在银行中,不可重复放入")
                    flag = true
                    return true
                end
            end)
        end)
    end

    if (flag) then return end

    --放入物品
    jass.StartSound(jglobals.gg_snd_MouseClick1);
    Items.copyItem(grabItem,grabCharges,function(newItem)
        Items.data.bank[_pack.data.addItem.index] = newItem
        _pack.update()
        
        --给银行物品打上标记
        Object.orElse(Items.data.common[jass.GetHandleId(newItem)][2],
            function(bind)
                bind.from = jass.GetItemUserData(grabItem)
            end,
            function()
                Items.data.common[jass.GetHandleId(newItem)][2] = {
                    from = jass.GetItemUserData(grabItem)
                }
            end);

        _pack.data.addItem.index = -1
        _pack.data.addItem.item = nil
    end)
end

local function addItemCheckNonempty()
    local grabItem = _pack.data.addItem.item
    local grabId = jass.GetItemUserData(grabItem)
    local grabTypeId = jass.GetItemTypeId(grabItem)
    local grabBaseId = Items.getItemGameBaseType(grabItem)

    local bankItem = Items.data.bank[_pack.data.addItem.index]
    local bankTypeId = jass.GetItemTypeId(bankItem)

    --是否可叠加物品 且类型相同
    if (grabBaseId >= 30 and grabTypeId== bankTypeId) then
        local grabCharges = jass.GetItemCharges(grabItem)
        local bankCharges = jass.GetItemCharges(bankItem)

        if (grabCharges > bankCharges) then
            --覆盖次数
            jass.StartSound(jglobals.gg_snd_MouseClick1)
            jass.SetItemCharges(bankItem,grabCharges)
            _pack.update()
            return 
        end
    end

    --其他情况检查是否存在物品
    local index = _pack.data.addItem.index
    addItemCheckEmpty()

    if (Items.data.bank[index] ~= bankItem) then
        --物品变了 说明保存成功
        --判断原来的物品是否需要删除
        if (not _pack.itemInLastbank(bankItem)) then
            Items.remove(bankItem,true)
        end
    end
end

local function addItemCheck(index,item)
    _pack.data.addItem.index = index
    _pack.data.addItem.item = item

    Object.orElse(Items.data.bank[_pack.data.addItem.index],
        _pack.showOverridDialog, --非空 判断是否覆盖
        addItemCheckEmpty     --空 判断是否重复
    )
end

function _pack.showOverridDialog()
    _pack.data.isEnable = false;

    dzapi.FrameSetText(_pack.data.abandon.dialogs[3],"确定要覆盖物品吗？")
    dzapi.RegisterFrameEvent(_pack.data.abandon.dialogs[1],nil,nil,function()
        addItemCheckNonempty()

        _pack.data.isEnable = true;
        _pack.data.addItem.index = 0
        _pack.data.addItem.item = nil
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    end)

    dzapi.RegisterFrameEvent(_pack.data.abandon.dialogs[2],nil,nil,function()
        _pack.data.isEnable = true;
        _pack.data.addItem.index = 0
        _pack.data.addItem.item = nil
        dzapi.FrameShow(_pack.data.abandon.dialogs[0],false);
    end)

    dzapi.FrameShow(_pack.data.abandon.dialogs[0],true);
end



function _pack.cancelGrabup()
    _pack.data.bankGrabup = {
        isGrabup = false
    }

    if (Interface.Mouse) then
        Interface.Mouse.normal()
    end
end

local function switchCheck(targetIndex)
    local temp = Items.data.bank[targetIndex]
    Items.data.bank[targetIndex] = _pack.data.bankGrabup.item
    Items.data.bank[_pack.data.bankGrabup.index] = temp
    jass.StartSound(jglobals.gg_snd_MouseClick1);
    _pack.cancelGrabup()
    _pack.update()
end

function _pack.bankMouseLeft()
    -- print("bank 左键")
    if(_pack.data.bankGrabup.isGrabup) then
        _pack.data.abandon.index = _pack.data.bankGrabup.index
        _pack.data.abandon.item = _pack.data.bankGrabup.item,
        _pack.cancelGrabup()
        _pack.showAbandonDialog()
    end
end

function _pack.bankMouseRight()
    -- print("bank 右键")
    if(_pack.data.bankGrabup.isGrabup) then
        _pack.cancelGrabup()
    end
end

function _pack.bankItemOver(frame)
    local index = getCellIndeByFrame(frame)
    local item = Items.data.bank[index]

    if(not item) then
        return
    end

    if (index <= 23) then
        Interface.GUI.showTip(4,4,item) --玩家物品 4银行
        
    elseif(index <= 39) then
        Interface.GUI.showTip(4,0,item) --商场物品 
    else
        Interface.GUI.showTip(2,0,item) --天赋
    end
end

function _pack.bankItemLeft(frame)
    local index = getCellIndeByFrame(frame)
    print("银行 bankItemLeft")

    --背包系统grabup (物品栏或背包都可以)
    if(BackpControl.data.grabup.isGrabup) then
        --判断添加物品
        addItemCheck(index,BackpControl.data.grabup.item)
        BackpControl.cancelGrabup()
        return
    end

    --银行grabup
    if (_pack.data.bankGrabup.isGrabup) then
        --判断交换物品
        switchCheck(index)
        return
    end
end
    
function _pack.bankItemRight(frame)
    print("银行 bankItemRight")
    local index = getCellIndeByFrame(frame)

    --背包grabup
    if(BackpControl.data.grabup.isGrabup) then
        --判断添加物品
        addItemCheck(index,BackpControl.data.grabup.item)
        BackpControl.cancelGrabup()
        return
    end

    --银行grabup
    if (_pack.data.bankGrabup.isGrabup) then
        --判断交换物品
        switchCheck(index)
        return
    end

    --抓取物品
    local item = Items.data.bank[index]
    if (item == nil) then
        print("银行-没有物品")
    else
        --进入抓取状态
        print("银行-抓取物品")
        jass.StartSound(jglobals.gg_snd_MouseClick1);
        _pack.data.bankGrabup = {
            isGrabup = true,
            index = index,
            item = item,
        }

        if (Interface.Mouse)then
            local path = jslk.item[Id.id2string(jass.GetItemTypeId(item))].Art
            Interface.Mouse.grabup(path)
        end
    end
end

--@init Bank
function _pack.init()
    --暴露接口
    Interface.Bank = {}
    Interface.Bank.show = _pack.show
    Interface.Bank.close = _pack.close
    Interface.Bank.toggle = _pack.toggle
    Interface.Bank.update = _pack.update
    Interface.Bank.cancelGrabup = _pack.cancelGrabup
    
    Interface.Bank.getStatus = function()
        return _pack.data.isOpen
    end
    
    Interface.Bank.bankGrabup = function()
        return _pack.data.bankGrabup
    end
end

return _pack
