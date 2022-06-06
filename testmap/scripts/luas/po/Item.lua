local UUID = require 'scripts.luas.utils.id.UUID'

--物品类

local _pack = {}

function _pack.create()
    local t = {
        type = "object@luas.po.Item",
        id = UUID.random(),
        data = {
            handle = nil,   --item handle  每一个po都对应一个存在的物品
            number =1,      --堆叠数量
            using = false,  --可以使用
        }
    }

    return t
end

return _pack
