local Id = require 'scripts.luas.utils.id.Id'

local _pack = {}

-- 分割字符串
-- https://www.cnblogs.com/AaronBlogs/p/7615877.html
function string:split(szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
       local nFindLastIndex = string.find(self, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
        nSplitArray[nSplitIndex] = string.sub(self, nFindStartIndex, string.len(self))  
        break  
       end  
       nSplitArray[nSplitIndex] = string.sub(self, nFindStartIndex, nFindLastIndex - 1)  
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end
    if (nSplitArray[#nSplitArray] == "") then
        nSplitArray[#nSplitArray] = nil
    end
    return nSplitArray  
end

--连接多个字符串
function string:concat(split,...)
    return table.concat({...},split)
end

--table转字符串
function string:tableConcat(split,...)
    local t = {...}
    local t1 = {}
    for _,v in pairs(t) do
        t1[#t1] = tostring(v)
    end
    if (pairs(t1)) then
        return self:concat(split,t1)
    end

    return ""
end

function string.startsWith(str,substr)
    if str == nil or substr == nil then  
        print("the string or the sub-stirng parameter is nil"  )
        return nil
    end  
    if string.find(str, substr) ~= 1 then  
        return false  
    else  
        return true
    end
end

function string.endsWith(str,substr)
    if str == nil or substr == nil then  
        print "the string or the sub-string parameter is nil"  
        return nil 
    end  

    local str_tmp = string.reverse(str)  
    local substr_tmp = string.reverse(substr)  
    if string.find(str_tmp, substr_tmp) ~= 1 then  
        return false  
    else  
        return true
    end  
end

--模板
function string:gsubs(strs,...)
    local p = {...}
    for i=1,#p,2 do
        if (p[i+1]) then
            strs = strs:gsub(p[i],p[i+1])
        end
    end
    return strs
end

--截取中英混合的UTF8字符串，endIndex可缺省
function string.SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = string.SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = string.SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then
        return string.sub(str, string.SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, string.SubStringGetTrueIndex(str, startIndex), string.SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

--获取中英混合UTF8字符串的真实字符数量
function string.SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = string.SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function string.SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = string.SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

--返回当前字符实际占用的字符数
function string.SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end

--统计某个字符串出现的次数 正则表达式
function string.findNumber(str,f)
    count = 0
    for i in string.gmatch(str,f) do
        count = count + 1
    end
    return count
end

--补全 <*>% 内的内容 根据物编
function string.insertSlk(str)
    for s in string.gmatch(str, "[^(<.*>)]*") do
        local check,_ = string.find(s,"^%a%w*%p")
        if (check) then
            local temp = jslk
            local i = 1;
            for p in  string.gmatch(s,"[(%a%w*)]*") do
                if(not p or p == "") then break end

                if (i==1) then
                    temp = jslk.ability[p] or jslk.item[p]
                else
                    temp = temp[p]
                end
                i = i+1
            end
            if (string.endsWith(s,"%%")) then
                s = s .. "%"
                str = string.gsub(str,"<"..s..">",tonumber(temp) * 100.0)
            else
                str = string.gsub(str,"<"..s..">",temp)
            end
        end
	end
    return str
end

--补全<*>的内容 根据bind
-- 自动识别 <>%转为百分数
function string.insertTip(tip,bind)
    for repl in string.gmatch(tip,"<%a+>%%") do
        local key = repl:gsub("<",""):gsub(">",""):gsub("%%","")
		repl = repl:gsub("%%","") 
		tip= tip:gsub(repl,bind[key]*100.0)
    end
	
	for repl in string.gmatch(tip,"<%a+>") do
        local key = repl:gsub("<",""):gsub(">","")
		tip= tip:gsub(repl,bind[key])
    end
	
	return tip
end

--获取一段文字切割几行
--@param str   最后几个字符是|n|n 的话会忽略
--@param length  每行几个字
function string.getWordLine(str,length)
    if (not str) then return 0 end
	
	local g = string.split(str,"|n")
	local row = 0
	
    for _,v in pairs(g) do
        local old = v
		local temp =nil
		
        while(old ~= nil and old ~= "") do
			row = row + 1
            temp = string.SubStringUTF8(old,1,length) -- 截取前n个
            old = string.SubStringUTF8(old,length+1) --截取后n个
        end
    end
	return row
end

local function addSpace(str,num)
    local len = string.len(str)
    if (len < num) then
        for i=1,num-len,1 do
            str = str .. " "
        end
    end
    return str
end

-- 格式化字符 用于tooltip
-- @param num 补齐空格 
-- @param ...  value
function string.formatSimpleTip(str,num,...)
    local params = {...}
    for k,v in pairs(params) do
        params[k] = addSpace(v,num)
    end
    return string.format(str,table.unpack(params))
end

--截断浮点数
function string.GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        nNum = tonumber(nNum)
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal);
    local nRet = nTemp / nDecimal;
    return nRet;
end

--@init
_pack.init = function() 
    local old_gsub = string.gsub
    string.gsubo = old_gsub 

    string.gsub = function(s,f,p)
        local s,_ = old_gsub(s,f,p or "")
        return s
    end
end

return _pack