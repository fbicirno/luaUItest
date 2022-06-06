local Random = require 'scripts.luas.utils.id.Random'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
local Context = require 'scripts.luas.core.applic.Context'
local Console = require 'scripts.luas.utils.envir.Console'
local Id = require 'scripts.luas.utils.id.Id'
local UnitsBase = require 'scripts.config.units'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local AbiTemp = require "scripts.luas.core.entity.Ability.AbiTemp"

--伤害系统
-- 接管所有伤害 模拟法球、特效

--[[
    投射物系统：
        拦截单位被攻击事件，如果判断伤害来源单位为远程攻击(slk读取单位数据)
        模拟投射物
        投射物消失后回调 -> 调用平砍函数给伤害(不再通过受到伤害事件给伤害)

        近战单位不拦截，通过受到伤害事件->调用平砍函数给伤害

        【平砍函数】、【技能伤害函数】直接扣生命值(注意单位死亡)

    伤害拦截系统：
        拦截单位受到伤害事件，
            如果是平砍，（1）远程平砍跳出 （2）近战平砍调用【平砍函数】
            如果是技能

            任意单位释放技能-> 捕捉到释放单位，释放点，目标点位，目标点,释放技能
                ->根据释放单位和释放技能 计算伤害，目标列表， 创建特效
                ->技能伤害系统给伤害 
                ->被伤害拦截系统拦截
                ->计算减伤
                ->扣除生命值

    统计系统：

    核心函数：
    【单位受到伤害】【单位被攻击】【平砍伤害函数】【技能伤害函数】【减伤计算函数】

    --强制伤害 法术+锁链
    jass.UnitDamageTarget( src, aim, demage, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_SPIRIT_LINK, jass.WEAPON_TYPE_WHOKNOWS )
    --致死伤害 法术+暗影突袭
    jass.UnitDamageTarget( src, aim, damage, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_SHADOW_STRIKE, jass.WEAPON_TYPE_WHOKNOWS )
]]

local _pack = {
    data = {
        --成长系数 等级
        base_growup = {

            strenght_grawup = {
                param = {"attack"},
                growup = {2},
            },

            agility_grawup = {
                param = {"attack","atkrate"},
                growup = {1.2,0.02},
            },

            intellect_grawup = {
                param = {"attack","haste"},
                growup = {1,0.03},
            },

            stamina_grawup = {
                param = {"health","phydef","mgcdef"},
                growup = {25,12,12},
            },

            spirit_grawup = {
                param = {"mana","mrcv"},
                growup = {15,0.25},
            },

            level_grawup = {
                -- 生命 魔法 物防 魔防 回血 回蓝
                param = {"health","mana","phydef","mgcdef","hrcv","mrcv"},
                growup = {15,15,3,2,0.25,0.25}
            },

            primary_growup = {
                [0] = {2,3,1},  --坦克成长
                [1] = {3,2,1},  --战士成长
                [2] = {3,1,2},  --射手成长
                [3] = {3,1,3},  --法术成长
            },
        },

        --攻击特效
        onDamage = {},

        --被攻击特效
        beDamaged = {},
        
        --根据马甲技能判定 攻击特效
        -- key:abilityTypeId - value: 效果id
        tmpOnDamage = {},

        --根据马甲技能判定 被攻击特效
        -- key:abilityTypeId - value: 效果id
        tmpBeDamaged = {},

        --内部伤害数据记录
        --造成伤害统计
        damageStatistics = {
            [0] = {
                total = 0,
                current = 0,
            },
            [1] = {
                total = 0,
                current = 0,
            },
            [2] = {
                total = 0,
                current = 0,
            },
            [3] = {
                total = 0,
                current = 0,
            },
            [4] = {
                total = 0,
                current = 0,
            },
            [5] = {
                total = 0,
                current = 0,
            },
        },
        --造成治疗统计
        recoveryStatistics = {

        },
        --抗伤害统计
        hurtdStatistics = {}
    },

    --暴击伤害系数
    citicalRate = 1.5,
}

--是否远程攻击单位
local function isLongrangeUnit(u)
    local slk = jslk.unit[Id.id2string(jass.GetUnitTypeId(u))]
    return slk.atkType1 == "spells" or slk.atkType1 == "pierce" --攻击1类型为法术 或 穿刺
end

-- 获取伤害类型
-- @param dt 伤害类型
-- @param at 攻击类型
-- @param ia 是否攻击(平砍)
-- @return number  0未知 1 普攻近战 2普攻刺穿 3普攻魔法 4技能物理 5技能魔法 6技能通用 7强制伤害(约定) 8致死伤害(约定)
local function getDamageType(dt,at,ia)
    local cat = jass.ConvertAttackType(at) --转换攻击类型为handle
    local cdt = jass.ConvertAttackType(dt) --转化伤害类型为handle

    --是攻击伤害
    if(ia) then
        -- 近战   攻击类型：普通 伤害类型：普通 (可以被硬化皮肤减免 可以被艾露减免)
        if(jass.ATTACK_TYPE_MELEE == cat and jass.DAMAGE_TYPE_NORMAL == cdt) then
            return 1
        end

        --穿刺   攻击类型：穿刺 伤害类型普通 (可以被艾露减免)
        if (jass.ATTACK_TYPE_PIERCE == cat and jass.DAMAGE_TYPE_NORMAL == cdt)then
            return 2
        end

        --魔法  攻击类型:魔法 伤害类型普通   (魔法 不可被神秘腰带减免 可以被反魔法外壳吸收)
        if(jass.ATTACK_TYPE_MAGIC == cat and jass.DAMAGE_TYPE_NORMAL == cdt) then
            return 3
        end
       
        --其他
        print("攻击类型非 近战、穿刺、魔法")
        return 0
    end

    -- 是通用技能伤害 攻击类型：法术，伤害类型：通用
    -- (无视魔免，无视虚无，无视反魔法外壳)
    if(jass.ATTACK_TYPE_NORMAL == cat and jass.DAMAGE_TYPE_UNIVERSAL == cdt) then
        return 6
    end

    -- 是物理技能伤害  攻击类型：普通，伤害类型：普通
    --(无视魔免，无视反魔法外壳，不能伤害虚无)   不能设置为攻击类型法术  因为反魔法外壳 对法术里 除通用外的伤害都会吸收
    if(jass.ATTACK_TYPE_MELEE ==cat and jass.DAMAGE_TYPE_ENHANCED == cdt)then
        return 4
    end

    --过滤掉未知、加强
    if (jass.ATTACK_TYPE_MELEE ==cat and  (jass.DAMAGE_TYPE_ENHANCED == cdt or jass.DAMAGE_TYPE_ENHANCED == cdt)) then
        return 0
    end

    --是强制伤害 约定为 攻击类型:法术，伤害类型:灵魂锁链
    if(jass.ATTACK_TYPE_NORMAL == cat and jass.DAMAGE_TYPE_SPIRIT_LINK == cdt) then
        return 7
    end

    --是强制伤害 约定为 攻击类型:法术，伤害类型:暗影突袭
    if(jass.ATTACK_TYPE_NORMAL == cat and jass.DAMAGE_TYPE_SHADOW_STRIKE == cdt) then
        return 8
    end

    -- 是魔法技能伤害  攻击类型：法术，伤害类型: 魔法类
    --(无视虚无， 不能伤害魔免，被魔法外壳吸收)
    -- (可以被神秘腰带减免 [神秘腰带只对法术类型生效 对魔法不生效])
    if( jass.ATTACK_TYPE_NORMAL == cat) then
        return 5
    end

    return 0
end

--武器伤害类型转为 标准伤害类型
--武器伤害类型：
--标准伤害类型：
--@return 
local function weapDmgType2dmgType(wdt)
    return 0
end

--判断投射物是否撞上风墙
local function windWallWithMissile(unit,marsk)
    return false
end

--是否免疫死亡
--@return skipType  nil  1 2 3 4 5
local function isSkipDeath(unit)
    --1 免疫buff
    --2 免疫技能
    return nil
end

-- 注册触发特效
function _pack.registerEvent(type,id,callback)
    _pack.data[type][id] = callback
end

--单位受到伤害事件-处理器
function _pack.damageHandle()
    -- print("拦截伤害")
    local dmg = jass.GetEventDamage()
    
    local dmgUnit = jass.GetTriggerUnit()       --受伤单位
    local srcUnit = jass.GetEventDamageSource() --伤害来源单位
    local dmgId =  jass.GetPlayerId(jass.GetOwningPlayer(dmgUnit))
    local srcId = jass.GetPlayerId(jass.GetOwningPlayer(srcUnit))

    --自残 判断单位是否相同
    if (dmgUnit == srcUnit) then 
        japi.EXSetEventDamage(0)   
        print("自残跳出")
        return
    end

    --马甲 判断是否拥有蝗虫技能
    if( jass.GetUnitAbilityLevel(srcUnit,Id.string2id('Aloc'))>=1)then 
        japi.EXSetEventDamage(0)   
        print("马甲伤害跳出")
        return
    end

    local isAtk = japi.EXGetEventDamageData(2) ~=0 --是否普攻
    local atkType = japi.EXGetEventDamageData(6)   --攻击类型
    local dmgType = japi.EXGetEventDamageData(4)   --伤害类型
    local damageType = getDamageType(dmgType,atkType,isAtk) --获取最终伤害类型
    -- print("damageHandle","damageType",({"近战","穿刺","魔法","技能物理","技能魔法","技能通用"})[damageType],isAtk)
    
    --强制伤害
    if(damageType == 7 )then
        return
    end

    --致死伤害
    if(damageType == 8) then
        local skipType = isSkipDeath(dmgUnit)
        if(skipType) then
            japi.EXSetEventDamage(0)
            AbiTemp.skipDeath(skipType,dmgUnit)
        end
        return 
    end

    --其他情况都先把伤害屏蔽掉
    japi.EXSetEventDamage(0)

    --远程普通攻击跳过
    --*由投射物系统触发伤害
    if(damageType==2 or damageType==3 ) then
        -- print("远程普通攻击跳过")
        return
    end

    --近战普通攻击
    if (damageType==1) then
        print("近战普通攻击")
        --调用【平砍伤害函数】
        _pack.damageNormalAttack({
            src = srcUnit,
            aim = dmgUnit,
            dmgType = 1, --物理伤害
            weapTp = "normal",
        })
        return
    end

    --物理技能
    if(damageType==4)then
        print("物理技能")
        return
    end

    --魔法技能
    if(damageType==5)then
        print("物理技能")
        return
    end

    --通用技能
    if(damageType==6)then
        print("物理技能")
        return
    end

    print("未知伤害跳出")
end

--单位被攻击事件-处理器
function _pack.attackHandle()
    local atkUnit = jass.GetTriggerUnit() --被攻击单位
    local srcUnit = jass.GetAttacker() --攻击单位

    --停止攻击同伴
    -- if(not jass.IsPlayerEnemy(jass.GetOwningPlayer(srcUnit),jass.GetOwningPlayer(atkUnit)) ) then
    --     jass.IssueImmediateOrderById(srcUnit , 851972 ) -- 停止命令
    --     --Console.system("不能攻击同伴!",jass.GetPlayerId(jass.GetOwningPlayer(srcUnit)))
    --     return
    -- end

    local atkId = jass.GetPlayerId(jass.GetOwningPlayer(atkUnit))
    local srcId = jass.GetPlayerId(jass.GetOwningPlayer(srcUnit))

    --判断是否远程单位
    --模拟投射物
    if (isLongrangeUnit(srcUnit)) then
        local unitTypeId = jass.GetUnitTypeId(srcUnit)
        local unitTypeStr = Id.id2string(unitTypeId)
        local slk = jslk.unit[unitTypeStr]

        --读取投射物 弹射速度
        local mspeed = tonumber(slk.Missilespeed) --速度
        local marc = slk.Missilearc  --弧度
        local model = UnitsBase.missile[unitTypeStr]
        local mhoming = slk.MissileHoming
        local mtype = slk.weapTp1 --武器类型 normal普通  missile箭矢 msplash溅射 mbounce弹射 mline穿透

        if(not model)then
            print("未找到投射物,检查配置。","UnitTypeId",unitTypeStr)
        end

        _pack.missile {
            id = srcId,
            src = srcUnit,
            aim = atkUnit,
            model = model,
            homing = true,
            speed = 2000,--mspeed,
            -- radian = marc,
            overtime = 50,
            callback = function(isAtk,point)
                if(isAtk)then
                    _pack.damageNormalAttack({
                        src = srcUnit,
                        aim = atkUnit,
                        point = point,
                        weapTp = mtype,
                    })
                end
            end
        }
    end
end

--模拟投射物
--[[ @param cfg 
    {
        id    number     源单位的所有者id
        src  unit        源单位
        aim   unit       目标单位 
        aimPoint {x,y}   目标点
        model  string    unitTypeStr 模型马甲单位类型
        homing string    nil|"1"     是否追踪  
        speed  number    每秒速度
        radian number    距离弧度系数 高度=距离*radian
        overtime number  最大存在时间(秒)
        callback function(boolean,point) 结束回调 是否击中，投射物当前位置
    }
]]
function _pack.missile(cfg)
    cfg.point =  {jass.GetUnitX(cfg.src),jass.GetUnitY(cfg.src)}
    
    if (not cfg.homing and cfg.aim) then
        cfg.aimPoint = {jass.GetUnitX(cfg.aim),jass.GetUnitY(cfg.aim)}
    end

    if (cfg.homing) then
        cfg.facing = bj.GetAngleBetweenUnits(cfg.src,cfg.aim) 
    else
        cfg.facing = bj.GetAngleBetweenCoor(cfg.point[1],cfg.point[2],cfg.aimPoint[1],cfg.aimPoint[2]) 
    end

    cfg.marsk = jass.CreateUnit(jass.Player(cfg.id), Id.string2id(cfg.model),cfg.point[1],cfg.point[2],0)
    japi.EXSetUnitFacing(cfg.marsk,cfg.facing)
    --cfg额外属性
    --[[
        point  投射物初始化坐标
        facing 投射物面向角度
        height 投射物高度
        frameSpeed 每帧速度
        overtime 超时时间点 可为nil
        forecast 预测最大距离 用于计算高度
        countLength 已行进距离，用于计算高度
    ]]
    cfg.countLength = 0
    cfg.height = 50
    cfg.frameSpeed = cfg.speed / 50 --0.02秒 1/50秒  mspeed是每秒速度
    cfg.checkLength = cfg.frameSpeed * cfg.frameSpeed /4

    --超时时间转为时间戳
    if (cfg.overtime) then
        cfg.overtime = CenterTimer.getCurrentTime() + cfg.overtime * 1000
    end

    --计算预设距离
    if (cfg.homing) then
        cfg.forecast = bj.GetCoorDistance2(cfg.point[1],cfg.point[2],jass.GetUnitX(cfg.aim),jass.GetUnitY(cfg.aim))
    else
        cfg.forecast = bj.GetCoorDistance2(cfg.point[1],cfg.point[2],cfg.aimPoint[1],cfg.aimPoint[2])
    end

    CenterTimer.addTrace(nil,{
        delay = 0.01, --刷新周期
        loop = true,
        bind = cfg,
        callback = function(bind)
            --检查马甲是否存在
            if (bind.marsk == nil)then
                print("missile 马甲不存在 跳出")
                return false
            end

            --检查超时
            if( bind.overtime and CenterTimer.getCurrentTime() > bind.overtime ) then
                bind.callback(false,{
                    jass.GetUnitX(bind.marsk),
                    jass.GetUnitY(bind.marsk)
                })
                jass.RemoveUnit(bind.marsk)
                print("missile 超时 跳出")
                return false
            end

            --检查是否击中
            if (bind.homing)then
                local distanc2 = bj.GetCoorDistance(jass.GetUnitX(bind.marsk),jass.GetUnitY(bind.marsk),jass.GetUnitX(bind.aim),jass.GetUnitY(bind.aim))
                if (distanc2 <=bind.checkLength) then
                    bind.callback(true,{
                        jass.GetUnitX(bind.marsk),
                        jass.GetUnitY(bind.marsk)
                    })
                    jass.RemoveUnit(bind.marsk)
                    print("missile 判定击中1 跳出")
                    return false
                end
            else
                local distanc2 = bj.GetCoorDistance(jass.GetUnitX(bind.marsk),jass.GetUnitY(bind.marsk),bind.aimPoint[1],bind.aimPoint[2]) --距离的平方
                if (distanc2 <=bind.checkLength) then
                    bind.callback(true,{
                        jass.GetUnitX(bind.marsk),
                        jass.GetUnitY(bind.marsk),
                    })
                    jass.RemoveUnit(bind.marsk)
                    print("missile 判定击中2 跳出")
                    return false
                end
            end
            
            --追踪时计算方向
            if (bind.homing) then
                bind.facing = bj.GetAngleBetweenUnits(bind.marsk,bind.aim)
                jass.SetUnitFacing(bind.marsk,bind.facing)
            end

            --计算高度
            -- if (bind.height < 50) then
            --     --最低50
            -- elseif (bind.radian) then
            --     if(bind.countLength <= bind.forecast/2) then
            --         --上升阶段
            --         bind.height = bind.height + bind.radian * bind.countLength
            --     else
            --         --下降阶段
            --         if (bind.homing) then
            --             --如果是追踪
            --             bind.height = bj.Min(
            --                 bind.height,
            --                 bind.height - bind.radian * bj.GetCoorDistance2(
            --                     jass.GetUnitX(bind.marsk),jass.GetUnitY(bind.marsk),
            --                     jass.GetUnitX(bind.aim),jass.GetUnitY(bind.aim)
            --                 )
            --             )
            --         else
            --             bind.height = bind.height - bind.radian *(bind.forecast - bind.countLength)
            --         end
            --     end
            -- end

            local currentPoint = {
                jass.GetUnitX(bind.marsk),
                jass.GetUnitY(bind.marsk)
            }

            local nextPoint = {
                currentPoint[1]+ bind.frameSpeed * jass.Cos(bind.facing * jass.bj_DEGTORAD),
                currentPoint[2]+ bind.frameSpeed * jass.Sin(bind.facing * jass.bj_DEGTORAD),
            }

            --地图边界

            --检查碰撞
            -- if(not jass.IsTerrainPathable(nextPoint[1],nextPoint[2],jass.PATHING_TYPE_WALKABILITY) ) then
            --     jass.RemoveUnit(bind.marsk)
            --     bind.marsk = nil
            --     print("missile 不可通行 跳出")
            --     return false
            -- end

            --移动投射物
            jass.SetUnitX(bind.marsk,nextPoint[1])
            jass.SetUnitY(bind.marsk,nextPoint[2])

            bind.countLength  = bind.countLength+bind.frameSpeed

            -- if (bind.radian) then
            --     jass.SetUnitFlyHeight(bind.marsk,bind.height)
            -- end

            return true
        end
    })
end

--平砍伤害函数
--自动判断玩家属性 或 普通单位属性
--直接扣除生命值 注意判定死亡 如果死亡直接给秒杀伤害
--[[@param cfg{
    src: unit    伤害来源
    aim: unit    伤害目标
    point: {x,y} 伤害位置(溅射有效)
    dmgType： number 伤害类型 1物理 2魔法
    weapTp: string 武器类型(normal普通  missile箭矢 msplash溅射 mbounce弹射 mline穿透)
}]]
function _pack.damageNormalAttack(cfg)
    print("damageNormalAttack")
    local srcGamerId = jass.GetPlayerId(jass.GetOwningPlayer(src))
    if (srcGamerId <=5 and jass.IsHeroUnitId(jass.GetUnitTypeId(cfg.src))) then
        --玩家英雄
        local gamer = Context.get("Gamers")[srcGamerId]
        local roleParams = gamer.data.role_params
        local damage = role_params.weapAtk * role_params.attack
        local type = weapDmgType2dmgType(role_params.calc_param.weapDt)

        --判断是否致死
        if(jass.GetUnitState(cfg.aim, jass.UNIT_STATE_LIFE) < damage ) then
            jass.UnitDamageTarget( cfg.src, cfg.aim, damage, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_SHADOW_STRIKE, jass.WEAPON_TYPE_WHOKNOWS )
        else
            jass.SetUnitState(cfg.aim,jass.UNIT_STATE_LIFE,jass.GetUnitState(cfg.aim, jass.UNIT_STATE_LIFE)-damage)
        end

        _pack.texttag(cfg.aim,damage,type)       --漂浮文字
        _pack.attackOrbs(cfg.src,damage,type)    --攻击法球
        _pack.attackTriggers(cfg.src,dmage,type) --伤害特效
        _pack.hurtTriggers(cfg.aim,damage,type)  --受伤单位 受伤特效

    elseif (srcGamerId <=5)then
        --玩家召唤兽

    else
        --普通单位
    end
end

--伤害触发效果
function _pack.attackOrbs(unit,damage,type)
end

--受伤害触发效果
function _pack.hurtTriggers(unit,damage,type)
end


--技能伤害函数
function _pack.damageAbility(cfg)
end

-- 计算减伤
--[[@param cfg{
    src 
    unit
    damage
    dmgType
    isCrit
}]]
function _pack.damageReduction(cfg)
end

--更新角色属性
--属性变化后调用该函数 包括buff变动
--return {}
function _pack.updateParam(gid)
    local gamer = Context.get("Gamers")[gid]
    local role = gamer.data.role
    local unit = role.data.unit
    local roleParams = gamer.data.role_params

    --计算基础属性
    local unitLevel = jass.GetUnitLevel(unit)
    local unitClass = roleParams.role_class
    --数值加成 add_param 
    --百分比加成rate_param
    --计算属性calc_param
    --面板属性base_param 
    --orbs trig
end

--重置角色属性
--删除所有buff 然后根据等级、装备、天赋重新计算属性
function _pack.resetParam(gid)
    _pack.updateParam(gid)
end

--删除某个天赋时调用
function _pack.removeTalent(gid,index)
    local gamer = Context.get("Gamers")[gid]
    local param = gamer.data.role_params

    --清除相关bind数据 @TODO
end

--@init
function _pack.init()
    Trigger.registerEvent("damage",_pack.damageHandle)
    Trigger.registerEvent("attack",_pack.attackHandle)
end

return _pack
