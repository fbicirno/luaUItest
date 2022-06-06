--镜头工具类
local _pack = {
    data= {
        timer = jass.CreateTimer(),
        isLockedRect = false,  --是否锁定区域
        isLockedCamera= false, --是否锁定镜头
    }
}

-- 移动镜头
-- @param posi table 位置坐标(x,y,z)
-- @param camera handle 应用镜头
-- @param flag boolean 是否锁定
function _pack.move(posi,camera,flag)
    if(_pack.data.isLockedRect) then
        print("Camera.move","error","rect is locked")
        print(debug.traceback())
        return 
    end

    if(_pack.data.isLockedCamera and not camera) then
        print("Camera.move","error","camera is locked")
        print(debug.traceback())
        return
    end

    if (flag) then
        _pack.data.isLockedRect = true
        jglobals.Hardware_lua_isLocked_rect = true

        if(camera) then 
            _pack.data.isLockedCamera = true 
            jglobals.Hardware_lua_isLocked_camera = true
        end

        jass.TimerStart(_pack.data.timer,0,true,function()
            local x,y,_ = table.unpack(posi)
            jass.PanCameraToTimed(x,y,0)

            if (camera) then
                jass.CameraSetupApplyForceDuration( camera, true, 0 ) -- 应用镜头
            end
        end)
    else
        local x,y,_ = table.unpack(posi)
        jass.PanCameraToTimed(x,y,0)

        if (camera) then
            jass.CameraSetupApplyForceDuration( camera, true, 0 ) -- 应用镜头
        end
    end
end

-- 移动镜头到单位
-- @param u handle 目标单位
-- @param camera handle 应用镜头
-- @param flag boolean 是否锁定
function _pack.moveUnit(u,camera,flag)
    if(_pack.data.isLockedRect) then
        print("Camera.moveUnit","error","rect is locked")
        print(debug.traceback())
        return 
    end

    if(_pack.data.isLockedCamera and not camera) then
        print("Camera.moveUnit","error","camera is locked")
        print(debug.traceback())
        return
    end

    if (flag) then
        _pack.data.isLockedRect = true
        jglobals.Hardware_lua_isLocked_rect = true

        if(camera) then 
            _pack.data.isLockedCamera = true 
            jglobals.Hardware_lua_isLocked_camera = true
        end

        jass.TimerStart(_pack.data.timer,0,true,function()
            local x = jass.GetUnitX(u)
            local y = jass.GetUnitY(u)
            jass.PanCameraToTimed(x,y,0)

            if (camera) then
                jass.CameraSetupApplyForceDuration( camera, true, 0 ) -- 应用镜头
            end
        end)
    else
        local x = jass.GetUnitX(u)
        local y = jass.GetUnitY(u)
        jass.PanCameraToTimed(x,y,0)

        if (camera) then
            jass.CameraSetupApplyForceDuration( camera, true, 0 ) -- 应用镜头
        end
    end
end

-- 移动到区域中心
-- @param posi table 坐标 {x1,x2,y1,y2}
-- @param camera handle 应用镜头
-- @param flag boolean 是否锁定
function _pack.moveRect(posi,camera,flag)
    if(_pack.data.isLockedRect) then
        print("Camera.moveRect","error","rect is locked")
        print(debug.traceback())
        return 
    end

    if(_pack.data.isLockedCamera and not camera) then
        print("Camera.moveRect","error","camera is locked")
        print(debug.traceback())
        return
    end

    if (flag) then
        _pack.data.isLockedRect = true
        jglobals.Hardware_lua_isLocked_rect = true

        if(camera) then 
            _pack.data.isLockedCamera = true 
            jglobals.Hardware_lua_isLocked_camera = true
        end

        jass.TimerStart(_pack.data.timer,0,true,function()
            local r = jass.Rect(table.unpack(posi))
            jass.PanCameraToTimed(jass.GetRectCenterX(r), jass.GetRectCenterY(r), 0)
            jass.RemoveRect(r)
            
            if (camera) then
                jass.CameraSetupApplyForceDuration( camera, true, 0 ) -- 应用镜头
            end
        end)
    else
        local r = jass.Rect(table.unpack(posi))
        jass.PanCameraToTimed(jass.GetRectCenterX(r), jass.GetRectCenterY(r), 0)
        jass.RemoveRect(r)
        
        if (camera) then
            jass.CameraSetupApplyForceDuration( camera, true, 0 ) -- 应用镜头
        end
    end
end

-- 设置地图镜头范围
function _pack.scene(posi)
    local r = jass.Rect(table.unpack(posi))
    jass.SetCameraBounds(jass.GetRectMinX(r), jass.GetRectMinY(r), jass.GetRectMinX(r), jass.GetRectMaxY(r), jass.GetRectMaxX(r), jass.GetRectMaxY(r), jass.GetRectMaxX(r), jass.GetRectMinY(r)) 
    jass.RemoveRect(r)
end

-- 设置视野修正
function _pack.fog(posi)
    local r =jass.Rect(table.unpack(posi))
    local fmr = jass.CreateFogModifierRect(jass.GetLocalPlayer(), jglobals.FOG_OF_WAR_VISIBLE, r , true, false)
    jass.FogModifierStart(fmr)
    jass.RemoveRect(r)
end

-- 解除镜头锁定
-- 取消计时器的锁定
-- 取消镜头范围限制
function _pack.release()
    jass.PauseTimer(_pack.data.timer)
    _pack.data.isLockedRect = false
    jglobals.Hardware_lua_isLocked_rect = false

    jass.ResetToGameCamera(0)
    _pack.data.isLockedCamera = false
    jglobals.Hardware_lua_isLocked_camera = false
    
    --解锁区域锁定
    local r = jglobals.bj_mapInitialPlayableArea
    jass.SetCameraBounds(jass.GetRectMinX(r), jass.GetRectMinY(r), jass.GetRectMinX(r), jass.GetRectMaxY(r), jass.GetRectMaxX(r), jass.GetRectMaxY(r), jass.GetRectMaxX(r), jass.GetRectMinY(r)) 
end

-- 设置小地图
function _pack.setMinimap(path)
end


return _pack
