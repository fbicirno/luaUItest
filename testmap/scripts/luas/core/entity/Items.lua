local UUID = require 'scripts.luas.utils.id.UUID'
local Id = require 'scripts.luas.utils.id.Id'
local Object = require 'scripts.luas.utils.object.ObjectUtils'
local Context = require 'scripts.luas.core.applic.Context'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
local Console= require 'scripts.luas.utils.envir.Console'
local Request = require 'scripts.luas.po.Request'
local Scoket = require 'scripts.luas.core.scoket.Scoket'
local ItemGameTypeContants = require 'scripts.luas.constants.ItemGameType'
local CardsBase = require 'scripts.config.cards'
local ItemsBase = require 'scripts.config.items'

-- 物品系统
-- items ability cards等信息
local _pack = {

    data = {
        --数据库
        db = {},

        --玩家物品表
        --[[
            handleId = {
                [1] = item_handle,  => id,handleId,icon,tip,uberTip,uses,charges, abilist
                [2] = bind {}
            }
        ]]
        common = {},

        --本地物品表
        -- 同common
        current = {},

        --背包物品
        --[[
            [0-63] = item_handle
        ]]
        backpack = {},

        --物品栏物品
        --[[
            [1-12] = item_handle
            [1-6]物品栏0 [7-12]物品栏1
        ]]
        invt = {}, 

        --bank 
        last_bank = {},
        bank = {},
        
    }
}

function _pack.findItemCommon(itemTypeId,id)
    for k,v in pairs(_pack.data.common) do
        local item = v[1]
        local itemId = jass.GetItemUserData(item)
        if (itemId == id and itemTypeId == jass.GetItemTypeId(item)) then
            return item
        end
    end
    return nil
end

--只根据itTypeId查找 用于测试
function _pack.findItemCommonTest2(itemTypeId)
    local rs = {}
    for k,v in pairs(_pack.data.common) do
        local item = v[1]
        if (itemTypeId == jass.GetItemTypeId(item)) then
            table.insert(rs,item)
        end
    end
    return rs
end

function _pack.findItemCurrent(itemTypeId,id)
    for k,v in pairs(_pack.data.current) do
        local item = v[1]
        local itemId = jass.GetItemUserData(item)

        if (itemId == id and itemTypeId == jass.GetItemTypeId(item)) then
            return item
        end
    end
    return nil
end

function _pack.getItemTypeStr(param)
    local itemTypeId
    Object.switch(type(param))
        .catch("string",function()
            itemTypeId = param
        end)
        .catch("number",function()
            itemTypeId = Id.id2string(param)
        end)
        .default(function()
            itemTypeId = Id.id2string(jass.GetItemTypeId(param))
        end)
    -- print("getItemTypeStr",itemTypeId,param)
    return itemTypeId
end

function _pack.getItemTypeId(param)
    local itemTypeId
    Object.switch(type(param))
        .catch("string",function()
            itemTypeId = Id.string2id(param)
        end)
        .catch("number",function()
            itemTypeId = param
        end)
        .default(function()
            itemTypeId = jass.GetItemTypeId(param)
        end)

    -- print("Items.getItemTypeId",param,type(param),itemTypeId,type(itemTypeId))

    return itemTypeId
end

function _pack.getItemQuality(param)
    local itemTypeIdStr =  _pack.getItemTypeStr(param)
    return ItemsBase[itemTypeIdStr].qt
end

function _pack.getItemInitBind(param)
    local itemTypeIdStr =  _pack.getItemTypeStr(param)
    print("getItemInitBind  itemTypeIdStr",itemTypeIdStr,ItemsBase[itemTypeIdStr])
    return ItemsBase[itemTypeIdStr] or ItemsBase.default
end

function _pack.getCardType(id)
    if (id>=1 and id<=0x64) then
        return "天赋"
    end

    if (id>=0x65 and id <= 0xC8) then
        return "宝具"
    end

    if (id >=0xC9 and id <= 0x12C)then
        return "技能"
    end

    return "未知"
end

function _pack.getCardIcon(id)
    if (id == nil) then
        return "img\\alpha.blp"
    end

    if (id == -101) then
        return "img\\ui_new\\UI_TalentLocak.blp"
    end

    if (id == -102) then
        return "img\\ui_new\\UI_BagEmpty.blp"
    end

    local type = _pack.getCardType(id)

    if (type == "天赋") then
        return string.gsub(CardsBase.talent[id].icon,"/","\\")
    end

    if (type == "宝具") then
        return string.gsub(CardsBase.card[id].icon,"/","\\")
    end

    if (type == "技能") then
        return string.gsub(CardsBase.ability[id].icon,"/","\\")
    end

    return "img\\red.blp"
end

function _pack.getCardName(id)
    if (id == -101) then
        return "锁定"
    end

    local type = _pack.getCardType(id)

    if (type == "天赋") then
        return CardsBase.talent[id].name
    end

    if (type == "宝具") then
        return CardsBase.card[id].name
    end

    if (type == "技能") then
        return CardsBase.ability[id].name
    end

    return "未知"
end

function _pack.getCardArt(id)
    if (id == nil) then
        return "img\\alpha.blp"
    end

    local type = _pack.getCardType(id)

    if (type == "天赋") then
        return string.gsub(CardsBase.talent[id].art,"/","\\")
    end

    if (type == "宝具") then
        return string.gsub(CardsBase.card[id].art,"/","\\")
    end

    if (type == "技能") then
        return string.gsub(CardsBase.ability[id].art,"/","\\")
    end

    return "img\\red.blp"
end

function _pack.getCardBack(id)
    local type = _pack.getCardType(id)

    if (type == "天赋") then
        return CardsBase.talent[id].back
    end

    if (type == "宝具") then
        return CardsBase.card[id].back
    end

    if (type == "技能") then
        return CardsBase.ability[id].back
    end
end

function _pack.getCardBase(id)
    if (id == nil) then
        return nil
    end

    local type = _pack.getCardType(id)

    if (type == "天赋") then
        return CardsBase.talent[id]
    end

    if (type == "宝具") then
        return CardsBase.card[id]
    end

    if (type == "技能") then
        return CardsBase.ability[id]
    end

    return nil
end

--获取物品类型
--[[
    10 Permanent永久 装备 (没有主动技能)
    20 Artifact人造  装备-饰品、装备-翅膀、装备盾牌 (有主动技能) 

    30 Charged可充的 消耗品  
    40 Purchasable可购买的 宝石           
    50 Miscellaneous混杂的 材料
]]
function _pack.getItemGameBaseType(param)
    local itemTypeId = _pack.getItemTypeStr(param)
    -- print("getItemGameBaseType",itemTypeId,param)

    return Object.switch(jslk.item[itemTypeId].class)
        .catch("Permanent",ItemGameTypeContants.BASE_TYPE.EQUIP)       --装备
        .catch("Artifact",ItemGameTypeContants.BASE_TYPE.EQUIP_USABLE) --可用装备
        .catch("Charged",ItemGameTypeContants.BASE_TYPE.CONSUM )       --消耗品
        .catch("Miscellaneous",ItemGameTypeContants.BASE_TYPE.MATERR)  --材料
        .catch("Purchasable",ItemGameTypeContants.BASE_TYPE.INGEM)     --镶嵌宝石
        .default()
end

--获取扩展类型
--@return int 主类型+物品oldLevel
function _pack.getItemGameExType(param)
    local itemTypeId = _pack.getItemTypeStr(param)
    local baseType = _pack.getItemGameBaseType(itemTypeId)
    local slk = jslk.item[itemTypeId]
    local oldLv = slk.oldLevel
    return baseType+oldLv
end

function _pack.getItemBuyResource(param)
    local itemTypeId = _pack.getItemTypeStr(param)
    local slk = jslk.item[itemTypeId]
    return tonumber(slk.goldcost),tonumber(slk.lumbercost)
end

-- 初始化物品bind
-- ***只能用于同步环境
local function initBind(itemTypeId)
    local itemGameBaseType= _pack.getItemGameBaseType(itemTypeId)
    local itemGameExType = _pack.getItemGameExType(itemTypeId)
    local itemBaseBind = _pack.getItemInitBind(itemTypeId)

    if(itemGameBaseType <=20) then

    end

    if (itemGameBaseType >=30) then

    end

    return nil
end

-- 掉落物品 
-- 自动偏移坐标 
-- ***只能用于同步环境
function _pack.loot(itemTypeId,posi,charges)
    posi = posi or {580,2480}
    charges = charges or 0
    itemTypeId = _pack.getItemTypeId(itemTypeId) --获取数字id
    
    -- 同步环境下 设置随机数
    local x = posi[1] + jass.GetRandomInt(-100,100)
    local y = posi[2] + jass.GetRandomInt(-100,100)
    local bind = initBind(itemTypeId)

    --转为主机异步
    local hostGamer = Context.get("GamerHost")
    local localGamer = Context.get("GamerLocal")

    if (localGamer.equals(hostGamer))then
        local itemId = UUID.random() --异步设置id

        --发送同步消息后创建物品
        local request = Request.create()
        request.head = "item_loot"
        request.target = "all"
        request.host = hostGamer.data.index
        request.message = {
            id = itemId,
            itemTypeId = itemTypeId,
            x = x,
            y = y,
            charges =charges,
            bind = bind
        }
        Scoket.send(request)
    end
end

-- 创建物品  
-- ***只能用于异步创建
--@callback  创建物品后的后续动作
function _pack.create(itemTypeId,posi,charges,callback)
    charges= charges or 0
    posi = posi or {580,2480}
    itemTypeId = _pack.getItemTypeId(itemTypeId) --获取数字id
    local itemId = UUID.random()

    local request = Request.create()
    request.head = "item_create"
    request.host = jass.GetPlayerId(jass.GetLocalPlayer())
    request.type = 2    --需要回执
    request.target = "all" --全部玩家
    request.message = {
        id = itemId, --本机随机id
        itemTypeId= itemTypeId,
        x= posi[1],
        y= posi[2],
        charges= charges,
    }
    Scoket.send(request,function(data_list,isOvertime)
        --注意这里还是异步环境
        --准备执行callback后续动作
        local item = _pack.findItemCommon(itemTypeId,itemId)
        if (callback) then
            callback(item)
        end
    end)
end

-- 复制物品
-- ***只能用于异步复制
--@callback  创建物品后的后续动作
function _pack.copyItem(item,charges,callback)
    charges = charges or 0

    local newItemId = UUID.random() --本地获取id
    local itemTypeId = jass.GetItemTypeId(item)
    local from = _pack.data.common[jass.GetHandleId(item)] or _pack.data.current[jass.GetHandleId(item)]
    local bind = from[2]

    local request = Request.create()
    request.head = "item_loot"  --loot用同的bind create会自己initBind
    request.host = jass.GetPlayerId(jass.GetLocalPlayer())
    request.type = 2      --需要回执
    request.target ="all" --全部玩家
    request.message = {
        id =newItemId,
        itemTypeId =itemTypeId,
        x =540,
        y =2480,
        charges =charges,
        bind =bind,
    }
    Scoket.send(request,function(data_list,isOvertime)
        --注意这里还是异步环境
        --准备执行callback后续动作
        local item = _pack.findItemCommon(itemTypeId,newItemId)
        if (callback) then
            callback(item)
        end
    end)
end

-- 移动位置
--@flag 非nil 非false时 表示异步转同步
--@posi { x,y} 不要出现索引
function _pack.setPosition(item,posi,flag)
    if (flag) then
        local request = Request.create()

        local from = _pack.data.common[jass.GetHandleId(item)] or _pack.data.current[jass.GetHandleId(item)]
        local bind = Object.serialize(from[2])

        request.head = "item_position"
        request.host = jass.GetPlayerId(jass.GetLocalPlayer())
        request.target = -1
        request.message = {
            id = jass.GetItemUserData(item),
            itemTypeId= jass.GetItemTypeId(item),
            x= posi[1],
            y= posi[2],
            charges= jass.GetItemCharges(item),
            bind= bind,
        }
        Scoket.send(request)
        return
    end

    Trigger.pause("unit_abandon")
    jass.SetItemPosition(item,posi[1],posi[12])
    Trigger.continue("unit_abandon")
end

--同步叠加数量
--@callback 异步
function _pack.setCharges(item,charges,callback)
    if (callback) then
        local request = Request.create()
        
        request.head = "item_charges"
        request.host = jass.GetPlayerId(jass.GetLocalPlayer())
        request.type = 2
        request.target = "all"
        request.message ={
            id = jass.GetItemUserData(item),
            itemTypeId = jass.GetItemTypeId(item),
            charges = charges,
        } 
        Scoket.send(request,callback)
        return
    end

    --如果是可叠加物品 设置charges
    local itemGameBaseType = _pack.getItemGameBaseType(item)
    if (itemGameBaseType <=20) then
        jass.SetItemCharges(item,0)
    else
        jass.SetItemCharges(item,charges)
    end
end

-- 删除物品
--@flag 异步
function _pack.remove(item,flag)
    if (flag) then
        local request = Request.create()
        request.head = "item_remove"
        request.target = "all"
        request.message = {
            id = jass.GetItemUserData(item),
            itemTypeId = jass.GetItemTypeId(item),
        }
        Scoket.send(request)
        return
    end

    local itemHid = jass.GetHandleId(item)
    _pack.data.current[itemHid] = nil
    _pack.data.common[itemHid] = nil
    jass.RemoveItem(item)
end

-- 添加给单位
-- @param item
-- @param index 物品栏中的位置
-- @flag 非nil 非false时 表示异步转同步
function _pack.addToUnit(unit,item,index,flag)
    if (flag) then
        local request = Request.create()
        request.head = "item_addtounit"
        request.host = jass.GetPlayerId(jass.GetLocalPlayer())
        request.target = -1
        request.message = {
            id = jass.GetItemUserData(item),
            itemTypeId = jass.GetItemTypeId(item),
            index = index,
        }
        return
    end

    print("Items.addToUnit",unit,item,index)

    jass.UnitAddItem(unit,item) 
    jass.IssueTargetOrderById( unit, 852002+index, item ) 
end

-- 同步玩家物品栏 
-- ***异步调用
function _pack.resetUnitSlot()
    local unit = Context.get("GamerLocal").data.role.data.unit
    local message = {}

    for i=1,6,1 do
        local item = jass.UnitItemInSlot(unit,i-1)
        if (item) then
            message[i] = {
                index = i,
                id = jass.GetItemUserData(item),
                itemTypeId = jass.GetItemTypeId(item),
                charges = jass.GetItemCharges(item),
                bind = _pack.data.current[jass.GetHandleId(item)][2],
            }
        end
    end

    local request = Request.create()
    request.head = "item_slot"
    request.host = jass.GetPlayerId(jass.GetLocalPlayer())
    request.target = -2 --其他玩家
    request.message = message
    Scoket.send(request)
end 

-- 使用物品   
-- 物品无需考虑释放目标
--@gid 哪个玩家使用的
--@flag 非nil 非false时 表示异步转同步
function _pack.use(item,gid,flag)
    if (flag) then
        local request = Request.create()
        request.head= "item_use"
        request.host = jass.GetPlayerId(jass.GetLocalPlayer())
        request.target = -1
        request.message ={
            id = jass.GetItemUserData(item),
            itemTypeId = jass.GetItemTypeId(item),
            charges = jass.GetItemCharges(item),
            bind = _pack.data.current[jass.GetHandleId(item)][2],
        } 
        Scoket.send(request)
        print("Items.use","发送同步消息")
        return
    end

    -- local useGamer = Context.get("Gamer")[gid]
    -- local localGamer = Context.get("GamerLocal")

    -- if (useGamer.equals(localGamer)) then
    -- end
    --local Abilities= require 'scripts.luas.core.entity.Abilities'
    --Abilities.cast(nil,gid,item) --目标(nil,单位,物品,posi,..)，使用者id,物品/技能
    local itemGameExType = _pack.getItemGameExType(item)
    useGamer.setCd(itemGameExType)     --设置cd
    jass.SetItemCharges(item,charges-1)--使用次数-1 
    
    --是否删除物品
    if (charges-1 <=0) then
        _pack.data.common[jass.GetHandleId(item)] = nil  --当charges-1 <=0 时,本地玩家在同步前已经移动到common表中了
        jass.RemoveItem(item)
    end
end

-- 获取开牌掉落list
--@type 类型   
--[[
    "normal"  普通   宝具、技能随机
    "better"  更好的 宝具、技能随机
    "talent"  仅天赋
    "card"    仅宝具
    "ability" 仅技能
    "talent_better"
    "card_better"
    "ability_better"
]]
-- 为了方便jar处理 路径都写成了斜杠 lua要转成反斜杠
function _pack.getCardList(type)
    local list = {}
    if(type == "talent" or type == "talent_better") then
        for i=1,4,1 do
            local index = math.random(1,55)
            table.insert(list,{
                index = index,
                art = string.gsub(CardsBase.talent[index].art,"/","\\"),
                qt  = CardsBase.talent[index].back,
            })
        end
    end

    return list
end

--@init 
function _pack.init()

    -- 监听事件
    Scoket.registerEvent("item_position",function(request,response)
        local hostGamer = Context.get("Gamers")[request.host]
        local localGamer = Context.get("GamerLocal")

        local itemTypeId = request.message.itemTypeId
        local itemId =   request.message.id
        local x = request.message.x
        local y =  request.message.y
        local charges =  request.message.charges
        local bind =  request.message.bind

        local item
        local from

        if(localGamer.equals(hostGamer)) then --先在current表找
            item = _pack.findItemCurrent(itemTypeId,itemId)
        end

        if(item) then
            from = _pack.data.current[jass.GetHandleId(item)]
        else
            item = _pack.findItemCommon(itemTypeId,itemId)
            from = _pack.data.common[jass.GetHandleId(item)]
        end

        if(item and from)then
            Trigger.pause("unit_abandon")
            jass.SetItemPosition(item,x,y)
            Trigger.continue("unit_abandon")

            if (charges) then
                jass.SetItemCharges(item,charges)
            end

            if (bind) then
                from[2] = bind
            end

        else
            print ("error: sync_item_position","未找到物品",itemTypeId,itemId)
        end
    end)

    Scoket.registerEvent("item_charges",function(request,response)
        local itemId =   request.message.id
        local itemTypeId = request.message.itemTypeId
        local charges =  request.message.charges

        local item = _pack.findItemCurrent(itemTypeId,itemId) or _pack.findItemCommon(itemTypeId,itemId)
        if(item)then
            _pack.setCharges(item,charges)
        else
            print ("error: sync_item_charges","未找到物品",itemTypeId,itemId)
        end
    end)

    Scoket.registerEvent("item_loot",function(request,response)
        -- print("sync_item_loot",request)
        -- table.print(request)

        local itemId = request.message.id
        local itemTypeId = request.message.itemTypeId
        local x = request.message.x 
        local y = request.message.y 
        local charges = request.message.charges
        local bind = request.message.bind

        local item = jass.CreateItem(itemTypeId,x,y)
        if(item)then
            jass.SetItemUserData(item,itemId)

            --如果是可叠加物品 设置charges
            local itemGameBaseType = _pack.getItemGameBaseType(item)
            if (itemGameBaseType <=20) then
                jass.SetItemCharges(item,0)
            else
                jass.SetItemCharges(item,charges)
            end

            --保存到common
            _pack.data.common[jass.GetHandleId(item)] = {
                item,bind
            }
        else
            print ("error: sync_item_position","未找到物品",itemTypeId,itemId)
        end
    end)

    Scoket.registerEvent("item_create",function(request,response)
        local itemId =  request.message.id
        local itemTypeId = request.message.itemTypeId
        local x = request.message.x 
        local y = request.message.y 
        local charges = request.message.charges

        local item = jass.CreateItem(itemTypeId,x,y)
        jass.SetItemUserData(item,itemId)

        --如果是可叠加物品 设置charges
        local itemGameBaseType = _pack.getItemGameBaseType(item)
        if (itemGameBaseType <=20) then
            jass.SetItemCharges(item,0)
        else
            jass.SetItemCharges(item,charges)
        end

        --保存到common表中
        local bind = initBind(itemTypeId)
        _pack.data.common[jass.GetHandleId(item)] = {
            item,bind
        }
    end)

    Scoket.registerEvent("item_use",function(request,response)
        print("sync_item_use","接收同步消息")

        local hostGamer = Context.get("Gamers")[request.host]
        local localGamer = Context.get("GamerLocal")

        local itemTypeId = request.message.itemTypeId
        local itemId =  request.message.id
        local charges = request.message.charges
        local bind = request.message.bind

        local item
        local from

        if(localGamer.equals(hostGamer)) then 
            --本地玩家
            item = _pack.findItemCurrent(itemTypeId,id)
            from = _pack.data.current[jass.GetHandleId(item)]
        else  
            --其他玩家 先同步属性
            item =  _pack.findItemCommon(itemTypeId,id)
            from = _pack.data.common[jass.GetHandleId(item)]

            from[2] = bind
            jass.SetItemCharges(item,charges)
        end

        if (item) then
            print ("sync_item_use","使用物品")
            _pack.use(item,request.host)
        else
            print ("error: sync_item_use","未找到物品",itemTypeId,itemId)
        end
    end)

    Scoket.registerEvent("item_remove",function(request,response)
        local itemTypeId = request.message.itemTypeId
        local itemId =  request.message.id

        local item =  _pack.findItemCurrent(itemTypeId,itemId) or _pack.findItemCommon(itemTypeId,itemId)
        if(item) then
            local itemHid = jass.GetHandleId(item)
            _pack.data.common[itemHid] = nil

            Trigger.pause("unit_abandon")
            jass.RemoveItem(item)
            Trigger.continue("unit_abandon")
        else
            print("error:","sync_item_remove","未找到物品")
        end
    end)

    Scoket.registerEvent("item_slot",function(request,response)
        print("sync_item_slot1")

        local message = request.message:gsub("%[%[","{"):gsub("%]%]","}"):gsub(";",",")
        local data = load("return " .. message)()

        local gamer = Context.get("Gamers")[request.host]
        local unit = gamer.data.role.data.unit

        Trigger.pause("unit_abandon")
        for i=1,6,1 do
            --移出旧物品
            local oldSlotItem = jass.UnitItemInSlot(unit,i-1)
            if (oldSlotItem) then
                jass.SetItemPosition(oldSlotItem,580,2480)
            end

            --移入新物品
            if (data[i]) then
                local newSlotItem = _pack.findItemCommon(data[i].itemTypeId,data[i].id)
                if(newSlotItem)then
                    jass.SetItemCharges(newSlotItem,data[i].charges) --更新次数
                    Items.data.common[jass.GetHandleId(newSlotItem)][2] = data[i].bind --更新bind

                    jass.UnitAddItem(unit,newSlotItem)
                    jass.IssueTargetOrderById( unit, 852001+i, newSlotItem); --移动到正确的位置
                else
                    print("error:","sync_item_slot","未发现物品",data[i].itemTypeId,data[i].id)
                end
            end
        end
        Trigger.continue("unit_abandon")
    end)

    Scoket.registerEvent("item_addtounit",function(request,response)

        --仅用于 玩家物品栏丢弃物品取消时 
        local hostGamer = Context.get("Gamers")[request.host]
        local localGamer = Context.get("GamerLocal")

        local unit = hostGamer.data.role.data.unit
        local item

        if (hostGamer.equals(localGamer)) then
            item = _pack.findItemCurrent(request.message.itemTypeId,request.message.id)
        else
            item = _pack.findItemCommon(request.message.itemTypeId,request.message.id)
        end

        if(item) then
            _pack.addToUnit(unit,item,request.message.index,false)
        else
            print("error:","sync_item_addtounit","未找到物品")
        end
    end)
end

return _pack
