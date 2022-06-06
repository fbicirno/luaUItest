local Scoket = require "scripts.luas.core.scoket.Scoket"
local Camera = require "scripts.luas.utils.envir.Camera"
local CameraConstants = require 'scripts.luas.constants.Camera'
local Dialog = require 'scripts.luas.utils.dialog.Dialog'
local RolesConstants = require "scripts.luas.constants.Roles"    
local Context = require 'scripts.luas.core.applic.Context'
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
local Id = require 'scripts.luas.utils.id.Id'
local Console= require 'scripts.luas.utils.envir.Console'
local Saves = require 'scripts.luas.core.behavior.Saves'
-- 地图流程控制器
local _pack = {
    data = {
        skipSelectHero = false, --是否跳过选择英雄
        defaultNewGame = false, --默认以"新建游戏"开始
    }
}

local function init1()

end

local function init2()
end

local function init3()

end

local function init4()

end

local function init5()

end

local function init6()

end

-- 初始化选择英雄
local function initSelect()
    if (_pack.data.skipSelectHero) then return end

    Camera.fog(CameraConstants.SelectRole)
    Camera.release()
    Camera.moveRect(CameraConstants.SelectRole,nil,true)

    local selectRole;
    local timer = jass.CreateTimer()  --异步了
    local trig = jass.CreateTrigger() --异步了

    jass.TriggerRegisterPlayerUnitEvent(trig, jass.GetLocalPlayer(), jass.EVENT_PLAYER_UNIT_SELECTED, nil)
    jass.TriggerAddAction(trig,function()
        local selectUnit = jass.GetTriggerUnit()

        if (selectRole == selectUnit) then
            Dialog.create({
                title = ('确定选择"$name"吗?'):gsub("$name",jass.GetUnitName(selectUnit) or "英雄"),
                buttons = {
                    {
                        name = "确定",
                        callback = function(obj,i)
                            -- 确定选择英雄
                            local gamer =Context.get("GamerLocal")
                            gamer.createRole(selectUnit) --创建英雄

                            obj.destroy()
                            jass.DestroyTrigger(trig)
                            jass.DestroyTimer(timer)
                        end
                    },
                    {
                        name = "取消",
                        callback = function(obj)
                            selectRole = nil
                            obj.destroy()
                        end
                    }
                }
            }).show()
        else
            if (RolesConstants.inGroup(selectUnit)) then
                selectRole = selectUnit

                -- 计时器0.3秒后清空
                jass.PauseTimer(timer)
                jass.DestroyTimer(timer)

                timer = jass.CreateTimer()
                jass.TimerStart(timer,0.3,false,function()
                    selectRole = nil
                end)
            end
        end

    end)
end

function _pack.start()

    -- 初始化视野
    Camera.fog(CameraConstants.Init)
    Camera.moveRect(CameraConstants.Init,nil,true)
    
    if (_pack.data.defaultNewGame) then 
        Saves.init(-2)
        initSelect()
        return
    end

    local localSaves = Saves.loadLocalSavesName()
    local cloudSaves = Saves.isExistCloudSave()

    local dailogCfg = {
        title = "选择存档",
        buttons = {
            {
                name = "新游戏",
                callback = function(object,index)
                    Saves.init(-2)
                    initSelect()
                    object.destroy()
                end
            }
        }
    }

    if (cloudSaves) then
        table.insert(dailogCfg.buttons,{
            name = "云存档",
            callback = function(object,index)
                Saves.init(-1)
                initSelect()
                object.destroy()
            end
        })
    end

    for k,v in pairs (localSaves) do
        table.insert(dailogCfg.buttons,{
            name = k,
            callback = function(obj,index)
                Saves.init(index)
                initSelect()
                obj.destroy()
            end
        })
    end
    

    Dialog.create(dailogCfg).show()
    Console.system("开始游戏")
end

return _pack
