local Items = require 'scripts.luas.core.entity.Items'
local Id = require 'scripts.luas.utils.id.Id'
local Context = require 'scripts.luas.core.applic.Context'
local Console= require 'scripts.luas.utils.envir.Console'
local BackpControl = require 'scripts.luas.core.grap.BackpControl'
local Object =require 'scripts.luas.utils.object.ObjectUtils'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'

--商店类
--[[
    register(unit,list,auto)

    list = {
        index 0~63 和格子位置一一对应
        [index] ={
            itemTypeId = string,      --用类别id string类型
            charges = number,         --物品数量  默认1
            random = true|false,  --购买后是否随机属性  用于装备随机属性 默认false
            alone  = true|false,  --每个玩家的数据独立  默认true
            cd = number,          --购买cd 默认0  每个玩家都是独立的
            inCd = false,         --是否在购买cd中
        } 
    }
]]

local _pack = {
    data = {
        drop = {},
        btn = {},
        shopCell = {},
        shopDrop = {},
        shopBtn = {},
        shopText = {},

        currentIndex = 0,

        isEnable = true,
        isOpen = false,

        separate ={
            index = 0,
            info = nil,
            num = 0,
            max = 0,

            dialogs={},
            timer = jass.CreateTimer(),
        },

        sell = {
            index = 0,
            item = nil,
            from = 0,

            num = 0,
            max = 0,
            dialogs={},
        },

        --保存商店列表
        shoper = {

        }
    }

}

local function getCellIndexByFrame(frame)
    for k,v in pairs (_pack.data.shopBtn) do
        if (v == frame) then
            return k
        end
    end
end

--根据鼠标指向的格子id获取物品信息
--自动查找商品表
local function getItemInfoByIndex(index)
    local t = _pack.data.shoper[_pack.data.currentIndex]
    return t.list[index]
end

function _pack.open()
    if (not _pack.data.isEnable) then return end

    Interface.Bank.close() --关闭银行面板
    BackpControl.open() --打开背包面板
    
    dzapi.FrameSetPoint( _pack.data.drop[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",-0.25,0.07);
    dzapi.FrameShow(_pack.data.drop[1],true);
    _pack.data.isOpen = true
end

function _pack.close()
    if (not _pack.data.isEnable) then return end

    BackpControl.close() --关闭背包面板
    BackpControl.cancelGrabup()

    dzapi.FrameSetPoint( _pack.data.drop[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",1,1);
    dzapi.FrameShow(_pack.data.drop[1],false);

    --关闭弹出框
    
    _pack.closeSellDialog()
    _pack.closeSeparateBuyDialog()
    -- _pack.closeSeparateSellDialog()
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

function _pack.update()
    local list = _pack.data.shoper[_pack.data.currentIndex].list

    Object.iterator(list,0,63).some(function(element,index)
        Object.orElse(element,
            function()
                if (element.charges <=0) then
                    dzapi.FrameSetTexture(_pack.data.shopDrop[index],"img\\alpha.blp",0)
                    dzapi.FrameSetText(_pack.data.shopText[index],"")
                else
                    local slk = jslk.item[element.itemTypeId]
                    local icon = slk.Art
                    dzapi.FrameSetTexture(_pack.data.shopDrop[index],icon,0)
                    if(element.charges >1) then
                        dzapi.FrameSetText(_pack.data.shopText[index],tostring(element.charges))
                    else
                        dzapi.FrameSetText(_pack.data.shopText[index],"")
                    end
                end
            end,
            function()
                dzapi.FrameSetTexture(_pack.data.shopDrop[index],"img\\alpha.blp",0)
                dzapi.FrameSetText(_pack.data.shopText[index],"")
            end);
    end)
end

function _pack.unitIsShoper(unit)
    for index,v in ipairs(_pack.data.shoper) do
        if (v.unit == unit) then
            return index
        end
    end
end

--注册商店单位
-- @param unit 点击单位后弹出
-- @param list 商品列表
-- @param autoReflush number 多少秒自动刷新
-- @return number 商店编号
function _pack.registerEvent(unit,list,autoReflush)
    return Object.ofNullable(unit,list,function(unit,list)
        local index= #_pack.data.shoper+1
        local trace

        --设置初始bind
        for k,v in pairs(list) do
            if (not v.bind)then
                v.bind = Items.getItemInitBind(v.itemTypeId)
                print("k="..k, "bind.qt="..v.bind.qt)
            end
        end

        _pack.data.shoper[index] = {
            unit = unit,
            list = list
        }

        if (autoReflush) then
            trace = CenterTimer.addTrace(nil,{
                delay = autoReflush,
                loop = true,
                bind = {index,table.clone(list)},
                callback = function(bind)
                    _pack.updateShopByIndex(bind[1],bind[2])
                    return true
                end
            })

            _pack.data.shoper[index].trace = trace
        end

        return index,trace
    end)
end

function _pack.updateShopByIndex(index,list)
    if (_pack.data.shoper[index]) then
        _pack.data.shoper[index].list = list
    end

    if (_pack.data.isOpen and _pack.data.currentIndex == index) then
        _pack.update()
    end
end

function _pack.updateShopByUnit(unit,list)
    Object.ofNullable(_pack.unitIsShoper(unit),list, _pack.updateShopByIndex)
end

function _pack.removeEventByIndex(index)
    if (_pack.data.isOpen and _pack.data.currentIndex == index) then
        _pack.close()
    end

    Object.ofNullable( _pack.data.shoper[index],function (shoper)
        shoper.trace.remove()
        _pack.data.shoper[index] = nil
    end)
end

function _pack.removeEventByUnit(unit)
    Object.ofNullable(_pack.unitIsShoper(unit),_pack.removeEventByIndex)
end

local function setShoperCD(index,shoperIndex,info)
    if(info.cd) then
        CenterTimer.addTrace(nil,{
            delay = info.cd/8,
            loop = true,
            bind = {
                step = 1,               --累积运行8次
                current = shoperIndex,  --哪个商店
                index = index,          --哪个格子
                info = info
    
            },
            callback = function(bind)
                if (bind.step == 8) then
                    if(_pack.data.currentIndex == bind.current) then
                        --清除cd图片
                        --_pack.update()
                    end
    
                    bind.info.inCd = false
                    return false
                end
    
                if(_pack.data.currentIndex == bind.current) then
                    --更新cd图片
                    --_pack.update()
                end
                return true
            end
        })
    end
end

local function systemSellResouece(gold,lumber)
    if (gold >0 and lumber>0) then
        Console.system(string.format("出售物品获得%d金币,%d水晶",gold,lumber))
        return
    end

    if (gold >0) then
        Console.system(string.format("出售物品获得%d金币。",gold))
        return
    end

    if (lumber>0) then
        Console.system(string.format("出售物品获得%d水晶。",lumber))
        return
    end
end

local function systemBuyResouece(gold,lumber)
    if (gold >0 and lumber>0) then
        Console.system(string.format("购买物品花费%d金币,%d水晶",gold,lumber))
        return
    end

    if (gold >0) then
        Console.system(string.format("购买物品花费%d金币。",gold))
        return
    end

    if (lumber>0) then
        Console.system(string.format("购买物品花费%d水晶。",lumber))
        return
    end
end


-- 购买多数量
function _pack.showSeparateBuyDialog()
    _pack.data.isEnable = false

    dzapi.RegisterFrameEvent(_pack.data.separate.dialogs[3],nil,nil,_pack.separateBuy)
    dzapi.RegisterFrameEvent(_pack.data.separate.dialogs[4],nil,nil,_pack.closeSeparateBuyDialog)
    dzapi.FrameSetText(_pack.data.separate.dialogs[5],"购买数量")

    --重置滑轴
    dzapi.FrameSetText(_pack.data.separate.dialogs[1],"1");
    dzapi.FrameSetValue(_pack.data.separate.dialogs[2],0);

    jass.TimerStart(_pack.data.separate.timer,0.1,true,function()
        local step = dzapi.FrameGetValue(_pack.data.separate.dialogs[2]);
        local currentNum  = math.floor(_pack.data.separate.max *(step/1));
        
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

function _pack.closeSeparateBuyDialog()
    _pack.data.isEnable = true
    _pack.data.separate.index  = 0
    _pack.data.separate.info  = nil
    _pack.data.separate.num  = 0
    _pack.data.separate.max  = 0

    jass.PauseTimer(_pack.data.separate.timer)
    dzapi.FrameShow(_pack.data.separate.dialogs[0],false);
end

function _pack.separateBuy()
    local itemTypeId = Items.getItemTypeId(_pack.data.separate.info.itemTypeId) --获取数字id

    --检查资源
    local gold,lumber = Items.getItemBuyResource(itemTypeId)
    gold = gold * _pack.data.separate.num
    lumber = lumber * _pack.data.separate.num

    local gamer = Context.get("GamerLocal")

    if (not gamer.checkResource(gold,lumber)) then
        Console.system("购买失败，金币或水晶不足！")
        return
    end
    gamer.deductResource(gold,lumber)
    systemBuyResouece(gold,lumber)

    --商店物品数量
    _pack.data.separate.info.charges = _pack.data.separate.max - _pack.data.separate.num
    _pack.update()

    --商店物品cd
    -- setShoperCD(_pack.data.separate.index,_pack.data.current,_pack.data.separate.info)

    --购买音效

    --异步创建物品添加到背包
    Items.create(itemTypeId,{580,2480},_pack.data.separate.num,function(newItem)
        BackpControl.addItem(newItem)
    end)

    _pack.closeSeparateBuyDialog()
end

local function buySeparateCheck(cellIndex,info)
    _pack.data.separate.index = cellIndex
    _pack.data.separate.info = info
    _pack.data.separate.num = 1
    _pack.data.separate.max = info.charges
    _pack.showSeparateBuyDialog()
end

local function buyCheck(cellIndex,info)
    local itemTypeId = Items.getItemTypeId(info.itemTypeId) --获取数字id

    --检查资源
    local gold,lumber = Items.getItemBuyResource(itemTypeId)
    local gamer = Context.get("GamerLocal")

    if (not gamer.checkResource(gold,lumber)) then
        Console.system("购买失败，金币或水晶不足！")
        return
    end

    gamer.deductResource(gold,lumber)
    systemBuyResouece(gold,lumber)

    --商店物品数量
    info.charges = 0
    _pack.update()

    --商店物品cd
    -- setShoperCD(cellIndex,shoperIndex,info)

    --购买音效

    --异步创建物品添加到背包
    Items.create(itemTypeId,{580,2480},1,function(newItem)
        BackpControl.addItem(newItem)
    end)
end


--出售物品  多数量
function _pack.closeSeparateSellDialog()
    _pack.data.isEnable = true
    _pack.data.sell.index = 0
    _pack.data.sell.from = 0
    _pack.data.sell.item = nil
    _pack.data.sell.num = 0
    _pack.data.sell.max = 0

    jass.PauseTimer(_pack.data.separate.timer)
    dzapi.FrameShow(_pack.data.separate.dialogs[0],false)
end

function _pack.separateSell()
    local itemTypeId = jass.GetItemTypeId(_pack.data.sell.item)
    local slk = jslk.item[Id.id2string(itemTypeId)]

    --添加资源
    local gold = tonumber(slk.goldcost)/2 * _pack.data.sell.num
    local lumber = tonumber(slk.lumbercost)/2 * _pack.data.sell.num
    local gamer = Context.get("GamerLocal")

    gamer.addResource(gold,lumber)
    systemSellResouece(gold,lumber)

    if (_pack.data.sell.num == _pack.data.sell.max) then
        --删除物品
        Items.remove(_pack.data.sell.item,true)

        if (_pack.data.sell.from ==0) then
            Items.data.backpack[_pack.data.sell.index] = nil
        end
    else
        --同步次数
        local charges = _pack.data.sell.max - _pack.data.sell.num
        Items.setCharges(_pack.data.sell.item,charges,function()
            print("ShopControl.separateSell","同步charges后回调",charges)
            BackpControl.update()
        end)
    end
    BackpControl.update()
    _pack.closeSeparateSellDialog()
end

function _pack.showSeparateSellDialog()
    _pack.data.isEnable = false

    dzapi.RegisterFrameEvent(_pack.data.separate.dialogs[3],nil,nil,_pack.separateSell)
    dzapi.RegisterFrameEvent(_pack.data.separate.dialogs[4],nil,nil,_pack.closeSeparateSellDialog)
    dzapi.FrameSetText(_pack.data.separate.dialogs[5],"出售数量")

    --用separate的dialog 用sell的数据
    --重置滑轴
    dzapi.FrameSetText(_pack.data.separate.dialogs[1],"1");
    dzapi.FrameSetValue(_pack.data.separate.dialogs[2],0.01);

    jass.TimerStart(_pack.data.separate.timer,0.1,true,function()
        local step = dzapi.FrameGetValue(_pack.data.separate.dialogs[2]);
        local currentNum  = math.floor(_pack.data.sell.max * step);

        --防止溢出
        if (currentNum> _pack.data.sell.max) then
            _pack.data.sell.num = _pack.data.sell.max;
        elseif (currentNum<1) then
            _pack.data.sell.num = 1
        else
            _pack.data.sell.num = currentNum
        end

        --设置text
        dzapi.FrameSetText(_pack.data.separate.dialogs[1],tostring(_pack.data.sell.num));
    end);

    dzapi.FrameShow(_pack.data.separate.dialogs[0],true);
end

function _pack.separateSellCheck(index,item,from)
    BackpControl.cancelGrabup()

    _pack.data.sell.index = index
    _pack.data.sell.item = item
    _pack.data.sell.from = from
    _pack.data.sell.max = jass.GetItemCharges(item)
    _pack.data.sell.num = jass.GetItemCharges(item)
    
    _pack.showSeparateSellDialog()
end

--出售物品
function _pack.showSellDialog()
    _pack.data.isEnable = false
    dzapi.FrameShow(_pack.data.sell.dialogs[0],true)
end

function _pack.closeSellDialog()
    _pack.data.isEnable = true

    _pack.data.sell.index =0
    _pack.data.sell.from = 0
    _pack.data.sell.item = nil

    dzapi.FrameShow(_pack.data.sell.dialogs[0],false)
end

function _pack.sell()
    local itemTypeId = jass.GetItemTypeId(_pack.data.sell.item)
    local slk = jslk.item[Id.id2string(itemTypeId)]

    --添加资源
    local gold = tonumber(slk.goldcost)/2
    local lumber = tonumber(slk.lumbercost)/2   
    local gamer = Context.get("GamerLocal")
    gamer.addResource(gold,lumber)
    systemSellResouece(gold,lumber)

    BackpControl.update()

    Items.remove(_pack.data.sell.item,true)

    if (_pack.data.sell.from ==0) then
        Items.data.backpack[_pack.data.sell.index] = nil
    end

    BackpControl.update()
   _pack.closeSellDialog()
end

function _pack.sellCheck(index,item,from)
    BackpControl.cancelGrabup()
    local level = jass.GetItemLevel(item)

    if (level <3) then
        local slk = jslk.item[Id.id2string(jass.GetItemTypeId(item))]
        local gold = tonumber(slk.goldcost) /2
        local lumber = tonumber(slk.lumbercost) /2
        local gamer = Context.get("GamerLocal")

        gamer.addResource(gold,lumber)
        systemSellResouece(gold,lumber)
        Items.remove(item,true)

        if (from ==0) then
            Items.data.backpack[index] = nil
        end
        BackpControl.update()
    else
        _pack.data.sell.index = index
        _pack.data.sell.from = from
        _pack.data.sell.item = item
        
        _pack.showSellDialog()
    end
end

function _pack.shopItemOver(frame)
    if (not _pack.data.isEnable) then
        return 
    end

    local index = getCellIndexByFrame(frame)
    local info = getItemInfoByIndex(index)

    Object.ofNullable(info,function(info)
        Interface.GUI.showTip(3,2,info.itemTypeId,info.bind)
    end)
end

function _pack.shopItemLeft(frame)
    if (not _pack.data.isEnable) then
        return 
    end
    local index = getCellIndexByFrame(frame)

    --是否出售物品
    if(BackpControl.data.grabup.isGrabup) then
        local charges = jass.GetItemCharges(BackpControl.data.grabup.item)
        if (charges <=1) then
            _pack.sellCheck(BackpControl.data.grabup.index,
                BackpControl.data.grabup.item,
                BackpControl.data.grabup.from )
        else
            _pack.separateSellCheck(BackpControl.data.grabup.index,
                BackpControl.data.grabup.item,
                BackpControl.data.grabup.from )
        end
        return
    end

    --购买检测
    local info = getItemInfoByIndex(index)
    do
        --是否格子有物品
        if (not info) then
            return
        end

        --是否有购买次数
        if(info.charges <=0) then
            return
        end

        --是否cd
        if(info.inCd or info.charges <=0) then
            print("cd中")
            return
        end

        --是否背包有空间
        if (not BackpControl.haveSpace()) then
            Console.system("购买失败，背包已满！")
        end
    end

    --批量购买
    if (info.charges >1) then
        buySeparateCheck(index,info)
        return
    end
    
    --购买1个
    buyCheck(index,info)
end

function _pack.shopItemRight(frame)

    if (not _pack.data.isEnable) then
        return 
    end

    local index getCellIndexByFrame(frame)
    local info = getItemInfoByIndex(index)

    --是否出售物品
    if(BackpControl.data.grabup.isGrabup) then
        local charges = jass.GetItemCharges(BackpControl.data.grabup.item)
        if (charges <=1) then
            _pack.sellCheck(BackpControl.data.grabup.index,
                BackpControl.data.grabup.item,
                BackpControl.data.grabup.from )
        else
            _pack.separateSellCheck(BackpControl.data.grabup.index,
                BackpControl.data.grabup.item,
                BackpControl.data.grabup.from )
        end
        return
    end

end


--@init Shop
function _pack.init()
    -- 暴露接口
    Interface.Shop = {}
    Interface.Shop.open = _pack.toggle;
    Interface.Shop.close = _pack.close;
    Interface.Shop.toggle = _pack.toggle;

    Interface.Shop.registerEvent = _pack.registerEvent;
    Interface.Shop.updateShopByIndex = _pack.updateShopByIndex;
    Interface.Shop.updateShopByUnit = _pack.updateShopByUnit;

    Interface.Shop.removeEventByIndex = _pack.removeEventByIndex;
    Interface.Shop.removeEventByUnit = _pack.removeEventByUnit;
    
    --选择单位弹出商店
    Trigger.registerEvent("select_local",function()
        local unit = jass.GetTriggerUnit()

        local role = Context.get("GamerLocal").data.role
        if(role) then
            local r = role.data.unit
            local p = role.data.partner

            Object.ofNullable(_pack.unitIsShoper(unit),function(index)
                --判断距离
                if (bj.unitDistanceLess(unit,r,500) or bj.unitDistanceLess(unit,p,500) )then
                    _pack.data.currentIndex = index
                    _pack.update()
                    _pack.open()
                    BackpControl.open()
                    Context.get("GamerLocal").selectSelf()
                end
            end)
        end
    end)
end

return _pack
