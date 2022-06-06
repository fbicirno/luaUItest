--封装BJ函数
local _pack ={
    data = {
        commonTimer = jass.CreateTimer(),
        yd_MapMinX = jass.GetCameraBoundMinX() - jass.GetCameraMargin(jass.CAMERA_MARGIN_LEFT),
        yd_MapMinY = jass.GetCameraBoundMinY() - jass.GetCameraMargin(jass.CAMERA_MARGIN_BOTTOM),
        yd_MapMaxX = jass.GetCameraBoundMaxX() + jass.GetCameraMargin(jass.CAMERA_MARGIN_RIGHT),
        yd_MapMaxY = jass.GetCameraBoundMaxY() + jass.GetCameraMargin(jass.CAMERA_MARGIN_TOP),
    }
}

--获取生命百分比
function _pack.GetUnitLifePercent(whichUnit)
    local value    = jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE)
    local maxValue = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE)
    return value / maxValue
end

--获取魔法百分比
function _pack.GetUnitManaPercent (whichUnit)
    local value    = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MANA)
    local maxValue = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA)
    return value / maxValue
end

--获取物品类型在单位物品栏的位置
--@return number 0-5
function _pack.GetInventoryIndexOfItemType(unit,itemTypeId)
    for i=0,5,1 do
        local check = jass.UnitItemInSlot(unit,i)
        if (check and jass.GetItemTypeId(check) == itemTypeId) then
            return i
        end
    end
end

--获取物品在单位物品栏的位置
--@return number 0-5
function _pack.GetInventoryIndexOfItem(unit,item)
    for i=0,5,1 do
        local check = jass.UnitItemInSlot(unit,i)
        if (check and check == item) then
            return i
        end
    end
end

function _pack.appendExecute(callback)
    jass.TimerStart(_pack.data.commonTimer,0,false,callback)
end

--判断两个单位的距离小于
function _pack.unitDistanceLess(u1,u2,length)
    local x1 = jass.GetUnitX(u1)
    local y1 = jass.GetUnitY(u1)

    local x2 = jass.GetUnitX(u2)
    local y2 = jass.GetUnitY(u2)

    return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) <= length*length
end

--判断两个单位的距离大于
function _pack.unitDistanceGreater (u1,u2,length)
    local x1 = jass.GetUnitX(u1)
    local y1 = jass.GetUnitY(u1)

    local x2 = jass.GetUnitX(u2)
    local y2 = jass.GetUnitY(u2)
    return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) > length*length
end

--两点距离的平方
function _pack.GetCoorDistance(x1,y1,x2,y2)
    return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2)
end

--两单位距离的平方
function _pack.GetUnitDistance(u1,u2)
    return _pack.GetCoorDistance(jass.GetUnitX(u1),jass.GetUnitY(u1),
        jass.GetUnitX(u2),jass.GetUnitY(u2))
end

--两点距离
function _pack.GetCoorDistance2(x1,y1,x2,y2)
    return jass.SquareRoot(_pack.GetCoorDistance(x1,y1,x2,y2))
end

--两个单位之间的角度
function _pack.GetAngleBetweenUnits(fromUnit,toUnit) 
    return  _pack.GetAngleBetweenCoor(
        jass.GetUnitX(fromUnit),jass.GetUnitY(fromUnit),
        jass.GetUnitX(toUnit),jass.GetUnitY(toUnit)
    )
end

--两点之间的角度
function _pack.GetAngleBetweenCoor(x1,y1,x2,y2)
    return jass.bj_RADTODEG * jass.Atan2(y2 - y1, x2 - x1)
    -- return jass.Atan((y2-y1)/(x2-x1)) * jass.bj_RADTODEG 
end

function _pack.isAlive(unit)
    return jass.GetUnitState(unit, jass.UNIT_STATE_LIFE) > 0
end

function _pack.isDeath(unit)
    return jass.GetUnitState(unit, jass.UNIT_STATE_LIFE) <= 0
end

function _pack.Min(a,b)
    if (a<b) then
        return a
    else
        return b
    end
end

function _pack.Max(a,b)
    if (a<b) then
        return b
    else
        return a
    end
end

--地图边界判断
function _pack.CoordinateX(x)
    return _pack.Min(_pack.Max(x, yd_MapMinX), yd_MapMaxX)
end

function _pack.CoordinateY(x)
    return _pack.Min(_pack.Max(y, yd_MapMinY), yd_MapMaxY)
end

--设置单位可以飞行
function _pack.FlyEnable (u)
    jass.UnitAddAbility(u,'Amrf')
    jass.UnitRemoveAbility(u,'Amrf')
end


--@init
function _pack.init()
    _G.bj = _pack
end

return _pack
