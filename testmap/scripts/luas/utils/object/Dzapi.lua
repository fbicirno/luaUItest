local GuiPointContants = require 'scripts.luas.constants.GuiPoint'

local _pack = {
    data = {
        mouseEvent = {},
        mouseMoveEvent = {},
        keyEvent = {},
        frameEvent = {},
        syncEvent = {},
        windowEvent = {},

        lastKeyEvent = {
            key = -1,
            status = -1,
        },

        isOpenKey = true,
    }
}

function _pack.GetMouseTerrain()
    jass.ExecuteFunc("GetMouseTerrain")
    return jass.LoadReal(jglobals.lua_engine,100,1),
           jass.LoadReal(jglobals.lua_engine,100,2),
           jass.LoadReal(jglobals.lua_engine,100,3)
end

function _pack.GetMouseRelative()
    jass.ExecuteFunc("GetMouseRelative")
    return jass.LoadReal(jglobals.lua_engine,100,1),
           jass.LoadReal(jglobals.lua_engine,100,2)
end

function _pack.GetMouseXY()
    jass.ExecuteFunc("GetMouseXY")
    return jass.LoadReal(jglobals.lua_engine,100,1),
           jass.LoadReal(jglobals.lua_engine,100,2)
end

function _pack.SetMousePos(x,y)
    jass.SaveInteger(jglobals.lua_engine,100,1,x)
    jass.SaveInteger(jglobals.lua_engine,100,2,y)
    jass.ExecuteFunc("SetMousePos")
end

function _pack.GetWindow()
    jass.ExecuteFunc("GetWindow")
    return jass.LoadInteger(jglobals.lua_engine,100,1),
           jass.LoadInteger(jglobals.lua_engine,100,2)
end

function _pack.GetWindowXY()
    jass.ExecuteFunc("GetWindowXY")
    return jass.LoadInteger(jglobals.lua_engine,100,1),
           jass.LoadInteger(jglobals.lua_engine,100,2)
end

function _pack.IsWindowActive()
    jass.ExecuteFunc("IsWindowActive")
    return jass.LoadBoolean(jglobals.lua_engine,100,1)
end

function _pack.FrameHideInterface()
    jass.ExecuteFunc("DzFrameHideInterface")
end

function _pack.LoadToc(path)
    jass.SaveStr(jglobals.lua_engine,100,1,path)
    jass.ExecuteFunc("LoadToc")
end

function _pack.FrameEditBlackBorders(up,down)
    jass.SaveReal(jglobals.lua_engine,100,1,up)
    jass.SaveReal(jglobals.lua_engine,100,2,down)
    jass.ExecuteFunc("FrameEditBlackBorders")
end

function _pack.GetColor(r,g,b,a)
    jass.SaveInteger(jglobals.lua_engine,100,1,r)
    jass.SaveInteger(jglobals.lua_engine,100,2,g)
    jass.SaveInteger(jglobals.lua_engine,100,3,b)
    jass.SaveInteger(jglobals.lua_engine,100,4,a)
    jass.ExecuteFunc("GetColor")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.EnableWideScreen(b)
    jass.SaveBoolean(jglobals.lua_engine,100,1,b)
    jass.ExecuteFunc("EnableWideScreen")
end

function _pack.SetWar3MapMap(path)
    jass.SaveStr(jglobals.lua_engine,100,1,path)
    jass.ExecuteFunc("SetWar3MapMap")
end

function _pack.FrameGetGameUI()
    return jass.LoadInteger(jglobals.lua_engine,101,1)
end

function _pack.FrameGetPortrait()
    return jass.LoadInteger(jglobals.lua_engine,101,2)
end

function _pack.FrameGetMinimap()
    return jass.LoadInteger(jglobals.lua_engine,101,3)
end

function _pack.FrameGetUpperButtonBarButton(i)
    return jass.LoadInteger(jglobals.lua_engine,101,4+i)
end

function _pack.FrameGetHeroBarButton(i)
    return jass.LoadInteger(jglobals.lua_engine,101,10+i)
end

function _pack.FrameGetHeroHPBar(i)
    return jass.LoadInteger(jglobals.lua_engine,101,19+i)
end

function _pack.FrameGetHeroManaBar(i)
    return jass.LoadInteger(jglobals.lua_engine,101,27+i)
end

function _pack.FrameGetItemBarButton(i)
    return jass.LoadInteger(jglobals.lua_engine,101,35+i)
end

function _pack.FrameGetMinimapButton(i)
    return jass.LoadInteger(jglobals.lua_engine,101,41+i)
end

function _pack.FrameGetTooltip()
    return jass.LoadInteger(jglobals.lua_engine,101,47)
end

function _pack.FrameGetChatMessage()
    return jass.LoadInteger(jglobals.lua_engine,101,48)
end

function _pack.FrameGetUnitMessage()
    return jass.LoadInteger(jglobals.lua_engine,101,49)
end

function _pack.FrameGetTopMessage()
    return jass.LoadInteger(jglobals.lua_engine,101,50)
end

function _pack.FrameGetCommandBarButton(x,y)
    return jass.LoadInteger(jglobals.lua_engine,101,51+x*4+y)
end

function _pack.RegisterKeyEvent(key,status,callback)
    if(not _pack.data.keyEvent[key]) then
        _pack.data.keyEvent[key] = {}
    end

    -- 不存在status 新建
    if (not _pack.data.keyEvent[key][status]) then
        _pack.data.keyEvent[key][status] = callback

        jass.SaveInteger(jglobals.lua_engine,100,1,key)
        jass.SaveInteger(jglobals.lua_engine,100,2,status)
        jass.ExecuteFunc("RegisterKeyEvent")
        return
    end

    --如果注册过 直接添加回调即可
    -- 是function 改为table
    if (type(_pack.data.keyEvent[key][status]) == "function") then
        local cb = _pack.data.keyEvent[key][status]
        _pack.data.keyEvent[key][status] = {
            cb,callback
        }
        return
    end

    -- 是table 直接插入
    if(type(_pack.data.keyEvent[key][status]) == "table") then
        table.insert(_pack.data.keyEvent[key][status],callback)
        return
    end
end

-- @param key 1左键 2右键
-- @param status 0释放 1按下
function _pack.RegisterMouseEvent(key,status,callback)
    if (not _pack.data.mouseEvent[key])then
        _pack.data.mouseEvent[key] ={}
    end

    -- 不存在status 新建
    if (not _pack.data.mouseEvent[key][status]) then
        _pack.data.mouseEvent[key][status] = callback
        return
    end

    -- 是function 改为table
    if (type(_pack.data.mouseEvent[key][status]) == "function") then
        local cb = _pack.data.mouseEvent[key][status]
        _pack.data.mouseEvent[key][status] = {
            cb,callback
        }
        return
    end

    -- 是table 直接插入
    if (type(_pack.data.mouseEvent[key][status]) == "table") then
        table.insert(_pack.data.mouseEvent[key][status],callback)
        return
    end
end

function _pack.RegisterMouseMoveEvent(callback)
    table.insert(_pack.data.mouseMoveEvent,callback)
end

-- 注册frame事件  已封装
-- 反复注册同一个frame会覆盖
-- 支持 移入|移出|左键|右键
function _pack.RegisterFrameEvent(frame,over_func,out_func,left_func,right_func)
    if ( _pack.data.frameEvent[frame]) then
        _pack.data.frameEvent[frame] = {
            [1] = left_func,
            [2] = over_func,
            [3] = out_func,
            [4] = right_func
        }
        return
    end

    --第一次注册
    _pack.data.frameEvent[frame] = {
        [1] = left_func,
        [2] = over_func,
        [3] = out_func,
        [4] = right_func
    }

    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.ExecuteFunc("RegisterFrameEvent")
end

function _pack.IsKeyDown(key)
    jass.FlushChildHashtable(jglobals.lua_engine,100)
    jass.SaveInteger(jglobals.lua_engine,100,1,key)
    jass.ExecuteFunc("IsKeyDown")
    return jass.LoadBoolean(jglobals.lua_engine,100,1)
end

function _pack.ClickFrame(frame)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.ExecuteFunc("ClickFrame")
end

function _pack.FrameSetFocus(frame,flag)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveBoolean(jglobals.lua_engine,100,2,flag)
    jass.ExecuteFunc("FrameSetFocus")
end

function _pack.FrameGetMouseFocus()
    jass.ExecuteFunc("FrameGetMouseFocus")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.FrameCageMouse(frame,flag)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveBoolean(jglobals.lua_engine,100,2,flag)
    jass.ExecuteFunc("FrameCageMouse")

end

function _pack.CreateFrame(frame,parent,id)
    jass.SaveStr(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,parent)
    jass.SaveInteger(jglobals.lua_engine,100,3,id)

    jass.ExecuteFunc("CreateFrame")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.CreateSimpleFrame(frame,parent,id)
    jass.SaveStr(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,parent)
    jass.SaveInteger(jglobals.lua_engine,100,3,id)

    jass.ExecuteFunc("CreateSimpleFrame")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.CreateFrameByTagName(frame,name,parent,temp,id)
    jass.SaveStr(jglobals.lua_engine,100,1,frame)
    jass.SaveStr(jglobals.lua_engine,100,2,name)
    jass.SaveInteger(jglobals.lua_engine,100,3,parent)
    jass.SaveStr(jglobals.lua_engine,100,4,temp)
    jass.SaveInteger(jglobals.lua_engine,100,5,id)

    jass.ExecuteFunc("CreateFrameByTagName")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.DestroyFrame(frame)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.ExecuteFunc("DestroyFrame")
end

function _pack.FrameFindByName(name,id)
    jass.SaveStr(jglobals.lua_engine,100,1,name)
    jass.SaveInteger(jglobals.lua_engine,100,2,id)

    jass.ExecuteFunc("FrameFindByName")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.SimpleFrameFindByName(name,id)
    jass.SaveStr(jglobals.lua_engine,100,1,name)
    jass.SaveInteger(jglobals.lua_engine,100,2,id)
    
    jass.ExecuteFunc("SimpleFrameFindByName")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.SimpleFontStringFindByName(name,id)
    jass.SaveStr(jglobals.lua_engine,100,1,name)
    jass.SaveInteger(jglobals.lua_engine,100,2,id)
    
    jass.ExecuteFunc("SimpleFontStringFindByName")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.SimpleTextureFindByName(name,id)
    jass.SaveStr(jglobals.lua_engine,100,1,name)
    jass.SaveInteger(jglobals.lua_engine,100,2,id)
    
    jass.ExecuteFunc("SimpleTextureFindByName")
    return jass.LoadInteger(jglobals.lua_engine,100,1)
end

function _pack.FrameShow(frame,flag)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveBoolean(jglobals.lua_engine,100,2,flag)
    jass.ExecuteFunc("FrameShow")
end

function _pack.FrameSetSize(frame,w,h)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveReal(jglobals.lua_engine,100,2,w)
    jass.SaveReal(jglobals.lua_engine,100,3,h)
    jass.ExecuteFunc("FrameSetSize")
end

function _pack.FrameSetScale(frame,r)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveReal(jglobals.lua_engine,100,2,r)
    jass.ExecuteFunc("FrameSetScale")
end

-- @param point string:  CENTER TOP RIGHT BOTTOM LEFT  TOPLEFT TOPRIGHT BOTTOMLEFT BOTTOMRIGHT
function _pack.FrameSetPoint(frame,point,rFrame,rPoint,x,y)
    point = GuiPointContants[point]
    rPoint = GuiPointContants[rPoint]

    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,point)
    jass.SaveInteger(jglobals.lua_engine,100,3,rFrame)
    jass.SaveInteger(jglobals.lua_engine,100,4,rPoint)
    jass.SaveReal(jglobals.lua_engine,100,5,x)
    jass.SaveReal(jglobals.lua_engine,100,6,y)

    jass.ExecuteFunc("FrameSetPoint")
end

function _pack.FrameSetAbsolutePoint(frame,point,x,y)
    point = GuiPointContants[point]
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,point)
    jass.SaveReal(jglobals.lua_engine,100,3,x)
    jass.SaveReal(jglobals.lua_engine,100,4,y)

    jass.ExecuteFunc("FrameSetAbsolutePoint")
end

function _pack.FrameSetAllPoints(frame,rFrame)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,rFrame)
    jass.ExecuteFunc("FrameSetAllPoints")
end

function _pack.FrameClearAllPoints(frame)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.ExecuteFunc("FrameClearAllPoints")
end

function _pack.FrameSetTexture(frame,path,type)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveStr(jglobals.lua_engine,100,2,path)
    jass.SaveInteger(jglobals.lua_engine,100,3,type)
    jass.ExecuteFunc("FrameSetTexture")
end

function _pack.FrameSetText(frame,text)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveStr(jglobals.lua_engine,100,2,text)
    jass.ExecuteFunc("FrameSetText")
end

function _pack.FrameGetText(frame)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.ExecuteFunc("FrameGetText")

    return jass.LoadStr(jglobals.lua_engine,100,1)
end

function _pack.FrameSetValue(frame,r)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveReal(jglobals.lua_engine,100,2,r)
    jass.ExecuteFunc("FrameSetValue")
end

function _pack.FrameGetValue(frame)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.ExecuteFunc("FrameGetValue")
    return jass.LoadReal(jglobals.lua_engine,100,1)
end

--设置透明度 1不透明 0透明
function _pack.FrameSetAlpha(frame,real)
    if (real >1) then real = 1 end
    if (real <0) then real = 0 end
    local i = real*255
    
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,i)
    jass.ExecuteFunc("FrameSetAlpha")
end

function _pack.FrameSetStepValue(frame,r)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveReal(jglobals.lua_engine,100,2,r)
    jass.ExecuteFunc("FrameSetStepValue")
end

function _pack.FrameSetModel(frame,path,t,fg)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveStr(jglobals.lua_engine,100,2,path)
    jass.SaveInteger(jglobals.lua_engine,100,3,t)
    jass.SaveInteger(jglobals.lua_engine,100,4,fg)
    jass.ExecuteFunc("FrameSetModel")
end

function _pack.FrameSetTextSizeLimit(frame,size)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,size)
    jass.ExecuteFunc("FrameSetTextSizeLimit")
end

function _pack.FrameSetTextColor(frame,color)
    jass.SaveInteger(jglobals.lua_engine,100,1,frame)
    jass.SaveInteger(jglobals.lua_engine,100,2,color)
    jass.ExecuteFunc("FrameSetTextColor")
end

--[[
FrameSetEnable   //设置frame禁用/启用
FrameGetEnable   //获取控件是否启用
FrameGetAlpha    //获取透明度
FrameGetTextSizeLimit //获取字数限制
FrameSetAnimateOffset //设置动画进度
FrameSetAnimate       //设置动画
FrameSetTooltip       //设置tooltip
FrameSetVertexColor   //设置颜色
SetCustomFovFix       //自定义屏幕比例
FrameSetMinMaxValue   //设置最大最小值
]]

--@init
function _pack.init()
    _G.dzapi = _pack

    --暴露jass接口
    Interface.dzevent = {}

    Interface.dzevent.windowResize = function()
        for k,v in pairs (_pack.data.windowEvent) do
            v()
        end
    end

    Interface.dzevent.mouseMove = function()
        for k,v in pairs (_pack.data.mouseMoveEvent) do
            v()
        end
    end

    Interface.dzevent.keyEvent = function(key,status,id)
        if (not _pack.data.isOpenKey) then
            return 
        end

        if (_pack.data.lastKeyEvent.key == key and _pack.data.lastKeyEvent.status== status) then
            return
        else
            _pack.data.lastKeyEvent.key =key 
            _pack.data.lastKeyEvent.status= status
        end

        if (_pack.data.keyEvent[key] and _pack.data.keyEvent[key][status]) then
            local t = _pack.data.keyEvent[key][status]
            if (type(t) == "function") then
                t(key,status,id)
            else
                for _,callback in pairs(t) do
                    callback(key,status,id)
                end
            end
        end
    end

    Interface.dzevent.mouseEvent = function(key,status,id)
        -- local t = {[0]="弹起","按下"}
        -- local y = {"左键","右键"}
        if (_pack.data.mouseEvent[key] and _pack.data.mouseEvent[key][status]) then
            local t = _pack.data.mouseEvent[key][status]
            if (type(t) == "function") then
                t(key,status,id)
            else
                for _,callback in pairs(t) do
                    callback(key,status,id)
                end
            end
        end
    end

    -- frame,eventId
    Interface.dzevent.frameEvent = function(frame,eventId)
        if (_pack.data.frameEvent[frame] and _pack.data.frameEvent[frame][eventId]) then
            _pack.data.frameEvent[frame][eventId](frame,eventId)
        end
    end
    
    Interface.dzevent.syncEvent = function(id,msg)
        print("Interface.dzevent.syncEvent","接收同步消息:",id,msg)
    end

    Interface.dzevent.pauseKey = function()
        _pack.data.isOpenKey = false
    end

    Interface.dzevent.continueKey = function()
        _pack.data.isOpenKey = true
    end
end

return _pack
