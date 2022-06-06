local UUID = require 'scripts.luas.utils.id.UUID'

local _pack = {}

function _pack.create()
    local object = {
        --存档签名
        signature = {
            type = 0, --0本地存档 1云存档 2临时存档
            name = "",
            index = 0,
            player_name = "",
            uuid = UUID.random(),
            init_time = 0, --创建时间
            last_time = 0, --最后一次保存时间
            count_time = 0,--累计游玩时间
        },
        --物品
        bank = {
            item = {},
            store = {},
            talent = {},
            skins = {},
            storeCurrency = 0,
        }
    }

    return object
end

return _pack