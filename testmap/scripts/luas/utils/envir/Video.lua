
-- Class.source = {}


-- function Class:structable()

-- end

-- -- 播放视频
-- --[[
--     cfg = {
--         tag = String,  --文件名 
--         rate = Number, --速率
--         time = Number, --时间
--         loop = Boolean --循环播放
--         frame = Number, --可选参数，如果是循环播放，需要给定总帧数

--         offset = { x,y} --位置
--         size = {w,h}    --尺寸

--         color = Number 默认 0xFFFFFFFF
--         zindex = Number 默认 5000
--     }

-- ]]

-- local function parseFilename(tag,rate,time)

-- end

-- function Class:play(cfg)
--     local names = parseFilename(cfg.tag,cfg.rate,cfg.time)

--     -- 根据offset和size建立幕布
--     local background = japi.CreateTexture("img/alpha.tga",
--         cfg.offset.x,cfg.offset.y,cfg.size.x,cfg.size.y,cfg.color or 0xFFFFFFFF, cfg.zindex or 5000)

--     local delay = 1/cfg.rate
--     local t = timer:getTimer(delay,true)
--     local i = 1
--     local count = 1

--     local function stop()
--         japi.DestroyTexture(background)
--         timer:clearInterval(t)
--     end

--     t.setCallback(function()
--         if (cfg.loop and i>#names) then
--             -- 循环播放
--             i = 1
--         end

--         if (not cfg.loop and i > #names) then
--             --结束播放
--             stop()
--             return
--         end

--         if(count > cfg.time * cfg.rate) then
--             --结束播放
--             stop()
--             return
--         end

--         japi.SetTexture(background,names[i])
--     end)

--     t:start()
-- end
