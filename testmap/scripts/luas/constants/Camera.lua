local _pack = {
    Init = {- 3072.0, 1632.0, - 864.0, 2848.0},
    Home = {},
    SelectRole = {- 3072.0, - 672.0, - 1792.0, 352.0},
    Items = {- 384.0, 1536.0, 1152.0, 3072.0},
    Caption = {
        {},
        {},
        {},
        {},
        {}, 
        {},
    },
    Map = { jass.GetCameraBoundMinX()-jass.GetCameraMargin(jass.CAMERA_MARGIN_LEFT), 
            jass.GetCameraBoundMinY()-jass.GetCameraMargin(jass.CAMERA_MARGIN_BOTTOM), 
            jass.GetCameraBoundMaxX()+jass.GetCameraMargin(jass.CAMERA_MARGIN_RIGHT), 
            jass.GetCameraBoundMaxY()+jass.GetCameraMargin(jass.CAMERA_MARGIN_TOP)
        },



    --==============封装为Rect========================--
    Rects = {
        Init = jass.Rect(- 3072.0, 1632.0, - 864.0, 2848.0),
        Home = jass.Rect(),
        SelectRole = jass.Rect(- 3072.0, - 672.0, - 1792.0, 352.0),
        Items = jass.Rect(- 384.0, 1536.0, 1152.0, 3072.0),
        Caption = {

        },
        Map = jass.Rect(jass.GetCameraBoundMinX()-jass.GetCameraMargin(jass.CAMERA_MARGIN_LEFT), 
            jass.GetCameraBoundMinY()-jass.GetCameraMargin(jass.CAMERA_MARGIN_BOTTOM), 
            jass.GetCameraBoundMaxX()+jass.GetCameraMargin(jass.CAMERA_MARGIN_RIGHT), 
            jass.GetCameraBoundMaxY()+jass.GetCameraMargin(jass.CAMERA_MARGIN_TOP)),
    }
}

return _pack