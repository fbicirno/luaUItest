//TESH.scrollpos=0
//TESH.alwaysfold=0
function InitTrig_start takes nothing returns nothing
    call DzFrameHideInterface()
    call DzFrameEditBlackBorders(0,0)
    call EnableMinimapFilterButtons( false, false ) //禁用小地图按钮
    // call EnableDragSelect( false, false ) //禁用框选
    //call Cheat("exec-lua:scripts.luas.core.map")
    call AbilityId("exec-lua:scripts.luas.core.map")
endfunction

