local UUID = require 'scripts.luas.utils.id.UUID'

local _pack ={
    caches = {} --保存已创建的缓存
}

-- 创建一个缓存
function _pack.create(name,ctype)
    -- name是否重复
    if(_pack.caches[name] ~= nil) then
        return
    end

    local cache =  {
        type = "object@luas.core.applic.Cache",
        id = UUID.random(),
        ctype = ctype,
        data = {},
    }

    if (ctype == "kv" or ctype == nil) then
        cache.put = function (name,value)
            cache.data[name] = value
        end

        cache.get = function (key)
            return cache.data[key]
        end

        cache.remove = function (key)
            cache.data[name] = key
        end
    
    elseif(ctype == "array" ) then
        cache.put = function (value,index)
            if (index) then
                table.insert(cache.data,index,value)
            else
                table.insert(cache.data,value)
            end
        end

        cache.get = function(index) 
            return cache.data[index]
        end

        cache.remove = function(index)
            table.remove(cache.data,index)
        end

    elseif (ctype == "stack")then
        -- 堆栈 左进左出
        cache.push = function(value)
            table.insert(cache.data,1,value)
        end

        cache.pop = function()
            return table.remove(cache.data,1)
        end
        
    elseif (ctype =="queue") then
        -- 队列 左进右出
        cache.push = function (value)
            table.insert(cache.data,1,value)
        end

        cache.pop = function()
            return table.remove(cache.data)
        end
    end

    cache.clear = function()
        cache.data = {}
    end

    cache.isEmpty = function()
        return pairs (cache.data) == nil
    end

    setmetatable(cache, {
        __newindex = doNothing,
        __pairs = function () return pairs(cache.data) end, 
        __ipairs = function () return ipairs(cache.data) end, 
        __len = function () return #cache.data end,
    })

    _pack.caches[name] = cache --保存到全局
    return cache
end

-- 根据name获取全局缓存
function _pack.get(name)
    return _pack.caches[name]
end

-- 删除缓存
function _pack:remove(name)
    _pack.caches[name] = nil
end

return _pack
