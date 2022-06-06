local Context = require 'scripts.luas.core.applic.Context'
local Items = require 'scripts.luas.core.entity.Items'
local Id = require 'scripts.luas.utils.id.Id'
local Console= require 'scripts.luas.utils.envir.Console'
local CenterTimer = require 'scripts.luas.utils.time.CenterTimer'

local _pack = {
    data = {
        drop = {},
        
        isOpen = false,  --当前抽卡界面是否在显示
        isEnable = true, --功能是否可用
        currentStep = 0, --当前在哪个界面 1卡牌界面 2格子界面

        --默认卡背
        card_back = {
            "img\\card\\card_back.blp", --品质1 默认卡背
            "img\\card\\card_back.blp", --品质2 默认卡背
            "img\\card\\card_rare.blp", --品质3 金色卡背
        }, 

        currentList = nil, --当前抽卡界面 4张卡牌信息

        --当前抽卡界面 选择卡牌的信息
        current = {
            index = 0,
            type = nil,  -- "天赋"/"宝具"/"技能"
        },

        --[[
            dzStylesFlag 标记变量 对应4张卡牌  刚打开抽卡界面时是false 此时显示卡背
                鼠标移入卡背后开始播放翻转动画 翻转结束后 dzStylesFlag[index]设置true

            dzStyleSwtichFlag 播放翻转动画时设为true 播放结束后设为false 用于翻转时防止被干扰
        ]]
        dzStylesFlag = {
            [1] = false,  --false表示还没播放过
            [2] = false,
            [3] = false,
            [4] = false,
        },

        dzStyleSwtichFlag = {  
            [1] = false, --true表示正在变换中
            [2] = false,
            [3] = false,
            [4] = false,
        },

    }
}

--根据frameId获取index 用于第一个界面
local function getCardIndexByFrameId(frameId)
    for i=111,114,1 do
        if (frameId == _pack.data.drop[i])then
            return i-110
        end
    end
    return -1
end

--根据frameId获取index 用于第二个界面
--@return type index
--@type 1宝具 2天赋 3技能
local function getIndexByFrameId(frameId)
    for i=0,5,1 do
        if (frameId == _pack.data.drop[16+i]) then
            return 1,i
        end
    end

    for i=0,3,1 do
        if (frameId == _pack.data.drop[26+i]) then
            return 2,i
        end
    end

    for i=0,3,1 do
        if (frameId == _pack.data.drop[34+i]) then
            return 3,i
        end
    end
end

--更新第二个界面
local function updateCardTip(selectCardId,cardArt)
    print ("updateCardTip",selectCardId,cardArt)
    local gamer = Context.get("GamerLocal")
    local role = gamer.data.role

    local cardType = Items.getCardType(selectCardId)
    dzapi.FrameSetText(_pack.data.drop[9],"类型:"..cardType)
    dzapi.FrameSetTexture(_pack.data.drop[8],cardArt)

    _pack.data.current = {
        index = selectCardId,
        type = cardType,
    }

    --读取宝具
    for i=1,6,1 do
        local card = role.data.abilities.card[i]

        if (not card) then
            dzapi.FrameSetTexture(_pack.data.drop[9+i],"img\\alpha.blp")
        else
            local icon = Items.getCardIcon(card.index)
            dzapi.FrameSetTexture(_pack.data.drop[9+i],icon)
        end
    end

    --读取天赋
    for i=1,4,1 do
        local talent = role.data.abilities.talent[i]
        if (not talent or talent.index == -102) then
            dzapi.FrameSetTexture(_pack.data.drop[21+i],"img\\alpha.blp")
        else 
            local icon = Items.getCardIcon(talent.index)
            dzapi.FrameSetTexture(_pack.data.drop[21+i],icon)
        end
    end

     --读取技能
     for i=1,4,1 do
        local ability = role.data.abilities.ability[i]
        if (not ability)then
            dzapi.FrameSetTexture(_pack.data.drop[29+i],"img\\alpha.blp")
        else
            local icon = Items.getCardIcon(ability)
            dzapi.FrameSetTexture(_pack.data.drop[29+i],icon)
        end
    end
end

--dzapi 翻牌动态效果
local function dzOpenStype(index,frameId,card)
    --关闭边框
    dzapi.FrameShow(_pack.data.drop[index+100],false) 
    dzapi.FrameShow(_pack.data.drop[index],true) 
   
    CenterTimer.addTrace(nil,{
        delay = 0.01, --刷新周期
        loop = true,
        bind = {
            index = index,
            frameId = frameId,
            card = card,
            num = 1,
            width = 0.06,
            height =  0.1633,
        },
        callback = function(bind)
            if (not _pack.data.isOpen) then
                _pack.data.dzStyleSwtichFlag = {
                    false,false,false,false,
                }
                return false
            end

            if (_pack.data.currentStep == 2) then
                _pack.data.dzStyleSwtichFlag = {
                    false,false,false,false,
                }
                return false
            end

            -- 10次关闭 10次打开
            if(bind.num > 20) then
                _pack.data.dzStyleSwtichFlag[bind.index] = false
                return false
            elseif (bind.num <=10) then
                bind.width = bind.width - 0.006
                dzapi.FrameSetSize(bind.frameId,bind.width,bind.height)
            elseif (bind.num == 11) then
                bind.width = 0.006
                dzapi.FrameSetSize(bind.frameId,bind.width,bind.height)
                dzapi.FrameSetTexture(bind.frameId,bind.card.art)
            else
                bind.width = bind.width + 0.006
                dzapi.FrameSetSize(bind.frameId,bind.width,bind.height)
            end

            bind.num = bind.num + 1
            return true
        end
    })
end

--关闭界面
function _pack.close()
    _pack.data.isOpen = false
    _pack.data.currentList =nil
    _pack.data.currentStep = 0

    Interface.Mouse.normal()
    Interface.dzevent.continueKey()

    dzapi.FrameShow(_pack.data.drop[5],false)

    for i=1,4,1 do
        japi.SetTextureX(_pack.data.drop[i],-200)
        japi.SetTextureY(_pack.data.drop[i],-200)

        _pack.data.dzStylesFlag[i] = false
    end

    _pack.data.dzStyleSwtichFlag = {
        false,false,false,false,
    }

    _pack.data.dzStylesFlag = {
        false,false,false,false,
    }

    _pack.data.current = nil
end

-- 开启界面
-- @param list 掉落配置
--[[
    list {
        [1] = {
            index = int   索引
            art = string  卡面
            qt  = int     品质 1普通 2普通 3金色
        }
        [2]
        [3]
        [4]
    }
]]
function _pack.open(list)
    if (_pack.data.isOpen) then
        return
    end
    Interface.dzevent.pauseKey() --暂停按键捕捉(防止这时候按b弹出背包)

    --保存list到currentlis 存储4张卡牌的信息
    _pack.data.currentList = list

    --设置当前为第一个界面
    _pack.data.currentStep = 1

    dzapi.FrameShow(_pack.data.drop[5],true) --背景框
    dzapi.FrameShow(_pack.data.drop[6],true) --预览卡牌界面
    dzapi.FrameShow(_pack.data.drop[7],false)--置入界面
    
    local type = Context.get("card_grap_flag")
   
    if (type == "dzapi") then
      for i=1,4,1 do
        --是否显示卡背 根据zStylesFlag判断
        if (_pack.data.dzStylesFlag[i]) then
            --直接显示卡面
            dzapi.FrameSetTexture(_pack.data.drop[i],_pack.data.currentList[i].art,0)
        else
            --显示卡背
            local cardBack = Items.getCardBack(_pack.data.currentList[i].index) --查询是否有自定义卡背 
            dzapi.FrameSetTexture(_pack.data.drop[i],cardBack or _pack.data.card_back[_pack.data.currentList[i].qt],0)

            --品质3显示边框
            if(_pack.data.currentList[i].qt == 3) then
                dzapi.FrameShow(_pack.data.drop[i+100],true)
                dzapi.FrameShow(_pack.data.drop[i],true)
            else
                dzapi.FrameShow(_pack.data.drop[i+100],false)
                dzapi.FrameShow(_pack.data.drop[i],true)
            end
        end
      end
    end

    _pack.data.isOpen = true
end

--第一个界面 玩家选择一张卡牌
function _pack.extractDzapi(frameId)
    if (not _pack.data.isEnable) then return end 

    local index = getCardIndexByFrameId(frameId) --获取玩家点击了哪张卡牌
    local currentCard = _pack.data.currentList[index] --获取点击卡牌的信息
    local cardIndex = currentCard.index  --获取卡牌的编号

    --判断选择卡牌类型(1宝具 2天赋 3技能) 这里略过了 直接走天赋判断

    --判断是否直接升级天赋
    --再次获取已拥有天赋时直接升级 不进入第二个界面了
    --天赋可以升级4次
    local gamer = Context.get("GamerLocal") --获取玩家类
    local role = gamer.data.role            --获取角色类
    local talents = role.data.abilities.talent --获取玩家已拥有的天赋

    for i=1,4,1 do
        if(talents[i] and talents[i].index == cardIndex) then
            --角色已拥有选择的卡牌天赋
            --直接升级天赋
            local check = role.addTalent(cardIndex,i) --调用role的天赋函数
            if(check == 2) then
               --升级失败直接return 不关闭界面
               return
            else
                --升级成功 关闭界面
                _pack.close()
                return
            end
        end
    end

    --玩家没有该天赋
    --打开选择格子界面
    _pack.data.currentStep =2 --设置当前为第二个界面

    --更新第二个界面
    updateCardTip(_pack.data.currentList[index].index,_pack.data.currentList[index].art)

    dzapi.FrameShow(_pack.data.drop[6],false)
    dzapi.FrameShow(_pack.data.drop[7],true)
end

--第一个界面 鼠标移出卡牌
function _pack.cardOutDzapi(frameId)
    local index = getCardIndexByFrameId(frameId)
    
    if (_pack.data.dzStyleSwtichFlag[index])then
        return 
    end

    dzapi.FrameSetSize(_pack.data.drop[index],0.06,0.1633)
end 

--第一个界面 鼠标移入卡牌
function _pack.cardOverDzapi(frameId)
    local index = getCardIndexByFrameId(frameId)

    if (_pack.data.dzStyleSwtichFlag[index])then
        return 
    end

    if (_pack.data.dzStylesFlag[index]) then
        dzapi.FrameSetSize(_pack.data.drop[index],0.07,0.1906)
    else
        _pack.data.dzStylesFlag[index] = true
        _pack.data.dzStyleSwtichFlag[index] = true
        dzOpenStype(index,_pack.data.drop[index],_pack.data.currentList[index])
    end
end

--第二个界面 鼠标移入格子
function _pack.cellOver(frameId)
    if (not _pack.data.isEnable) then return end 

    --移动箭头
    dzapi.FrameSetPoint(_pack.data.drop[38],"BOTTOM",frameId,"TOP",0,0.001)

    --显示已拥有卡牌的tip
    local type,index = getIndexByFrameId(frameId) --注意index是 0-3 gui.tip是1-4
    print("cellOver",index)
    local gamer = Context.get("GamerLocal")
    local role = gamer.data.role
    local abis = role.data.abilities

    if (type ==1 and abis.card[index+1]) then --宝具
        Interface.GUI.showTip(2,abis.card[index+1],role.data.unit)

    elseif(type ==2 and abis.talent[index+1] and abis.talent[index+1].index >=1) then --天赋
        Interface.GUI.showTip(2,abis.talent[index+1],role.data.unit)

    elseif(type ==3 and abis.ability[index+1]) then --技能
        Interface.GUI.showTip(1,index+1,role.data.unit)

    else
    end
end

--第二个界面 鼠标移出格子
function _pack.cellOut(frameId)
    if (not _pack.data.isEnable) then return end 
    Interface.GUI.closeTip()
end

--第二个界面 玩家点击格子
function _pack.extractCell(frameId)
    if (not _pack.data.isEnable) then return end 

    --获取点击格子类型和序号    
    local type,index = getIndexByFrameId(frameId) --type 1宝具 2天赋  3技能   index 0-5 0-3 0-3
    print("cardControl cellLeft",type,index)

    --检查类型是否匹配
    if (_pack.data.current.type == "宝具" and type ~= 1  ) then
        Console.system("只能选择|cFFFF0000宝具|r的格子!")
        jass.StartSound(jglobals.gg_snd_Error)
        return
    end

    if (_pack.data.current.type == "天赋" and type ~= 2  ) then
        Console.system("只能选择|cFFFF0000天赋|r的格子!")
        jass.StartSound(jglobals.gg_snd_Error)
        return
    end

    if (_pack.data.current.type == "技能" and type ~= 3  ) then
        Console.system("只能选择|cFFFF0000技能|r的格子!")
        jass.StartSound(jglobals.gg_snd_Error)
        return
    end

    local gamer = Context.get("GamerLocal")
    local role = gamer.data.role

    --如果是宝具 优先叠加次数
    if (type == 1) then
        --查找是否有相同的卡牌
        for i=1,6,1 do
            local role_card = role.data.abilities.card[i]
            if (role_card == _pack.data.current.index) then
                --相同的卡牌 直接次数+1
                role.data.abilities.cardNum[i] = role.data.abilities.cardNum[i]+1
                Interface.GUI.update_card()
                _pack.close()
                return
            end
        end

        --无相同 判断是否覆盖
        local role_card = role.data.abilities.card[index]
        if (role_card and role_card ~=0) then
            --替换覆盖
            --@TODO
            return
        else
            --直接放入
            role.data.abilities.card[index+1] = _pack.data.current.index
            role.data.abilities.cardNum[index+1] = 1
            Interface.GUI.update_card()
            _pack.close()
            return
        end
    end

    --如果是天赋 
    if(type == 2) then
        --检查是否可置入  1不可用栏位 其他成功
        local check = role.addTalent(_pack.data.current.index,index+1,true)
        
        if (check ==1) then
            Console.system("请选择未锁定的位置")
            return 

        else
            _pack.close()
        end
    end

    --技能
    if(type ==3) then
        local role_ability = role.data.abilities.ability[i]
        if (role_ability and role_ability ~=0) then
            --替换
            --@TODO
            return
        else
            --直接放入
            role.data.abilities.ability[index+1] = _pack.data.current.index
            Interface.GUI.update_skill()
            _pack.close()
            return
        end
    end
end

--玩家点击返回按钮
function _pack.extractBack()
    if (_pack.data.currentStep == 1) then return end
    if (not _pack.data.isEnable) then return end 

    _pack.data.isOpen = false
    _pack.open(_pack.data.currentList)
end

--@init Card
function _pack.init()

    --暴露接口
    Interface.Card = {}
    Interface.Card.open = _pack.open
    Interface.Card.close = _pack.close
end

return _pack