local Save = require 'scripts.luas.po.Save'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'
local DateTime = require 'scripts.luas.utils.time.DateTime'

--存档管理
local _pack = {
    current = nil,
}

--创建新存档
local function creatSave(cfg)

end

local function loadCloudSave()
    return ""
end

local function loadLocalSave(index)
    return ""
end

local function json2save(json)
    local save = Save.create()

    return save
end


function _pack.getCurrentSaveInfo()
    if (not _pack.current)then return end

    local info = {
        type = nil,
        currentTime = nil,
        countTime = nil,
        currentItem = nil,
        bankItem = nil,
        skins = nil,
        storeCurrency = nil,
    }

    --当前存档
    local type = _pack.current.signature.type
    if (type == 0)then
        local index = _pack.current.signature.index
        info.type = string.format("本地存档[%d]",index)
    elseif (type ==1)then
        info.type = "云存档"
    elseif(type==2)then
        info.type = "未存档"
    end

    --已进行时间
    info.currentTime =DateTime.formatTimer(CenterTimer.getCurrentTime(),"D hh:mm:ss")

    --累计时间
    local countTime = _pack.current.signature.count_time + CenterTimer.getCurrentTime()
    info.countTime = DateTime.formatTimer(countTime,"D hh:mm:ss")
    
    --拥有物品
    info.currentItem = 0

    --银行物品
    info.bankItem = 0

    --拥有皮肤
    info.skins = 0

    --商城币
    info.storeCurrency = _pack.current.bank.storeCurrency

    return info
end

--检查是否存在云存档
-- return boolean
function _pack.isExistCloudSave()
    return false
end

function _pack.toSave()
end

--读取本地存档列表
-- return {name1,name2,...}
function _pack.loadLocalSavesName()
    return  {}
end

-- type 根据玩家开局时选择
-- -2新游戏 -1云存档  0-?本地存档序号
function _pack.init(type)
    if(type == -2) then
       local save = Save.create()

       save.signature.type = 2
       save.signature.name = ""
       save.signature.player_name = jass.GetPlayerName(jass.GetLocalPlayer())

       _pack.current = save

    elseif (type == -1) then
        --读取平台存档
        local json = loadCloudSave()
        local save = json2save(json)

        save.signature.type = 1

        _pack.current = save

        --@TODO 应用到实例
    else
        local json = loadLocalSave(type)
        local save = json2save(json)

        save.signature.type = 0
        save.signature.index = type

        _pack.current = save

        --@TODO 应用到实例
    end
end

return _pack