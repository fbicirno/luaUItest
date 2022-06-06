local ShopControl = require 'scripts.luas.core.grap.ShopControl'
local Items = require 'scripts.luas.core.entity.Items'


local _pack = {}


function _pack.init_dialog()
    --destroyDialog
    local panel = ShopControl.data.sell.dialogs
    panel[0] = dzapi.CreateFrame("myBackpDestroy",dzapi.FrameGetGameUI(),100);
    dzapi.FrameSetPoint(panel[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",0,0);
    dzapi.FrameShow(panel[0],false);

    panel[1] = dzapi.FrameFindByName("myBackpDestroyBtn1",100); --confirm
    panel[2] = dzapi.FrameFindByName("myBackpDestroyBtn2",100); --cancle
    panel[3] = dzapi.FrameFindByName("myBackpDestroyText",100); --title

    dzapi.RegisterFrameEvent(panel[1],nil,nil,ShopControl.sell)
    dzapi.RegisterFrameEvent(panel[2],nil,nil,ShopControl.closeSellDialog)
    dzapi.FrameSetText(panel[3],"确定要出售物品吗？")
    
    --separateDialog
    panel = ShopControl.data.separate.dialogs
    panel[0] = dzapi.CreateFrame("myBackpSeparate",dzapi.FrameGetGameUI(),100);
    dzapi.FrameSetPoint(panel[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",0,0);
    dzapi.FrameShow(panel[0],false);

    panel[1] = dzapi.FrameFindByName("myBackpSeparateTextValue",100); --text
    panel[2] = dzapi.FrameFindByName("myBackpSeparateSlider",100);    --slider
    panel[3] = dzapi.FrameFindByName("myBackpSeparateBtn1",100); --confirm
    panel[4] = dzapi.FrameFindByName("myBackpSeparateBtn2",100); --cancle
    panel[5] = dzapi.FrameFindByName("myBackpSeparateTitle",100);--title

end

--@init start
function _pack.init()
    local h = dzapi.SimpleFrameFindByName("SimpleInfoPanelUnitDetail",0); --单位信息框架

    ShopControl.data.drop[0] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myShopFrame",h,"myBackp",2);
    dzapi.FrameSetPoint( ShopControl.data.drop[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",1,1);

    --背景btn
    ShopControl.data.drop[1] = dzapi.CreateFrameByTagName("BUTTON","myShopFrameBtn",dzapi.FrameGetGameUI(),"template",2);
    dzapi.FrameSetAllPoints(ShopControl.data.drop[1], ShopControl.data.drop[0]);
    dzapi.RegisterFrameEvent( ShopControl.data.drop[1]) --注册空回调 防止触发左键右键 @BUG

    h = dzapi.CreateFrame("myBackpackTitle", ShopControl.data.drop[1],1); --标题
    dzapi.FrameSetPoint(h,"TOP", ShopControl.data.drop[0],"TOP",0.01,0.0025);
    dzapi.FrameSetText(h,"商店");

    ShopControl.data.drop[2] = dzapi.CreateFrame("myBackpBtnClose",h,2); --关闭按钮
    dzapi.FrameSetSize( ShopControl.data.drop[2],0.028,0.0165);
    dzapi.FrameSetTexture(dzapi.FrameFindByName("myBackpBtnCloseDrop",2),"img\\alpha.blp",0);
    dzapi.FrameSetPoint(ShopControl.data.drop[2],"TOPRIGHT", ShopControl.data.drop[0],"TOPRIGHT",-0.001,-0.001);

    --cells
    for row = 0,7,1 do
        for col =0,7,1 do
            local h = row*8 + col

            ShopControl.data.shopCell[h] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBackpCell", ShopControl.data.drop[0],"myBackpBtn",h+200);
            ShopControl.data.shopDrop[h] = dzapi.SimpleTextureFindByName("myBackpBtnDrop",h+200); --背景
            
            ShopControl.data.shopBtn[h] = dzapi.CreateFrame("myBackpBtnButton",ShopControl.data.drop[2],h+200);--按钮
            ShopControl.data.shopText[h] = dzapi.FrameFindByName("myBackpBtnText",h+200); --文字
            
            dzapi.FrameSetSize(ShopControl.data.shopCell[h],0.023,0.023);
            dzapi.FrameSetPoint(ShopControl.data.shopCell[h],"TOPLEFT",ShopControl.data.drop[0],"TOPLEFT",0.0492+ col*0.02818, -0.022-row*0.0282);
            dzapi.FrameSetAllPoints(ShopControl.data.shopBtn[h],ShopControl.data.shopCell[h]);
            
            dzapi.RegisterFrameEvent(ShopControl.data.shopBtn[h],
                ShopControl.shopItemOver,
                function(frame,event) 
                    Interface.GUI.closeTip()
                end,
                ShopControl.shopItemLeft,
                ShopControl.shopItemRight
            )
        end
    end

    dzapi.FrameShow(ShopControl.data.drop[1],false);
    dzapi.RegisterFrameEvent( ShopControl.data.drop[2],nil,nil,ShopControl.close)

    _pack.init_dialog()
    ShopControl.init()
end

return _pack