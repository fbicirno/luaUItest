jruntime = require 'jass.runtime'
jconsole = require 'jass.console'
jdebug = require 'jass.debug'
jass = require 'jass.common'
japi = require 'jass.japi'
jlog = require 'jass.log'
jslk = require 'jass.slk'
jmessage = require 'jass.message'
jglobals = require 'jass.globals'
jhook    = require 'jass.hook'
jai = require 'jass.ai'

--重载print,自动转换编码
print = jconsole.write

-- 错误函数 正式版要去掉该定义
jruntime.error_handle = function(msg)
    print("---------------------------------------")
    print("              LUA ERROR!!              ")
    print("---------------------------------------")
    print(tostring(msg) .. "\n")
    print(debug.traceback())
    print("---------------------------------------")
end

--将句柄等级设置为2(句柄用userdata封装)
jruntime.handle_level = 2

--脚本加载路径 注意是upath
package.upath =[[scripts\?.lua;scripts\luas\?.lua;scripts\config\?.lua;\?.lua;]]

--控制台 @TEST
jconsole.enable = true

--关闭等待
jruntime.sleep = false

local Context = require 'scripts.luas.core.applic.Context'
require "scripts.luas.utils.commonFunctions"

Context.put("release",false)
Context.put("version",'0.1bate')
Context.put("raskey",'knciik@123')
Context.put("author",'knciik')
Context.put("name",'test')
Context.put("describe",'')
Context.put("email",'knciik@qq.com')
Context.put("url",'')
Context.put("datetime",'20201229')

-- Context.put("card_grap_flag","wjapi") --卡片模块绘制方式 wjapi
Context.put("card_grap_flag","dzapi") --卡片模块绘制方式 dzapi

--加载版本补丁

--加载平台补丁

--@init
xpcall(function() 
    require 'scripts.luas.utils.object.Interface'.init()
    require 'scripts.luas.utils.object.Bj'.init()
    require 'scripts.luas.utils.object.Japi'.init()
    require 'scripts.luas.utils.object.Dzapi'.init()
    require 'scripts.luas.utils.object.Dzapi'.FrameHideInterface()
    require 'scripts.luas.utils.time.CenterTimer'.init()
    require 'scripts.luas.utils.object.StringUtils'.init()
    require 'scripts.luas.utils.object.ObjectUtils'.init()
    require 'scripts.luas.utils.envir.Console'.init()
    require 'scripts.luas.core.scoket.Scoket'.init()
    require 'scripts.luas.core.behavior.Order'.init()
    require 'scripts.luas.utils.object.TriggerUtils'.init()
    require 'scripts.luas.utils.id.Random'.init()
    require 'scripts.luas.core.gamer.Gamer'.init()
    -- require "scripts.luas.core.behavior.Keys".init() --已弃用
    require 'scripts.luas.core.entity.Abilities'.init()
    require 'scripts.luas.core.entity.Items'.init()
    require 'scripts.luas.constants.Roles'.init()
    require 'scripts.luas.core.entity.Damage'.init()
end,print)

--检测平台环境
Context.put("platform",'wy')

-- 游戏开始后运行
local Trigger = require 'scripts.luas.utils.object.TriggerUtils'
Trigger.registerEvent("game_start",function()
    --ui初始化
    require 'scripts.luas.core.grap.GUI'.init()
    require "scripts.luas.core.grap.Mouse".init()
    require 'scripts.luas.core.grap.Backpack'.init()
    require "scripts.luas.core.grap.Inventory".init()
    require "scripts.luas.core.grap.Bank".init()
    require "scripts.luas.core.grap.Shop".init()
    require "scripts.luas.core.grap.Store".init()
    require "scripts.luas.core.grap.Card".init()

    --测试脚本
    require 'scripts.luas.core.test'

    --开始
    require 'scripts.luas.core.behavior.Caption'.start()
end)
