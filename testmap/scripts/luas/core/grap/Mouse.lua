
local _pack = {
    data = {
        moveTimer = jass.CreateTimer(),
        grabupIconTexture = 0,
        grabupMouseTexture =0, 
        pointTextrue =0,
    }
}

function _pack.grabup(path)
    _pack.normal()

    japi.SetTexture(_pack.data.grabupIconTexture,path)
    jass.TimerStart(_pack.data.moveTimer,0.01,true, function()
        local x = japi.GetMouseVectorX()
        local y = japi.GetMouseVectorY()

        japi.SetTextureX(_pack.data.grabupIconTexture,x-22)
        japi.SetTextureY(_pack.data.grabupIconTexture,y-22)
        -- japi.SetTextureX(_pack.data.grabupMouseTexture,x-6)
        -- japi.SetTextureY(_pack.data.grabupMouseTexture,y-36)
    end)
end

function _pack.point()
    _pack.normal()

    jass.TimerStart(_pack.data.moveTimer,0.01,true,function()
        local x = japi.GetMouseVectorX()
        local y = japi.GetMouseVectorY()

        japi.SetTextureX(_pack.data.pointTextrue,x-4)
        japi.SetTextureY(_pack.data.pointTextrue,y-32)
    end)
end

function _pack.normal()
    jass.PauseTimer(_pack.data.moveTimer)

    japi.SetTextureX(_pack.data.grabupIconTexture,-100)
    japi.SetTextureY(_pack.data.grabupIconTexture,-100)
    -- japi.SetTextureX(_pack.data.grabupMouseTexture,-100)
    -- japi.SetTextureY(_pack.data.grabupMouseTexture,-100)

    japi.SetTextureX(_pack.data.pointTextrue,-100)
    japi.SetTextureY(_pack.data.pointTextrue,-100)
end

--@init start
function _pack.init()
    if(not japi.CreateTexture) then
        _pack.grabup = function()end
        _pack.normal = function()end
        _pack.point = function()end
        return
    end

    local screenH = japi.GetWindowHeight() --759
    local screenW = japi.GetWindowWidth() --1012

    local grabupH = screenH *0.04216 *0.7
    local grabupW = screenW *0.03162 *0.8*0.7

    _pack.data.grabupIconTexture = japi.CreateTexture("img\\alpha.tga",0,0,grabupW,grabupH,0xFFFFFFFF,500);
    -- _pack.data.grabupMouseTexture = japi.CreateTexture("img\\ui\\grabup.blp",0,0,grabupW,grabupH,0xFFFFFFFF,99);

    -- japi.SetTextureX(_pack.data.grabupMouseTexture,-100)
    -- japi.SetTextureY(_pack.data.grabupMouseTexture,-100)

    _pack.data.pointTextrue = japi.CreateTexture("ui\\Cursor\\mouse_point.blp",0,0,grabupW,grabupH,0xFFFFFFFF,500);

    _pack.normal()
    --@Interface
    Interface.Mouse = {}
    Interface.Mouse.grabup = _pack.grabup
    Interface.Mouse.normal = _pack.normal
    Interface.Mouse.point = _pack.point
end

return _pack
