local Context = require 'scripts.luas.core.applic.Context'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
local Id = require 'scripts.luas.utils.id.Id'
local Items = require 'scripts.luas.core.entity.Items'
local ItemGameTypeContants = require 'scripts.luas.constants.ItemGameType'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local Console= require 'scripts.luas.utils.envir.Console'
local TooltipTemplates = require 'scripts.luas.constants.Tooltips'
local Camera = require "scripts.luas.utils.envir.Camera"
local Object =require 'scripts.luas.utils.object.ObjectUtils'
local Saves = require 'scripts.luas.core.behavior.Saves'
local roleConstant = require 'scripts.luas.constants.Roles'
local Color = require 'scripts.luas.constants.Color'

-- 界面绘制
local _pack = {
    data = {
        tooltip_size_w = 0.24,
        tooltip_size_h = 0.04, --0.05;
        tooltip ={},

        skillOld  ={},
        skillDrop ={},
        black     ={},
        hui       ={},
        bar       ={},
        talent    ={},

        currentBoss = nil,
    }
}

function _pack.closeTip()
    dzapi.FrameShow( _pack.data.tooltip[0],false)
end

--显示tooltip
-- 1技能 p1 index0-4 p2 unit
-- 2天赋/宝具  p1 skill对象 p2 unit
-- 3物品无实例 p1 from [2商店 3商城] p2 itTypeId p3 bind
-- 4物品有实例 p1 from [0背包 1物品栏  4银行-玩家物品 5银行-商城物品]   p2 item_handle
-- 5单位头像 p1单位
-- 6存档  p1内容
function _pack.showTip(type,...)
    local params = {...}

    if(type == 1) then
        local index = params[1] --本地英雄是index 其他单位是abilityTypeId
        local unit = params[2]

        --建筑技能/帝国/骑空/晶兽
        local gid = jass.GetPlayerId(jass.GetOwningPlayer(unit))
        if(jass.IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE) or gid >=7) then
            do return end
            --@TODO
            --直接显示
            local skill,_,_ = jmessage.button(2,i)
            if (not skill) then 
                print("没有技能 跳过")
                return 
            end

            local lv = jass.GetUnitAbilityLevel(unit,skill)
            local slk = jslk.ability[Id.id2string(skill)]
            local name = slk.Tip:split(",")[lv]
            local tip = string.insertSlk(skl.Ubertip:split(",")[lv]):gsub("%%","%%%%")
            
            dzapi.FrameSetText(_pack.data.tooltip[1],name)

            --cd
            dzapi.FrameSetTexture(_pack.data.tooltip[2],"ui\\widgets\\battlenet\\bnet-tournament-clock.blp",0)
            dzapi.FrameSetText(_pack.data.tooltip[3],"")
            dzapi.FrameSetText(_pack.data.tooltip[3],slk["Cool"..lv])
            --mana
            dzapi.FrameSetTexture(_pack.data.tooltip[4],"ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp",0)
            dzapi.FrameSetText(_pack.data.tooltip[5],"")
            dzapi.FrameSetText(_pack.data.tooltip[5],slk["Cost"..lv])
            --icon3 hidden
            dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
            dzapi.FrameSetText(_pack.data.tooltip[7],"")

            local content = TooltipTemplates.template_skill
            content = content
                :gsub("$lv",lv)
                :gsub("$type","技能")
                :gsub("$tip",tip)

            dzapi.FrameSetText(_pack.data.tooltip[8],content)
            dzapi.FrameShow( _pack.data.tooltip[0],true)
            return
        end

        --其他玩家技能不显示
        if (not gid == jass.GetPlayerId(jass.GetLocalPlayer())) then
            return
        end

        --本地玩家技能
        local gamer = Context.get("GamerLocal")
        local role = gamer.data.role
        skill = role.data.abilities.ability[index+1]

        --判断技能是否存在
        if (not skill or skill.index == -102) then
            return
        end

        local lv = skill.lv
        local cardBase = Items.getCardBase(skill.index)
        local name = Color.getColorStringByQt(cardBase.name,cardBase.quality)
        local slk = jslk.ability["AHbz"] --jslk.ability[Id.id2string(cardBase.ability)]
        local tip = string.insertSlk(string.split(slk.Ubertip,[=[","]=])[lv]):gsub("%%","%%%%")

        dzapi.FrameSetText(_pack.data.tooltip[1],name)

        --cd
        dzapi.FrameSetTexture(_pack.data.tooltip[2],"ui\\widgets\\battlenet\\bnet-tournament-clock.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[3],"")
        dzapi.FrameSetText(_pack.data.tooltip[3],slk["Cool"..lv])
        --mana
        dzapi.FrameSetTexture(_pack.data.tooltip[4],"ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[5],"")
        dzapi.FrameSetText(_pack.data.tooltip[5],slk["Cost"..lv])
        --icon3 hidden
        dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[7],"")

        local content = TooltipTemplates.template_skill
        content = content
            :gsub("$lv",lv)
            :gsub("$type","技能")
            :gsub("$tip",tip)

        dzapi.FrameSetText(_pack.data.tooltip[8],content)
        dzapi.FrameShow( _pack.data.tooltip[0],true)

    elseif (type ==2) then
        local skill = params[1] --role.data.abilities.talent[]  {index: lv:}
        local unit = params[2]

        local lv = skill.lv
        local cardBase = Items.getCardBase(skill.index) --confg.cards.ability[]  {...}
        local type = Items.getCardType(skill.index)
        local name = Color.getColorStringByQt(cardBase.name,cardBase.quality)
        local tip = cardBase.uber:gsub("%%","%%%%")

        print("显示天赋/宝具")
        table.print(skill)

        -- local slk = jslk.ability["AHbz"] --jslk.ability[Id.id2string(cardBase.ability)]
        -- local tip = string.insertSlk(string.split(slk.Ubertip,[=[","]=])[lv]):gsub("%%","%%%%")

        dzapi.FrameSetText(_pack.data.tooltip[1],name)

        --cd
        dzapi.FrameSetTexture(_pack.data.tooltip[2],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[3],"")
        --mana
        dzapi.FrameSetTexture(_pack.data.tooltip[4],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[5],"")
        --icon3 hidden
        dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[7],"")

        local content = TooltipTemplates.template_skill
        content = content
            :gsub("$lv",lv)
            :gsub("$type",type)
            :gsub("$tip",tip)

        dzapi.FrameSetText(_pack.data.tooltip[8],content)
        dzapi.FrameShow( _pack.data.tooltip[0],true)

    elseif (type==3)then
        local from = params[1]
        local itTypeId = params[2]
        local bind = params[3]
        local slk = jslk.item[itTypeId]

        local name = Color.getColorStringByQt(slk.Name,bind.qt)
        local tip = string.insertTip(slk.Ubertip):gsub("%%","%%%%")
        local gold = slk.goldcost
        local lumb = slk.lumbercost
        dzapi.FrameSetText(_pack.data.tooltip[1],name)
        
        dzapi.FrameSetTexture(_pack.data.tooltip[2],"img\\ui\\gold.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[3],"")
        dzapi.FrameSetTexture(_pack.data.tooltip[4],"img\\ui\\jewel.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[5],"")
        dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[7],"")

        local content = TooltipTemplates.template_item --值传递

        --添加灰字
        if (from == 2) then --2商店 
            content = content:gsub("$add0","|cff808080点击左键购买(商店)|r|n")

            dzapi.FrameSetText(_pack.data.tooltip[3],gold)
            dzapi.FrameSetText(_pack.data.tooltip[5],lumb)
        end

        if(from == 3) then --3商城
            content = content:gsub("$add0","|cff808080点击左键购买(商城)|r|n")

            dzapi.FrameSetText(_pack.data.tooltip[3],gold)
            dzapi.FrameSetText(_pack.data.tooltip[5],lumb)
        end

        local itemGameBaseType = Items.getItemGameBaseType(itTypeId)

        -- 装备 
        if(itemGameBaseType <=20) then
            local itExType = Items.getItemGameExType(itTypeId)
            content = content:gsub("$add0",""):gsub("$add2","")
                :gsub("$lv",jass.GetItemLevel(item)) 
                :gsub("$only","")
                :gsub("$tip","随机生成属性")

            if(itExType <=19)then
                content = content:gsub("$type","武器")
                :gsub("$add1","武器类型:" .. ItemGameTypeContants.EX_TYPE_NAME[itExType] .. "|n")
            else
                content = content:gsub("$type","装备")
                :gsub("$add1","装备类型:".. ItemGameTypeContants.EX_TYPE_NAME[itExType] .. "|n")
            end

        elseif (itemGameBaseType == 50) then
            content = content:gsub("$add0",""):gsub("$add1",TooltipTemplates.template_ingem):gsub("$add2","|n"):gsub("$tip","")
                :gsub("$lv",jass.GetItemLevel(item)) 
                :gsub("$type","镶嵌宝石")
                :gsub("$only","")
                :gsub("$p1",ItemGameTypeContants.PARAMS[bind.type])

                if (bind.type <=19) then
                    --数值类
                    content=content:gsub("$p2",bind.value)
                else
                    --百分比类
                    content=content:gsub("$p2",bind.value*100 .. "%%")
                end
        else
            content = content:gsub("$add0",""):gsub("$add1",""):gsub("$add2","|n")
                :gsub("$lv",1) 
                :gsub("$type",tostring(ItemGameTypeContants.BASE_TYPE_NAME[itemGameBaseType]) .. "/" .. tostring(ItemGameTypeContants.EX_TYPE_NAME[itExType]))
                :gsub("$only","")
                :gsub("$tip",tip)
        end

        dzapi.FrameSetText(_pack.data.tooltip[8],content)
        dzapi.FrameShow( _pack.data.tooltip[0],true)
        
    elseif (type ==4) then
        local from = params[1]
        local item = params[2]
        local itTypeId = jass.GetItemTypeId(item)
        local slk = jslk.item[Id.id2string(itTypeId)]

        local itHid = jass.GetHandleId(item)
        local itemp = Items.data.current[itHid] or Items.data.common[itHid]
        local itemBind= itemp[2] or Items.getItemInitBind(itTypeId)

        local itemId = jass.GetItemUserData(item)
        local itemGameBaseType = Items.getItemGameBaseType(item)
        local itExType = Items.getItemGameExType(item)

        local name = Color.getColorStringByQt(slk.Name,itemBind.qt)
        local tip = string.insertTip(slk.Ubertip):gsub("%%","%%%%")
        local gold = tonumber(slk.goldcost)
        local lumb = tonumber(slk.lumbercost)

        dzapi.FrameSetText(_pack.data.tooltip[1],name)
        dzapi.FrameSetTexture(_pack.data.tooltip[2],"img\\ui\\gold.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[3],"")
        dzapi.FrameSetTexture(_pack.data.tooltip[4],"img\\ui\\jewel.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[5],"")
        dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[7],"")

        local content = TooltipTemplates.template_item --值传递

        --添加灰字
        if(from == 0) then --0背包
            if (itemGameBaseType <=20 or itemGameBaseType == 50) then
                content = content:gsub("$add0","|cff808080点击左键打开强化面板(背包)|r|n" )
            elseif (itemGameBaseType == 30) then
                content = content:gsub("$add0","|cff808080点击左键使用物品(背包)|n按住alt后点击左键分离物品(背包)|r|n")
            elseif (itemGameBaseType >= 40)then
                content = content:gsub("$add0","|cff808080按住alt后点击左键分离物品(背包)|r|n")
            end

            dzapi.FrameSetText(_pack.data.tooltip[3],tostring(math.floor(gold/2)))
            dzapi.FrameSetText(_pack.data.tooltip[5],tostring(math.floor(lumb/2)))
        end

        if (from == 1 ) then -- 1物品栏
            if (itemGameBaseType ==20 or itemGameBaseType == 30) then
                content = content:gsub("$add0","|cff808080点击左键使用(物品栏)|r|n")
            end

            dzapi.FrameSetText(_pack.data.tooltip[3],tostring(math.floor(gold/2)))
            dzapi.FrameSetText(_pack.data.tooltip[5],tostring(math.floor(lumb/2)))
        end

        if(from ==4) then --4 银行
            content = content:gsub("$add0","|cff808080银行物品|r|n" )
            dzapi.FrameSetText(_pack.data.tooltip[3],tostring(math.floor(gold/2)))
            dzapi.FrameSetText(_pack.data.tooltip[5],tostring(math.floor(lumb/2)))
        end

        content = content:gsub("$add0","")

         -- 装备 
        if(itemGameBaseType <=20) then
            content = content:gsub("$add2",TooltipTemplates.template_equip)
            
            -- 武器（攻击力+攻速）
            if(itExType >=11 and itExType <=19) then    
                content = content:gsub("$add1",TooltipTemplates.template_weap_add)
                    :gsub("$lv",jass.GetItemLevel(item)) 
                    :gsub("$type","武器") 
                    :gsub("$only","[装备唯一]") 
                    :gsub("$aty",ItemGameTypeContants.EX_TYPE_NAME[itExType]) --武器类型
                    :gsub("$atk",itemBind.atk)   --武器伤害
                    :gsub("$asp",itemBind.asp)   --武器攻速
                    :gsub("$adt",ItemGameTypeContants.EX_WEAP_DT[itExType]) --伤害类型

            -- 胸甲（护甲类型）
            elseif (itExType ==20)then 
                content = content:gsub("$add1",TooltipTemplates.template_chest_add)
                    :gsub("$lv",jass.GetItemLevel(item)) 
                    :gsub("$type","装备")
                    :gsub("$only","[装备唯一]") 
                    :gsub("$ety","胸甲") 
                    :gsub("$cdt",ItemGameTypeContants.EX_ARMOR_DT[itemBind.armor])

            -- 魔盾/饰品/翅膀/称号 （唯一）
            elseif (itExType >=21 and  itExType <=25)then 
                content = content:gsub("$add1",TooltipTemplates.template_equip_add)
                    :gsub("$lv",jass.GetItemLevel(item)) 
                    :gsub("$type","装备")
                    :gsub("$ety",ItemGameTypeContants.EX_TYPE_NAME[itExType]) 
                    :gsub("$only","[装备唯一]") 

            --其他
            else 
                content = content:gsub("$add1",TooltipTemplates.template_equip_add)
                    :gsub("$lv",jass.GetItemLevel(item)) 
                    :gsub("$type","装备")
                    :gsub("$ety",ItemGameTypeContants.EX_TYPE_NAME[itExType]) 
                    :gsub("$onlyone","")
            end
            
            --处理4条属性
            content = content:gsub("$add2",TooltipTemplates.template_equip)

            if (itemBind.p1 and itemBind.p1.type) then
                content = content:gsub("$p1",
                    ItemGameTypeContants.PARAMS[itemBind.p1.type] .. "+" .. itemBind.p1.value
                )
            else
                content = content:gsub("$p1","无")
            end

            if (itemBind.p2 and itemBind.p2.type) then
                if(itemBind.p2.type>=20)then
                    content = content:gsub("$p2",
                        ItemGameTypeContants.PARAMS[itemBind.p2.type] .. "+" .. itemBind.p2.value*100 .. "%%" .. "[唯一]"
                    )
                else
                    content = content:gsub("$p2",
                        ItemGameTypeContants.PARAMS[itemBind.p2.type] .. "+" .. itemBind.p2.value
                    )
               end
            else
                content = content:gsub("$p2","可镶嵌")
            end

            if (itemBind.p3 and itemBind.p3.type) then
                if(itemBind.p3.type>=20)then
                    content = content:gsub("$p3",
                        ItemGameTypeContants.PARAMS[itemBind.p3.type] .. "+" .. itemBind.p3.value*100 .. "%%" .. "[唯一]"
                    )
                else
                    content = content:gsub("$p3",
                        ItemGameTypeContants.PARAMS[itemBind.p3.type] .. "+" .. itemBind.p3.value
                    )
               end
            else
                content = content:gsub("$p3","可镶嵌")
            end

            if (itemBind.p4 and itemBind.p4.type) then
                if(itemBind.p4.type>=20)then
                    content = content:gsub("$p4",
                        ItemGameTypeContants.PARAMS[itemBind.p4.type] .. "+" .. itemBind.p4.value*100 .. "%%" .. "[唯一]"
                    )
                else
                    content = content:gsub("$p4",
                        ItemGameTypeContants.PARAMS[itemBind.p4.type] .. "+" .. itemBind.p4.value
                    )
               end
            else
                content = content:gsub("$p4","可镶嵌")
            end

            --添加说明和灰字
            content = content:gsub("$tip",tip)

        -- 镶嵌石头
        elseif (itemGameBaseType == 50) then
            
            content = content:gsub("$add0",""):gsub("$add1",TooltipTemplates.template_ingem):gsub("$add2","|n"):gsub("$tip","")
                :gsub("$lv",jass.GetItemLevel(item)) 
                :gsub("$type","镶嵌宝石")
                :gsub("$only","")
                :gsub("$p1",ItemGameTypeContants.PARAMS[itemBind.type])
                
                if (itemBind.type <=19) then
                    --数值类
                    content=content:gsub("$p2",itemBind.value)
                else
                    --百分比类
                    content=content:gsub("$p2",itemBind.value*100 .. "%%" .. "[唯一]")
                end
        else
            -- 其他 直接显示ubertip
            content = content:gsub("$add0",""):gsub("$add1",""):gsub("$add2","|n")
                :gsub("$lv",1) 
                :gsub("$type",tostring(ItemGameTypeContants.BASE_TYPE_NAME[itemGameBaseType]) .. "/" .. tostring(ItemGameTypeContants.EX_TYPE_NAME[itExType]))
                :gsub("$only","")
                :gsub("$tip",tip)
        end

        dzapi.FrameSetText(_pack.data.tooltip[8],content)
        dzapi.FrameShow( _pack.data.tooltip[0],true)

    elseif (type ==5) then
        local unit = params[1]

        if(not unit) then return end

        local role = Context.get("GamerLocal").data.role
        if (role and unit == role.data.unit) then
            --如果是玩家角色
            local gamer = Context.get("GamerLocal")
            local role_param = gamer.data.role_params
            local lv = jass.GetUnitLevel(gamer.data.role.data.unit)
        
            dzapi.FrameSetText(_pack.data.tooltip[1],jass.GetUnitName(gamer.data.role.data.unit))

            dzapi.FrameSetTexture(_pack.data.tooltip[2],"img\\alpha.blp",0)
            dzapi.FrameSetText(_pack.data.tooltip[3],"")

            dzapi.FrameSetTexture(_pack.data.tooltip[4],"img\\alpha.blp",0)
            dzapi.FrameSetText(_pack.data.tooltip[5],"")

            dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
            dzapi.FrameSetText(_pack.data.tooltip[7],"")

            dzapi.FrameSetText(_pack.data.tooltip[8],
                string.formatSimpleTip(TooltipTemplates.template_role,12,
                    lv, roleConstant.class[role_param.role_class],
                    role_param.base_param.attack,   role_param.base_param.atkrate,
                    role_param.base_param.magic,    role_param.base_param.haste,
                    role_param.base_param.citical,  role_param.base_param.citrate,
                    role_param.base_param.phydef,   role_param.base_param.mgcdef,
                    role_param.calc_param.health,   role_param.calc_param.hrcv,
                    role_param.calc_param.mana,     role_param.calc_param.mrcv,
                    role_param.calc_param.speed,    ItemGameTypeContants.EX_ARMOR_DT[role_param.calc_param.armorType],
                    role_param.calc_param.weapAtk,  role_param.calc_param.weapRate 
                )
            )

            dzapi.FrameShow( _pack.data.tooltip[0],true)
            return
        end

        --建筑不显示
        if (jass.IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE))then
            return
        end

        --其他玩家英雄\玩家伙伴\中立英雄 不显示
        local gid = jass.GetPlayerId(jass.GetOwningPlayer(unit))
        if (gid<=6 or gid ==13 or gid ==14)then
            print("跳过")
            return
        end

        --普通单位\议会单位\帝国单位\其他玩家单位
        dzapi.FrameSetText(_pack.data.tooltip[1],jass.GetUnitName(unit))

        dzapi.FrameSetTexture(_pack.data.tooltip[2],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[3],"")

        dzapi.FrameSetTexture(_pack.data.tooltip[4],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[5],"")

        dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[7],"")

        -- 等级:%s  攻击:%s
        -- 物防:%s  法防:%s 
        -- 生命:%s  回血:%s
        -- 魔法:%s  回蓝:%s
        -- 移动     护甲
        local unitTypeId = jass.GetUnitTypeId(unit)
        local slk = jslk.unit[Id.id2string(unitTypeId)]

        dzapi.FrameSetText(_pack.data.tooltip[8], 
            string.formatSimpleTip(TooltipTemplates.template_unit,12,
                jass.GetUnitLevel(unit),jass.GetUnitState(unit,jass.ConvertUnitState(0x12)),
                "10%","10%",
                math.floor(jass.GetUnitState(unit,jass.UNIT_STATE_MAX_LIFE)),string.GetPreciseDecimal(slk.regenHP,2),
                math.floor(jass.GetUnitState(unit,jass.UNIT_STATE_MAX_MANA)),string.GetPreciseDecimal(slk.regenMana,2),
                math.floor(slk.spd), ItemGameTypeContants.EX_GAMER_DEFTYPE[slk.defType]
            )
        )

        dzapi.FrameShow( _pack.data.tooltip[0],true)
        print("1111")
        return

    elseif (type ==6) then
        dzapi.FrameSetText(_pack.data.tooltip[1],"存档信息:")

        dzapi.FrameSetTexture(_pack.data.tooltip[2],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[3],"")

        dzapi.FrameSetTexture(_pack.data.tooltip[4],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[5],"")

        dzapi.FrameSetTexture(_pack.data.tooltip[6],"img\\alpha.blp",0)
        dzapi.FrameSetText(_pack.data.tooltip[7],"")

        local info = params[1]
        dzapi.FrameSetText(_pack.data.tooltip[8], 
            string.formatSimpleTip(TooltipTemplates.template_save,12,
                info.type,             
                info.currentTime,info.countTime,
                info.bankItem,info.skins,
                info.storeCurrency
            )
        )

        dzapi.FrameShow( _pack.data.tooltip[0],true)

    
    end
end

function _pack.showSysTip(id,type)
end

function _pack.init_tooltip()
    -- 原生提示框
    local h = dzapi.FrameGetTooltip()
    dzapi.FrameClearAllPoints(h);
    -- dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --技能tip
    _pack.data.tooltip[0] = dzapi.CreateFrame("myTooltipDrop1",dzapi.FrameGetGameUI(),0);
    _pack.data.tooltip[1] = dzapi.FrameFindByName("myTooltipName1",0) --name

    _pack.data.tooltip[2] = dzapi.FrameFindByName("myTooltipIcon1",0)      --icon1
    _pack.data.tooltip[3] = dzapi.FrameFindByName("myTooltipIconValue1",0) --iconValue1

    _pack.data.tooltip[4] = dzapi.FrameFindByName("myTooltipIcon2",0)      --icon2
    _pack.data.tooltip[5] = dzapi.FrameFindByName("myTooltipIconValue2",0) --iconValue2

    _pack.data.tooltip[6] = dzapi.FrameFindByName("myTooltipIcon3",0)      --icon3
    _pack.data.tooltip[7] = dzapi.FrameFindByName("myTooltipIconValue3",0) --iconValue3

    _pack.data.tooltip[8] = dzapi.CreateFrame("myTootip1",_pack.data.tooltip[0],0);

    dzapi.FrameSetAbsolutePoint(_pack.data.tooltip[8], "BOTTOMLEFT", 0.58, 0.1);
    dzapi.FrameSetPoint(_pack.data.tooltip[0],"TOPLEFT",_pack.data.tooltip[8],"TOPLEFT",-0.006,0.04)
    dzapi.FrameSetPoint(_pack.data.tooltip[0],"BOTTOMLEFT",_pack.data.tooltip[8],"BOTTOMLEFT",-0.006,-0.01)

    dzapi.FrameShow( _pack.data.tooltip[0],false)

    --物品背包tip
    --_pack.data.tooltip[10] = dzapi.CreateFrame("myTooltipDrop1",dzapi.FrameGetGameUI(),1);


    --天赋 宝具tip

    --头像 存档tip
end

function _pack.showBossBar(unit)
    _pack.data.currentBoss = unit

    --设置名字
    local name = "|cFFFF0000" .. jass.GetUnitName(unit) .. "|r"
    dzapi.FrameSetText(_pack.data.hui[307],name)
    
    --设置头像
    local slk = jslk.unit[Id.id2string(jass.GetUnitTypeId(unit))]
    local icon = "img\\alpha.blp"
    if (slk) then
        icon = slk.Art
    end
    dzapi.FrameSetTexture(_pack.data.hui[305],icon)

    dzapi.FrameShow(_pack.data.hui[305],true)
end

function _pack.closeBossBar()
    _pack.data.currentBoss = nil
end

function _pack.init_buff()
    --英雄主属性
    local h=dzapi.SimpleFrameFindByName("SimpleInfoPanelIconHero",6);
    dzapi.FrameClearAllPoints(h);
    dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --攻击一
    h = dzapi.SimpleTextureFindByName("InfoPanelIconBackdrop",0); 
    dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --攻击二
    h = dzapi.SimpleTextureFindByName("InfoPanelIconBackdrop",1); 
    dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --护甲图标
    h = dzapi.SimpleTextureFindByName("InfoPanelIconBackdrop",2); 
    dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --物品名字
    h = dzapi.SimpleFontStringFindByName("SimpleItemNameValue",3);
    dzapi.FrameClearAllPoints(h);

    --物品描述
    h = dzapi.SimpleFontStringFindByName("SimpleItemDescriptionValue",3);
    dzapi.FrameClearAllPoints(h);

    --建造面板
    h= dzapi.SimpleFrameFindByName("SimpleInfoPanelBuildingDetail",1);
    dzapi.FrameClearAllPoints(h);
    dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --装载面板
    h= dzapi.SimpleFrameFindByName("SimpleInfoPanelCargoDetail",2);
    dzapi.FrameClearAllPoints(h);
    dzapi.FrameSetAbsolutePoint(h,"CENTER", 1, 1);

    --盟友信息
    h= dzapi.SimpleFrameFindByName("SimpleInfoPanelIconAlly",7);
    dzapi.FrameClearAllPoints(h);
    dzapi.FrameSetAbsolutePoint(h, "CENTER", 1, 1);

    --经验条
    h=dzapi.SimpleFrameFindByName("SimpleHeroLevelBar",0);
    dzapi.FrameClearAllPoints(h);

    -- h = dzapi.SimpleFontStringFindByName("SimpleClassValue",0); --经验条中的文字
    -- dzapi.FrameClearAllPoints(h);
    -- dzapi.FrameSetPoint(h, "CENTER", dzapi.SimpleFrameFindByName("SimpleHeroLevelBar",0), "CENTER", 0, 0);

    --英雄名字 单位名字
    h = dzapi.SimpleFontStringFindByName("SimpleNameValue",0);
    dzapi.FrameClearAllPoints(h);

    --buff栏
    h = dzapi.SimpleFrameFindByName("SimpleInfoPanelUnitDetail",0);
    dzapi.FrameClearAllPoints(h);
    dzapi.FrameSetSize(h,0.2,0.1);
    dzapi.FrameSetPoint(h ,"BOTTOMLEFT", _pack.data.hui[0], "TOPLEFT", -0.07, -0.009);

    dzapi.FrameShow(h,true)
end

function _pack.update_invt(unit)
    for i=0,5,1 do
        local it = jass.UnitItemInSlot(unit,i)
        if (it) then
            dzapi.FrameSetTexture(_pack.data.hui[21+i],"img\\alpha.blp")
        else
            dzapi.FrameSetTexture(_pack.data.hui[21+i],"img\\ui_new\\UI_BagEmpty.blp")
        end
    end
end

function _pack.update_talent(role)
    if (role == nil) then
        -- print("update_talent role is nil")
        for i=1,4,1 do
            dzapi.FrameSetTexture(_pack.data.hui[10+i],Items.getCardIcon(-101))
        end
        return
    end
    
    local talents = role.data.abilities.talent
    for i=1,4,1 do
        local talent = talents[i]

        if(not talent or talent.index == -102) then
            local icon = Items.getCardIcon(-102)
            dzapi.FrameSetTexture(_pack.data.hui[10+i],icon)
        else
            local icon = Items.getCardIcon(talent.index)
            dzapi.FrameSetTexture(_pack.data.hui[10+i],icon)
        end
    end
end

function _pack.update_card(role)
    for i=0,5,1 do

    end
end

function _pack.update_skill(role)
    for i=0,3,1 do

    end
end

function _pack.update_selfHead(role)
    local unit = role.data.unit
    local pt = role.data.partner

    --英雄图标
    local slk = jslk.unit[Id.id2string(jass.GetUnitTypeId(unit))]
    local icon = "img\\alpha.blp"
    if (slk)then
        icon = slk.Art
    end
    dzapi.FrameSetTexture(_pack.data.hui[300],icon)
    
    --如果单位死亡 显示遮罩层
    if(bj.isDeath(unit))then
        dzapi.FrameShow(_pack.data.hui[301],true)
    else
        dzapi.FrameShow(_pack.data.hui[301],false)
    end

    --伙伴图标
    slk = jslk.unit[Id.id2string(jass.GetUnitTypeId(pt))]
    icon = "img\\alpha.blp"
    if (slk)then
        icon = slk.Art
    end
    dzapi.FrameSetTexture(_pack.data.hui[303],icon)
end

function _pack.update(unit)
    local Role = require 'scripts.luas.core.gamer.Role'
    local currentRole = Role.getInstanceByUnit(unit)

    _pack.update_invt(unit)
    _pack.update_talent(currentRole)
    _pack.update_card(currentRole)
    _pack.update_skill(currentRole)
end

--@init 
function _pack.init()
    local h;
    dzapi.LoadToc( "custom.toc" )

    --头像区
    do
        --背景黑
        _pack.data.black[0] = dzapi.CreateFrame("BLACK",dzapi.FrameGetGameUI(),0)
        dzapi.FrameSetSize(_pack.data.black[0],0.22,0.029)
        dzapi.FrameSetAbsolutePoint(_pack.data.black[0],"TOPLEFT",0,0.093)

        _pack.data.black[1] = dzapi.CreateFrame("BLACK",_pack.data.black[0],1)
        dzapi.FrameSetSize(_pack.data.black[1],0.003,0.07)
        dzapi.FrameSetAbsolutePoint(_pack.data.black[1],"TOPLEFT",0.001,0.065)

        _pack.data.black[2] = dzapi.CreateFrame("BLACK",_pack.data.black[0],2)
        dzapi.FrameSetSize(_pack.data.black[2],0.004,0.07)
        dzapi.FrameSetAbsolutePoint(_pack.data.black[2],"TOPLEFT",0.058,0.065)

        _pack.data.black[3] = dzapi.CreateFrame("BLACK",_pack.data.black[0],3)
        dzapi.FrameSetSize(_pack.data.black[3],0.06,0.004)
        dzapi.FrameSetAbsolutePoint(_pack.data.black[3],"TOPLEFT",0.000,0.008)

        _pack.data.black[4] = dzapi.CreateFrame("BLACK",_pack.data.black[0],4)
        dzapi.FrameSetSize(_pack.data.black[4],0.16,0.036)
        dzapi.FrameSetAbsolutePoint(_pack.data.black[4],"TOPLEFT",0.06,0.04)

        _pack.data.black[5] = dzapi.CreateFrame("BLACK",_pack.data.black[0],5)
        dzapi.FrameSetSize(_pack.data.black[5],0.16,0.025)
        dzapi.FrameSetAbsolutePoint(_pack.data.black[5],"TOPLEFT",0.06,0.04+0.025)

        --背景边框
        _pack.data.hui[0] =dzapi.CreateFrame("HeadBG", _pack.data.black[0], 0)
        dzapi.FrameSetAbsolutePoint( _pack.data.hui[0],"BOTTOMLEFT", 0.00, 0 )

        _pack.data.hui[1] = dzapi.CreateFrame("HeadBorder", dzapi.FrameGetGameUI(), 0)
        dzapi.FrameSetPoint(_pack.data.hui[1], "TOPLEFT", _pack.data.hui[0], "TOPLEFT",0.002, -0.02 )

        h = dzapi.FrameGetPortrait() --单位头像
        dzapi.FrameClearAllPoints( h)
        dzapi.FrameSetSize( h, 0.055, 0.055 )
        dzapi.FrameSetPoint(h, "TOPLEFT", _pack.data.hui[1], "BOTTOMLEFT",0.005,  -0.002)
        dzapi.FrameShow(h, true )

        dzapi.RegisterFrameEvent(dzapi.FrameGetPortrait(),
            function()
                _pack.showTip(5,jmessage.selection()) --5头像
            end,
            _pack.closeTip
        )

        --单位名字
        _pack.data.hui[2] = dzapi.FrameFindByName("UnitNameText",0)

        --物品栏标题
        _pack.data.hui[20] = dzapi.CreateFrame("BagTitle", dzapi.FrameGetGameUI(), 0)
        dzapi.FrameSetPoint(_pack.data.hui[20], "TOPLEFT",_pack.data.hui[1], "TOPRIGHT",0.02484*2.4, -0.004)

        --物品栏 21-26drop 27-32border
        for i=0,5,1 do
            _pack.data.hui[21+i] = dzapi.CreateFrameByTagName("BACKDROP","BagDrop",_pack.data.hui[20],"template",0)
            dzapi.FrameSetSize( _pack.data.hui[21+i],0.022,0.022)
            dzapi.FrameSetPoint( _pack.data.hui[21+i], "TOPLEFT",_pack.data.hui[1], "BOTTOMRIGHT",i*0.02484, 0 )
            dzapi.FrameSetTexture(_pack.data.hui[21+i],"img\\alpha.blp")

            _pack.data.hui[27+i] = dzapi.CreateFrame("BagBG",_pack.data.hui[20],i)
            dzapi.FrameSetPoint( _pack.data.hui[27+i], "TOPLEFT",_pack.data.hui[1], "BOTTOMRIGHT",i*0.02484, 0 )

            h = dzapi.FrameGetItemBarButton(i)
            dzapi.FrameClearAllPoints(h)
            dzapi.FrameSetAllPoints(h, _pack.data.hui[21+i])
        end

        --天赋标题
        _pack.data.hui[10] = dzapi.CreateFrame("BagTitle", dzapi.FrameGetGameUI(), 1)
        dzapi.FrameSetText(_pack.data.hui[10],"天赋")
        dzapi.FrameSetPoint(_pack.data.hui[10], "TOPLEFT",_pack.data.hui[1], "BOTTOMRIGHT",0.002, -0.034)

        --天赋 11-14drop 15-18border 33-36btn
        for i=0,3,1 do
            _pack.data.hui[11+i] = dzapi.CreateFrameByTagName("BACKDROP","talent_drop",_pack.data.hui[10],"template",0)
            dzapi.FrameSetSize( _pack.data.hui[11+i],0.02484,0.02484)
            dzapi.FrameSetPoint(_pack.data.hui[11+i], "TOPLEFT",_pack.data.hui[1], "BOTTOMRIGHT",(i+1)*0.02484, -0.03 )
            dzapi.FrameSetTexture(_pack.data.hui[11+i],"img\\alpha.blp")

            _pack.data.hui[15+i] = dzapi.CreateFrame("BagBG", _pack.data.hui[10],i)
            dzapi.FrameSetAllPoints(_pack.data.hui[15+i],_pack.data.hui[11+i])

            _pack.data.hui[33+i] = dzapi.CreateFrameByTagName("BUTTON","talent_button",_pack.data.hui[10],"template",0)
            dzapi.FrameSetAllPoints(_pack.data.hui[33+i],_pack.data.hui[11+i])

            dzapi.RegisterFrameEvent(_pack.data.hui[33+i],
                function(frame,event) --移入
                    local gamer = Context.get("GamerLocal")
                    local role = gamer.data.role
                    local unit = jmessage.selection()
                    if (not unit==role.data.unit) then
                        return
                    end

                    for i=0,3,1 do
                        if (frame == _pack.data.hui[33+i])then
                            print("移入天赋",i)
                            local talent = role.data.abilities.talent[i+1]
                            if (not talent or talent.index <0) then
                                return
                            end
                            _pack.showTip(2,talent,unit)
                            break
                        end
                    end
                end,
                _pack.closeTip
            )
        end
    end

    --控制台区
    do
        _pack.data.black[6] = dzapi.CreateFrame("BLACK",dzapi.FrameGetGameUI(),6)
        dzapi.FrameSetSize(_pack.data.black[6],0.058,0.04)
        dzapi.FrameSetAbsolutePoint( _pack.data.black[6],"TOPLEFT", 0.3, 0.1)

        _pack.data.black[7] = dzapi.CreateFrame("BLACK",_pack.data.black[6],7)
        dzapi.FrameSetSize(_pack.data.black[7],0.012,0.04)
        dzapi.FrameSetAbsolutePoint( _pack.data.black[7],"TOPLEFT", 0.383, 0.1)

        _pack.data.black[8] = dzapi.CreateFrame("BLACK",_pack.data.black[6],8)
        dzapi.FrameSetSize(_pack.data.black[8],0.012,0.04)
        dzapi.FrameSetAbsolutePoint( _pack.data.black[8],"TOPLEFT", 0.423, 0.1)

        _pack.data.black[9] = dzapi.CreateFrame("BLACK",_pack.data.black[6],9)
        dzapi.FrameSetSize(_pack.data.black[9],0.012,0.04)
        dzapi.FrameSetAbsolutePoint( _pack.data.black[9],"TOPLEFT", 0.463, 0.1)

        _pack.data.black[10] = dzapi.CreateFrame("BLACK",_pack.data.black[6],10)
        dzapi.FrameSetSize(_pack.data.black[10],0.058,0.04)
        dzapi.FrameSetAbsolutePoint( _pack.data.black[10],"TOPLEFT", 0.463+0.04, 0.1)

        _pack.data.black[11] = dzapi.CreateFrame("BLACK",_pack.data.black[6],11)
        dzapi.FrameSetSize(_pack.data.black[11],0.27,0.1)
        dzapi.FrameSetAbsolutePoint( _pack.data.black[11],"TOPLEFT", 0.30, 0.064)

        _pack.data.hui[50] = dzapi.CreateFrame("HpMpBG", _pack.data.black[6], 0)
        dzapi.FrameSetAbsolutePoint( _pack.data.hui[50],"CENTER", 0.43, 0.00 )

        --技能
        local key = {"Q","W","E","R"}
        for i=0,3,1 do
            _pack.data.hui[51+i] = dzapi.CreateFrame("SkillBG", _pack.data.hui[50], i)
            dzapi.FrameSetPoint(_pack.data.hui[51+i],"TOPLEFT",_pack.data.hui[50],"TOPLEFT",0.084+i*0.04,-0.056)

            h =  dzapi.CreateFrame("SkillBGKey", _pack.data.hui[51+i], i)
            dzapi.FrameSetPoint(h,"BOTTOM",_pack.data.hui[51+i],"BOTTOM",0,-0.002)
            dzapi.FrameSetText(h,key[i+1])

            h = dzapi.FrameGetCommandBarButton(2,i)
            dzapi.FrameClearAllPoints(h)
            dzapi.FrameSetAllPoints(h,_pack.data.hui[51+i])

            dzapi.RegisterFrameEvent(h,
                function(frame,event) --移入
                    for i=0,3,1 do
                        if (frame == dzapi.FrameGetCommandBarButton(2,i))then
                            print("移入技能",i)
                            _pack.showTip(1,i,jmessage.selection())
                        end
                    end
                end,
                _pack.closeTip
            )
        end

        --血条
        _pack.data.hui[60] = dzapi.CreateFrame("HpBar", _pack.data.black[6], 0)
        dzapi.FrameSetAbsolutePoint( _pack.data.hui[60],"TOPLEFT", 0.32, 0.06 )

        _pack.data.hui[61] = dzapi.CreateFrame("MpBar", _pack.data.hui[60], 0)
        _pack.data.hui[62] = dzapi.CreateFrame("ExpBar", _pack.data.hui[60], 0)

        dzapi.FrameShow(_pack.data.hui[60],false)

        _pack.data.bar[0] = dzapi.FrameFindByName("HpFill",0)
        _pack.data.bar[1] = dzapi.FrameFindByName("HpBarText",0)

        _pack.data.bar[2] = dzapi.FrameFindByName("MpFill",0)
        _pack.data.bar[3] = dzapi.FrameFindByName("MpBarText",0)

        _pack.data.bar[4] = dzapi.FrameFindByName("ExpFill",0)
        _pack.data.bar[5] = dzapi.FrameFindByName("ExpBarText",0)

        --获取生命周期条
        h= dzapi.SimpleFrameFindByName("SimpleProgressIndicator", 0);
        --  dzapi.FrameClearAllPoints(h);
        --  dzapi.FrameSetSize(h , 0.065, 0.015);
        --  dzapi.FrameSetPoint(h, "BOTTOMLEFT",dzapi.FrameGetPortrait(), "BOTTOMRIGHT", 0, 0.03 );
         
        _pack.data.hui[90] = _pack.data.black[6]

        --宝具 91-96图标 70-75边框 77-82数字背景 84-89数字  62-69宝具btn 
        for i=0,5,1 do
            _pack.data.hui[91+i] = dzapi.CreateFrameByTagName("BACKDROP","myCardDrop", _pack.data.hui[90+i],"template",0)
            dzapi.FrameSetTexture(_pack.data.hui[91+i],"img\\ui_new\\UI_BagEmpty.blp")
            dzapi.FrameSetSize( _pack.data.hui[91+i],0.026,0.026)
            dzapi.FrameSetPoint(_pack.data.hui[91+i],"TOPLEFT",_pack.data.hui[50],"TOPLEFT",0.046+i*0.04,-0.0052)

            _pack.data.hui[70+i] = dzapi.CreateFrame("CardBG", _pack.data.hui[91+i], i)
            dzapi.FrameSetPoint(_pack.data.hui[70+i],"TOPLEFT",_pack.data.hui[50],"TOPLEFT",0.044+i*0.04,-0.005)

            _pack.data.hui[77+i] = dzapi.CreateFrame("CardNumBG",  _pack.data.hui[70+i], i)
            dzapi.FrameSetPoint(_pack.data.hui[77+i],"BOTTOMRIGHT",_pack.data.hui[70+i],"BOTTOMRIGHT",0,0)

            _pack.data.hui[84+i] = dzapi.CreateFrame("CardNumText", _pack.data.hui[76+i], i)
            dzapi.FrameSetPoint(_pack.data.hui[84+i],"CENTER",_pack.data.hui[76+i],"CENTER",0,0)

            _pack.data.hui[62+i] = dzapi.CreateFrameByTagName("BUTTON","myCardBtn", _pack.data.hui[90+i],"template",0)
            dzapi.FrameSetAllPoints(_pack.data.hui[62+i],_pack.data.hui[70+i])

            dzapi.RegisterFrameEvent(_pack.data.hui[62+i],
                function(frame,event)
                    local gamer = Context.get("GamerLocal")
                    local role = gamer.data.role
                    local unit  = jmessage.selection()

                    if (not unit == role.data.unit) then
                        return
                    end

                    for i=0,5,1 do
                        if (frame == _pack.data.hui[62+i]) then
                            print("移入宝具",i)
                            local card = role.data.abilities.card[i+1]
                            if (not card or card.index <0) then
                                return
                            end
                            _pack.showTip(2,card,unit)
                            break
                        end
                    end

                    _pack.showTip(5,jmessage.selection()) --5头像
                end,
                _pack.closeTip
            )

            dzapi.FrameShow(_pack.data.hui[77+i],false)
        end
    end

    --小地图
    do  
        h = dzapi.FrameGetMinimap() 
        dzapi.FrameClearAllPoints(h)
        dzapi.FrameSetAbsolutePoint(h, "BOTTOMRIGHT", 0.80, 0.00 )
        dzapi.FrameSetSize( h, 0.11, 0.11 )
        dzapi.FrameShow( h, true )

        _pack.data.hui[200] =  dzapi.CreateFrame("MapBG", dzapi.FrameGetGameUI(), 0)
        dzapi.FrameSetAbsolutePoint( _pack.data.hui[200],"BOTTOMRIGHT", 0.80, 0 )
    end

    --菜单按钮
    do
        --右侧菜单 hui[101-107]
         for i=101,109,1 do
            _pack.data.hui[i] = dzapi.CreateFrame("myUiButton",dzapi.FrameGetGameUI(),i);
            dzapi.FrameSetPoint(_pack.data.hui[i],"TOPRIGHT",dzapi.FrameGetGameUI(),"TOPRIGHT",-0.002,-0.2-(i-101)*0.025);
            -- dzapi.FrameSetAlpha(_pack.data.hui[i],180);

            --              101      102       103       104      105       106      107        108       109
            local name = {" 任  务"," 菜  单"," 商  城"," 存  档"," 背  包","虚空银行","界面重置"," 帮  助"," 统  计",}
            dzapi.FrameSetText(dzapi.FrameFindByName("myUiButtonText",i ),name[i-100]);

            dzapi.RegisterFrameEvent(_pack.data.hui[i],
                function(frame,event) --移入
                    if(frame == _pack.data.hui[104]) then--save
                        local saveInfo = Saves.getCurrentSaveInfo()
                        if (saveInfo) then
                            _pack.showTip(6,saveInfo)
                        end
                    end
                end,
                function(frame,event) --移出
                    if(frame == _pack.data.hui[104]) then--save
                        _pack.closeTip()
                    end
                end,
                function(frame,event) --点击
                    --101 102
                    if(frame == _pack.data.hui[103]) then
                        --@Interface
                        print("点击store")

                    elseif(frame == _pack.data.hui[104]) then
                        --@Interface
                        print("点击save")

                    elseif(frame == _pack.data.hui[105]) then
                        print("点击backpack")
                        --@Interface
                        Interface.Backpack.toggle()

                    elseif(frame == _pack.data.hui[106]) then
                        --@Interface
                        print("点击bank")
                        Interface.Bank.toggle()

                    elseif(frame == _pack.data.hui[107]) then
                        --@Interface
                        print("点击reset")  
                
                    elseif(frame == _pack.data.hui[108]) then
                        --@Interface
                        print("点击help")
                    elseif(frame == _pack.data.hui[109]) then
                        --@Interface
                        print("点击record")
                    end
                end
            )

            --原生任务
            h = dzapi.FrameGetUpperButtonBarButton(0)
            dzapi.FrameShow(h)
            dzapi.FrameClearAllPoints(h)
            dzapi.FrameSetAllPoints(h,_pack.data.hui[101])

            --原生菜单
            h = dzapi.FrameGetUpperButtonBarButton(1)
            dzapi.FrameShow(h)
            dzapi.FrameClearAllPoints(h)
            dzapi.FrameSetAllPoints(h,_pack.data.hui[102])

        end
    end

    --目标boss
    do
        --当前英雄头像
        _pack.data.hui[300] = dzapi.CreateFrameByTagName("BACKDROP","Hero1",dzapi.FrameGetGameUI(),"template",0)
        dzapi.FrameSetSize(_pack.data.hui[300],0.035,0.035)
        dzapi.FrameSetTexture(_pack.data.hui[300],"img\\alpha.blp")
        dzapi.FrameSetAbsolutePoint(_pack.data.hui[300],"TOPLEFT",0.004,0.585)

        --死亡时的遮罩层
        _pack.data.hui[301] = dzapi.CreateFrameByTagName("BACKDROP","Hero1_gray",_pack.data.hui[300],"template",0)
        dzapi.FrameSetAllPoints(_pack.data.hui[301],_pack.data.hui[300])
        -- dzapi.FrameSetTexture(_pack.data.hui[301],"UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp")
        dzapi.FrameSetTexture(_pack.data.hui[301],"img\\ui_new\\UI_DeathLayer.blp")
        dzapi.FrameSetAlpha(_pack.data.hui[301],0.65)
        dzapi.FrameShow(_pack.data.hui[301],false)

        _pack.data.hui[302] = dzapi.CreateFrameByTagName("BUTTON","Hero1_btn",_pack.data.hui[300],"template",0)
        dzapi.FrameSetAllPoints(_pack.data.hui[302],_pack.data.hui[300])
        dzapi.RegisterFrameEvent(_pack.data.hui[302],nil,nil,function()
            --点击移动镜头
            local unit = Context.get("GamerLocal").data.role.data.unit
            Camera.moveUnit(unit)

            jass.ClearSelection()
            jass.SelectUnit(unit,true)
        end)

        --当前伙伴头像
        _pack.data.hui[303] = dzapi.CreateFrameByTagName("BACKDROP","Hero2",_pack.data.hui[300],"template",0)
        dzapi.FrameSetTexture(_pack.data.hui[303],"img\\alpha.blp")
        dzapi.FrameSetSize(_pack.data.hui[303],0.035,0.035)
        dzapi.FrameSetPoint(_pack.data.hui[303],"TOP",_pack.data.hui[300],"BOTTOM",0,-0.006)

        _pack.data.hui[304] = dzapi.CreateFrameByTagName("BUTTON","Hero1_btn",_pack.data.hui[303],"template",0)
        dzapi.FrameSetAllPoints(_pack.data.hui[304],_pack.data.hui[303])
        dzapi.RegisterFrameEvent(_pack.data.hui[304],nil,nil,function()
            --点击移动镜头
            local unit = Context.get("GamerLocal").data.role.data.partner
            Camera.moveUnit(unit)

            jass.ClearSelection()
            jass.SelectUnit(unit,true)
        end)

        --敌对单位头像
        _pack.data.hui[305] =  dzapi.CreateFrame("Topaim", dzapi.FrameGetGameUI(), 0)
        dzapi.FrameSetAbsolutePoint( _pack.data.hui[305],"TOPLEFT", 0.225, 0.585 )

        _pack.data.hui[306] = dzapi.CreateFrameByTagName("BUTTON","Hero1_btn",_pack.data.hui[305],"template",0)
        dzapi.FrameSetAllPoints(_pack.data.hui[306],_pack.data.hui[305])

        _pack.data.hui[307] = dzapi.FrameFindByName("TopaimName"  ,0)--boss名字
        _pack.data.hui[308] = dzapi.FrameFindByName("TopaimHpfill",0)--血条
        _pack.data.hui[309] = dzapi.FrameFindByName("TopaimHPtext",0)--血量文字
        _pack.data.hui[310] = dzapi.FrameFindByName("TopaimMpfill",0)--蓝条
        _pack.data.hui[311] = dzapi.FrameFindByName("TopaimMPtext",0)--蓝量文字

        dzapi.RegisterFrameEvent(_pack.data.hui[306],
            function()
                --移入显示tooltip
                if (_pack.data.currentBoss)then
                    _pack.showTip(5,_pack.data.currentBoss)
                end
            end,function()
                --移出
                _pack.closeTip()
            end,function()
                --点击移动镜头
                if (_pack.data.currentBoss) then
                    Camera.moveUnit(_pack.data.currentBoss)
                end
            end)

        dzapi.FrameShow(_pack.data.hui[305],false)
    end
    
    --系统消息
    h = dzapi.FrameGetUnitMessage();
    dzapi.FrameClearAllPoints(h);
    dzapi.FrameSetPoint(h ,"BOTTOMLEFT", _pack.data.hui[0], "TOPLEFT", 0.002, 0.01);

    _pack.init_tooltip()
    _pack.init_buff()

    --暴露接口
    do
        Interface.GUI = {}

        --隐藏hui
        Interface.GUI.setShow = function(flag)
            if(flag) then
                --显示hui
            else
                --隐藏hui
            end
        end

        Interface.GUI.showTip = _pack.showTip
        Interface.GUI.closeTip = _pack.closeTip
        Interface.GUI.showSysTip = _pack.showSysTip
        Interface.GUI.update = _pack.update

        Interface.GUI.update_invt = _pack.update_invt
        Interface.GUI.update_talent = _pack.update_talent
        Interface.GUI.update_card = _pack.update_card
        Interface.GUI.update_skill = _pack.update_skill
        Interface.GUI.update_selfHead = _pack.update_selfHead
    end

     --捕捉alt ctrl
     if(japi.CreateTexture) then
         local index = japi.CreateTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp",1,1,1,1,0xFFFFFFFF,0)
         japi.TextureAddEvent(index,0x12, function ()
             Context.put("key_alt",true)
         end,function ()
             Context.put("key_alt",false)
         end)

         japi.TextureAddEvent(index,0x11, function ()
            Context.put("key_ctrl",true)
        end,function ()
            Context.put("key_ctrl",false)
        end)
     end

    --选择单位时
    Trigger.registerEvent("select_local",function()
        local unit = jass.GetTriggerUnit();

        --设置名字
        local name = jass.GetUnitName(unit)
        dzapi.FrameSetText(_pack.data.hui[2],name)

        --判断ui
        local role = Context.get("GamerLocal").data.role
        if (not role) then return end --还没选择角色  跳出
        role = role.data.unit

        --如果是敌对单位 选中英雄 显示boss血条
        if(jass.IsUnitEnemy(unit,jass.Player(0))) then
            jass.ClearSelection()
            jass.SelectUnit(role,true)
            _pack.showBossBar(unit)
            return
        end

        --是否显示宝具
        dzapi.FrameShow( _pack.data.hui[91],unit==role);
   
        --是否显示天赋
        dzapi.FrameShow( _pack.data.hui[10],unit==role);
        
        --是否显示物品栏
        if (jass.GetUnitAbilityLevel(unit,Id.string2id('AInv'))>=1) then
            dzapi.FrameShow( _pack.data.hui[20], true);
            dzapi.FrameShow( _pack.data.black[5], false);
        else
            dzapi.FrameShow( _pack.data.hui[20], false);
            dzapi.FrameShow( _pack.data.black[5], true);
        end

        --是否显示血条
        dzapi.FrameShow(_pack.data.hui[60],jass.GetUnitAbilityLevel(unit, Id.string2id('Avul'))==0)

        --是否显示蓝条
        dzapi.FrameShow(_pack.data.hui[61],jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)>0)

        --是否显示经验条
        dzapi.FrameShow(_pack.data.hui[62],unit==role)

        _pack.update(unit)
    end);

    --取消选中单位事件  
    Trigger.registerEvent("deselect_local",function()
        dzapi.FrameSetText(_pack.data.hui[2],"")

        --隐藏宝具
        dzapi.FrameShow( _pack.data.hui[91],false)

        --隐藏天赋
        dzapi.FrameShow(_pack.data.hui[10],false)

        --隐藏物品栏
        dzapi.FrameShow( _pack.data.hui[20], false)
        dzapi.FrameShow( _pack.data.black[5], true)

        --隐藏血条 蓝条 经验条
        dzapi.FrameShow(_pack.data.hui[60],false)
        dzapi.FrameShow(_pack.data.hui[61],false)
        dzapi.FrameShow(_pack.data.hui[62],false)

        -- 等待0.5秒 如果没有选择单位则选中英雄
        CenterTimer.addTrace(nil,{
            delay = 500,
            loop = false,
            callback = function()
                local unit = jmessage.selection()
                if (not unit) then
                    local role = Context.get("GamerLocal").data.role.data.unit
                    jass.ClearSelection()
                    jass.SelectUnit(role,true)
                end
            end
        })
    end);

    --血条
    jass.TimerStart(jass.CreateTimer(),0.01,true,function()
        local unit = jmessage.selection()

        --经验条
        local gamer = Context.get("GamerLocal")
        if(gamer and gamer.data.role) then
            local role1 = gamer.data.role.data.unit
            if(unit == role1) then
                local rate = gamer.data.currentExp / gamer.data.maxExp
                dzapi.FrameSetSize(_pack.data.bar[4],0.2135* rate+0.0001,0.0134)
                dzapi.FrameSetText(_pack.data.bar[5],
                    gamer.data.currentExp .. "/" .. gamer.data.maxExp
                )
            end
        end
        
        if (unit) then

            --生命
            dzapi.FrameSetSize(_pack.data.bar[0],0.2135* bj.GetUnitLifePercent(unit),0.0134);
            dzapi.FrameSetText(_pack.data.bar[1],
                math.floor(jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)) .. "/"..
                math.floor(jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE))
            )

            --魔法
            dzapi.FrameSetSize(_pack.data.bar[2],0.2135* bj.GetUnitManaPercent(unit),0.0134);
            dzapi.FrameSetText(_pack.data.bar[3],
                math.floor(jass.GetUnitState(unit, jass.UNIT_STATE_MANA) ).. "/" ..
                math.floor(jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA))
            )
        end

        --boss条
        if (_pack.data.currentBoss) then
            if (bj.isAlive(_pack.data.currentBoss)) then
                --目标存活中
                dzapi.FrameSetSize(_pack.data.hui[308],0.3* bj.GetUnitLifePercent(_pack.data.currentBoss),0.01);
                dzapi.FrameSetText(_pack.data.hui[309],
                    math.floor(jass.GetUnitState(_pack.data.currentBoss, jass.UNIT_STATE_LIFE)) .. "/"..
                    math.floor(jass.GetUnitState(_pack.data.currentBoss, jass.UNIT_STATE_MAX_LIFE))
                )
                
                --boss蓝条
                if (jass.GetUnitState(_pack.data.currentBoss, jass.UNIT_STATE_MAX_MANA) <=0) then
                    dzapi.FrameSetSize(_pack.data.hui[310],0.3,0.01);
                    dzapi.FrameSetText(_pack.data.hui[311],"0/0")
                else
                    dzapi.FrameSetSize(_pack.data.hui[310],0.3* bj.GetUnitManaPercent(_pack.data.currentBoss),0.01);
                    dzapi.FrameSetText(_pack.data.hui[311],
                        math.floor(jass.GetUnitState(_pack.data.currentBoss, jass.UNIT_STATE_MANA)) .. "/"..
                        math.floor(jass.GetUnitState(_pack.data.currentBoss, jass.UNIT_STATE_MAX_MANA))
                    )
                end
            else    
                --目标死亡 隐藏boss bar
                _pack.data.currentBoss = nil
                dzapi.FrameShow(_pack.data.hui[305],false)
            end
        end
    end);
   
    --按esc关闭所有弹出层
    local trig = jass.CreateTrigger()
    jass.TriggerRegisterPlayerEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_END_CINEMATIC)
    jass.TriggerAddAction(trig,function()
        Interface.Backpack.close()
        Interface.Bank.close()
        Interface.Shop.close()
        Interface.stroe.close()
    end)
end

return _pack
