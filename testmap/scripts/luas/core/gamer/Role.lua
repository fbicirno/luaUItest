local UUID = require 'scripts.luas.utils.id.UUID'
local Id = require 'scripts.luas.utils.id.Id'
local Console= require 'scripts.luas.utils.envir.Console'
local Random = require 'scripts.luas.utils.id.Random'
local Damage = require 'scripts.luas.core.entity.Damage'
local Object =require 'scripts.luas.utils.object.ObjectUtils'
local Context = require 'scripts.luas.core.applic.Context'
local Items = require 'scripts.luas.core.entity.Items'

--角色类
local _pack = {}

function _pack.create(index,unit)
    local t = {
        type ="object@luas.core.gamer.Role",
        id = UUID.random(),
        data = {
            unit = nil,
            partner = nil,
            index = index,
            role_class = 0,

            --拥有卡牌
            abilities = {
                --{ index:config/cards/index lv: bind:}
                ability = {
                    [1] = nil,
                    [2] = nil,
                    [3] = nil,
                    [4] = nil,
                },
                --{ index:config/cards/index  lv: }   nil -102空  -101锁定
                talent = {
                    [1] = nil,
                    [2] = {
                        index = -101
                    },
                    [3] =  {
                        index = -101
                    },
                    [4] = {
                        index = -101
                    },
                },
                --{ index:config/cards/index num:}
                card = {
                    [1] = nil,
                    [2] = nil,
                    [3] = nil,
                    [4] = nil,
                    [5] = nil,
                    [6] = nil,
                }
            },

            --记录模板技能
            abiTemplate= {
                [1] = nil,
                [2] = nil,
                [3] = nil,
                [4] = nil,
            },

            --物品栏物品
            --保存的是handleId
            items = {
                [1] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                    [4] = 0,
                    [5] = 0,
                    [6] = 0, 
                },
                [2] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                    [4] = 0,
                    [5] = 0,
                    [6] = 0,
                }
            },

            --背包物品
            --保存的是handleId
            backp = {
                -- 1~36
            }
        }
    }

    setmetatable(t,{
        __index =  function(mytable,key)
            if (key == "create" or key == "init") then
                return nil
            end

            if (type(_pack[key]) == "function")then
                return function(...)
                    return _pack[key](mytable,...)
                end
            end
            
            return _pack[key]
        end,
	
	    __newindex = function()
            print("error:","Role","不能插入新的属性！")
        end
    })

    -- 创建单位
    local unitType = jass.GetUnitTypeId(unit)
    t.data.unit = jass.CreateUnit(jass.GetLocalPlayer(),unitType,660,-1340,0)
    t.data.partner = jass.CreateUnit(jass.GetLocalPlayer(),Id.string2id("H00K"),500,-1100,0)

    local slk = jslk.unit[Id.id2string(unitType)]
    --根据主属性和武器类型判断职业
    if (slk.Primary == "AGI")then
        t.data.role_class = 0
    elseif (slk.Primary == "INT")then
        t.data.role_class = 3
    elseif (slk.weapTp1 == "normal")then
        t.data.role_class = 1
    else
        t.data.role_class = 2
    end

    -- 拾取技能
    jass.UnitAddAbility( t.data.unit, Id.string2id('A000'));
    jass.UnitAddAbility( t.data.partner, Id.string2id('A000'));

    return t
end

-- 停止动作
function _pack.stop(this)
    local unit = this.data.unit
    jass.IssueImmediateOrderById(unit , 851972 )
end

-- 停止伙伴动作
function _pack.partnerStop(this)
    local unit = this.data.partner
    jass.IssueImmediateOrderById(unit , 851972 )
end

-- 设置位置
function _pack.position(this,x,y)
    local unit = this.data.unit
    -- 检查坐标
    jass.SetUnitX(x)
    jass.SetUnitY(y)
end

-- 设置伙伴位置
function _pack.partnerPosition(this,x,y)
    local unit = this.data.partner
    -- 检查坐标
    jass.SetUnitX(x)
    jass.SetUnitY(y)
end


-- 获取位置
function _pack.getPosition(this)
    local unit = this.data.unit
    return{
        jass.GetUnitX(x),
        jass.GetUnitY(y),
        0
    }
end

-- 获取伙伴位置
function _pack.partnerGetPosition(this)
    local unit = this.data.partner
    return{
        jass.GetUnitX(x),
        jass.GetUnitY(y),
        0
    }
end

-- 移动到
function _pack.move(this,x,y)
    local unit = this.data.unit
    x = x or 0
    y = y or 0
    jass.IssuePointOrderById(unit, 851986, x, y )
end

--伙伴移动到
function _pack.partnerMove(this,x,y)
    local unit = this.data.partner
    x = x or 0
    y = y or 0
    jass.IssuePointOrderById(unit, 851986, x, y )
end

--添加天赋
--@param index 卡牌index
--@param posi 1-4 位置
--@return int  1选定posi不可用 2已经4级不可升级 10成功
function _pack.addTalent(this,index,posi)
    local old = this.data.abilities.talent[posi]

    --判断是否不可用格子
    if(old and old.index == -101) then
        return 1
    end

    --天赋升级
    if (old and old.index == index) then
        if (old.lv <=3) then
            local name = Items.getCardName(index)
            old.lv = old.lv+1
            Console.system(string.format("获取天赋[%s]",name))
            Console.system(string.format("天赋[%s]升级为等级%d",name,old.lv))
            Damage.updateParam(this.data.index)
            return 10
        else
            Console.system("该天赋已满级!")
            return 2
        end
        return
    end

    --如果选定格子存在天赋
    if(old and old.index >0) then
        Damage.removeTalent(this.data.index,index)
    end

    --添加
    local cardBase = Items.getCardBase(index)
    this.data.abilities.talent[posi] = {
        index = index,
        lv = 1,
    }

    Damage.updateParam(this.data.index)
    Interface.GUI.update_talent(this)
    Console.system(string.format("获取天赋[%s]",cardBase.name))
end

--添加宝具
function _pack.addCard(this,index,posi,num)
end

--添加技能 
function _pack.addAbility(this,index,posi)
end

-- 根据英雄或伙伴获取role对象
function _pack.getInstanceByUnit(unit)
    local gamers = Context.get("Gamers")

    for i=0,5,1 do
        if (not gamers[i].data.isGamer) then
            --没有玩家时不执行
            break;
        end

        local role = gamers[i].data.role
        if (role) then
            if (role.data.unit == unit or role.data.partner == unit) then
                return role
            end
        end
    end

    return nil
end

return _pack