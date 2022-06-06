local Context = require 'scripts.luas.core.applic.Context'
local CardControl = require 'scripts.luas.core.grap.CardControl'

--抽卡绘制

local _pack = {}

--2 dzapi实现
local function dzapiCreate()
    --第一个界面 抽卡界面
    CardControl.data.drop[5] = dzapi.CreateFrame("myCardDrop",dzapi.FrameGetGameUI(),0);
    dzapi.FrameSetAbsolutePoint(CardControl.data.drop[5],"CENTER",0.4,0.35)
    
    CardControl.data.drop[6] = dzapi.FrameFindByName("myCardTitle",0) 

    --返回按钮
    local backBtn= dzapi.FrameFindByName("myCardDropBackBtn",0) 
    dzapi.RegisterFrameEvent(backBtn,nil,nil,CardControl.extractBack,nil)
    
    --退出按钮
    local exitBtn = dzapi.FrameFindByName("myCardDropExitBtn",0) 
    dzapi.RegisterFrameEvent(exitBtn,nil,nil,CardControl.close,nil) --绑定点击触发

    local cardExtFrame = dzapi.CreateFrame("myCardPreview",CardControl.data.drop[6],0)
    CardControl.data.drop[1] = dzapi.FrameFindByName("myCardPreview_Card1Drop",0)   --卡面
    CardControl.data.drop[101] = dzapi.FrameFindByName("myCardPreview_Card1_Hig",0) --边框
    CardControl.data.drop[111] = dzapi.FrameFindByName("myCardPreview_Card1_BTN",0) --按钮


    CardControl.data.drop[2] = dzapi.FrameFindByName("myCardPreview_Card2Drop",0) 
    CardControl.data.drop[102] = dzapi.FrameFindByName("myCardPreview_Card2_Hig",0) 
    CardControl.data.drop[112] = dzapi.FrameFindByName("myCardPreview_Card2_BTN",0) 

    CardControl.data.drop[3] = dzapi.FrameFindByName("myCardPreview_Card3Drop",0) 
    CardControl.data.drop[103] = dzapi.FrameFindByName("myCardPreview_Card3_Hig",0) 
    CardControl.data.drop[113] = dzapi.FrameFindByName("myCardPreview_Card3_BTN",0) 

    CardControl.data.drop[4] = dzapi.FrameFindByName("myCardPreview_Card4Drop",0) 
    CardControl.data.drop[104] = dzapi.FrameFindByName("myCardPreview_Card4_Hig",0) 
    CardControl.data.drop[114] = dzapi.FrameFindByName("myCardPreview_Card4_BTN",0) 

    --绑定鼠标事件
    for i=111,114,1 do
        dzapi.RegisterFrameEvent(CardControl.data.drop[i],
            CardControl.cardOverDzapi,
            CardControl.cardOutDzapi,
            CardControl.extractDzapi)
    end

    --第二个界面
    CardControl.data.drop[7] = dzapi.CreateFrame("myCardDrop1",CardControl.data.drop[5],0);
    CardControl.data.drop[8] = dzapi.FrameFindByName("myCardTip2",0) 
    CardControl.data.drop[9] = dzapi.FrameFindByName("myCardTip3",0) 
    CardControl.data.drop[38] = dzapi.FrameFindByName("myCardPoint",0) --红色箭头

    --宝具格子   10-15 16-21
    local h = dzapi.FrameFindByName("myCardTip5",0) 
    for i=0,5,1 do
        CardControl.data.drop[10+i] = dzapi.CreateFrameByTagName("BACKDROP","myCard_card",h,"template",0)
        dzapi.FrameSetSize(CardControl.data.drop[10+i],0.026,0.026)
        dzapi.FrameSetPoint(CardControl.data.drop[10+i],"TOPLEFT",h,"TOPRIGHT",0.005+i*0.04,0)

        local t = dzapi.CreateFrame("CardBG",h,300+i)
        dzapi.FrameSetSize(t,0.03,0.03)
        dzapi.FrameSetPoint(t,"TOPLEFT",h,"TOPRIGHT",0.004+i*0.04,0)

        CardControl.data.drop[16+i] = dzapi.CreateFrameByTagName("BUTTON","myCard_card_btn",h,"template",0)
        dzapi.FrameSetAllPoints(CardControl.data.drop[16+i],CardControl.data.drop[10+i])

        dzapi.RegisterFrameEvent(CardControl.data.drop[16+i],
            CardControl.cellOver,CardControl.cellOut,CardControl.extractCell
        )
    end

    --天赋格子 22-25 26-29
    h = dzapi.FrameFindByName("myCardTip6",0) 
    for i=0,3,1 do
        CardControl.data.drop[22+i] = dzapi.CreateFrameByTagName("BACKDROP","myCard_talent",h,"template",0)
        dzapi.FrameSetSize(CardControl.data.drop[22+i],0.026,0.026)
        dzapi.FrameSetPoint(CardControl.data.drop[22+i],"TOPLEFT",h,"TOPRIGHT",0.005+i*0.04,0)

        local t = dzapi.CreateFrame("CardBG",h,310+i)
        dzapi.FrameSetSize(t,0.03,0.03)
        dzapi.FrameSetPoint(t,"TOPLEFT",h,"TOPRIGHT",0.004+i*0.04,0)

        CardControl.data.drop[26+i] = dzapi.CreateFrameByTagName("BUTTON","myCard_talent_btn",h,"template",0)
        dzapi.FrameSetAllPoints(CardControl.data.drop[26+i],CardControl.data.drop[22+i])

        dzapi.RegisterFrameEvent(CardControl.data.drop[26+i],
            CardControl.cellOver,CardControl.cellOut,CardControl.extractCell
        )
    end

    --技能格子 30-33 34-37
    h = dzapi.FrameFindByName("myCardTip7",0) 
    for i=0,3,1 do
        CardControl.data.drop[30+i] = dzapi.CreateFrameByTagName("BACKDROP","myCard_skill",h,"template",0)
        dzapi.FrameSetSize(CardControl.data.drop[30+i],0.026,0.026)
        dzapi.FrameSetPoint(CardControl.data.drop[30+i],"TOPLEFT",h,"TOPRIGHT",0.005+i*0.04,0)

        local t = dzapi.CreateFrame("CardBG",h,320+i)
        dzapi.FrameSetSize(t,0.03,0.03)
        dzapi.FrameSetPoint(t,"TOPLEFT",h,"TOPRIGHT",0.004+i*0.04,0)

        CardControl.data.drop[34+i] = dzapi.CreateFrameByTagName("BUTTON","myCard_skill_btn",h,"template",0)
        dzapi.FrameSetAllPoints(CardControl.data.drop[34+i],CardControl.data.drop[30+i])

        dzapi.RegisterFrameEvent(CardControl.data.drop[34+i],
            CardControl.cellOver,CardControl.cellOut,CardControl.extractCell
        )
    end

    dzapi.FrameShow(CardControl.data.drop[5],false)
end

--@init start
function _pack.init()
    local flag = Context.get("card_grap_flag")
    
    -- 绘制
    if (flag == "wjapi") then
        -- wjapiCreate() --已弃用
    end

    if (flag == "dzapi") then
        dzapiCreate()
    end

    CardControl.init()
end

return _pack