-- 时间日期工具类
local _pack = {}

-- 日期格式化 标准时间
-- @param timestamp
-- @param format  YYYY-MM-DD hh:mm:ss 
function _pack.format(timestamp,format)
    return "0000-00-00 00:00:00"
end

-- 日期格式化 累计时间
-- @param timestamp
-- @param format  hh:mm:ss 
function _pack.formatTimer(timestamp,format)
    return "00:00:00"
end

return _pack