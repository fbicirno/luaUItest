local _pack = {
    names = {},
    index = {
        jglobals.gg_unit_H000_0009,
        jglobals.gg_unit_H001_0010,
        jglobals.gg_unit_H002_0008,
        jglobals.gg_unit_H003_0011,
        jglobals.gg_unit_H004_0012,
        jglobals.gg_unit_H005_0013,
        jglobals.gg_unit_H006_0014,
        jglobals.gg_unit_H007_0015,
        jglobals.gg_unit_H008_0016,
        jglobals.gg_unit_H009_0017,
        jglobals.gg_unit_H00A_0018,
        jglobals.gg_unit_H00B_0019,
    },
    
    class={
        [0] = "战士",
        [1] = "刺客",
        [2] = "射手",
        [3] = "法师",
        [4] = "牧师",
    },

    
}

--[[
gg_unit_H000_0009
gg_unit_H001_0010
gg_unit_H002_0008
gg_unit_H003_0011
gg_unit_H004_0012
gg_unit_H005_0013
gg_unit_H006_0014
gg_unit_H007_0015
gg_unit_H008_0016
gg_unit_H009_0017
gg_unit_H00A_0018
gg_unit_H00B_0019
]]

--@init
function _pack.init()
    for k,v in pairs(_pack.index) do
        local name = jass.GetUnitName(v)
        _pack.names[name] = v
    end
end

function _pack.getByName(name)
    return _pack.names[name]
end

function _pack.inGroup(u)
    for _,v in pairs (_pack.index) do
        if (u == v) then
            return true
        end
    end
    return false
end

function _pack.untiTypeIdGroup(tid)
    for _,v in pairs (_pack.index)do
        local g_tid = jass.GetUnitTypeId(v)
        if (tid == g_tid) then
            return true
        end
    end
    return false
end

return _pack