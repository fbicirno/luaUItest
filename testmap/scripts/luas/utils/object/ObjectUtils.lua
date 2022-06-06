-- 对象/表 工具类
local _pack = {}

-- 深度克隆
function table.clone(source, target)
    target = target or {}
    source = source or {}

    for k, v in pairs(source) do
        if (type(v) == "table") then
            target[k] = table.clone(source[k])
        else
            target[k] = v
        end
    end

    return target
end

-- 浅克隆
-- 仅克隆 string number boolean  table userdata  注意table、userdata仅克隆一个引用
function table.simpleClone(souce, target)
    target = target or {}
    source = source or {}
    
    for k, v in pairs(source) do
        local vt = type(v)
        if (vt == "string" or vt == "number" or vt == "boolean" or vt == "table" or vt == "userdata") then 
            target[k] = v 
        end
    end
    return target
end

-- 遍历打印table
-- https://www.cnblogs.com/leoin2012/p/3915295.html
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function table.print(self, level, filteDefault)
    if (not self) then return end
        
    local msg = ""
    filteDefault = filteDefault or true -- 默认过滤关键字（DeleteMe, _class_type）
    level = level or 1
    local indent_str = ""

    for i = 1, level do indent_str = indent_str .. "  " end

    print(indent_str .. "{")
    for k, v in pairs(self) do
        if filteDefault then
            if k ~= "_class_type" and k ~= "DeleteMe" then
                local item_str = nil
                if (type(v) == 'string') then
                    item_str = string.format('%s%s = "%s"', indent_str .. " ",tostring(k), tostring(v))
                else
                    item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
                end
                
                print(item_str)
                if type(v) == "table" then
                    table.print(v, level + 1)
                end
            end
        else
            local item_str = nil
            if (type(v) == 'string') then
                item_str = string.format('%s%s = "%s"', indent_str .. " ",tostring(k), tostring(v))
            else
                item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
            end
            print(item_str)
            if type(v) == "table" then
                table.print(v, level + 1) 
            end
        end
    end
    print(indent_str .. "}")
end

function _pack.serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. _pack.serialize(k) .. "]=" .. _pack.serialize(v) .. ","
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
            lua = lua .. "[" .. _pack.serialize(k) .. "]=" .. _pack.serialize(v) .. ","
        end
    end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

function _pack.unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = load(lua)
    if func == nil then
        return nil
    end
    return func()
end

--获取一个function的形参表
--https://www.cnblogs.com/zitonglove/p/10058162.html
local function getArgs(fun)
    local args = {}
    local hook = debug.gethook()
    local argHook = function(...)
        local info = debug.getinfo(3)
        --for k,v in pairs(info) do
        --    print(k,v)
        --end
        if "pcall" ~= info.name then
            return
        end
        for i = 1, math.huge do
            local name, value = debug.getlocal(2, i)
            --print(i, name, value)
            if "(*temporary)" == name then
                debug.sethook(hook)
                error("")
                return
            end
            table.insert(args, name)
        end
    end
    debug.sethook(argHook, "c")
    pcall(fun)
    return args
end

-- 非空判断
-- 简单的判断参数是否为nil  
-- 最后一个参数为callback   
-- callback要写形参(根据形参个数进行非空判断)
function _pack.ofNullable(...)
    local t = {...}
    local callback = table.remove(t,#t)
    local num = #getArgs(callback)

    if (num <=0 or callback == nil) then
        return
    end

    for i=1,num,1 do
		if(t[i] == nil) then
            return
		end
	end

    return callback(table.unpack(t))
end

--链式检测对象调用
--第一个参数是要检查的对象
--最后一个参数是callback
--callback只接收一个参数
function _pack.ofNullableParam(...)
    local t = {...}
    local obj = table.remove(t,1)
    local callback = table.remove(t,#t)
    
    if (obj == nil) then
        print("ObjectUtils.ofNullableParam object is nil")
        print(debug.traceback())
        return
    end

    for _,v in pairs(t) do
        obj = obj[v]
        if (obj == nil) then
            print("ObjectUtils.ofNullableParam  key=",v)
            print(debug.traceback())
            return
        end
    end

    callback(obj)
end

function _pack.switch(value)

    local t = {}
    t.result = nil
    t.next = true
    t.catch = function(vc,callback)
        if (t.next and vc == value) then
            t.next = false --终断继续

            if(type(callback)=="function") then
                t.result = callback()
            else
                t.result = callback
            end  
        end

        return t
    end
    t.default = function(callback)
        if (t.next) then
            if(type(callback)=="function") then
                t.result = callback()
            else
                t.result = callback --可能为nil
            end  
        end

        return t.result
    end

    return t
end

-- 可空判断
-- 简单判断p是否nil 非nil调用c1(p1)  nil调用c2(p2)
function _pack.orElse(p1,c1,c2,p2)
    if(p1~=nil) then
        return c1(p1)
    else
        return c2(p2)
    end
end

--新迭代器
-- @param array table
-- @param first number 开始索引 默认1
-- @param last  number 结束索引 默认#array
function _pack.iterator(array,first,last)
    if not array then return end

    first = first or 1
    last = last or #array

    return {
        --匹配遍历 return true结束遍历
        some = function(callback)
            for i=first,last,1 do
                local element =  array[i]
                if(callback(element,i)) then
                    return
                end
            end
        end,
        --检查遍历 return false结束遍历
        any = function(callback)
            for i=first,last,1 do
                local element =  array[i]
                if(callback(element,i) == false) then
                    return 
                end
            end
        end
    }
end

--@init
_pack.init = function ()
end

return _pack
