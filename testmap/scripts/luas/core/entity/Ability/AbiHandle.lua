local AbiTemp = require 'scripts.luas.core.entity.Ability.AbiTemp'
local Damage = require 'scripts.luas.core.entity.Damage'

local _pack = {}


--@init abilities
function _pack.init(Abi)
    --嘲讽
    Abi.abiHandle[1] = function()

    end
    --胜利之旗
    Abi.abiHandle[2] = function()

    end
    --死亡拯救
    Abi.abiHandle[3] = function()

    end
    --风暴之锤
    Abi.abiHandle[4] = function()

    end
    --狂暴撕裂
    Abi.abiHandle[5] = function()

    end
    --战斗冲锋
    Abi.abiHandle[6] = function()
        --冲锋
        AbiTemp.charge({
            loc = {},
            collision = true,
            mod = "",
            angle = 0,
            speed = 1000,
            length = 0,
        },function( )
           --冲锋结束 选取周围单位伤害
           AbiTemp.circular({
             loc = {},
             rad = 200,
             target = 1,
             mod = "",
           },function(aim)
             --造成伤害
             --上下移动
           end)

       end,nil)
        --
    end
    --战争践踏
    Abi.abiHandle[7] = function()

    end
    --巨斧旋风
    Abi.abiHandle[8] = function()

    end
    --剑刃风暴
    Abi.abiHandle[9] = function()

    end
    --血气剑刃
    Abi.abiHandle[10] = function()

    end
    --天崩地裂
    Abi.abiHandle[11] = function()

    end
    --战神之影
    Abi.abiHandle[12] = function()

    end

    --手里剑
    Abi.abiHandle[13] = function()

    end

    Abi.abiHandle[14] = function()

    end

    Abi.abiHandle[15] = function()

    end

    Abi.abiHandle[16] = function()

    end

    Abi.abiHandle[17] = function()

    end

    Abi.abiHandle[18] = function()

    end

     Abi.abiHandle[19] = function()

    end

    Abi.abiHandle[20] = function()

    end

    Abi.abiHandle[21] = function()

    end

    Abi.abiHandle[22] = function()

    end

    Abi.abiHandle[23] = function()

    end

    Abi.abiHandle[24] = function()

    end

    Abi.abiHandle[25] = function()

    end

    Abi.abiHandle[26] = function()

    end

    Abi.abiHandle[27] = function()

    end

    Abi.abiHandle[28] = function()

    end

    Abi.abiHandle[29] = function()

    end

    Abi.abiHandle[30] = function()

    end

    Abi.abiHandle[31] = function()

    end

    Abi.abiHandle[32] = function()

    end

    Abi.abiHandle[33] = function()

    end

    Abi.abiHandle[34] = function()

    end

    Abi.abiHandle[35] = function()

    end

    Abi.abiHandle[36] = function()

    end

    Abi.abiHandle[37] = function()

    end

    Abi.abiHandle[38] = function()

    end

    Abi.abiHandle[39] = function()

    end

    Abi.abiHandle[40] = function()

    end

    Abi.abiHandle[41] = function()

    end

    Abi.abiHandle[42] = function()

    end

    Abi.abiHandle[43] = function()

    end

    Abi.abiHandle[44] = function()

    end

    Abi.abiHandle[45] = function()

    end

    Abi.abiHandle[46] = function()

    end

     Abi.abiHandle[47] = function()

    end

    Abi.abiHandle[48] = function()

    end

     Abi.abiHandle[49] = function()

    end

    Abi.abiHandle[50] = function()

    end

     Abi.abiHandle[51] = function()

    end

    Abi.abiHandle[52] = function()

    end

    Abi.abiHandle[53] = function()

    end

     Abi.abiHandle[54] = function()

    end

    Abi.abiHandle[55] = function()

    end

    Abi.abiHandle[56] = function()

    end

    Abi.abiHandle[57] = function()

    end

    Abi.abiHandle[58] = function()

    end

    Abi.abiHandle[59] = function()

    end

    Abi.abiHandle[60] = function()

    end
end

return _pack