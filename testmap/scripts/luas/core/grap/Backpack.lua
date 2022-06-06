local Context = require 'scripts.luas.core.applic.Context'
local Console= require 'scripts.luas.utils.envir.Console'
local BackpControl = require 'scripts.luas.core.grap.BackpControl'
local Items = require 'scripts.luas.core.entity.Items'
local Id = require 'scripts.luas.utils.id.Id'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'

--背包绘制
-- 使用原生jass实现 lua调用接口
local _pack = {}

function _pack.init_dialog()
    --destroyDialog
    local panel = BackpControl.data.abandon.dialogs
    panel[0] = dzapi.CreateFrame("myBackpDestroy",dzapi.FrameGetGameUI(),0);
    dzapi.FrameSetPoint(panel[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",0,0);
    panel[1] = dzapi.FrameFindByName("myBackpDestroyBtn1",0); --confirm
    panel[2] = dzapi.FrameFindByName("myBackpDestroyBtn2",0); --cancle
    dzapi.RegisterFrameEvent(panel[1],nil,nil,BackpControl.abandon)
    dzapi.RegisterFrameEvent(panel[2],nil,nil,BackpControl.deabandon)
    dzapi.FrameShow(panel[0],false);
    
    
    --separateDialog
    panel = BackpControl.data.separate.dialogs
    panel[0] = dzapi.CreateFrame("myBackpSeparate",dzapi.FrameGetGameUI(),0);
    dzapi.FrameSetPoint(panel[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",0,0);
    panel[1] = dzapi.FrameFindByName("myBackpSeparateTextValue",0); --text
    panel[2] = dzapi.FrameFindByName("myBackpSeparateSlider",0);    --slider
    panel[3] = dzapi.FrameFindByName("myBackpSeparateBtn1",0); --confirm
    panel[4] = dzapi.FrameFindByName("myBackpSeparateBtn2",0); --cancle
    dzapi.RegisterFrameEvent(panel[3],nil,nil,BackpControl.separate)
    dzapi.RegisterFrameEvent(panel[4],nil,nil,BackpControl.closeSeparateDialog)
    dzapi.FrameShow(panel[0],false);

    --strength
end

--@init start
function _pack.init()
    local h = dzapi.SimpleFrameFindByName("SimpleInfoPanelUnitDetail",0); --单位信息框架
    
    BackpControl.data.backp[0] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBackpFrame",h,"myBackp",0); --背包背景 SimpleFrame
    dzapi.FrameSetPoint( BackpControl.data.backp[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",1,1);
    
    --背景btn
    BackpControl.data.backp[1] = dzapi.CreateFrameByTagName("BUTTON","myBackpBtnDrop",dzapi.FrameGetGameUI(),"template",0);
    dzapi.FrameSetAllPoints( BackpControl.data.backp[1], BackpControl.data.backp[0]);
    dzapi.RegisterFrameEvent( BackpControl.data.backp[1]) --注册空回调 防止触发左键右键
    
    h = dzapi.CreateFrame("myBackpackTitle", BackpControl.data.backp[1],0); --标题
    dzapi.FrameSetPoint(h,"TOP", BackpControl.data.backp[0],"TOP",0.01,0.0025);
    dzapi.FrameSetText(h,"背包");
    
    BackpControl.data.backp[2] = dzapi.CreateFrame("myBackpBtnClose",h,0); --关闭按钮
    dzapi.FrameSetSize( BackpControl.data.backp[2],0.028,0.0165);
    dzapi.FrameSetTexture(dzapi.FrameFindByName("myBackpBtnCloseDrop",0),"img\\alpha.blp",0);
    dzapi.FrameSetPoint( BackpControl.data.backp[2],"TOPRIGHT", BackpControl.data.backp[0],"TOPRIGHT",-0.001,-0.001);
    
    --cells
    for row = 0,7,1 do
        for col =0,7,1 do
            local h = row*8 + col
            
            BackpControl.data.backpCell[h] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBackpCell", BackpControl.data.backp[0],"myBackpBtn",h);
            BackpControl.data.backpDrop[h] = dzapi.SimpleTextureFindByName("myBackpBtnDrop",h); --背景
            
            BackpControl.data.backpBtn[h] = dzapi.CreateFrame("myBackpBtnButton",BackpControl.data.backp[2],h);--按钮
            BackpControl.data.backpText[h] = dzapi.FrameFindByName("myBackpBtnText",h); --文字
            
            dzapi.FrameSetSize(BackpControl.data.backpCell[h],0.023,0.023);
            dzapi.FrameSetPoint(BackpControl.data.backpCell[h],"TOPLEFT",BackpControl.data.backp[0],"TOPLEFT",0.0492+ col*0.02818, -0.022-row*0.0282);
            dzapi.FrameSetAllPoints(BackpControl.data.backpBtn[h],BackpControl.data.backpCell[h]);
            
            dzapi.RegisterFrameEvent(BackpControl.data.backpBtn[h],
                BackpControl.backpItemOver,
                function(frame,event) 
                    Interface.GUI.closeTip()
                end,
                BackpControl.backpItemLeft,
                BackpControl.backpItemRight
            )
        end
    end

    --resource
    h = dzapi.CreateFrame("myBackpackResource",BackpControl.data.backp[2],0);
    dzapi.FrameSetSize(h,0.02,0.028);
    dzapi.FrameSetPoint(h,"TOPLEFT",BackpControl.data.backp[0],"BOTTOMLEFT",0.03828125,0.04365471);
    
    BackpControl.data.backp[3] = dzapi.FrameFindByName("myBackpResGoldValue",0);   --gold;
    BackpControl.data.backp[4] = dzapi.FrameFindByName("myBackpResLumberValue",0); --lumber;
    
    dzapi.FrameSetText(BackpControl.data.backp[3],"0");
    dzapi.FrameSetText(BackpControl.data.backp[4],"0");

    --invt
    for i=0,5,1 do
        local itemFrame = dzapi.FrameGetItemBarButton(i);
        BackpControl.data.invtFrames[i] = itemFrame
        dzapi.RegisterFrameEvent(itemFrame,
            BackpControl.backpInvtOver,
            function()
                Interface.GUI.closeTip()
            end,
            BackpControl.backpInvtLeft,
            BackpControl.backpInvtRight
        )
    end

    _pack.init_dialog()
    dzapi.FrameShow( BackpControl.data.backp[1],false);
    BackpControl.init()

    --mouse
    dzapi.RegisterMouseEvent(1,1,BackpControl.backpMouseLeft)
    dzapi.RegisterMouseEvent(2,1,BackpControl.backpMouseRight)
    
    --close
    dzapi.RegisterFrameEvent( BackpControl.data.backp[2],nil,nil,BackpControl.close)

    --按键B
    dzapi.RegisterKeyEvent(jmessage.keyboard.B,1,BackpControl.toggle) 
end

return _pack
