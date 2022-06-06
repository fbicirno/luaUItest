globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from DZAPI:
constant boolean LIBRARY_DZAPI=true
constant hashtable lua_engine=InitHashtable()
constant trigger syncTrig=CreateTrigger()
integer DZAPI__current_frame_over=- 1
timer DZAPI__current_frame_timer=CreateTimer()
//endglobals from DZAPI
//globals from Hardware:
constant boolean LIBRARY_Hardware=true
        //初始视野等级
integer Hardware__ViewLevel= 13
        //开启玩家控制标识
boolean Hardware__TurnOnControl= false
        //镜头变化平滑度
real Hardware__WheelSpeed= 0.1
        //是否是宽屏
boolean Hardware__WideScr= false
        
boolean Hardware_lua_isLocked_camera= false
boolean Hardware_lua_isLocked_rect= false
//endglobals from Hardware
//globals from JapiConstantLib:
constant boolean LIBRARY_JapiConstantLib=true
integer array i_1
integer array i_2
integer array i_3
integer array i_4
integer array i_5
integer array i_6
integer array i_7
integer array i_8
integer array i_9
integer array i_10
integer array i_11
integer array i_12
integer array i_13
integer array i_14
integer array i_15
integer array i_16
integer array i_17
integer array i_18
integer array i_19
integer array i_20
integer array i_21
integer array i_22
integer array i_23
integer array i_24
integer array i_25
integer array i_26
integer array i_27
integer array i_28
integer array i_29
integer array i_30
integer array i_31
integer array i_32

//endglobals from JapiConstantLib
//globals from japi:
constant boolean LIBRARY_japi=true
hashtable japi_ht=InitHashtable()
integer japi__key=StringHash("jass")
//endglobals from japi
    // User-defined
unit array udg_roles
    // Generated
rect gg_rct_items= null
sound gg_snd_Error= null
sound gg_snd_CreepAggroWhat1= null
sound gg_snd_BigButtonClick= null
sound gg_snd_HeroDropItem1= null
sound gg_snd_MouseClick1= null
sound gg_snd_PickUpItem= null
sound gg_snd_GoblinMerchantWhat2= null
sound gg_snd_GoblinMerchantWhat1= null
sound gg_snd_GoblinMerchantWhat3= null
sound gg_snd_AltarOfKingsWhat1= null
sound gg_snd_KnightNoGold1= null
sound gg_snd_KnightNoLumber1= null
sound gg_snd_KnightInventoryFull1= null
trigger gg_trg_ydjapi= null
trigger gg_trg_wjapi= null
trigger gg_trg_dzapi= null
trigger gg_trg_mouse= null
trigger gg_trg_init= null
trigger gg_trg_start= null
unit gg_unit_H001_0010= null
unit gg_unit_H00A_0018= null
unit gg_unit_H009_0017= null
unit gg_unit_H008_0016= null
unit gg_unit_H000_0009= null
unit gg_unit_H002_0008= null
unit gg_unit_H00B_0019= null
unit gg_unit_H003_0011= null
unit gg_unit_H004_0012= null
unit gg_unit_H005_0013= null
unit gg_unit_H006_0014= null
unit gg_unit_H007_0015= null

trigger l__library_init

//JASSHelper struct globals:

endglobals
    native DzGetMouseTerrainX takes nothing returns real
    native DzGetMouseTerrainY takes nothing returns real
    native DzGetMouseTerrainZ takes nothing returns real
    native DzIsMouseOverUI takes nothing returns boolean
    native DzGetMouseX takes nothing returns integer
    native DzGetMouseY takes nothing returns integer
    native DzGetMouseXRelative takes nothing returns integer
    native DzGetMouseYRelative takes nothing returns integer
    native DzSetMousePos takes integer x, integer y returns nothing
    native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzGetTriggerKey takes nothing returns integer
    native DzGetWheelDelta takes nothing returns integer
    native DzIsKeyDown takes integer iKey returns boolean
    native DzGetTriggerKeyPlayer takes nothing returns player
    native DzGetWindowWidth takes nothing returns integer
    native DzGetWindowHeight takes nothing returns integer
    native DzGetWindowX takes nothing returns integer
    native DzGetWindowY takes nothing returns integer
    native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzIsWindowActive takes nothing returns boolean
    native DzDestructablePosition takes destructable d, real x, real y returns nothing
    native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
    native DzExecuteFunc takes string funcName returns nothing
    native DzGetUnitUnderMouse takes nothing returns unit
    native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
    native DzSetMemory takes integer address, real value returns nothing
    native DzSetUnitID takes unit whichUnit, integer id returns nothing
    native DzSetUnitModel takes unit whichUnit, string path returns nothing
    native DzSetWar3MapMap takes string map returns nothing
    native DzGetLocale takes nothing returns string
    native DzGetUnitNeededXP takes unit whichUnit, integer level returns integer
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzFrameHideInterface takes nothing returns nothing
    native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
    native DzFrameGetPortrait takes nothing returns integer
    native DzFrameGetMinimap takes nothing returns integer
    native DzFrameGetCommandBarButton takes integer row, integer column returns integer
    native DzFrameGetHeroBarButton takes integer buttonId returns integer
    native DzFrameGetHeroHPBar takes integer buttonId returns integer
    native DzFrameGetHeroManaBar takes integer buttonId returns integer
    native DzFrameGetItemBarButton takes integer buttonId returns integer
    native DzFrameGetMinimapButton takes integer buttonId returns integer
    native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
    native DzFrameGetTooltip takes nothing returns integer
    native DzFrameGetChatMessage takes nothing returns integer
    native DzFrameGetUnitMessage takes nothing returns integer
    native DzFrameGetTopMessage takes nothing returns integer
    native DzGetColor takes integer r, integer g, integer b, integer a returns integer
    native DzFrameSetUpdateCallback takes string func returns nothing
    native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
    native DzFrameShow takes integer frame, boolean enable returns nothing
    native DzCreateFrame takes string frame, integer parent, integer id returns integer
    native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
    native DzDestroyFrame takes integer frame returns nothing
    native DzLoadToc takes string fileName returns nothing
    native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
    native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
    native DzFrameClearAllPoints takes integer frame returns nothing
    native DzFrameSetEnable takes integer name, boolean enable returns nothing
    native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
    native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
    native DzGetTriggerUIEventPlayer takes nothing returns player
    native DzGetTriggerUIEventFrame takes nothing returns integer
    native DzFrameFindByName takes string name, integer id returns integer
    native DzSimpleFrameFindByName takes string name, integer id returns integer
    native DzSimpleFontStringFindByName takes string name, integer id returns integer
    native DzSimpleTextureFindByName takes string name, integer id returns integer
    native DzGetGameUI takes nothing returns integer
    native DzClickFrame takes integer frame returns nothing
    native DzSetCustomFovFix takes real value returns nothing
    native DzEnableWideScreen takes boolean enable returns nothing
    native DzFrameSetText takes integer frame, string text returns nothing
    native DzFrameGetText takes integer frame returns string
    native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
    native DzFrameGetTextSizeLimit takes integer frame returns integer
    native DzFrameSetTextColor takes integer frame, integer color returns nothing
    native DzGetMouseFocus takes nothing returns integer
    native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
    native DzFrameSetFocus takes integer frame, boolean enable returns boolean
    native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
    native DzFrameGetEnable takes integer frame returns boolean
    native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
    native DzFrameGetAlpha takes integer frame returns integer
    native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
    native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
    native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
    native DzFrameSetScale takes integer frame, real scale returns nothing
    native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
    native DzFrameCageMouse takes integer frame, boolean enable returns nothing
    native DzFrameGetValue takes integer frame returns real
    native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
    native DzFrameSetStepValue takes integer frame, real step returns nothing
    native DzFrameSetValue takes integer frame, real value returns nothing
    native DzFrameSetSize takes integer frame, real w, real h returns nothing
    native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
    native DzFrameSetVertexColor takes integer frame, integer color returns nothing
    native DzOriginalUIAutoResetPoint takes boolean enable returns nothing
    native DzFrameSetPriority takes integer frame, integer priority returns nothing
    native DzFrameSetParent takes integer frame, integer parent returns nothing
    native DzFrameGetHeight takes integer frame returns real
    native DzFrameSetFont takes integer frame, string fileName, real height, integer flag returns nothing
    native DzFrameGetParent takes integer frame returns integer
    native DzFrameSetTextAlignment takes integer frame, integer align returns nothing
    native DzFrameGetName takes integer frame returns string
    native SetHeroLevels takes code f returns nothing 
    native TeleportCaptain takes real x, real y returns nothing
    native GetUnitGoldCost takes integer unitid returns integer


//library BzAPI:
    //hardware




























    //plus











    //sync




    //gui








































































    function DzTriggerRegisterMouseEventTrg takes trigger trg,integer status,integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterKeyEventTrg takes trigger trg,integer status,integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterMouseMoveEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseMoveEvent(trg, true, null)
    endfunction
    function DzTriggerRegisterMouseWheelEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseWheelEvent(trg, true, null)
    endfunction
    function DzTriggerRegisterWindowResizeEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterWindowResizeEvent(trg, true, null)
    endfunction
    function DzF2I takes integer i returns integer
        return i
    endfunction
    function DzI2F takes integer i returns integer
        return i
    endfunction
    function DzK2I takes integer i returns integer
        return i
    endfunction
    function DzI2K takes integer i returns integer
        return i
    endfunction

//library BzAPI ends
//library DZAPI:

    //public:
        function DZAPI__anon__0 takes nothing returns nothing
            call AbilityId("Interface.dzevent.windowResize()")
        endfunction
        function DZAPI__anon__1 takes nothing returns nothing
            if ( DZAPI__current_frame_over != - 1 ) then
                call AbilityId("Interface.dzevent.frameEvent(" + I2S(DZAPI__current_frame_over) + ",1)")
            else
                call AbilityId("Interface.dzevent.mouseEvent(1,1)")
            endif
        endfunction
        function DZAPI__anon__2 takes nothing returns nothing
            if ( DZAPI__current_frame_over == - 1 ) then
                call AbilityId("Interface.dzevent.mouseEvent(1,0)")
            endif
        endfunction
        function DZAPI__anon__3 takes nothing returns nothing
            if ( DZAPI__current_frame_over != - 1 ) then
                call AbilityId("Interface.dzevent.frameEvent(" + I2S(DZAPI__current_frame_over) + ",4)")
            else
                call AbilityId("Interface.dzevent.mouseEvent(2,1)")
            endif
        endfunction
        function DZAPI__anon__4 takes nothing returns nothing
            if ( DZAPI__current_frame_over == - 1 ) then
                call AbilityId("Interface.dzevent.mouseEvent(2,0)")
            endif
        endfunction
        function DZAPI__anon__5 takes nothing returns nothing
            local integer mw=DzGetWheelDelta()
            call AbilityId("Interface.dzevent.mouseEvent(2," + I2S(mw) + ")")
        endfunction
        function DZAPI__anon__6 takes nothing returns boolean
            local string msg=DzGetTriggerSyncData()
            local integer id=GetPlayerId(DzGetTriggerSyncPlayer())
            call AbilityId("Interface.dzevent.syncEvent(" + I2S(id) + ",[===[" + msg + "]===])")
            return false
        endfunction
    function DZAPI__onInit takes nothing returns nothing
        call DzTriggerRegisterWindowResizeEventByCode(null, false, function DZAPI__anon__0)
        call DzTriggerRegisterMouseEventByCode(null, 1, 1, false, function DZAPI__anon__1)
        call DzTriggerRegisterMouseEventByCode(null, 1, 0, false, function DZAPI__anon__2)
        call DzTriggerRegisterMouseEventByCode(null, 2, 1, false, function DZAPI__anon__3)
        call DzTriggerRegisterMouseEventByCode(null, 2, 0, false, function DZAPI__anon__4)
        call DzTriggerRegisterMouseWheelEventByCode(null, false, function DZAPI__anon__5)
        call DzTriggerRegisterSyncData(syncTrig, "sync", false)
        call TriggerAddCondition(syncTrig, Condition(function DZAPI__anon__6))
        call SaveInteger(lua_engine, 101, 1, DzGetGameUI()) //界面类
        call SaveInteger(lua_engine, 101, 2, DzFrameGetPortrait())
        call SaveInteger(lua_engine, 101, 3, DzFrameGetMinimap())
        call SaveInteger(lua_engine, 101, 4, DzFrameGetUpperButtonBarButton(0))
        call SaveInteger(lua_engine, 101, 5, DzFrameGetUpperButtonBarButton(1))
        call SaveInteger(lua_engine, 101, 6, DzFrameGetUpperButtonBarButton(2))
        call SaveInteger(lua_engine, 101, 7, DzFrameGetUpperButtonBarButton(3)) // SaveInteger(lua_engine,101,8,DzFrameGetUpperButtonBarButton(4));
        call SaveInteger(lua_engine, 101, 10, DzFrameGetHeroBarButton(0)) // SaveInteger(lua_engine,101,9,DzFrameGetUpperButtonBarButton(5));
        call SaveInteger(lua_engine, 101, 11, DzFrameGetHeroBarButton(1))
        call SaveInteger(lua_engine, 101, 12, DzFrameGetHeroBarButton(2))
        call SaveInteger(lua_engine, 101, 13, DzFrameGetHeroBarButton(3))
        call SaveInteger(lua_engine, 101, 14, DzFrameGetHeroBarButton(4))
        call SaveInteger(lua_engine, 101, 15, DzFrameGetHeroBarButton(5))
        call SaveInteger(lua_engine, 101, 16, DzFrameGetHeroBarButton(6)) // SaveInteger(lua_engine,101,18,DzFrameGetHeroBarButton(7));
        call SaveInteger(lua_engine, 101, 19, DzFrameGetHeroHPBar(0))
        call SaveInteger(lua_engine, 101, 20, DzFrameGetHeroHPBar(1))
        call SaveInteger(lua_engine, 101, 21, DzFrameGetHeroHPBar(2))
        call SaveInteger(lua_engine, 101, 22, DzFrameGetHeroHPBar(3))
        call SaveInteger(lua_engine, 101, 23, DzFrameGetHeroHPBar(4))
        call SaveInteger(lua_engine, 101, 24, DzFrameGetHeroHPBar(5))
        call SaveInteger(lua_engine, 101, 25, DzFrameGetHeroHPBar(6)) // SaveInteger(lua_engine,101,26,DzFrameGetHeroHPBar(7));
        call SaveInteger(lua_engine, 101, 27, DzFrameGetHeroManaBar(0))
        call SaveInteger(lua_engine, 101, 28, DzFrameGetHeroManaBar(1))
        call SaveInteger(lua_engine, 101, 20, DzFrameGetHeroManaBar(2))
        call SaveInteger(lua_engine, 101, 30, DzFrameGetHeroManaBar(3))
        call SaveInteger(lua_engine, 101, 31, DzFrameGetHeroManaBar(4))
        call SaveInteger(lua_engine, 101, 32, DzFrameGetHeroManaBar(5))
        call SaveInteger(lua_engine, 101, 33, DzFrameGetHeroManaBar(6)) // SaveInteger(lua_engine,101,34,DzFrameGetHeroManaBar(7));
        call SaveInteger(lua_engine, 101, 35, DzFrameGetItemBarButton(0))
        call SaveInteger(lua_engine, 101, 36, DzFrameGetItemBarButton(1))
        call SaveInteger(lua_engine, 101, 37, DzFrameGetItemBarButton(2))
        call SaveInteger(lua_engine, 101, 38, DzFrameGetItemBarButton(3))
        call SaveInteger(lua_engine, 101, 39, DzFrameGetItemBarButton(4))
        call SaveInteger(lua_engine, 101, 40, DzFrameGetItemBarButton(5))
        call SaveInteger(lua_engine, 101, 41, DzFrameGetMinimapButton(0))
        call SaveInteger(lua_engine, 101, 42, DzFrameGetMinimapButton(1))
        call SaveInteger(lua_engine, 101, 43, DzFrameGetMinimapButton(2))
        call SaveInteger(lua_engine, 101, 44, DzFrameGetMinimapButton(3))
        call SaveInteger(lua_engine, 101, 45, DzFrameGetMinimapButton(4)) // SaveInteger(lua_engine,101,46,DzFrameGetMinimapButton(5));
        call SaveInteger(lua_engine, 101, 47, DzFrameGetTooltip())
        call SaveInteger(lua_engine, 101, 48, DzFrameGetChatMessage())
        call SaveInteger(lua_engine, 101, 49, DzFrameGetUnitMessage())
        call SaveInteger(lua_engine, 101, 50, DzFrameGetTopMessage())
        call SaveInteger(lua_engine, 101, 51, DzFrameGetCommandBarButton(0, 0))
        call SaveInteger(lua_engine, 101, 52, DzFrameGetCommandBarButton(0, 1))
        call SaveInteger(lua_engine, 101, 53, DzFrameGetCommandBarButton(0, 2))
        call SaveInteger(lua_engine, 101, 54, DzFrameGetCommandBarButton(0, 3))
        call SaveInteger(lua_engine, 101, 55, DzFrameGetCommandBarButton(1, 0))
        call SaveInteger(lua_engine, 101, 56, DzFrameGetCommandBarButton(1, 1))
        call SaveInteger(lua_engine, 101, 57, DzFrameGetCommandBarButton(1, 2))
        call SaveInteger(lua_engine, 101, 58, DzFrameGetCommandBarButton(1, 3))
        call SaveInteger(lua_engine, 101, 59, DzFrameGetCommandBarButton(2, 0))
        call SaveInteger(lua_engine, 101, 60, DzFrameGetCommandBarButton(2, 1))
        call SaveInteger(lua_engine, 101, 61, DzFrameGetCommandBarButton(2, 2))
        call SaveInteger(lua_engine, 101, 62, DzFrameGetCommandBarButton(2, 3))
    endfunction
    //public:  //封装函数
        function GetMouseTerrain takes nothing returns nothing
            call SaveReal(lua_engine, 100, 1, DzGetMouseTerrainX())
            call SaveReal(lua_engine, 100, 2, DzGetMouseTerrainY())
            call SaveReal(lua_engine, 100, 3, DzGetMouseTerrainZ())
        endfunction
        function GetMouseXY takes nothing returns nothing
            call SaveReal(lua_engine, 100, 1, DzGetMouseX())
            call SaveReal(lua_engine, 100, 2, DzGetMouseY())
        endfunction
        function GetMouseRelative takes nothing returns nothing
            call SaveReal(lua_engine, 100, 1, DzGetMouseXRelative())
            call SaveReal(lua_engine, 100, 2, DzGetMouseYRelative())
        endfunction
        function SetMousePos takes nothing returns nothing
            local integer x=LoadInteger(lua_engine, 100, 1)
            local integer y=LoadInteger(lua_engine, 100, 2)
            call DzSetMousePos(x, y)
        endfunction
        function GetWindow takes nothing returns nothing
            call SaveInteger(lua_engine, 100, 1, DzGetWindowWidth())
            call SaveInteger(lua_engine, 100, 2, DzGetWindowHeight())
        endfunction
        function GetWindowXY takes nothing returns nothing
            call SaveInteger(lua_engine, 100, 1, DzGetWindowX())
            call SaveInteger(lua_engine, 100, 2, DzGetWindowY())
        endfunction
        function IsWindowActive takes nothing returns nothing
            call SaveBoolean(lua_engine, 100, 1, DzIsWindowActive())
        endfunction
    //public:
            function DZAPI__anon__7 takes nothing returns nothing
                local integer k=DzGetTriggerKey()
                local integer id=GetPlayerId(DzGetTriggerKeyPlayer())
                call AbilityId("Interface.dzevent.keyEvent(" + I2S(k) + ",1," + I2S(id) + ")")
            endfunction
            function DZAPI__anon__8 takes nothing returns nothing
                local integer k=DzGetTriggerKey()
                local integer id=GetPlayerId(DzGetTriggerKeyPlayer())
                call AbilityId("Interface.dzevent.keyEvent(" + I2S(k) + ",0," + I2S(id) + ")")
            endfunction
        function RegisterKeyEvent takes nothing returns nothing
            local integer k=LoadInteger(lua_engine, 100, 1)
            call DzTriggerRegisterKeyEventByCode(null, k, 1, false, function DZAPI__anon__7)
            call DzTriggerRegisterKeyEventByCode(null, k, 0, false, function DZAPI__anon__8)
        endfunction
        //private:
            function DZAPI__anon__9 takes nothing returns nothing
                local integer id=GetPlayerId(DzGetTriggerUIEventPlayer())
                local integer frame=DzGetTriggerUIEventFrame()
                call AbilityId("Interface.dzevent.frameEvent(" + I2S(frame) + ",2)") // frame,eventId
                call PauseTimer(DZAPI__current_frame_timer)
                set DZAPI__current_frame_over=frame
            endfunction
                function DZAPI__anon__11 takes nothing returns nothing
                    set DZAPI__current_frame_over=- 1
                endfunction
            function DZAPI__anon__10 takes nothing returns nothing
                local integer id=GetPlayerId(DzGetTriggerUIEventPlayer())
                local integer frame=DzGetTriggerUIEventFrame()
                call AbilityId("Interface.dzevent.frameEvent(" + I2S(frame) + ",3)")
                call TimerStart(DZAPI__current_frame_timer, 0.15, false, function DZAPI__anon__11)
            endfunction
        function RegisterFrameEvent takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call DzFrameSetScriptByCode(f, 2, function DZAPI__anon__9, false)
            call DzFrameSetScriptByCode(f, 3, function DZAPI__anon__10, false)
        endfunction
        function IsKeyDown takes nothing returns nothing
            local integer k=LoadInteger(lua_engine, 100, 1)
            call SaveBoolean(lua_engine, 100, 1, DzIsKeyDown(k))
        endfunction
        function ClickFrame takes nothing returns nothing
            local integer k=LoadInteger(lua_engine, 100, 1)
            call DzClickFrame(k)
        endfunction
        function FrameSetFocus takes nothing returns nothing
            local integer k=LoadInteger(lua_engine, 100, 1)
            local boolean b=LoadBoolean(lua_engine, 100, 2)
            call DzFrameSetFocus(k, b)
        endfunction
        function FrameGetMouseFocus takes nothing returns nothing
            call SaveInteger(lua_engine, 100, 1, DzGetMouseFocus())
        endfunction
    //public:  //native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing //native DzIsMouseOverUI takes nothing returns boolean
        function LoadToc takes nothing returns nothing
            local string path=LoadStr(lua_engine, 100, 1)
            call DzLoadToc(path)
            set path=null
        endfunction
        function FrameEditBlackBorders takes nothing returns nothing
            local real x=LoadReal(lua_engine, 100, 1)
            local real y=LoadReal(lua_engine, 100, 2)
            call DzFrameEditBlackBorders(x, y)
        endfunction
        function GetColor takes nothing returns nothing
            local integer a1=LoadInteger(lua_engine, 100, 1)
            local integer a2=LoadInteger(lua_engine, 100, 1)
            local integer a3=LoadInteger(lua_engine, 100, 1)
            local integer a4=LoadInteger(lua_engine, 100, 1)
            call SaveInteger(lua_engine, 100, 1, DzGetColor(a1, a2, a3, a4))
        endfunction
        function EnableWideScreen takes nothing returns nothing
            local boolean f=LoadBoolean(lua_engine, 100, 1)
            call DzEnableWideScreen(f)
        endfunction
        function SetWar3MapMap takes nothing returns nothing
            local string path=LoadStr(lua_engine, 100, 1)
            call DzSetWar3MapMap(path)
            set path=null
        endfunction
        function CreateFrame takes nothing returns nothing
            local string frame=LoadStr(lua_engine, 100, 1)
            local integer parent=LoadInteger(lua_engine, 100, 2)
            local integer id=LoadInteger(lua_engine, 100, 3)
            call SaveInteger(lua_engine, 100, 1, DzCreateFrame(frame, parent, id))
            set frame=null
        endfunction
        function CreateSimpleFrame takes nothing returns nothing
            local string frame=LoadStr(lua_engine, 100, 1)
            local integer parent=LoadInteger(lua_engine, 100, 2)
            local integer id=LoadInteger(lua_engine, 100, 3)
            call SaveInteger(lua_engine, 100, 1, DzCreateSimpleFrame(frame, parent, id))
            set frame=null
        endfunction
        function CreateFrameByTagName takes nothing returns nothing
            local string frame=LoadStr(lua_engine, 100, 1)
            local string name=LoadStr(lua_engine, 100, 2)
            local integer parent=LoadInteger(lua_engine, 100, 3)
            local string template=LoadStr(lua_engine, 100, 4)
            local integer id=LoadInteger(lua_engine, 100, 5)
            call SaveInteger(lua_engine, 100, 1, DzCreateFrameByTagName(frame, name, parent, template, id))
            set frame=null
            set name=null
            set template=null
        endfunction
        function DestroyFrame takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call DzDestroyFrame(f)
        endfunction
        function FrameFindByName takes nothing returns nothing
            local string name=LoadStr(lua_engine, 100, 1)
            local integer id=LoadInteger(lua_engine, 100, 2)
            call SaveInteger(lua_engine, 100, 1, DzFrameFindByName(name, id))
            set name=null
        endfunction
        function SimpleFrameFindByName takes nothing returns nothing
            local string name=LoadStr(lua_engine, 100, 1)
            local integer id=LoadInteger(lua_engine, 100, 2)
            call SaveInteger(lua_engine, 100, 1, DzSimpleFrameFindByName(name, id))
            set name=null
        endfunction
        function SimpleFontStringFindByName takes nothing returns nothing
            local string name=LoadStr(lua_engine, 100, 1)
            local integer id=LoadInteger(lua_engine, 100, 2)
            call SaveInteger(lua_engine, 100, 1, DzSimpleFontStringFindByName(name, id))
            set name=null
        endfunction
        function SimpleTextureFindByName takes nothing returns nothing
            local string name=LoadStr(lua_engine, 100, 1)
            local integer id=LoadInteger(lua_engine, 100, 2)
            call SaveInteger(lua_engine, 100, 1, DzSimpleTextureFindByName(name, id))
            set name=null
        endfunction
        function FrameShow takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local boolean b=LoadBoolean(lua_engine, 100, 2)
            call DzFrameShow(f, b)
        endfunction
        function FrameSetEnable takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local boolean b=LoadBoolean(lua_engine, 100, 2)
            call DzFrameSetEnable(f, b)
        endfunction
        function FrameGetEnable takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call SaveBoolean(lua_engine, 100, 1, DzFrameGetEnable(f))
        endfunction
        function FrameSetSize takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real w=LoadReal(lua_engine, 100, 2)
            local real h=LoadReal(lua_engine, 100, 3)
            call DzFrameSetSize(f, w, h)
        endfunction
        function FrameSetScale takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real w=LoadReal(lua_engine, 100, 2)
            call DzFrameSetScale(f, w)
        endfunction
        function FrameSetPoint takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer pt=LoadInteger(lua_engine, 100, 2)
            local integer rf=LoadInteger(lua_engine, 100, 3)
            local integer rpt=LoadInteger(lua_engine, 100, 4)
            local real x=LoadReal(lua_engine, 100, 5)
            local real y=LoadReal(lua_engine, 100, 6)
            call DzFrameSetPoint(f, pt, rf, rpt, x, y)
        endfunction
        function FrameSetAbsolutePoint takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer pt=LoadInteger(lua_engine, 100, 2)
            local real x=LoadReal(lua_engine, 100, 3)
            local real y=LoadReal(lua_engine, 100, 4)
            call DzFrameSetAbsolutePoint(f, pt, x, y)
        endfunction
        function FrameSetAllPoints takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer pt=LoadInteger(lua_engine, 100, 2)
            call DzFrameSetAllPoints(f, pt)
        endfunction
        function FrameClearAllPoints takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call DzFrameClearAllPoints(f)
        endfunction
        function FrameSetTexture takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local string s=LoadStr(lua_engine, 100, 2)
            local integer fg=LoadInteger(lua_engine, 100, 3)
            call DzFrameSetTexture(f, s, fg)
            set s=null
        endfunction
        function FrameSetText takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local string s=LoadStr(lua_engine, 100, 2)
            call DzFrameSetText(f, s)
            set s=null
        endfunction
        function FrameGetText takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call SaveStr(lua_engine, 100, 1, DzFrameGetText(f))
        endfunction
        function FrameSetTextSizeLimit takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer sz=LoadInteger(lua_engine, 100, 2)
            call DzFrameSetTextSizeLimit(f, sz)
        endfunction
        function FrameGetTextSizeLimit takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call SaveInteger(lua_engine, 100, 1, DzFrameGetTextSizeLimit(f))
        endfunction
        function FrameSetTextColor takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer sz=LoadInteger(lua_engine, 100, 2)
            call DzFrameSetTextColor(f, sz)
        endfunction
        function FrameSetValue takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real r=LoadReal(lua_engine, 100, 2)
            call DzFrameSetValue(f, r)
        endfunction
        function FrameGetValue takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call SaveReal(lua_engine, 100, 1, DzFrameGetValue(f))
        endfunction
        function FrameSetAlpha takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer a=LoadInteger(lua_engine, 100, 2)
            call DzFrameSetAlpha(f, a)
        endfunction
        function FrameGetAlpha takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            call SaveInteger(lua_engine, 100, 1, DzFrameGetAlpha(f))
        endfunction
        function FrameSetAnimateOffset takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real r=LoadReal(lua_engine, 100, 2)
            call DzFrameSetAnimateOffset(f, r)
        endfunction
        function FrameSetAnimate takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer a=LoadInteger(lua_engine, 100, 2)
            local boolean b=LoadBoolean(lua_engine, 100, 3)
            call DzFrameSetAnimate(f, a, b)
        endfunction
        function FrameSetTooltip takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer a=LoadInteger(lua_engine, 100, 2)
            call DzFrameSetTooltip(f, a)
        endfunction
        function FrameSetVertexColor takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local integer a=LoadInteger(lua_engine, 100, 2)
            call DzFrameSetVertexColor(f, a)
        endfunction
        function FrameSetStepValue takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real r=LoadReal(lua_engine, 100, 2)
            call DzFrameSetStepValue(f, r)
        endfunction
        function FrameSetModel takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local string s=LoadStr(lua_engine, 100, 2)
            local integer t=LoadInteger(lua_engine, 100, 3)
            local integer fg=LoadInteger(lua_engine, 100, 4)
            call DzFrameSetModel(f, s, t, fg)
            set s=null
        endfunction
        function SetCustomFovFix takes nothing returns nothing
            local real r=LoadReal(lua_engine, 100, 1)
            call DzSetCustomFovFix(r)
        endfunction
        function FrameCageMouse takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local boolean b=LoadBoolean(lua_engine, 100, 2)
            call DzFrameCageMouse(f, b)
        endfunction
        function FrameSetMinMaxValue takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real min=LoadReal(lua_engine, 100, 2)
            local real max=LoadReal(lua_engine, 100, 3)
            call DzFrameSetMinMaxValue(f, min, max)
        endfunction
    //public:
        function EXExecuteFunc takes nothing returns nothing
            local string s=LoadStr(lua_engine, 100, 1)
            call DzExecuteFunc(s)
            set s=null
        endfunction
        function EXSetMemory takes nothing returns nothing
            local integer f=LoadInteger(lua_engine, 100, 1)
            local real r=LoadReal(lua_engine, 100, 2)
            call DzSetMemory(f, r)
        endfunction
        function SyncData takes nothing returns nothing
            local string s=LoadStr(lua_engine, 100, 1)
            call DzSyncData("sync", s)
        endfunction
    //public:
        function EXDestructablePosition takes nothing returns nothing
            local destructable d=LoadDestructableHandle(lua_engine, 100, 1)
            local real x=LoadReal(lua_engine, 100, 2)
            local real y=LoadReal(lua_engine, 100, 3)
            call DzDestructablePosition(d, x, y)
            set d=null
            call FlushChildHashtable(lua_engine, 100)
        endfunction
        function EXSetUnitPosition takes nothing returns nothing
            local unit d=LoadUnitHandle(lua_engine, 100, 1)
            local real x=LoadReal(lua_engine, 100, 2)
            local real y=LoadReal(lua_engine, 100, 3)
            call DzSetUnitPosition(d, x, y)
            set d=null
            call FlushChildHashtable(lua_engine, 100)
        endfunction
        function EXGetUnitUnderMouse takes nothing returns nothing
            call SaveUnitHandle(lua_engine, 100, 1, DzGetUnitUnderMouse())
        endfunction
        function EXSetUnitTexture takes nothing returns nothing
            local unit d=LoadUnitHandle(lua_engine, 100, 1)
            local string s=LoadStr(lua_engine, 100, 2)
            local integer t=LoadInteger(lua_engine, 100, 3)
            call DzSetUnitTexture(d, s, t)
            set d=null
            set s=null
            call FlushChildHashtable(lua_engine, 100)
        endfunction
        function EXSetUnitID takes nothing returns nothing
            local unit d=LoadUnitHandle(lua_engine, 100, 1)
            local integer t=LoadInteger(lua_engine, 100, 2)
            call DzSetUnitID(d, t)
            set d=null
            call FlushChildHashtable(lua_engine, 100)
        endfunction
        function EXSetUnitModel takes nothing returns nothing
            local unit d=LoadUnitHandle(lua_engine, 100, 1)
            local string s=LoadStr(lua_engine, 100, 2)
            call DzSetUnitModel(d, s)
            set d=null
            set s=null
            call FlushChildHashtable(lua_engine, 100)
        endfunction

//library DZAPI ends
//library Hardware:
    
    //鼠标滚轮变化时调用
    function Hardware__OnWheel takes nothing returns nothing
        //滚轮变化量
        local integer delta= DzGetWheelDelta()
        //如果鼠标不在游戏内，就不响应鼠标滚轮
        if not DzIsMouseOverUI() then
            return
        endif
        set Hardware__TurnOnControl=true
        //关闭玩家控制，即可不触发滚轮事件中魔兽原生设定的镜头变化
        call EnableUserControl(false)
        if delta < 0 then
            //滚轮下滑
            if Hardware__ViewLevel < 14 then //视野等级上限
set Hardware__ViewLevel=Hardware__ViewLevel + 1
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, Hardware__ViewLevel * 200, Hardware__WheelSpeed)
            endif
        else
            //滚轮上滑
            if Hardware__ViewLevel > 3 then //视野等级下限
set Hardware__ViewLevel=Hardware__ViewLevel - 1
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, Hardware__ViewLevel * 200, Hardware__WheelSpeed)
            endif
        endif
    endfunction
    //每帧渲染时调用
    function Hardware__Update takes nothing returns nothing
        if Hardware__TurnOnControl then
            //开启被禁用的玩家控制
            //注意，如果你在其它地方有关闭玩家控制，应当考虑与滚轮的兼容性
            //如果你不想出现滚轮可以解除禁用玩家控制的BUG，需要在滚轮改变时或此处做判断
            call EnableUserControl(true)
            set Hardware__TurnOnControl=false
        endif
    endfunction
    //按键触发
    function SetWideScreen takes nothing returns nothing
        set Hardware__WideScr=not Hardware__WideScr
        call DzEnableWideScreen(Hardware__WideScr)
    endfunction
    function Hardware__Init takes nothing returns nothing
        // call FogEnable( false )
        // call FogMaskEnable( false )
        //注册滚轮事件
        call DzTriggerRegisterMouseWheelEventByCode(null, false, function Hardware__OnWheel)
        //注册每帧渲染事件
        call DzFrameSetUpdateCallbackByCode(function Hardware__Update)
        //注册按下键码为145的按键(ScrollLock)事件
        call DzTriggerRegisterKeyEventByCode(null, 145, 1, false, function SetWideScreen)
    endfunction

//library Hardware ends
//library JapiConstantLib:
    function JapiConstantLib_init_memory takes nothing returns nothing
         set i_1[8191]=0
 set i_2[8191]=0
 set i_3[8191]=0
 set i_4[8191]=0
 set i_5[8191]=0
 set i_6[8191]=0
 set i_7[8191]=0
 set i_8[8191]=0
 set i_9[8191]=0
 set i_10[8191]=0
 set i_11[8191]=0
 set i_12[8191]=0
 set i_13[8191]=0
 set i_14[8191]=0
 set i_15[8191]=0
 set i_16[8191]=0
 set i_17[8191]=0
 set i_18[8191]=0
 set i_19[8191]=0
 set i_20[8191]=0
 set i_21[8191]=0
 set i_22[8191]=0
 set i_23[8191]=0
 set i_24[8191]=0
 set i_25[8191]=0
 set i_26[8191]=0
 set i_27[8191]=0
 set i_28[8191]=0
 set i_29[8191]=0
 set i_30[8191]=0
 set i_31[8191]=0
 set i_32[8191]=0

    endfunction
    function JapiConstantLib_init takes nothing returns integer
        call ExecuteFunc("JapiConstantLib_init_memory")
        return 1
    endfunction

//library JapiConstantLib ends
//library japi:



    
    function japi_japiDoNothing takes nothing returns nothing
    
    endfunction
    
    function japi_GetFuncAddr takes code f returns integer
        call SetHeroLevels(f)
        return LoadInteger(japi_ht, japi__key, 0)
    endfunction
    
    function japi_Call takes string str returns nothing
        call UnitId(str)
    endfunction
    
    function japi_initializePlugin takes nothing returns integer
        call ExecuteFunc("japiDoNothing")
        call StartCampaignAI(Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback")
        call japi_Call(I2S(GetHandleId(japi_ht)))
        call SaveStr(japi_ht, japi__key, 0, "(I)V")
        call SaveInteger(japi_ht, japi__key, 1, japi_GetFuncAddr(function japi_japiDoNothing))
        call japi_Call("SaveFunc")
        call ExecuteFunc("japiDoNothing")
        return 0
    endfunction

//library japi ends
//===========================================================================
// 
// 幻想骑空士团
// 
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Wed Jun 02 12:04:14 2021
//   Map Author: knciik
// 
//===========================================================================
//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************
function InitGlobals takes nothing returns nothing
    local integer i= 0
endfunction
//***************************************************************************
//*
//*  Sounds
//*
//***************************************************************************
function InitSounds takes nothing returns nothing
    set gg_snd_Error=CreateSound("Sound\\Interface\\Error.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_Error, "InterfaceError")
    call SetSoundDuration(gg_snd_Error, 614)
    set gg_snd_CreepAggroWhat1=CreateSound("Sound\\Interface\\CreepAggroWhat1.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_CreepAggroWhat1, "CreepAggro")
    call SetSoundDuration(gg_snd_CreepAggroWhat1, 1236)
    set gg_snd_BigButtonClick=CreateSound("Sound\\Interface\\BigButtonClick.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_BigButtonClick, "GlueScreenClick")
    call SetSoundDuration(gg_snd_BigButtonClick, 390)
    set gg_snd_HeroDropItem1=CreateSound("Sound\\Interface\\HeroDropItem1.wav", false, true, true, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_HeroDropItem1, "ItemDrop")
    call SetSoundDuration(gg_snd_HeroDropItem1, 486)
    set gg_snd_MouseClick1=CreateSound("Sound\\Interface\\MouseClick1.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_MouseClick1, "InterfaceClick")
    call SetSoundDuration(gg_snd_MouseClick1, 239)
    set gg_snd_PickUpItem=CreateSound("Sound\\Interface\\PickUpItem.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_PickUpItem, "ItemGet")
    call SetSoundDuration(gg_snd_PickUpItem, 174)
    set gg_snd_GoblinMerchantWhat2=CreateSound("Sound\\Buildings\\Other\\Merchant\\GoblinMerchantWhat2.wav", false, true, true, 10, 10, "DefaultEAXON")
    call SetSoundParamsFromLabel(gg_snd_GoblinMerchantWhat2, "MerchantWhat")
    call SetSoundDuration(gg_snd_GoblinMerchantWhat2, 940)
    set gg_snd_GoblinMerchantWhat1=CreateSound("Sound\\Buildings\\Other\\Merchant\\GoblinMerchantWhat1.wav", false, true, true, 10, 10, "DefaultEAXON")
    call SetSoundParamsFromLabel(gg_snd_GoblinMerchantWhat1, "MerchantWhat")
    call SetSoundDuration(gg_snd_GoblinMerchantWhat1, 583)
    set gg_snd_GoblinMerchantWhat3=CreateSound("Sound\\Buildings\\Other\\Merchant\\GoblinMerchantWhat3.wav", false, true, true, 10, 10, "DefaultEAXON")
    call SetSoundParamsFromLabel(gg_snd_GoblinMerchantWhat3, "MerchantWhat")
    call SetSoundDuration(gg_snd_GoblinMerchantWhat3, 1547)
    set gg_snd_AltarOfKingsWhat1=CreateSound("Buildings\\Human\\AltarOfKings\\AltarOfKingsWhat1.wav", false, true, true, 10, 10, "DefaultEAXON")
    call SetSoundParamsFromLabel(gg_snd_AltarOfKingsWhat1, "AltarOfKingsWhat")
    call SetSoundDuration(gg_snd_AltarOfKingsWhat1, 3585)
    set gg_snd_KnightNoGold1=CreateSound("Sound\\Interface\\Warning\\Human\\KnightNoGold1.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_KnightNoGold1, "NoGoldHuman")
    call SetSoundDuration(gg_snd_KnightNoGold1, 1486)
    set gg_snd_KnightNoLumber1=CreateSound("Sound\\Interface\\Warning\\Human\\KnightNoLumber1.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_KnightNoLumber1, "NoLumberHuman")
    call SetSoundDuration(gg_snd_KnightNoLumber1, 1863)
    set gg_snd_KnightInventoryFull1=CreateSound("Sound\\Interface\\Warning\\Human\\KnightInventoryFull1.wav", false, false, false, 10, 10, "")
    call SetSoundParamsFromLabel(gg_snd_KnightInventoryFull1, "InventoryFullHuman")
    call SetSoundDuration(gg_snd_KnightInventoryFull1, 1498)
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateBuildingsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set u=CreateUnit(p, 'hkee', 2240.0, - 896.0, 270.000)
    set u=CreateUnit(p, 'hhou', 2624.0, - 768.0, 270.000)
endfunction
//===========================================================================
function CreateUnitsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set u=CreateUnit(p, 'hrif', - 46.6, - 2286.6, 40.211)
    set u=CreateUnit(p, 'hkni', - 20.7, 748.6, 102.290)
    set u=CreateUnit(p, 'hrif', 262.8, - 2278.9, 40.211)
    set u=CreateUnit(p, 'hrif', - 400.9, - 2299.9, 40.211)
    set u=CreateUnit(p, 'okod', 2250.1, - 1280.5, 206.352)
    set u=CreateUnit(p, 'ocat', 2726.7, - 1370.9, 128.181)
    set u=CreateUnit(p, 'nzep', 2373.0, - 1598.2, 74.890)
endfunction
//===========================================================================
function CreateBuildingsForPlayer1 takes nothing returns nothing
    local player p= Player(1)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set u=CreateUnit(p, 'hkee', 3264.0, - 1536.0, 270.000)
endfunction
//===========================================================================
function CreateUnitsForPlayer7 takes nothing returns nothing
    local player p= Player(7)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set u=CreateUnit(p, 'hkni', - 124.8, 737.9, 102.290)
endfunction
//===========================================================================
function CreateNeutralPassiveBuildings takes nothing returns nothing
    local player p= Player(PLAYER_NEUTRAL_PASSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set u=CreateUnit(p, 'ngob', 20544.0, - 12480.0, 270.000)
    set u=CreateUnit(p, 'nmgv', 20544.0, - 13120.0, 270.000)
    set u=CreateUnit(p, 'ndfl', 18816.0, - 12992.0, 270.000)
    set u=CreateUnit(p, 'npgr', 20224.0, - 15424.0, 270.000)
    set u=CreateUnit(p, 'nwc1', 20288.0, - 12928.0, 270.000)
    set u=CreateUnit(p, 'nbfl', 19200.0, - 12864.0, 270.000)
    set u=CreateUnit(p, 'ndmg', 18560.0, - 12224.0, 270.000)
    set u=CreateUnit(p, 'nfnp', 19264.0, - 12480.0, 270.000)
    set u=CreateUnit(p, 'nnsa', 22016.0, - 16192.0, 270.000)
    set u=CreateUnit(p, 'nnsg', 21568.0, - 16128.0, 270.000)
    set u=CreateUnit(p, 'nntt', 21568.0, - 16640.0, 270.000)
    set u=CreateUnit(p, 'nnfm', 21920.0, - 16672.0, 270.000)
    set u=CreateUnit(p, 'nnad', 22240.0, - 16544.0, 270.000)
    set u=CreateUnit(p, 'ndrk', 19008.0, - 14208.0, 270.000)
    set u=CreateUnit(p, 'ngol', 18560.0, - 13696.0, 270.000)
    call SetResourceAmount(u, 0)
    set u=CreateUnit(p, 'ndrg', 19520.0, - 14208.0, 270.000)
    set u=CreateUnit(p, 'ndro', 19264.0, - 14784.0, 270.000)
    set u=CreateUnit(p, 'nfoh', 20160.0, - 16832.0, 270.000)
    set u=CreateUnit(p, 'nbse', 20064.0, - 13984.0, 270.000)
    set u=CreateUnit(p, 'ncop', 21120.0, - 13504.0, 270.000)
    set u=CreateUnit(p, 'ncp3', 21504.0, - 13696.0, 270.000)
    set u=CreateUnit(p, 'ncp2', 21216.0, - 13216.0, 270.000)
    set u=CreateUnit(p, 'ndkw', 19328.0, - 16320.0, 270.000)
    set u=CreateUnit(p, 'ncmw', 20960.0, - 14432.0, 270.000)
    call SetUnitState(u, UNIT_STATE_MANA, 0)
endfunction
//===========================================================================
function CreateNeutralPassive takes nothing returns nothing
    local player p= Player(PLAYER_NEUTRAL_PASSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set gg_unit_H002_0008=CreateUnit(p, 'H002', - 2297.9, 106.3, 262.134)
    call SetUnitState(gg_unit_H002_0008, UNIT_STATE_MANA, 0)
    set gg_unit_H000_0009=CreateUnit(p, 'H000', - 2833.1, 103.1, 296.590)
    call SetUnitState(gg_unit_H000_0009, UNIT_STATE_MANA, 0)
    set gg_unit_H001_0010=CreateUnit(p, 'H001', - 2553.5, 115.5, 280.001)
    call SetUnitState(gg_unit_H001_0010, UNIT_STATE_MANA, 150)
    set gg_unit_H003_0011=CreateUnit(p, 'H003', - 2027.3, 100.1, 244.500)
    call SetUnitState(gg_unit_H003_0011, UNIT_STATE_MANA, 0)
    set gg_unit_H004_0012=CreateUnit(p, 'H004', - 2800.7, - 133.8, 304.584)
    call SetUnitState(gg_unit_H004_0012, UNIT_STATE_MANA, 0)
    set gg_unit_H005_0013=CreateUnit(p, 'H005', - 2532.1, - 131.0, 282.136)
    call SetUnitState(gg_unit_H005_0013, UNIT_STATE_MANA, 0)
    set gg_unit_H006_0014=CreateUnit(p, 'H006', - 2287.0, - 133.8, 257.819)
    call SetUnitState(gg_unit_H006_0014, UNIT_STATE_MANA, 0)
    set gg_unit_H007_0015=CreateUnit(p, 'H007', - 2025.2, - 156.5, 234.795)
    call SetUnitState(gg_unit_H007_0015, UNIT_STATE_MANA, 0)
    set gg_unit_H008_0016=CreateUnit(p, 'H008', - 2794.4, - 405.3, 322.451)
    call SetUnitState(gg_unit_H008_0016, UNIT_STATE_MANA, 0)
    set gg_unit_H009_0017=CreateUnit(p, 'H009', - 2544.3, - 405.3, 294.498)
    call SetUnitState(gg_unit_H009_0017, UNIT_STATE_MANA, 0)
    set gg_unit_H00A_0018=CreateUnit(p, 'H00A', - 2277.9, - 397.6, 246.571)
    call SetUnitState(gg_unit_H00A_0018, UNIT_STATE_MANA, 0)
    set gg_unit_H00B_0019=CreateUnit(p, 'H00B', - 2002.7, - 400.2, 216.504)
    call SetUnitState(gg_unit_H00B_0019, UNIT_STATE_MANA, 0)
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer0()
    call CreateBuildingsForPlayer1()
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
    call CreateUnitsForPlayer0()
    call CreateUnitsForPlayer7()
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreateNeutralPassiveBuildings()
    call CreatePlayerBuildings()
    call CreateNeutralPassive()
    call CreatePlayerUnits()
endfunction
//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************
function CreateRegions takes nothing returns nothing
    local weathereffect we
    set gg_rct_items=Rect(- 384.0, 1536.0, 1152.0, 3072.0)
endfunction
//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************
//TESH.scrollpos=0
//TESH.alwaysfold=0
//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************
//===========================================================================
// Trigger: ydjapi
//===========================================================================
//TESH.scrollpos=0
//TESH.alwaysfold=0

//===========================================================================
// Trigger: wjapi
//===========================================================================
//TESH.scrollpos=0
//TESH.alwaysfold=0

//===========================================================================
// Trigger: dzapi
//
// 
//===========================================================================
//TESH.scrollpos=216
//TESH.alwaysfold=0




































































































//===========================================================================
// Trigger: mouse
//===========================================================================
//TESH.scrollpos=0
//TESH.alwaysfold=0
// Trigger: init
//===========================================================================
function Trig_initActions takes nothing returns nothing
    set udg_roles[1]=gg_unit_H000_0009
    set udg_roles[2]=gg_unit_H001_0010
    set udg_roles[3]=gg_unit_H002_0008
    set udg_roles[4]=gg_unit_H003_0011
    set udg_roles[5]=gg_unit_H004_0012
    set udg_roles[6]=gg_unit_H005_0013
    set udg_roles[7]=gg_unit_H006_0014
    set udg_roles[8]=gg_unit_H007_0015
    set udg_roles[9]=gg_unit_H008_0016
    set udg_roles[10]=gg_unit_H009_0017
    set udg_roles[11]=gg_unit_H00A_0018
    set udg_roles[12]=gg_unit_H00B_0019
endfunction
//===========================================================================
function InitTrig_init takes nothing returns nothing
    set gg_trg_init=CreateTrigger()
    call DoNothing()
    call TriggerAddAction(gg_trg_init, function Trig_initActions)
endfunction
//===========================================================================
// Trigger: start
//===========================================================================
//TESH.scrollpos=0
//TESH.alwaysfold=0
function InitTrig_start takes nothing returns nothing
    call DzFrameHideInterface()
    call DzFrameEditBlackBorders(0, 0)
    call EnableMinimapFilterButtons(false, false) //禁用小地图按钮
// call EnableDragSelect( false, false ) //禁用框选
//call Cheat("exec-lua:scripts.luas.core.map")
call AbilityId("exec-lua:scripts.luas.core.map")
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    //Function not found: call InitTrig_ydjapi()
    //Function not found: call InitTrig_wjapi()
    //Function not found: call InitTrig_dzapi()
    //Function not found: call InitTrig_mouse()
    call InitTrig_init()
    call InitTrig_start()
endfunction
//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_init)
endfunction
//***************************************************************************
//*
//*  Players
//*
//***************************************************************************
function InitCustomPlayerSlots takes nothing returns nothing
    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call ForcePlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0), false)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)
    // Player 1
    call SetPlayerStartLocation(Player(1), 1)
    call ForcePlayerStartLocation(Player(1), 1)
    call SetPlayerColor(Player(1), ConvertPlayerColor(1))
    call SetPlayerRacePreference(Player(1), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(1), false)
    call SetPlayerController(Player(1), MAP_CONTROL_USER)
    // Player 2
    call SetPlayerStartLocation(Player(2), 2)
    call ForcePlayerStartLocation(Player(2), 2)
    call SetPlayerColor(Player(2), ConvertPlayerColor(2))
    call SetPlayerRacePreference(Player(2), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(2), false)
    call SetPlayerController(Player(2), MAP_CONTROL_USER)
    // Player 3
    call SetPlayerStartLocation(Player(3), 3)
    call ForcePlayerStartLocation(Player(3), 3)
    call SetPlayerColor(Player(3), ConvertPlayerColor(3))
    call SetPlayerRacePreference(Player(3), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(3), false)
    call SetPlayerController(Player(3), MAP_CONTROL_USER)
    // Player 4
    call SetPlayerStartLocation(Player(4), 4)
    call ForcePlayerStartLocation(Player(4), 4)
    call SetPlayerColor(Player(4), ConvertPlayerColor(4))
    call SetPlayerRacePreference(Player(4), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(4), false)
    call SetPlayerController(Player(4), MAP_CONTROL_USER)
    // Player 5
    call SetPlayerStartLocation(Player(5), 5)
    call ForcePlayerStartLocation(Player(5), 5)
    call SetPlayerColor(Player(5), ConvertPlayerColor(5))
    call SetPlayerRacePreference(Player(5), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(5), false)
    call SetPlayerController(Player(5), MAP_CONTROL_USER)
    // Player 6
    call SetPlayerStartLocation(Player(6), 6)
    call ForcePlayerStartLocation(Player(6), 6)
    call SetPlayerColor(Player(6), ConvertPlayerColor(6))
    call SetPlayerRacePreference(Player(6), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(6), false)
    call SetPlayerController(Player(6), MAP_CONTROL_COMPUTER)
    // Player 7
    call SetPlayerStartLocation(Player(7), 7)
    call ForcePlayerStartLocation(Player(7), 7)
    call SetPlayerColor(Player(7), ConvertPlayerColor(7))
    call SetPlayerRacePreference(Player(7), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(7), false)
    call SetPlayerController(Player(7), MAP_CONTROL_COMPUTER)
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_001
    call SetPlayerTeam(Player(0), 0)
    call SetPlayerState(Player(0), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(1), 0)
    call SetPlayerState(Player(1), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(2), 0)
    call SetPlayerState(Player(2), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(3), 0)
    call SetPlayerState(Player(3), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(4), 0)
    call SetPlayerState(Player(4), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(5), 0)
    call SetPlayerState(Player(5), PLAYER_STATE_ALLIED_VICTORY, 1)
    call SetPlayerTeam(Player(6), 0)
    call SetPlayerState(Player(6), PLAYER_STATE_ALLIED_VICTORY, 1)
    //   Allied
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(5), true)
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(5), true)
    // Force: TRIGSTR_012
    call SetPlayerTeam(Player(7), 1)
    call SetPlayerState(Player(7), PLAYER_STATE_ALLIED_VICTORY, 1)
endfunction
function InitAllyPriorities takes nothing returns nothing
    call SetStartLocPrioCount(0, 5)
    call SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 1, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 3, 4, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 4, 5, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(1, 5)
    call SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 3, 4, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 4, 5, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(2, 5)
    call SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 3, 4, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 4, 5, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(3, 5)
    call SetStartLocPrio(3, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 2, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 3, 4, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 4, 5, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(4, 5)
    call SetStartLocPrio(4, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(4, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(4, 2, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(4, 3, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(4, 4, 5, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(5, 5)
    call SetStartLocPrio(5, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(5, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(5, 2, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(5, 3, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(5, 4, 4, MAP_LOC_PRIO_HIGH)
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call JapiConstantLib_init()
 call japi_initializePlugin()
 call SetCameraBounds(- 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 28160.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 27904.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 27904.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 28160.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("SunkenRuinsDay")
    call SetAmbientNightSound("SunkenRuinsNight")
    call SetMapMusic("Music", true, 0)
    call InitSounds()
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("DZAPI__onInit")
call ExecuteFunc("Hardware__Init")

    call InitGlobals()
    call InitCustomTriggers()
    call RunInitializationTriggers()
endfunction
//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************
function config takes nothing returns nothing
    call SetMapName("幻想骑空士团")
    call SetMapDescription("1 ORPG、rogelike、卡牌策略

2 探索、防守、任务
")
    call SetPlayers(8)
    call SetTeams(8)
    call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    call DefineStartLocation(0, - 2624.0, 2560.0)
    call DefineStartLocation(1, - 2624.0, 2560.0)
    call DefineStartLocation(2, - 2624.0, 2560.0)
    call DefineStartLocation(3, - 2624.0, 2560.0)
    call DefineStartLocation(4, - 2624.0, 2560.0)
    call DefineStartLocation(5, - 2624.0, 2560.0)
    call DefineStartLocation(6, - 2624.0, 2560.0)
    call DefineStartLocation(7, - 2624.0, 2560.0)
    // Player setup
    call InitCustomPlayerSlots()
    call InitCustomTeams()
    call InitAllyPriorities()
endfunction




//Struct method generated initializers/callers:

