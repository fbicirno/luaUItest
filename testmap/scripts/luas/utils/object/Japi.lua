
local _pack = {}

--@init
function _pack.init()
    japi.EXSetMemory = function(addr,value)
        jass.SaveInteger(jglobals.lua_engine,100,1,addr)
        jass.SaveReal(jglobals.lua_engine,100,2,value)
        jass.ExecuteFunc("EXSetMemory");
    end

    japi.SyncData = function(msg)
        jass.SaveStr(jglobals.lua_engine,100,1,msg)
        jass.ExecuteFunc("SyncData");
    end

    japi.EXDestructablePosition = function (handle,x,y)
        jass.SaveDestructableHandle(jglobals.lua_engine,100,1,handle)
        jass.SaveReal(jglobals.lua_engine,100,2,x)
        jass.SaveReal(jglobals.lua_engine,100,3,y)

        jass.ExecuteFunc("EXDestructablePosition");
    end

    japi.EXSetUnitPosition = function (handle,x,y)
        jass.SaveUnitHandle(jglobals.lua_engine,100,1,handle)
        jass.SaveReal(jglobals.lua_engine,100,2,x)
        jass.SaveReal(jglobals.lua_engine,100,3,y)
        
        jass.ExecuteFunc("EXSetUnitPosition");
    end

    japi.EXGetUnitUnderMouse = function ()
        jass.ExecuteFunc("EXGetUnitUnderMouse");
        local u = LoadUnitHandle(jglobals.lua_engine,100,1)
        jass.FlushChildHashtable(jglobals.lua_engine,100);
        return u
    end

    japi.EXSetUnitTexture = function (unit,path,texId)
        jass.SaveUnitHandle(jglobals.lua_engine,100,1,unit)
        jass.SaveStr(jglobals.lua_engine,100,2,path)
        jass.SaveInteger(jglobals.lua_engine,100,3,texId)
        jass.ExecuteFunc("EXSetUnitTexture");
    end

    japi.EXSetUnitID = function (unit,id)
        jass.SaveUnitHandle(jglobals.lua_engine,100,1,unit)
        jass.SaveInteger(jglobals.lua_engine,100,2,id)
        jass.ExecuteFunc("EXSetUnitID");
    end

    japi.EXSetUnitModel = function (unit,path)
        jass.SaveUnitHandle(jglobals.lua_engine,100,1,unit)
        jass.SaveStr(jglobals.lua_engine,100,2,path)
        jass.ExecuteFunc("EXSetUnitModel");
    end
end

return _pack