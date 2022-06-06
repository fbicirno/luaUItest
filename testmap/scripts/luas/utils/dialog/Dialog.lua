local UUID = require 'scripts.luas.utils.id.UUID'

-- 对话框类
local _pack = {
    data = {
        trig = jass.CreateTrigger(),
        tag = {}
    }
}

-- 创建一个对话框
-- @param cfg
--[[
    cfg={
        title:String,
        buttons:{
            [1]={  ---注意是1开始的
                name:String,
                callback:Function,    function(object,index)
                key:number
            }
            ...
        }
    }
--]]
function _pack.create(cfg)
    if(not cfg) then
        return
    end

    local t = {
        type = "object@luas.utils.dialog.Dialog",
        id = UUID.random(),
        data = {
            dialog = jass.DialogCreate(),
            title = cfg.title,
            trigger = jass.CreateTrigger(),
            buttons = {},
            callbacks = {},
        }
    }

    for _,v in pairs (cfg.buttons) do
        table.insert(t.data.buttons,jass.DialogAddButton(t.data.dialog, v.name,  v.key or 0))
        table.insert(t.data.callbacks,v.callback)
    end
    
    jass.TriggerRegisterDialogEvent(t.data.trigger,t.data.dialog)
    jass.TriggerAddAction(t.data.trigger,function()
        local click = jass.GetClickedButton()
        for index,btn in pairs (t.data.buttons) do
            if (click == btn) then
                t.data.callbacks[index](t,index)
            end
        end
    end)

    t.setTitle = function(tot)
        t.data.title = tot
    end

    t.show = function ()
        jass.DialogSetMessage(t.data.dialog,t.data.title)
        jass.DialogDisplay(jass.Player(0),t.data.dialog,true)
    end

    t.hide = function()
        jass.DialogDisplay(jass.GetLocalPlayer(),t.data.dialog,false)
    end

    t.destroy = function()
        jass.DialogDisplay(jass.GetLocalPlayer(),t.data.dialog,false)
        jass.DestroyTrigger(t.data.trigger)
        jass.DialogDestroy(t.data.dialog)
    end

    return t
end

-- 退出游戏对话框
function _pack.createExitGame()
    local t = {
        title = "已退出游戏",
        dialog = jass.DialogCreate(),
    }

    jass.DialogAddQuitButton(t.dialog,false, "确定", 0)

    t.show = function()
        jass.DialogSetMessage(t.dialog,"已退出游戏")
        jass.DialogDisplay(jass.GetLocalPlayer(), t.dialog, true)
    end

    return t
end

return _pack
