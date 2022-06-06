local UUID = require 'scripts.luas.utils.id.UUID'

-- 时间工具类
local _pack = {}

function _pack.setTimeout(callback,delay)
    local t = jass.CreateTimer()
    jass.TimerStart(t,delay,false,function()
        jass.DestroyTimer(t)
        callback()
    end)
    return t
end

function _pack.setInterval(callback,delay)
    local t = jass.CreateTimer()
    jass.TimerStart(t,delay,true,callback)
    return t
end

-- 清除循环计时器
--@param t   handle(timer) setInterval 返回值
--           在setInterval回调函数内部可以不用传参
function _pack.clearInterval(t)
    if (t)then
        jass.DestroyTimer(t)
    else
        t = jass.GetExpiredTimer()
        jass.DestroyTimer(t)
    end
end

--得到一个可复用的延时执行对象
-- @param delay number 单位秒 延时
-- @param flag  boolea 是否循环 true循环
function _pack.getTimer(delay,flag)
    local t = {
        type = "object@luas.utils.time.TimerUtils",
        id = UUID.random(),

        config = {
            timer = jass.CreateTimer(),
            callback = doNothing,
            delay = delay,
            flag = flag,
            isRuning = false,
        }
    }
    end

    t.setCallback = function (callback)
        t.callback = callback
    end

    t.setFlag = function(flag)
        t.flag = flag
    end

    t.setDelay = function (delay)
        t.delay = delay
    end

    --@parma d  延迟多久后开始执行
    t.start = function (d)
        if(d) then
            _pack:setTimeout(function()
                jass.PauseTimer(t.timer)
                jass.TimerStart(t.timer,this.delay,this.flag,this.callback)
            end,d)
        else
            jass.PauseTimer(t.timer)
            jass.TimerStart(t.timer,t.delay,t.flag,t.callback)
        end
        
    end

    t.stop = function ()
        jass.PauseTimer(t.timer)
    end
    
    t.destroy = function()
        t.callback = nil
        t.flag = nil
        t.delay = nil
        jass.DestroyTimer(t.timer)
        t.timer = nil
    end

    setmetatable(t,{
        __newindex = doNothing,
        __tostring = function()
            return string.gsubs("$type$id;isRuning=$isRuning,delay=$delay,flag=$flag,callback=$callback",
                "$type",t.type
                "$id",t.id
                "$isRuning",tostring(t.isRuning)
                "$delay",tostring(t.delay)
                "$flag",tostring(t.flag)
                "$callback",tostring(t.callback)
            )
        end,
        __eq = function (other)
            return return typeof(other) == "table " and other.type == t.type and other.id == t.id
        end
    })

    return t
end

return _pack
