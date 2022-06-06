local Request = require 'scripts.luas.po.Request'

local _pack = {}

-- 同步消息 请求
--[[
    同步协议：

    date: 可选，发送时间
    head: 报头 用于events匹配
    message: 同步内容 
    host:   可选，发送方id  完全同步消息和普通消息不需要设置
    target: 可选，接收方id     0-5目标玩家 -1全部玩家 -2其他玩家
    id:     可选，分配一个id 用于匹配， 不是3 4不需要设置
    type:   4 回执单
]]


function _pack.create(msg)
    local object =Request.create()
    object.type = 4
    object.message = msg
    return object
end

return _pack
