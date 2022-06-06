-- 电影工具类

local _pack = {}

_pack.hide = {}
_pack.show = {}

-- 注册隐藏函数   开启电影模式后调用hide函数
function _pack:regHide(cb)
    table.insert(_pack.hide,cb)
end

-- 注册显示函数   关闭电影模式后调用show函数
function _pack:regShow(cb)
    table.insert(_pack.show,cb)
end

-- 开启电影模式
function _pack:open()
    if (not bj_cineModeAlreadyIn) then
        jglobals.bj_cineModeAlreadyIn = true
        jglobals.bj_cineModePriorSpeed = jass.GetGameSpeed()
        jglobals.bj_cineModePriorFogSetting = jass.IsFogEnabled()
        jglobals.bj_cineModePriorMaskSetting = jass.IsFogMaskEnabled()
        jglobals.bj_cineModePriorDawnDusk = jglobals.bj_useDawnDuskSounds --IsDawnDuskEnabled
        jglobals.bj_cineModeSavedSeed = jass.GetRandomInt(0, 1000000)
    end

    -- Perform local changes
    if (jass.IsPlayerInForce(jass.GetLocalPlayer(), jglobals.bj_FORCE_ALL_PLAYERS)) then
       -- Use only local code (no net traffic) within this block to avoid desyncs.
       jass.ClearTextMessages()
       jass.ShowInterface(false, interfaceFadeTime)
       jass.EnableUserControl(false)
       jass.EnableOcclusion(false)
        
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_UNITMOVEMENT,  jglobals.bj_CINEMODE_VOLUME_UNITMOVEMENT)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_UNITSOUNDS,    jglobals.bj_CINEMODE_VOLUME_UNITSOUNDS)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_COMBAT,        jglobals.bj_CINEMODE_VOLUME_COMBAT)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_SPELLS,        jglobals.bj_CINEMODE_VOLUME_SPELLS)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_UI,            jglobals.bj_CINEMODE_VOLUME_UI)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_MUSIC,         jglobals.bj_CINEMODE_VOLUME_MUSIC)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_AMBIENTSOUNDS, jglobals.bj_CINEMODE_VOLUME_AMBIENTSOUNDS)
       jass.VolumeGroupSetVolume(jglobals.SOUND_VOLUMEGROUP_FIRE,          jglobals.bj_CINEMODE_VOLUME_FIRE)
    end

    -- Perform global changes
    jass.SetGameSpeed(jglobals.bj_CINEMODE_GAMESPEED)
    jass.SetMapFlag(jglobals.MAP_LOCK_SPEED, true)
    jass.FogMaskEnable(false)
    jass.FogEnable(false)
    jass.EnableWorldFogBoundary(false)
    jglobals.bj_useDawnDuskSounds = false--EnableDawnDusk

    -- Use a fixed random seed, so that cinematics play consistently.
    jass.SetRandomSeed(0)

    for c in pairs (_pack.hide) do
        c()
    end
end

-- 关闭电影模式
function _pack:close()
    for c in pairs (_pack.show) do
        c()
    end
end

cinematic = _pack