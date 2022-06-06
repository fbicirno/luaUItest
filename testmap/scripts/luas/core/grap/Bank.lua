local BankControl = require 'scripts.luas.core.grap.BankControl'
local Items = require 'scripts.luas.core.entity.Items'

--银行类
--[[
  开局后根据存档创建物品，然后复制一份给单位
  否则发给单位后如果单位删除 会导致tip失效 
  银行删除物品后 item_handle不要删除 用于撤销时还原物品
]]
local _pack = {}

function _pack.init_dialog()
  --destroyDialog
  local panel = BankControl.data.abandon.dialogs
  panel[0] = dzapi.CreateFrame("myBackpDestroy",dzapi.FrameGetGameUI(),50);
  dzapi.FrameSetPoint(panel[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",0,0);
  panel[1] = dzapi.FrameFindByName("myBackpDestroyBtn1",50); --confirm
  panel[2] = dzapi.FrameFindByName("myBackpDestroyBtn2",50); --cancle
  panel[3] = dzapi.FrameFindByName("myBackpDestroyText",50); --title
  dzapi.FrameShow(panel[0],false);

  -- dzapi.FrameSetText(dzapi.FrameFindByName("myBackpDestroyText",50),"确定要移除物品吗？")
  -- dzapi.RegisterFrameEvent(panel[1],nil,nil,BankControl.abandon)
  -- dzapi.RegisterFrameEvent(panel[2],nil,nil,BankControl.closeAbandonDialog)
end

--@inti start
function _pack.init()
    local h = dzapi.SimpleFrameFindByName("SimpleInfoPanelUnitDetail",0); --单位信息框架

    BankControl.data.drop[0] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBankFrame",h,"myBank",1);
    dzapi.FrameSetPoint( BankControl.data.drop[0],"CENTER",dzapi.FrameGetGameUI(),"CENTER",1,1);
    
    --背景btn
    BankControl.data.drop[1] = dzapi.CreateFrameByTagName("BUTTON","myBankFrameBtn",dzapi.FrameGetGameUI(),"template",1);
    dzapi.FrameSetAllPoints(BankControl.data.drop[1], BankControl.data.drop[0]);
    dzapi.RegisterFrameEvent( BankControl.data.drop[1]) --注册空回调 防止触发左键右键 @BUG

    h = dzapi.CreateFrame("myBackpackTitle", BankControl.data.drop[1],1); --标题
    dzapi.FrameSetPoint(h,"TOP", BankControl.data.drop[0],"TOP",0.01,0.0025);
    dzapi.FrameSetText(h,"虚空银行");

    BankControl.data.drop[2] = dzapi.CreateFrame("myBackpBtnClose",h,1); --关闭按钮
    dzapi.FrameSetSize( BankControl.data.drop[2],0.028,0.0165);
    dzapi.FrameSetTexture(dzapi.FrameFindByName("myBackpBtnCloseDrop",1),"img\\alpha.blp",0);
    dzapi.FrameSetPoint(BankControl.data.drop[2],"TOPRIGHT", BankControl.data.drop[0],"TOPRIGHT",-0.001,-0.001);

    h = dzapi.CreateFrame("myBankWord1", BankControl.data.drop[1],0);
    dzapi.FrameSetPoint(h,"TOPRIGHT", BankControl.data.drop[0],"TOPRIGHT",0.05,-0.0175);
    dzapi.FrameSetText(h,"物品")

    h = dzapi.CreateFrame("myBankWord1", BankControl.data.drop[1],1);
    dzapi.FrameSetPoint(h,"TOPRIGHT", BankControl.data.drop[0],"TOPRIGHT",0.05,-0.113);
    dzapi.FrameSetText(h,"商城")

    h = dzapi.CreateFrame("myBankWord1", BankControl.data.drop[1],2);
    dzapi.FrameSetPoint(h,"TOPRIGHT", BankControl.data.drop[0],"TOPRIGHT",0.05,-0.182);
    dzapi.FrameSetText(h,"天赋")

    -- h = dzapi.CreateFrame("myBankWord2", BankControl.data.drop[1],0);
    -- dzapi.FrameSetPoint(h,"TOPRIGHT", BankControl.data.drop[0],"TOPRIGHT",0.05,-0.22);
    -- dzapi.FrameSetText(h,"")

    BankControl.data.btn[0] = dzapi.CreateFrame("myBankBtn", BankControl.data.drop[1],0);
    dzapi.FrameSetPoint(BankControl.data.btn[0],"BOTTOMRIGHT", BankControl.data.drop[1],"BOTTOMRIGHT",-0.156,0.015);
    h = dzapi.FrameFindByName("myBankBtnText",0);
    dzapi.FrameSetText(h,"拥有皮肤");

    BankControl.data.btn[1] = dzapi.CreateFrame("myBankBtn", BankControl.data.drop[1],1);
    dzapi.FrameSetPoint(BankControl.data.btn[1],"BOTTOMRIGHT", BankControl.data.drop[1],"BOTTOMRIGHT",-0.096,0.015);
    h = dzapi.FrameFindByName("myBankBtnText",1);
    dzapi.FrameSetText(h,"保 存");

    BankControl.data.btn[2] = dzapi.CreateFrame("myBankBtn", BankControl.data.drop[1],2);
    dzapi.FrameSetPoint(BankControl.data.btn[2],"BOTTOMRIGHT", BankControl.data.drop[1],"BOTTOMRIGHT",-0.036,0.015);
    h = dzapi.FrameFindByName("myBankBtnText",2);
    dzapi.FrameSetText(h,"还 原");

    --cells
    --1 自定义物品 3行24个  0-23
    for row = 0,2,1 do
      for col = 0,7,1 do
        local h = row*8+col

        BankControl.data.bankCell[h] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBankCell", BankControl.data.drop[0],"myBackpBtn",h+100);
        BankControl.data.bankDrop[h] = dzapi.SimpleTextureFindByName("myBackpBtnDrop",h+100); --背景

        BankControl.data.bankBtn[h] = dzapi.CreateFrame("myBackpBtnButton",BankControl.data.drop[1],h+100);--按钮
        BankControl.data.bankText[h] = dzapi.FrameFindByName("myBackpBtnText",h+100); --文字
        
        dzapi.FrameSetSize(BankControl.data.bankCell[h],0.023,0.023);
        dzapi.FrameSetPoint(BankControl.data.bankCell[h],"TOPLEFT",BankControl.data.drop[0],"TOPLEFT",0.0492+ col*0.02818, -0.031-row*0.0283);
        dzapi.FrameSetAllPoints(BankControl.data.bankBtn[h],BankControl.data.bankCell[h]);

        dzapi.RegisterFrameEvent( BankControl.data.bankBtn[h],
          BankControl.bankItemOver,
          function(frame,event)
            Interface.GUI.closeTip()
          end,
          BankControl.bankItemLeft,
          BankControl.bankItemRight
        )
      end
    end

    --2 商城物品 2行16个   24-39
    for row = 3,4,1 do
      for col = 0,7,1 do
        local h = row*8+col

        BankControl.data.bankCell[h] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBankCell", BankControl.data.drop[0],"myBackpBtn",h+100);
        BankControl.data.bankDrop[h] = dzapi.SimpleTextureFindByName("myBackpBtnDrop",h+100); --背景
        BankControl.data.bankBtn[h] = dzapi.CreateFrame("myBackpBtnButton",BankControl.data.drop[1],h+100);--按钮
        BankControl.data.bankText[h] = dzapi.FrameFindByName("myBackpBtnText",h+100); --文字
        
        dzapi.FrameSetSize(BankControl.data.bankCell[h],0.023,0.023);
        dzapi.FrameSetPoint(BankControl.data.bankCell[h],"TOPLEFT",BankControl.data.drop[0],"TOPLEFT",0.0492+ col*0.02818, -0.043-row*0.0283);
        dzapi.FrameSetAllPoints(BankControl.data.bankBtn[h],BankControl.data.bankCell[h]);
      end
    end

    --3 天赋 4个   40-43
    for col = 0,3,1 do  
      local h = 5*8+col

      BankControl.data.bankCell[h] = dzapi.CreateFrameByTagName("SIMPLEFRAME","myBankCell", BankControl.data.drop[0],"myBackpBtn",h+100);
      BankControl.data.bankDrop[h] = dzapi.SimpleTextureFindByName("myBackpBtnDrop",h+100); --背景

      BankControl.data.bankBtn[h] = dzapi.CreateFrame("myBackpBtnButton",BankControl.data.drop[1],h+100);--按钮
      BankControl.data.bankText[h] = dzapi.FrameFindByName("myBackpBtnText",h+100); --文字
      
      dzapi.FrameSetSize(BankControl.data.bankCell[h],0.023,0.023);
      dzapi.FrameSetPoint(BankControl.data.bankCell[h],"TOPLEFT",BankControl.data.drop[0],"TOPLEFT",0.10556+ col*0.02818,-0.196);
      dzapi.FrameSetAllPoints(BankControl.data.bankBtn[h],BankControl.data.bankCell[h]);
    end

    --content
    -- h = dzapi.CreateFrame("myBackpackTitle", BankControl.data.drop[1],1); --标题
    -- dzapi.FrameSetPoint(h,"TOP", BankControl.data.drop[0],"TOP",0.01,0.0025);
    -- dzapi.FrameSetText(h,"虚空银行");

    dzapi.FrameShow(BankControl.data.drop[1],false);
    BankControl.init()
    _pack.init_dialog()

    for i=24,43,1 do
      dzapi.RegisterFrameEvent( BankControl.data.bankBtn[i],
        BankControl.bankItemOver,
        function(frame,event)
          Interface.GUI.closeTip()
        end
      )
    end

    --mouse
    dzapi.RegisterMouseEvent(1,1,BankControl.bankMouseLeft)
    dzapi.RegisterMouseEvent(2,1,BankControl.bankMouseRight)
    
    dzapi.RegisterFrameEvent( BankControl.data.drop[2],nil,nil,BankControl.close)
    dzapi.RegisterFrameEvent( BankControl.data.btn[0],nil,nil,BankControl.btnSkin)
    dzapi.RegisterFrameEvent( BankControl.data.btn[1],nil,nil,BankControl.btnSave)
    dzapi.RegisterFrameEvent( BankControl.data.btn[2],nil,nil,BankControl.btnRollback)
    dzapi.RegisterKeyEvent(jmessage.keyboard.V,1,BankControl.toggle) 
end

return _pack
