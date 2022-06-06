-- 背景音乐控制器
local bgmConstants = require 'scripts.luas.constants.Bgm'

local _pack = {
    current = 0, -- 当前播放的音乐
}

-- 播放指定名字音乐
function _pack.play(name)
end

-- 随机播放
function _pack.random(list)
end

-- 暂停
function _pack.pause()
end

-- 恢复
function _pack.continue()
end

return _pack
