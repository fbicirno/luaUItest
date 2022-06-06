local Object = require 'scripts.luas.utils.object.ObjectUtils'
local roleConstant = require 'scripts.luas.constants.Roles'
local Id = require 'scripts.luas.utils.id.Id'

local _pack = {
    data={
        template_health = {
            [0] = 800,
            [1] = 600,
            [2] = 700,
            [3] = 600,
        },
        
        template_mana = {
            [0] = 500,
            [1] = 500,
            [2] = 400,
            [3] = 750,
        },

        template_speed = 180,
        template_hrcv = 0.25,
        template_mrcv = 0.15,
        template_citrate = 1.5,

        --玩家角色 属性模板
        --[[
            没有主属性区分 分为：面板属性 隐藏属性
            伤害相关：
                攻击强度%
                攻击速度%
                法术强度%
                冷却时间%
                暴击几率%
                暴击伤害%  基础1.5倍
                {武器伤害 武器速度 技能伤害 技能冷却}
            防御相关：
                生命上限%
                生命回复%
                魔法上限%
                魔法回复%
                物理防御%
                魔法防御%
                移动速度%
                护甲类型 {攻防表}
            
            隐藏属性：
                命中 
                闪避
                吸血
                吸蓝
                全伤害加成
                物理加成
                魔法加成
                基础生命值  {800 750 600}
                基础魔法值  {600 650 700}
                基础移动     180
                基础生命回复 0.25
                基础魔法回复 0.15

            攻防表{
                     普通攻击 穿刺攻击 魔法攻击 法术攻击 物理攻击 
                无甲  110     100      100     100      110
                轻甲  90      100      110     90       90
                重甲  80      90       100     90       80
                魔免  100     100      0       0        100
                虚无  0       0        110     110      0
                无敌  0       0        0       0        0 
            }

            基础属性大多数为0 所以百分比加成为 add*(1+百分比)
            百分比加成词条取一条最高的计算
            add属性需要换算 

            例如
                1 移动速度 基础=180  add=100  rate= 15%  即面板显示 180* [1+(100/60)%]* (1+15%) = 210.44
                2 攻击强度 add=220 rate=25%  calc_param中攻击强度= 220 * (1+25%) = 275
                    武器伤害=100 攻击强度275  实际武器伤害= 100* [1+(275/60)%] = 104.5
        ]]
        template_role = {
            role_class = 0, --0战士 1刺客 2射手 3法师
            
            --面板属性 int型 {初始+数值加成+百分百加成}
            base_param = {
                attack  = 0,   --攻击强度
                atkrate = 0,   --攻击速度
                magic   = 0,   --法术强度
                haste   = 0,   --冷却速度
                citical = 0,   --暴击几率
                citrate = 0,   --暴击伤害

                health  = 0,   --生命上限
                mana    = 0,   --魔法上限
                hrcv    = 0,   --生命恢复
                mrcv    = 0,   --魔法恢复
                phydef  = 0,   --物理防御
                mgcdef  = 0,   --魔法防御
                speed   = 0,   --移动速度

                dodge   = 0,   --闪避
                hit     = 0,   --命中
            },
            
            --计算属性
            calc_param = {
                attack  = 1,   --攻击强度%
                atkrate = 1,   --攻击速度% [光环模拟]
                magic   = 1,   --法术强度%
                citical = 1,   --暴击几率%
                citrate = 1,   --暴击伤害%
                haste   = 1,   --冷却速度%

                health  = 0,   --生命上限 [=japi直接设置]
                mana    = 0,   --魔法上限 [=japi直接设置]
                hrcv    = 0,   --生命恢复 [光环模拟]
                mrcv    = 0,   --魔法恢复 [光环模拟]
                speed   = 0,   --移动速度% [光环模拟]
                phydef  = 1,   --物理防御% [=伤害系统]
                mgcdef  = 1,   --魔法防御% [=伤害系统]
                
                hit     = 1,   --命中%
                dodge   = 1,   --闪避% 
                block   = 1,   --格挡%
                absorb  = 0,   --吸收%
                abhealth= 0,   --吸血% [攻击伤害的%用于回血]
                abmana  = 0,   --吸蓝% [技能伤害的%用于回蓝]

                phyRate = 1,   --物理伤害加成
                mgcRate = 1,   --魔法伤害加成
                allRate = 1,   --全伤害加成

                armorType = 0, --护甲类型
                weapAtk   = 0, --武器伤害
                weapRate  = 0, --武器攻速
                weapDt    = 0, --武器伤害类型
            },

            --数值加成
            add_param = {
                attack  = 0,   --攻击强度
                atkrate = 0,   --攻击速度
                magic   = 0,   --法术强度
                haste   = 0,   --冷却速度
                citical = 0,   --暴击几率
                citrate = 0,   --暴击伤害

                health  = 0,   --生命上限
                mana    = 0,   --魔法上限
                hrcv    = 0,   --生命恢复
                mrcv    = 0,   --魔法恢复
                phydef  = 0,   --物理防御
                mgcdef  = 0,   --魔法防御
                speed   = 0,   --移动速度
            },

            --百分比加成
            rate_param = {
                attack  = 1,   --攻击强度
                atkrate = 1,   --攻击速度
                magic   = 1,   --法术强度
                haste   = 1,   --冷却速度
                citical = 1,   --暴击几率
                citrate = 1,   --暴击伤害

                health  = 1,   --生命上限
                mana    = 1,   --魔法上限
                hrcv    = 1,   --生命恢复
                mrcv    = 1,   --魔法恢复
                phydef  = 1,   --物理防御
                mgcdef  = 1,   --魔法防御
                speed   = 1,   --移动速度

                hit     = 1,   --命中% (天赋属性)
                dodge   = 1,   --闪避% (天赋属性)
                block   = 1,   --格挡% (盾牌属性)
                absorb  = 1,   --吸收% (盾牌属性)
                abhealth= 1,   --吸血% (天赋属性)
                abmana  = 1,   --吸蓝% (天赋属性)
            },

            --法球效果
            orbs = {},

            --触发效果
            trig = {},
        },

        --精英 属性模板
        template_boss = {
            base_param = {

            },
            orbs = {},

            trig = {},
        },

        --单位 属性模板
        -- 单位同场存在多个一模一样属性的单位 所以根据单位类型区分 公用同一张表
        template_unit = {
            base_param = {},
        },
    }
}

local function getInitTypeByUnitTypeId(unitTypeId)
    local templateId = "template"
    local primaryType = 0
    return templateId,primaryType
end

--创建属性表
--@param unitTypeId 单位类型
-- 自动根据单位类型创建模板
function _pack.create(unitTypeId)
    --是玩家英雄单位
    if (roleConstant.untiTypeIdGroup(unitTypeId)) then
        local t = table.clone(_pack.data.template_role)
        local slk = jslk.unit[Id.id2string(unitTypeId)]

        --根据主属性和武器类型判断职业
        if (slk.Primary == "AGI")then
            t.role_class = 0
        elseif (slk.Primary == "INT")then
            t.role_class = 3
        elseif (slk.weapTp1 == "normal")then
            t.role_class = 1
        else
            t.role_class = 2
        end

        --设置初始值
        t.base_param.dodge = 30 --1级闪避
        t.base_param.hit = 50   --1级命中
        t.calc_param.health = _pack.data.template_health[t.role_class] --根据职业 1级生命值
        t.calc_param.mana = _pack.data.template_mana[t.role_class]     --根据职业 1级魔法值
        t.calc_param.speed = _pack.data.template_speed
        t.calc_param.hrcv = _pack.data.template_hrcv
        t.calc_param.mrcv = _pack.data.template_mrcv
        t.calc_param.citrate = _pack.data.template_citrate --基础爆伤1.5

        setmetatable(t,{
            __newindex = function()
                print("error:","UnitParam","不能插入新的属性！")
                print(debug.traceback())
            end
        })

        return t
    end

    
    local t 

    --非玩家英雄单位
    if (jass.IsHeroUnitId(unitTypeId))then
        t = table.clone(_pack.data.template_boss)

    else
    --非玩家普通单位
        t = table.clone(_pack.data.template_unit)

    end

    setmetatable(t,{
        __newindex = function()
            print("error:","UnitParam","不能插入新的属性！")
        end
    })

    return t
end

return _pack