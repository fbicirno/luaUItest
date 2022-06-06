
-- -- 电台控制类
-- --[[
--     仿星际二的左侧电台

--     cfgs = {
--         --key String|Number 标识 方便索引 
--         key = {   
--             --视频配置  参考video类的配置 
--             --不需要配置offset size
--             video = {
--             },

--             movie = Boolean 是否开启电影模式
--             name = String,显示名字
            
--             --文字配置  key时间点(秒) value文字String  最后一个value表示删除时间点，值任意
--             -- 时间点精确到 0.1
--             text = {
--             },

--             --声音配置  key时间点(秒) value声音路径String 最后一个value表示删除时间点，值任意
--             -- 时间点精确到 0.1
--             sound = {
--             },
--         }
--     }
-- ]]

-- local _pack = {
--     cfgs = {},
--     offset = {},
--     size = {},
--     font = nil,
--     background = nil,
--     isPlay = false, --是否正在播放
-- }


-- -- 智能判断key
-- -- @param cfgs 配置对象 或 配置数组
-- -- @param key 可选参数  如果是配置对象必须要指定key
-- -- @param offset 电台位置Table{x,y}
-- -- @param size   电台大小Table{w,h}
-- -- @param path   电台背景图片String
-- function _pack.create(cfgs,key,offset,size,path)
--     Class.source.font = japi.CreateFont()


--     if (cfgs) then
--         if(type(key) == "string") then
--             Class.source.cfgs[key] = cfgs
--         else
--             for k,cfg in pairs(cfgs) do
--                 Class.source.cfgs[k] = cfg
--             end
--             offset = key
--             size = offset
--             path = size
--         end
--     else
--         offset = cfgs
--         size = key
--         path = offset
--     end

--     if (offset and type(offset) == "table") then
--         Class.source.offset = offset
--     end

--     if (size and type(size) == "table") then
--         Class.source.size = size
--     end
-- end

-- -- 添加配置
-- -- @params cfgs 配置对象 或 数组
-- -- @param key 如果不是数组 必须制定一个key  若是是配置数组 不要传key
-- -- ** 注意相同的key会顶掉旧的
-- function _pack.add(cfgs,key)
--     if(key) then
--         if( Class.source.cfgs[key]) then
--             logger:warn("add: a new config  will be override old config, key = " .. key)
--         end
--         Class.source.cfgs[key] = cfgs
--     else
--         for k,cfg in pairs (cfgs) do
--             if( Class.source.cfgs[k]) then
--                 logger:warn("add: a new config  will be override old config, key = " .. k)
--             end
--             Class.source.cfgs[k] = cfg
--         end
--     end
-- end

-- function _pack.remove(key)
--     if( Class.source.cfgs[key]) then
--         Class.source.cfgs[key] = nil
--     else
--         logger:warn("remove: not found config, key = "  .. key)
--     end
-- end

-- function _pack.play(key)
--     -- 判断播放条件
--     if (Class.source.isPlay) then
--         return 
--     end

--     if (not Class.source.offset) then
--         return
--     end

--     if (not Class.source.size) then
--         return
--     end

--     if (not Class.source.background) then
--         return
--     end

--     if (not Class.source.cfgs[key]) then
--         logger:warn("play: not found config, key = "  .. key)
--     end

--     -- 播放
--     Class.source.isPlay = true
--     local cfg = Class.source.cfgs[key]

--     -- 是否打开电影模式
--     if (cfg.movie) then
--         movie:open()
--     end

--     --边框
--     local background = japi.CreateTexture("img/alpht.tga",Class.source.offset.x,Class.source.offset.y,
--         Class.source.size.w,Class.source.size.h,0XFFFFFF,5000)

--     --显示名字
--     local name = nil
--     if (cfg.name) then
--         name = japi.CreateText( Class.source.font,cfg.name,Class.source.offset.x, Class.source.offset.y ,9999,0xFFFFFFFF)
--     end

--     -- 显示对话
--     local text = japi.CreateText( Class.source.font,"",Class.source.offset.x, Class.source.offset.y ,9999,0xFFFFFFFF)

--     --播放视频
--     cfg.video.offset = Class.source.offset
--     cfg.video.size = Class.source.size
--     video:play(cfg.video)

--     --计时器控制
--     --寻找最大时间点
--     local max = 0
--     local point = { --记录文字和声音的时间节点
--         text = Array:new(),
--         sound = Array:new(),
--     }
--     for k,v in pairs (cfg.text) do
--         point.text:insert(tonumber(k))
--         max = math.max(max,tonumber(k))
--     end
--     for k,v in pairs (cfg.text) do
--         point.sound:insert(tonumber(k))
--         max = math.max(max,tonumber(k))
--     end

--     point.text:sort("asc")
--     point.sound:sort("asc")

--     local t = timer:getTimer(0.1,true)
--     t.textIndex = 1   --记录下一个text节点
--     t.soundIndex = 1  --记录下一个sound节点
--     t.timesgin = 0    --记录计时器时间
--     t:setCallback(function()
--         t.timesgin = t.timesgin+0.1
--         if (t.timesgin >= max) then
--             --结束
--             japi.DestroyTexture(background)
--             japi.SetTextTime(text,0)
--             if (name) then
--                 japi.SetTextTime(name,0)
--             end
--             if (cfg.movie) then
--                 movie:close()
--             end
--             return
--         end

--         -- 文字处理
--         local textPoint = point.text:get(t.textIndex)
--         if (textPoint and t.timesgin >= textPoint) then
--             t.textIndex = t.textIndex+1
--             -- 播放文字
--             local msg = cfg.text[tostring(textPoint)]
--             japi.SetText(text,msg)
--         end

--         -- 声音处理
--         local soundPoint = point.sounde:get(soundIndex)
--         if(soundPoint and t.timesgin >= soundPoint) then
--             t.soundIndex = t.soundIndex+1
--             -- 播放声音
--             local path = cfg.sound[tostring(soundPoint)]
--             --TODO
--         end
--     end)

--     t:start()
-- end
