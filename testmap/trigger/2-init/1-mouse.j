//TESH.scrollpos=0
//TESH.alwaysfold=0
library Hardware initializer Init

    /*
        鼠标滚轮控制视距
        一键切换宽屏模式
        made by 裂魂
        2018/9/11
    */

    globals
        //初始视野等级
        private integer ViewLevel = 13
        //开启玩家控制标识
        private boolean TurnOnControl = false
        //镜头变化平滑度
        private real WheelSpeed = 0.1
        //是否是宽屏
        private boolean WideScr = false
        
        public boolean lua_isLocked_camera = false
        public boolean lua_isLocked_rect = false
    endglobals

    //鼠标滚轮变化时调用
    private function OnWheel takes nothing returns nothing
        //滚轮变化量
        local integer delta = DzGetWheelDelta()
        //如果鼠标不在游戏内，就不响应鼠标滚轮
        if not DzIsMouseOverUI() then
            return
        endif
        set TurnOnControl = true
        //关闭玩家控制，即可不触发滚轮事件中魔兽原生设定的镜头变化
        call EnableUserControl(false)
        if delta < 0 then
            //滚轮下滑
            if ViewLevel < 14 then  //视野等级上限
                set ViewLevel = ViewLevel + 1
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, WheelSpeed)
            endif
        else
            //滚轮上滑
            if ViewLevel > 3 then   //视野等级下限
                set ViewLevel = ViewLevel - 1
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, WheelSpeed)
            endif
        endif
    endfunction

    //每帧渲染时调用
    private function Update takes nothing returns nothing
        if TurnOnControl then
            //开启被禁用的玩家控制
            //注意，如果你在其它地方有关闭玩家控制，应当考虑与滚轮的兼容性
            //如果你不想出现滚轮可以解除禁用玩家控制的BUG，需要在滚轮改变时或此处做判断
            call EnableUserControl(true)
            set TurnOnControl = false
        endif
    endfunction

    //按键触发
    function SetWideScreen takes nothing returns nothing
        set WideScr = not WideScr
        call DzEnableWideScreen(WideScr)
    endfunction

    private function Init takes nothing returns nothing
        // call FogEnable( false )
        // call FogMaskEnable( false )
        //注册滚轮事件
        call DzTriggerRegisterMouseWheelEventByCode( null, false, function OnWheel)
        //注册每帧渲染事件
        call DzFrameSetUpdateCallbackByCode(function Update)
        //注册按下键码为145的按键(ScrollLock)事件
        call DzTriggerRegisterKeyEventByCode( null, 145, 1, false, function SetWideScreen)
    endfunction

endlibrary