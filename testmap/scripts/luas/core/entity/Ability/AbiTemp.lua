local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'

--技能通用模板
--[[
    1 单体类+配置项+回调
    2 圆形区域类+配置项+回调
    3 矩形区域类+配置项+回调
    4 扇形区域类+配置项+回调
    5 冲锋+配置项+回调
    6 弹幕+配置项+回调
    7 吸附+配置项
    8 数值类(增益、减益、回复)
    9 

]]
local _pack = {}

--数值修正类
--[[
    cfg:{
        unit:handle  单位
        delay:number 持续时间
        attribute:{
            [index]={
                type:number 属性序号
                    --0生命 1魔法 2移速 3攻强 4法强 5防御(物+法) 6攻速 
            }
        }
    }
    callback(unit) 结束后调用
]]
function _pack.revAttr(cfg,callback)

end

--恢复类 dot类
--[[
    cfg:{
        unit:handle 单位
        type:number 类型 0直接 1多次
        rType:number 恢复类型 1生命 2魔法
        texttag:boolean 是否显示漂浮文字
        value:number  每次恢复数值 可以为负

        --type==1
        interval:number 间隔
        num:number 次数
    }
    callback(unit)每次恢复后调用
]]
function _pack.recovery(cfg,callback)
    if(cfg.type == 1) then
        CenterTimer.addTrace(nil,{
            delay = cfg.interval,
            loop = true,
            bind = {
                step = 0,
            },
            callback = function(bind)
                if(cfg.rType==1) then
                    --恢复生命

                    --显示漂浮文字
                    if(cfg.texttag) then
                        if(cfg.value>0) then
                            --浅绿色漂浮文字
                        else
                            --深绿色漂浮文字
                        end
                    end
                elseif (cfg.rType==2)then
                    --恢复魔法

                    if(cfg.texttag) then
                        if(cfg.value>0) then
                            --浅蓝色漂浮文字
                        else
                            --深蓝色漂浮文字
                        end
                    end
                end


                if (bind.step >=cfg.num) then
                    callback(cfg.unit)
                    return false
                else
                    bind.step = bind.step + 1
                    return true
                end
            end
        })
    else
        if(cfg.rType==1)then
            --恢复生命

            --漂浮文字
            if(cfg.texttag)then
                if (cfg.value >0)then

                else

                end
            end
        elseif(cfg.rType==2) then
            --恢复魔法

            --漂浮文字
            if(cfg.texttag)then
                if (cfg.value >0)then

                else

                end
            end
        end

        callback(cfg.unit)
    end
end

--投掷物
--[[
    cfg:{ 
        loc:{x,u}    目标点
        aim:handle   目标单位
        mod:string   特效模型
        height:number 高度
        speed:number 飞行速度
        para:boolean 抛物线
        follow:boolean 跟踪目标
    }
]]
function _pack.missile(cfg,callback)
    local selfX = jass.GetUnitX(unit)
    local selfY = jass.GetUnitY(unit)
    local marsk = jass.CreateUnit(jass.Player(0),0,selfX,selfY,0)
    -- japi.SetModle(marsk,cfg.mod) --japi设置马甲模型

    if(cfg.follow and cfg.aim) then
        --跟踪模式
        local maxHeight =0
        if (cfg.para) then
            maxHeight = bj.GetCoorDistance({1,1},{1,1})*0.3 --根据距离计算高度
        end
        
        _pack.charge({
            unit = marsk,
            aim = cfg.aim,
            follow = true,
            speed = cfg.speed,
            para = cfg.para,
            maxHeight = maxHeight,

        },callback)

    else
        if(cfg.aim) then
            cfg.loc = {
                jass.GetUnitX(cfg.aim),
                jass.GetUnitY(cfg.aim),
            }
        end 

        local maxHeight =0
        if (cfg.para) then
            maxHeight = bj.GetCoorDistance({1,1},{1,1})*0.3 --根据距离计算高度
        end

        _pack.charge({
            unit = marsk,
            aim = cfg.aim,
            follow = true,
            speed = cfg.speed,
            para = cfg.para,
            maxHeight = maxHeight,

        },callback)

    end


end

--单体 
--[[ config:{
    aim:handle 目标单位
    mod:string 模型特效
    damgeType:number  判定次数 
    damgeDelay:number 判定间隔
    }
    callback(unit) 每次判断
]]
function _pack.single(cfg,callback)
end

--圆形
--[[ cfg:{
    loc:{x,y}  中心坐标
    rad:number 最大半径
    target:number 判断单位所属 0玩家1-6 1玩家敌对(不含中立) 2玩家敌对(包含中立)
    mod:string   特效模型 

    damgeType:number  判定次数  默认1
    damgeDelay:number 判定间隔
    speedDpd:number   扩散速度 0直接判断 >0 慢慢扩散   默认0
    }
    callback(unit) 每选取一个单位
]]
function _pack.circular(cfg,callback)
end

--矩形 
--[[
    cfg:{
        loc:{x,y}  
        size:{w,h} 宽度 长度
        targe:number
        mod:string
        damgeType:number  判定次数 
        damgeDelay:number 判定间隔
    }
]]
function _pack.rect(cfg,callback)
end

--扇形
-- loc释放点 rad半径 radian弧度 angle角度
function _pack.sector(loc,radius,radian,angle,unit,cfg,callback)
end

--冲锋
--[[ cfg:{
    loc:{x,y} 目标点
    aim:handle 目标单位
    follow:boolean 是否跟随目标 aim有值时有效

    unit:handle 冲锋单位
    para:boolean true跳劈 false冲锋 默认冲锋
    maxHeight:number 最大高度 对para=true有效
    aniIndex:number 冲锋或跳跃时播放单位动作
    atkIndex:number 冲锋结束或跳劈时播放单位动作

    collision：boolean 碰撞检测  单位建筑&可破坏物&不可通行
    mod:string 附加特效模型
    angle：number 方向
    speed:number 速度
    delay:number 时间
    length:number 距离

    damageRadius:number 伤害判定范围
    damageDelay:number 伤害判定间隔
    }
    call1 冲锋结束时调用
    call2 每选取一个单位时调用
]]
function _pack.charge(cfg,call1,call2)
end

--控制类
--[[
    cfg:{
        aim:handle 被控制单位
        type:number 控制类型
            --0眩晕 1减速 2禁锢 3击飞 4击倒 5击退 6沉默 
            --7吸附(单体) 8嘲讽 9恐惧
        delay:number 持续时间

        unit:handle 释放单位 type=8有效
    }
    callback:function(aim) 结束后调用
]]
function _pack.govern(cfg,callback)

end

--群体吸附
--[[
    cfg:{
        loc:{x,y}    中心点
        delay:number 持续时间
        target:number 匹配单位类型 
            -- 0玩家1-6 1玩家敌对(不含中立) 2玩家敌对(包含中立) 3投掷物 4全部
    }
    call1 结束后调用
    call2 每选取一个单位调用
]]
function _pack.suck(cfg,call1,call2)
end

--风墙类
--[[
    cfg:{
        loc:{x,y}
        angle:number 面向角度
        size:{l,w,h} 判定范围
        mod:string  模型路径
        marsk:unitTypeId 用马甲作为模型
        modSize：number 缩放比例

        type:number 风墙类型 0全阻挡 1
        push:boolean 创建时弹开周围单位
        through：Boolean 单位可穿过风墙
    }
]]
function _pack.wall(cfg)
end

--肉钩
function _pack.meathook(cfg,call1,call2)
end

--弹幕
--[[
    cfg:{
        loc:{x,y} 发射点坐标
        wavenum:number 发射次数
        objnum:number 每次发射个数
        mod:string 模型
        marsk:unitTypeId 用马甲

        --弹幕动态样式
        style:{
            fade：boolean 是否变淡 
            fadeInit: number 初始透明度
            fadeEnd：number  结束透明度

            size:boolean    是否缩放
            sizeInit:number 初始大小
            sizeEnd:number  结束大小

            color:boolean   是否变色
            colorRInit：    初始R
            colorREnd:      结束R

            colorGInit:     初始R
            colorGEnd:      结束R

            colorBInit:     初始R
            colorBEnd:      结束R
        }

        --弹幕轨迹配置
        trace:{
            type:number 轨迹类型 0直线移动 1水平正弦移动 2垂直正弦移动 3螺旋线移动 4滚筒移动
            delay:number 弹幕存在时间
            interval:number 帧间隔(默认0.03)
            speed:number 每帧移动速度

            --type=0
            
            --type=1
            lenghtDpd:number 上下离散距离
            speedDpd:number  上下移动速度(每帧)

            --type=2
            heightDpd:number 上下离散距离
            speedDpd:number  上下移动速度(每帧)

            --type=3
            speedDpd:number 扩散速度

            --type=4
            radius：number 离散半径
            speedDpd:number 滚动速度
        }
        

        --弹幕扩散配置
        diffuse:{

        }
    }
]]
function _pack.barrage(cfg,callback)

end

--复杂连续特效
--[[
    cfg:{
        [index] = {
            mod:string  特效模型
            num:number  创建个数
            radius:number 对num>1时有效 分布半径
            type:number 特效类型 0直接删除 1原地旋转 2向外扩散 3上下移动 4丝带
            trace:number 时间轴

            --根据type可选配置项
            --type=0
            delay:number 存在时间

            --type=1
            delay:number 存在时间
            angle:number 每一帧旋转角度

            --type=2
            delay:number 存在时间
            speed:number 每一帧移动速度
            add:boolean  是否自动添加特效以填充空白部分

            --type=3
            delay:number  存在时间
            upnum:number  上下次数(上下来回算一次)
            height:number 高度差

            --type=4 
            delay:number 存在时间
            unit:handle  跟随单位
            loc:{x,y}    中心点  unit loc二选一
            speed:number 每一帧移动距离
            interval:number 帧间隔(默认0.03) 增加以降低资源消耗
        },
    }
    callback 完全结束后调用
]]
function _pack.effect(cfg,callback)
end

--免疫致死
--@param type 1希望之花 2双生世界 3死亡魂器 4重生勋章 5
function _pack.skipDeath(type,unit)
    if(type  ==1)then

    elseif(type ==2)then

    elseif(type ==3)then

    elseif(type ==4)then

    elseif(type ==5)then

    end
end

--佣兵ai
--[[
    cfg:{
        mcyTypeId:unitTypeId,
        delay:number,   单位存在时间  0无限
        followRad:number, 跟随半径
        abiActive:boolean, 主动使用技能
        control:boolean,  玩家是否可以控制
    }
    call1 function(mcy) 创建出佣兵后调用  用于设置属性

    近战型会主动帮玩家承担伤害(试图站在玩家前面 优先打近战怪)
    远程型会自动走位风筝(不集火 优先攻击玩家攻击的目标)
    所有类型优先躲弹幕 躲地圈    

    return switcher 可控制ai开启关闭

    delay到期后自动销毁switcher对象
]]
function _pack.mercenary(cfg,call1)
    local t = {
        
    }

    t.destroy = function()
    end

    t.open = function()
    end

    t.close = function()
    end

    return t
end

return _pack