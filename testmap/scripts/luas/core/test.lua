print("----test start----")
print(japi.GetPluginVersion())
local Random = require 'scripts.luas.utils.id.Random'
local Context = require 'scripts.luas.core.applic.Context'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local Order = require 'scripts.luas.core.behavior.Order'
local Id = require 'scripts.luas.utils.id.Id'
local UUID = require 'scripts.luas.utils.id.UUID'
local Items = require 'scripts.luas.core.entity.Items'
local Gamer = require 'scripts.luas.core.gamer.Gamer'
local CardControl = require 'scripts.luas.core.grap.CardControl'
local Camera = require "scripts.luas.utils.envir.Camera"

local Caption = require 'scripts.luas.core.behavior.Caption'
Caption.data.skipSelectHero = true
Caption.data.defaultNewGame = true

--代理caption的start方法
local Caption_start = Caption.start
Caption.start = function()
    Caption_start()
    Camera.release()
end

--测试指令
do
    Order.registerEvent("-debugSC","设置物品charge",function(id,msg)
        local role = Context.get("GamerLocal").data.role
        local unit = role.data.unit
    
        local item = jass.UnitItemInSlot(unit,0)
        local charges = tonumber(msg)
    
        print(jass.GetItemName(item),charges)
        jass.SetItemCharges(item,charges)
    end)
    
    Order.registerEvent("-debugSUD","设置消耗品UserData",function(id,msg)
        local role = Context.get("GamerLocal").data.role
        local unit = role.data.unit
    
        local item = jass.UnitItemInSlot(unit,0)
    
        if(item) then
            jass.SetItemUserData(item,("[id=$id,icType=1,icValue=1]")
                :gsub("$id",UUID.random())
            )
    
            print("设置消耗品UserData",jass.GetItemUserData(item))
        else
            print("设置消耗品UserData","error")
        end
    end)
    
    Order.registerEvent("-alt","按下/释放alt键",function(id,msg)
        local flag = Context.get("key_alt")
        Context.put("key_alt",not flag)
    end)
    
    Order.registerEvent("-showCommon","打印Items.data.common",function(id,msg)
        -- for k,v in pairs (Items.data.common) do
        --     local item = v[1]
        --     print("找到一个物品",
        --         "item=",jass.GetHandleId(item),
        --         "itemTypeId=",jass.GetItemTypeId(item),
        --         "id=",jass.GetItemUserData(item),
        --         "name=",jass.GetItemName(item),
        --         "bind=",tostring(v[2])
        --     )
        -- end
        table.print(Items.data.common)
    end)
    
    Order.registerEvent("-showCurrent","打印Items.data.current",function(id,msg)
        for k,v in pairs (Items.data.current) do
            local item = v[1]
            print("找到一个物品",
                "item=",jass.GetHandleId(item),
                "itemTypeId=",jass.GetItemTypeId(item),
                "id=",jass.GetItemUserData(item),
                "name=",jass.GetItemName(item),
                "bind=",tostring(v[2])
            )
        end
    end)
    
    Order.registerEvent("-showCharges","",function(id,msg)
        local unit = Context.get("GamerLocal").data.role.data.unit
        local item = jass.UnitItemInSlot(unit,0)
        print("showCharges",item,jass.GetItemCharges(item))
    end)
    
    Order.registerEvent("-showGamers","",function(id,msg)
        print("玩家数量",Gamer.getNumber())
    
        for i=0,5,1 do
            local gamer = Context.get("Gamers")[i]
    
            print("玩家"..i, "是玩家:"..tostring(gamer.isGamer()))
        end
    end)
    
    Order.registerEvent("-sa","显示A00G",function(id,msg)
        local gamer = Context.get("GamerLocal")
        local role = gamer.data.role
        local u = role.data.unit
        local p = role.data.partner
    
        print("sa1:",jass.GetUnitAbilityLevel(u,Id.string2id("A000")))
        print("sa2:",jass.GetUnitAbilityLevel(p,Id.string2id("A000")))
    end)

    Order.registerEvent("-unlock","解锁天赋",function(id,msg)
        local gamer = Context.get("GamerLocal")
        local role = gamer.data.role
        local talents = role.data.abilities.talent

        for i=1,4,1 do
            if (talents[i] == -101) then
                talents[i] = -102
            end
        end
        
        Interface.GUI.update_talent(role)
    end)

end

--测试英雄
do
    local gamer =Context.get("GamerLocal")
    local rc = require "scripts.luas.constants.Roles"
    local u= rc.getByName("格尔文")
    gamer.createRole(u) --创建英雄
    local role = gamer.data.role

    -- role.data.abilities.ability = {
    --     Id.string2id('AHbz'),
    --     Id.string2id('AHtb'),
    --     Id.string2id('AHre'),
    --     Id.string2id('AHab'),
    -- }

    -- role.data.abilities.talent = {
    --     Id.string2id('AHpx'),
    --     Id.string2id('AHtc'),
    --     Id.string2id('AHfs'),
    --     Id.string2id('AHdr'),
    -- }

    --设置英雄属性
    -- local unitParam = gamer.data.role_params

    -- unitParam.primaryType =2
    -- unitParam.primaryStr = "敏捷"

    -- unitParam.extra_param.primary   = 14
    -- unitParam.extra_param.stamina   = 5
    -- unitParam.extra_param.spirit    = 6

    -- unitParam.extra_param.attack    = 125
    -- unitParam.extra_param.atkrate   = 0.03
    -- unitParam.extra_param.phydef    = 23
    -- unitParam.extra_param.mgcdef    = 16
    -- unitParam.extra_param.citical   = 0.05
    -- unitParam.extra_param.health    = 220
    -- unitParam.extra_param.mana      = 123
    -- unitParam.extra_param.hrcv      = 0.006
    -- unitParam.extra_param.mrcv      = 0.005
    -- unitParam.extra_param.speed     = 20

    -- table.print(unitParam)
    -- table.print(unitParam.calcRoleParam())
    --添加金钱
    gamer.addResource(10000,10000)
end

--测试物品
do
    local Items = require 'scripts.luas.core.entity.Items'
    Items.loot("I000",{660,-1340},20)
    Items.loot("I001",{660,-1340},20)
    Items.loot(Id.string2id("afac"),{660,-1340},0)
    
    jass.TimerStart(jass.CreateTimer(),3,false,function()
        print("设置属性")
        local item_afac_arr = Items.findItemCommonTest2(Id.string2id("afac"))
        local item_afac = item_afac_arr[1]
        print("item_afac",#item_afac_arr,item_afac)
        --添加bind
        local item_afac_hid = jass.GetHandleId(item_afac)
        local itemp = Items.data.common[item_afac_hid]
        itemp[2] = {
            lv = 10,
            qt = 3,
            type = 10,
            atk = 10,
            asp = 10,
            armor = 1,
            p1 = {
                type = 0,
                value = 120,
            },
            p3 = {
                type = 20,
                value = 0.05,
            }
        }
    end)

    --uitest 添加物品栏物品
    -- for i=0,2,1 do
    --     jass.UnitAddItem(gamer.data.role.data.unit, jass.CreateItem(Id.string2id('ratf'),0,0))
    -- end
    -- jass.UnitAddItem(gamer.data.role.data.unit, jass.CreateItem(Id.string2id('lgdh'),0,0))
    -- jass.UnitAddItem(gamer.data.role.data.unit, jass.CreateItem(Id.string2id('sbch'),0,0))

    --注册商店
    local shopUnit = jass.CreateUnit(jass.Player(6),Id.string2id("hpea"),600,-1340,0)
    Interface.Shop.registerEvent(shopUnit,{
        [1] = {
            itemTypeId = "spsh",
            charges = 1,
        },
        [3] = {
            itemTypeId = "I00A",
            charges = 99,
        },
    })
end

--测试抽卡
do
    Order.registerEvent("-card","显示A00G",function(id,msg)
        -- local card_list =Items.getCardList("talent")
        local card_list = {
            [1] = {
                index = 0x0006,--分裂
                art = [[card\talent\card6.blp]],
                qt = 3,
            },
            [2] = {
                index =0x0007 ,--弹射
                art = [[card\talent\card7.blp]],
                qt = 1,
            },
            [3] = {
                index = 0x0008,--穿透
                art = [[card\talent\card8.blp]],
                qt = 1,
            },
            [4] = {
                index = 0x0029, --希望之花
                art = [[card\talent\card41.blp]],
                qt = 1,
            },
        }

        CardControl.open(card_list)
    end)
end

print("----test stop----")