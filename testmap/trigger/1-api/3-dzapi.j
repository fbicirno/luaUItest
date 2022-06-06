//TESH.scrollpos=216
//TESH.alwaysfold=0
native DzGetMouseTerrainX takes nothing returns real
native DzGetMouseTerrainY takes nothing returns real
native DzGetMouseTerrainZ takes nothing returns real
native DzGetMouseX takes nothing returns integer
native DzGetMouseY takes nothing returns integer
native DzGetMouseXRelative takes nothing returns integer
native DzGetMouseYRelative takes nothing returns integer
native DzSetMousePos takes integer x, integer y returns nothing
native DzGetWindowWidth takes nothing returns integer
native DzGetWindowHeight takes nothing returns integer
native DzGetWindowX takes nothing returns integer
native DzGetWindowY takes nothing returns integer
native DzIsWindowActive takes nothing returns boolean
native DzIsKeyDown takes integer iKey returns boolean
native DzExecuteFunc takes string funcName returns nothing
native DzSetMemory takes integer address, real value returns nothing
native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
native DzSyncData takes string prefix, string data returns nothing
native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
native DzIsMouseOverUI takes nothing returns boolean
native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
native DzSetWar3MapMap takes string map returns nothing
native DzGetTriggerKey takes nothing returns integer
native DzGetTriggerKeyPlayer takes nothing returns player
native DzGetWheelDelta takes nothing returns integer
native DzDestructablePosition takes destructable d, real x, real y returns nothing
native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
native DzGetUnitUnderMouse takes nothing returns unit
native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
native DzSetUnitID takes unit whichUnit, integer id returns nothing
native DzSetUnitModel takes unit whichUnit, string path returns nothing
native DzGetTriggerSyncData takes nothing returns string
native DzGetTriggerSyncPlayer takes nothing returns player
native DzFrameHideInterface takes nothing returns nothing
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

//! zinc
library DZAPI{
    public{
        constant hashtable lua_engine = InitHashtable();
        constant trigger syncTrig = CreateTrigger();
    }
    
    function onInit(){
        //事件类
        DzTriggerRegisterWindowResizeEventByCode(null,false,function(){
            AbilityId("Interface.dzevent.windowResize()");
        });
       
        /*
        //鼠标移动触发 太消耗资源 建议不启用
        DzTriggerRegisterMouseMoveEventByCode(null,false,function(){
            AbilityId("Interface.dzevent.mouseMove()");
        });
        */
        
        //点击左键  1,1
        DzTriggerRegisterMouseEventByCode(null,1,1,false,function(){
            //检查是否先触发frame鼠标事件
            if(current_frame_over != -1){
                AbilityId("Interface.dzevent.frameEvent("+I2S(current_frame_over)+",1)");
            }else{
                AbilityId("Interface.dzevent.mouseEvent(1,1)");
            }
        });
        
        //释放左键  0,1
        DzTriggerRegisterMouseEventByCode(null,1,0,false,function(){
            if (current_frame_over == -1){
                AbilityId("Interface.dzevent.mouseEvent(1,0)");
            }
        });
        
        //点击右键 1,2
        DzTriggerRegisterMouseEventByCode(null,2,1,false,function(){
            if(current_frame_over != -1){
                AbilityId("Interface.dzevent.frameEvent("+I2S(current_frame_over)+",4)");
            }else{
                AbilityId("Interface.dzevent.mouseEvent(2,1)");
            }
        });
        
        //释放右键 0,2
        DzTriggerRegisterMouseEventByCode(null,2,0,false,function(){
            if (current_frame_over == -1){
                AbilityId("Interface.dzevent.mouseEvent(2,0)");
            }
        }); 
        
        //滑动滚轮 2,x
        DzTriggerRegisterMouseWheelEventByCode(null,false,function(){
            integer mw = DzGetWheelDelta();
            AbilityId("Interface.dzevent.mouseEvent(2,"+I2S(mw)+")");
        });
        
        //同步类
        
        //同步数据  id,msg
        DzTriggerRegisterSyncData(syncTrig,"sync",false);
        TriggerAddCondition(syncTrig,function()->boolean
        {
            string msg = DzGetTriggerSyncData();
            integer id = GetPlayerId(DzGetTriggerSyncPlayer());
           
            AbilityId("Interface.dzevent.syncEvent("+I2S(id)+",[===["+msg+"]===])");
            return false;
        });

        
        //界面类
        SaveInteger(lua_engine,101,1,DzGetGameUI());
        SaveInteger(lua_engine,101,2,DzFrameGetPortrait());
        SaveInteger(lua_engine,101,3,DzFrameGetMinimap());
        
        SaveInteger(lua_engine,101,4,DzFrameGetUpperButtonBarButton(0));
        SaveInteger(lua_engine,101,5,DzFrameGetUpperButtonBarButton(1));
        SaveInteger(lua_engine,101,6,DzFrameGetUpperButtonBarButton(2));
        SaveInteger(lua_engine,101,7,DzFrameGetUpperButtonBarButton(3));
        // SaveInteger(lua_engine,101,8,DzFrameGetUpperButtonBarButton(4));
        // SaveInteger(lua_engine,101,9,DzFrameGetUpperButtonBarButton(5));
        
        SaveInteger(lua_engine,101,10,DzFrameGetHeroBarButton(0));  
        SaveInteger(lua_engine,101,11,DzFrameGetHeroBarButton(1));
        SaveInteger(lua_engine,101,12,DzFrameGetHeroBarButton(2));
        SaveInteger(lua_engine,101,13,DzFrameGetHeroBarButton(3));
        SaveInteger(lua_engine,101,14,DzFrameGetHeroBarButton(4));
        SaveInteger(lua_engine,101,15,DzFrameGetHeroBarButton(5));
        SaveInteger(lua_engine,101,16,DzFrameGetHeroBarButton(6));
        // SaveInteger(lua_engine,101,18,DzFrameGetHeroBarButton(7));
        
        
        SaveInteger(lua_engine,101,19,DzFrameGetHeroHPBar(0));
        SaveInteger(lua_engine,101,20,DzFrameGetHeroHPBar(1));
        SaveInteger(lua_engine,101,21,DzFrameGetHeroHPBar(2));
        SaveInteger(lua_engine,101,22,DzFrameGetHeroHPBar(3));
        SaveInteger(lua_engine,101,23,DzFrameGetHeroHPBar(4));
        SaveInteger(lua_engine,101,24,DzFrameGetHeroHPBar(5));
        SaveInteger(lua_engine,101,25,DzFrameGetHeroHPBar(6));
        // SaveInteger(lua_engine,101,26,DzFrameGetHeroHPBar(7));
        
        SaveInteger(lua_engine,101,27,DzFrameGetHeroManaBar(0));
        SaveInteger(lua_engine,101,28,DzFrameGetHeroManaBar(1));
        SaveInteger(lua_engine,101,20,DzFrameGetHeroManaBar(2));
        SaveInteger(lua_engine,101,30,DzFrameGetHeroManaBar(3));
        SaveInteger(lua_engine,101,31,DzFrameGetHeroManaBar(4));
        SaveInteger(lua_engine,101,32,DzFrameGetHeroManaBar(5));
        SaveInteger(lua_engine,101,33,DzFrameGetHeroManaBar(6));
        // SaveInteger(lua_engine,101,34,DzFrameGetHeroManaBar(7));
        
        SaveInteger(lua_engine,101,35,DzFrameGetItemBarButton(0));
        SaveInteger(lua_engine,101,36,DzFrameGetItemBarButton(1));
        SaveInteger(lua_engine,101,37,DzFrameGetItemBarButton(2));
        SaveInteger(lua_engine,101,38,DzFrameGetItemBarButton(3));
        SaveInteger(lua_engine,101,39,DzFrameGetItemBarButton(4));
        SaveInteger(lua_engine,101,40,DzFrameGetItemBarButton(5));
        
        SaveInteger(lua_engine,101,41,DzFrameGetMinimapButton(0));
        SaveInteger(lua_engine,101,42,DzFrameGetMinimapButton(1));
        SaveInteger(lua_engine,101,43,DzFrameGetMinimapButton(2));
        SaveInteger(lua_engine,101,44,DzFrameGetMinimapButton(3));
        SaveInteger(lua_engine,101,45,DzFrameGetMinimapButton(4));
        // SaveInteger(lua_engine,101,46,DzFrameGetMinimapButton(5));
        
        SaveInteger(lua_engine,101,47,DzFrameGetTooltip());
        SaveInteger(lua_engine,101,48,DzFrameGetChatMessage());
        SaveInteger(lua_engine,101,49,DzFrameGetUnitMessage());
        SaveInteger(lua_engine,101,50,DzFrameGetTopMessage());
        
        SaveInteger(lua_engine,101,51,DzFrameGetCommandBarButton(0,0));
        SaveInteger(lua_engine,101,52,DzFrameGetCommandBarButton(0,1));
        SaveInteger(lua_engine,101,53,DzFrameGetCommandBarButton(0,2));
        SaveInteger(lua_engine,101,54,DzFrameGetCommandBarButton(0,3));
        SaveInteger(lua_engine,101,55,DzFrameGetCommandBarButton(1,0));
        SaveInteger(lua_engine,101,56,DzFrameGetCommandBarButton(1,1));
        SaveInteger(lua_engine,101,57,DzFrameGetCommandBarButton(1,2));
        SaveInteger(lua_engine,101,58,DzFrameGetCommandBarButton(1,3));
        SaveInteger(lua_engine,101,59,DzFrameGetCommandBarButton(2,0));
        SaveInteger(lua_engine,101,60,DzFrameGetCommandBarButton(2,1));
        SaveInteger(lua_engine,101,61,DzFrameGetCommandBarButton(2,2));
        SaveInteger(lua_engine,101,62,DzFrameGetCommandBarButton(2,3));
        
    }
    
    //封装函数
    public{
    
        function GetMouseTerrain (){
            SaveReal(lua_engine,100,1,DzGetMouseTerrainX());
            SaveReal(lua_engine,100,2,DzGetMouseTerrainY());
            SaveReal(lua_engine,100,3,DzGetMouseTerrainZ());
        }
       
        function GetMouseXY(){
            SaveReal(lua_engine,100,1,DzGetMouseX());
            SaveReal(lua_engine,100,2,DzGetMouseY());
        }
        
        function GetMouseRelative(){
            SaveReal(lua_engine,100,1,DzGetMouseXRelative());
            SaveReal(lua_engine,100,2,DzGetMouseYRelative());
        }
        
        function SetMousePos(){
            integer x = LoadInteger(lua_engine,100,1);
            integer y = LoadInteger(lua_engine,100,2);
            DzSetMousePos(x,y);
        }
        
        function GetWindow(){
            SaveInteger(lua_engine,100,1, DzGetWindowWidth());
            SaveInteger(lua_engine,100,2, DzGetWindowHeight());
        }
        
        function GetWindowXY(){
            SaveInteger(lua_engine,100,1, DzGetWindowX());
            SaveInteger(lua_engine,100,2, DzGetWindowY());
        }
        
        function IsWindowActive(){
            SaveBoolean(lua_engine,100,1, DzIsWindowActive());
        }
        
    }
    
    public{
        
        //键盘事件
        function RegisterKeyEvent(){ 
            integer k = LoadInteger(lua_engine,100,1);  //key
            
            DzTriggerRegisterKeyEventByCode(null,k,1,false,function(){
                integer k = DzGetTriggerKey();
                integer id = GetPlayerId(DzGetTriggerKeyPlayer());
                //key_code  status=1  playerId
                AbilityId("Interface.dzevent.keyEvent("+I2S(k)+",1,"+I2S(id)+")");
            });
            
            DzTriggerRegisterKeyEventByCode(null,k,0,false,function(){
                integer k = DzGetTriggerKey();
                integer id = GetPlayerId(DzGetTriggerKeyPlayer());
                //key_code  status=0 playerId
                AbilityId("Interface.dzevent.keyEvent("+I2S(k)+",0,"+I2S(id)+")");
            });
        }
        
        private {
            integer current_frame_over = -1;
            timer current_frame_timer = CreateTimer();
        }
        
        
        //frame事件  封装左键右键
        function RegisterFrameEvent(){
            integer f = LoadInteger(lua_engine,100,1); 
            
            //over
            DzFrameSetScriptByCode(f,2,function(){
                integer id = GetPlayerId(DzGetTriggerUIEventPlayer());
                integer frame = DzGetTriggerUIEventFrame();
                
                // frame,eventId
                AbilityId("Interface.dzevent.frameEvent("+I2S(frame)+",2)");
                PauseTimer(current_frame_timer);
                current_frame_over = frame;
            },false);
            
            //out
            DzFrameSetScriptByCode(f,3,function(){
                integer id = GetPlayerId(DzGetTriggerUIEventPlayer());
                integer frame = DzGetTriggerUIEventFrame();
                
                // frame,eventId
                AbilityId("Interface.dzevent.frameEvent("+I2S(frame)+",3)");
                TimerStart(current_frame_timer,0.15,false,function(){
                    current_frame_over = -1;
                });
            },false);
        }
        
        function IsKeyDown(){
            integer k = LoadInteger(lua_engine,100,1);  //key
            SaveBoolean(lua_engine,100,1,DzIsKeyDown(k));
        }
        
        function ClickFrame (){
            integer k = LoadInteger(lua_engine,100,1);
            DzClickFrame(k);
        }
        
        function FrameSetFocus(){
            integer k = LoadInteger(lua_engine,100,1);
            boolean b = LoadBoolean(lua_engine,100,2);
            DzFrameSetFocus(k,b);
        }
        
        function FrameGetMouseFocus(){
            SaveInteger(lua_engine,100,1,DzGetMouseFocus());
        }
        
        //native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
        //native DzIsMouseOverUI takes nothing returns boolean
        
    }
    
    public {
        /*
        function FrameHideInterface(){
            DzFrameHideInterface();
        }
        */
    
        function LoadToc(){
            string path = LoadStr(lua_engine,100,1);
            DzLoadToc(path);
            path = null;
        }
    
        function FrameEditBlackBorders(){
            real x = LoadReal(lua_engine,100,1);
            real y = LoadReal(lua_engine,100,2);
            DzFrameEditBlackBorders(x,y);
        }
        
        function GetColor(){
            integer a1 =LoadInteger(lua_engine,100,1);
            integer a2 =LoadInteger(lua_engine,100,1);
            integer a3 =LoadInteger(lua_engine,100,1);
            integer a4 =LoadInteger(lua_engine,100,1);
            
            SaveInteger (lua_engine,100,1,DzGetColor(a1,a2,a3,a4));
        }
    
        function EnableWideScreen(){
            boolean f = LoadBoolean(lua_engine,100,1);
            DzEnableWideScreen(f);
        }
        
        function SetWar3MapMap(){
            string path = LoadStr(lua_engine,100,1);
            DzSetWar3MapMap(path);
            path = null;
        }

        function CreateFrame(){
            string frame = LoadStr(lua_engine,100,1);
            integer parent = LoadInteger(lua_engine,100,2);
            integer id = LoadInteger(lua_engine,100,3);
            SaveInteger(lua_engine,100,1,DzCreateFrame(frame,parent,id));
            frame = null;
        }
        
        function CreateSimpleFrame(){
            string frame = LoadStr(lua_engine,100,1);
            integer parent = LoadInteger(lua_engine,100,2);
            integer id = LoadInteger(lua_engine,100,3);
            SaveInteger(lua_engine,100,1,DzCreateSimpleFrame(frame,parent,id));
            frame = null;
        }
        
        function CreateFrameByTagName(){
            string frame = LoadStr(lua_engine,100,1);
            string name = LoadStr(lua_engine,100,2);
            integer parent = LoadInteger(lua_engine,100,3);
            string template = LoadStr(lua_engine,100,4);
            integer id = LoadInteger(lua_engine,100,5);
            
            SaveInteger(lua_engine,100,1,DzCreateFrameByTagName(frame,name,parent,template,id));
            
            frame= null;name=null;template=null;
        }
        
        function DestroyFrame(){
            integer f = LoadInteger(lua_engine,100,1);
            DzDestroyFrame(f);
        }
        
        function FrameFindByName(){
            string name = LoadStr(lua_engine,100,1);
            integer id = LoadInteger(lua_engine,100,2);
            
            SaveInteger(lua_engine,100,1,DzFrameFindByName(name,id));
            name = null;
        }
        
        function SimpleFrameFindByName(){
            string name = LoadStr(lua_engine,100,1);
            integer id = LoadInteger(lua_engine,100,2);
            
            SaveInteger(lua_engine,100,1,DzSimpleFrameFindByName(name,id));
            name = null;
        }

        function SimpleFontStringFindByName(){
            string name = LoadStr(lua_engine,100,1);
            integer id = LoadInteger(lua_engine,100,2);
            
            SaveInteger(lua_engine,100,1,DzSimpleFontStringFindByName(name,id));
            name = null;
        }
    
        function SimpleTextureFindByName(){
            string name = LoadStr(lua_engine,100,1);
            integer id = LoadInteger(lua_engine,100,2);
            
            SaveInteger(lua_engine,100,1,DzSimpleTextureFindByName(name,id));
            name = null;
        }
        
        function FrameShow(){
            integer f = LoadInteger(lua_engine,100,1);
            boolean b = LoadBoolean(lua_engine,100,2);
            DzFrameShow(f,b);
        }
        
        function FrameSetEnable(){
            integer f = LoadInteger(lua_engine,100,1);
            boolean b = LoadBoolean(lua_engine,100,2);
            
            DzFrameSetEnable(f,b);
        }
        
        function FrameGetEnable(){
            integer f = LoadInteger(lua_engine,100,1);
           
            SaveBoolean(lua_engine,100,1,DzFrameGetEnable(f));
        }
        
        function FrameSetSize(){
            integer f = LoadInteger(lua_engine,100,1);
            real w = LoadReal(lua_engine,100,2);
            real h = LoadReal(lua_engine,100,3);
                
            DzFrameSetSize(f,w,h);
        }
        
        function FrameSetScale(){
            integer f = LoadInteger(lua_engine,100,1);
            real w = LoadReal(lua_engine,100,2);
                
            DzFrameSetScale(f,w);
        }
        
        function FrameSetPoint(){
            integer f = LoadInteger(lua_engine,100,1);
            integer pt = LoadInteger(lua_engine,100,2);
            integer rf = LoadInteger(lua_engine,100,3);
            integer rpt =LoadInteger(lua_engine,100,4);
            real x = LoadReal(lua_engine,100,5);
            real y = LoadReal(lua_engine,100,6);
            
            DzFrameSetPoint(f,pt,rf,rpt,x,y);
        }
        
        function FrameSetAbsolutePoint(){
            integer f = LoadInteger(lua_engine,100,1);
            integer pt = LoadInteger(lua_engine,100,2);
            real x = LoadReal(lua_engine,100,3);
            real y = LoadReal(lua_engine,100,4);
            
            DzFrameSetAbsolutePoint(f,pt,x,y);
        }
        
        function FrameSetAllPoints(){
            integer f = LoadInteger(lua_engine,100,1);
            integer pt = LoadInteger(lua_engine,100,2);
            DzFrameSetAllPoints(f,pt);
        }
    
        function FrameClearAllPoints(){
            integer f = LoadInteger(lua_engine,100,1);
            DzFrameClearAllPoints(f);
        }
    
        function FrameSetTexture(){
            integer f = LoadInteger(lua_engine,100,1);
            string s = LoadStr(lua_engine,100,2);
            integer fg = LoadInteger(lua_engine,100,3);
            DzFrameSetTexture(f,s,fg);
            s = null;
        }
        
        function FrameSetText(){
            integer f = LoadInteger(lua_engine,100,1);
            string s = LoadStr(lua_engine,100,2);
            DzFrameSetText(f,s);
            s = null;
        }
        
        function FrameGetText(){
            integer f = LoadInteger(lua_engine,100,1);
            SaveStr(lua_engine,100,1,DzFrameGetText(f));
        }
    
        function FrameSetTextSizeLimit(){
            integer f = LoadInteger(lua_engine,100,1);
            integer sz = LoadInteger(lua_engine,100,2);
            DzFrameSetTextSizeLimit(f,sz);
        }
        
        function FrameGetTextSizeLimit(){
            integer f = LoadInteger(lua_engine,100,1);
            SaveInteger(lua_engine,100,1,DzFrameGetTextSizeLimit(f));
        }
        
         function FrameSetTextColor(){
            integer f = LoadInteger(lua_engine,100,1);
            integer sz = LoadInteger(lua_engine,100,2);
            DzFrameSetTextColor(f,sz);
        }
        
        function FrameSetValue(){
            integer f = LoadInteger(lua_engine,100,1);
            real r = LoadReal(lua_engine,100,2);
            DzFrameSetValue(f,r);
        }
        
        function FrameGetValue(){
            integer f = LoadInteger(lua_engine,100,1);
            SaveReal(lua_engine,100,1,DzFrameGetValue(f));
        }
        
        function FrameSetAlpha(){
            integer f = LoadInteger(lua_engine,100,1);
            integer a = LoadInteger(lua_engine,100,2);
            DzFrameSetAlpha(f,a);
        }
        
        function FrameGetAlpha(){
            integer f = LoadInteger(lua_engine,100,1);
            SaveInteger(lua_engine,100,1,DzFrameGetAlpha(f));
        }
        
        function FrameSetAnimateOffset(){
            integer f = LoadInteger(lua_engine,100,1);
            real r = LoadReal(lua_engine,100,2);
            DzFrameSetAnimateOffset(f,r);
        }
        
        function FrameSetAnimate(){
            integer f = LoadInteger(lua_engine,100,1);
            integer a = LoadInteger(lua_engine,100,2);
            boolean b = LoadBoolean(lua_engine,100,3);

            DzFrameSetAnimate(f,a,b);
        }

        function FrameSetTooltip(){
            integer f = LoadInteger(lua_engine,100,1);
            integer a = LoadInteger(lua_engine,100,2);
            DzFrameSetTooltip(f,a);
        }
        
        function FrameSetVertexColor(){
            integer f = LoadInteger(lua_engine,100,1);
            integer a = LoadInteger(lua_engine,100,2);
            DzFrameSetVertexColor(f,a);
        }
        
        function FrameSetStepValue(){
            integer f = LoadInteger(lua_engine,100,1);
            real r = LoadReal(lua_engine,100,2);
            DzFrameSetStepValue(f,r);
        }
        
        function FrameSetModel(){
            integer f = LoadInteger(lua_engine,100,1);
            string s = LoadStr(lua_engine,100,2);
            integer t = LoadInteger(lua_engine,100,3);
            integer fg = LoadInteger(lua_engine,100,4);
            
            DzFrameSetModel(f,s,t,fg);
            s = null;
        }
        
        function SetCustomFovFix(){
            real r = LoadReal(lua_engine,100,1);
            DzSetCustomFovFix(r);
        }
        
        function FrameCageMouse(){
            integer f = LoadInteger(lua_engine,100,1);
            boolean b = LoadBoolean(lua_engine,100,2);

            DzFrameCageMouse(f,b);
        }

        function FrameSetMinMaxValue(){
            integer f = LoadInteger(lua_engine,100,1);
            real min = LoadReal(lua_engine,100,2);
            real max = LoadReal(lua_engine,100,3);
            
            DzFrameSetMinMaxValue(f,min,max);
        }
    }
   
    public {
   
        function EXExecuteFunc(){
            string s = LoadStr(lua_engine,100,1);
            DzExecuteFunc(s);
            s = null;
        }
        
        function EXSetMemory(){
            integer f = LoadInteger(lua_engine,100,1);
            real r = LoadReal(lua_engine,100,2);
            DzSetMemory(f,r);
        }
        
        function SyncData(){
            string s = LoadStr(lua_engine,100,1);
            DzSyncData("sync",s);
        }
    }
    
    public{
        function EXDestructablePosition(){
            destructable d = LoadDestructableHandle(lua_engine,100,1);
            real x = LoadReal(lua_engine,100,2);
            real y = LoadReal(lua_engine,100,3);
            
            DzDestructablePosition(d,x,y);
            d=null;
            FlushChildHashtable(lua_engine,100);
        }
        
        function EXSetUnitPosition(){
            unit d = LoadUnitHandle(lua_engine,100,1);
            real x = LoadReal(lua_engine,100,2);
            real y = LoadReal(lua_engine,100,3);
            
            DzSetUnitPosition(d,x,y);
            d = null;
            FlushChildHashtable(lua_engine,100);
        }
        
        function EXGetUnitUnderMouse(){
            SaveUnitHandle(lua_engine,100,1,DzGetUnitUnderMouse());
        }
        
        function EXSetUnitTexture(){
            unit d = LoadUnitHandle(lua_engine,100,1);
            string s = LoadStr(lua_engine,100,2);
            integer t = LoadInteger(lua_engine,100,3);
        
            DzSetUnitTexture(d,s,t);
            d= null;s= null;
            FlushChildHashtable(lua_engine,100);
        }
    
        function EXSetUnitID(){
            unit d = LoadUnitHandle(lua_engine,100,1);
            integer t = LoadInteger(lua_engine,100,2);
            DzSetUnitID(d,t);
            d=null;
            FlushChildHashtable(lua_engine,100);
        }

        function EXSetUnitModel(){
            unit d = LoadUnitHandle(lua_engine,100,1);
            string s = LoadStr(lua_engine,100,2);
            DzSetUnitModel(d,s);
            d=null;s=null;
            FlushChildHashtable(lua_engine,100);
        }

    }

}
//! endzinc















