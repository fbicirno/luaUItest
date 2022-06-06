local Context = require 'scripts.luas.core.applic.Context'
local UUID = require 'scripts.luas.utils.id.UUID'

--中心计时器
local _pack = {
    data ={
        timer =jass.CreateTimer(),
        currentTag = 0,
        traces = {}
    }
}
--[[
    traces 

    {
        key
        tag
        delay 
        loop
        bind
        callback
    }

    cfg
    {
        delay: double 加入时开始计时 多长时间后运行
        loop: boolean 是否循环
        bind： table  可选，绑定数据
        callback: function 回调函数
                function(bind)  reutn boolean   返回true继续运行 返回false停止允许 只对loop=true的有效
    }
]]

--循环计时器扫描trace
function _pack.check()
    _pack.data.currentTag = _pack.data.currentTag + 20

    for k,v in pairs (_pack.data.traces) do
        if (_pack.data.currentTag>= v.tag) then
            local ctn =  v.callback(v.bind)
        
            --是否循环
            if(v.loop and ctn) then
                v.tag = _pack.data.currentTag+v.delay
            else
                _pack.data.traces[v.key] = nil
            end
        end
    end
end

--添加一个计时项目
--key 分配一个key 方便查找
--[[
    cfg:{
        delay：number    到期延时/循环延时  单位秒
        loop:boolean     是否循环， loop=true 且 callback返回true时才会进入下一次循环
        bind:table       绑定数据
        callback：function(bind)  到期回调
    }
]]
function _pack.addTrace(key,cfg)
    key = key or UUID.random()

    local t = {
        key = key,
        tag = cfg.delay*1000 + _pack.data.currentTag, --运行时间 时间戳
        delay = cfg.delay*1000,
        loop = cfg.loop,
        bind = cfg.bind or {},
        callback = cfg.callback,
    }

    setmetatable(t,{
        __index =  function(mytable,key)
            
            if (key == "create" or key == "init") then
                return nil
            end

            if (key == "remove") then
                _pack.remove(false,mytable)
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

    _pack.data.traces[key] = t
    return t
end

-- 删除
-- 可以通过 addTrace返回的实例调用删除
-- 也可以通过本类用key删除
-- 注意通过实例调用this放在后面 key设置为false
function _pack.remove(key,this)
    if (key == false)then
        key = this.key
    end

    _pack.data.traces[key] = nil
end

-- 获取游戏已进行时间
function _pack.getCurrentTime()
    return _pack.data.currentTag
end

--@init @TODO
function _pack.init()
    jass.TimerStart(_pack.data.timer,0.02,true,_pack.check)
end

return _pack