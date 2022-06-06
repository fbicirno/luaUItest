-- 同步消息 请求
--[[
    同步协议：

    date: 可选，发送时间
    head: 报头 用于events匹配
    message: 同步内容 
    host:   可选，发送方id  完全同步消息和普通消息不需要设置
    target: 可选，接收方id     0-5目标玩家 -1全部玩家 -2其他玩家
    rid:    可选，分配一个id 用于匹配， 不是3 4不需要设置
    type:   可选，消息类型  1普通消息 2确认消息 3试探 4回执单
                普通消息 发送即可 对方是否收到不关心
                确认消息 发送后等待对方回复一条回执单 并匹配id
                试探    发送一个报头并等待对方确认
                回执    用于确认收到了消息，以及返回结果
]]

local _pack = {}

function _pack.create()
    local object = {
        date = nil,
        rid = nil,
        head = nil,
        message = nil,
        host = nil,
        target = nil,
        type = nil,
    }
    return object
end

return _pack
