-- 交互接口
local _pack = {}

--@init
function _pack.init()
    _G.Interface = _pack

    --jass->lua 入口
    function jhook.AbilityId(code)
        --print("jhook.GetSoundFileDuration  " .. tostring(code))
        local func = load(code)
        if (func) then
            func()
        else
            print("error:","Interface.hook",tostring(code))
        end
    end
end

return _pack
