local Context = require 'scripts.luas.core.applic.Context'

--随机数系统  注意需要同步下使用

--[[
    模拟自然随机

    几率每次随机结果
    如果偏离目标期望结果 对下一次随机的概率进行调整
    下一次的概率 = 期望+偏离*系数
]]
local _pack = {
    data = {},
    factor = 2, --修正系数
    force = false, --如果偏差过大，是否强制修正本次随机结果
    forceLine = 10, -- 强制修正触发临界
}


-- 根据概率计算一个近似整数
-- @param decimal double 实数概率[0-1]
-- @return integer [0-100]
local function approximate(decimal)
    return math.floor((decimal*100)+0.5)
end

local function random(ext)
    return math.random(1,100) <= ext
end

-- 注册一个随机数事件
function _pack.registerEvent(name,prb)
    local apx=approximate(prb)

    local t = {
        type ="object@luas.utils.id.Random",
        name = name,
        data = {
            expect  =  apx/100, --目标几率
            dynamic =  apx, --下一次几率
            actually = apx/100,  --真实几率
            last_differ = 0,  --上一次的真实几率偏差
            --factor = _pack.factor, --动态修正系数
            number = 1,    --已进行次数
            numOfTrg = 0,  --已进行中为真的次数
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
	
	    __newindex = function() end
    })

    --保存到环境变量中
    Context.get("Randoms")[name] = t
end

-- 调整概率
function _pack.setProbability(this,prb)
    local apx=approximate(prb)

    this.data.expect = apx/100
    this.data.dynamic = apx
    this.data.actually = apx/100
    this.data.last_differ=0
    this.number = 1
    this.numOfTrg =0
end

function _pack.__debug()
    print(
        ("")
    )
end

-- 获取随机结果
-- @return boolean
function _pack.getResult(this)
    local r = random(this.data.dynamic)
    local obj = this.data

    --根据当前结果修正参数
    obj.number = obj.number+1
    if (r)then
        obj.numOfTrg = obj.numOfTrg+1
    end

    local last_differ = obj.last_differ     --上一次真实几率偏差
    local lastAct =  last_differ+obj.expect --上一次真实几率
    local currentAct = obj.numOfTrg/obj.number --本次真实几率
    obj.last_differ = obj.expect - currentAct

    -- 下一次的几率 修正为 偏差*修正系数
    -- 当修正系数很大时 可以短期内快速修正，波动比较大
    -- 当修正系数很小时 可以稳定在目标几率附近
    obj.dynamic = obj.expect + obj.last_differ*_pack.factor 
    
    --是否触发强制修正 @TODO
    if (_pack.data.force and obj.last_differ >= _pack.data.forceLine)then

    end

    return r
end

-- 删除随机数事件
function _pack.remove(this)
    Context.get("Randoms")[this.name]  = nil
end

--异步转同步随机数 @TODO
-- scoket 挂起状态
function _pack.getSyncRandom(min,max,callback)
end

--@init
function _pack.init()
    Context.put("Randoms",{}) 
end

return _pack
