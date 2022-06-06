
function setDefault(v1,v2)
    if (v1 == nil) then
        v1 = v2
    end
    return v1
end

function getDefault(v1,v2)
    if (v1 == nil) then
        return v1
    else
        return v2
    end
end

function doNothing () 
end