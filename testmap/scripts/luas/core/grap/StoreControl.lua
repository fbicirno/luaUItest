local _pack = {
    data = {
        
    }
}

function _pack.open()

end

function _pack.close()
end

function _pack.toggle()
end

--@init Stroe
function _pack.init ()

    -- 暴露接口
    Interface.stroe = {}
    Interface.stroe.open = _pack.toggle
    Interface.stroe.close = _pack.close
    Interface.stroe.toggle = _pack.toggle
end

return _pack
