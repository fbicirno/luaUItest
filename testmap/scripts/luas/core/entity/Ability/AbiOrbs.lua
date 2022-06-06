local AbiTemp = require 'scripts.luas.core.entity.Ability.AbiTemp'
local Damage = require 'scripts.luas.core.entity.Damage'

-- 法球处理
local _pack = {}

--@init abilities
function _pack.init(Abi)
    --火球
    Abi.orbHandle[1] = function (dmgUnit,srcUnit,dmg)
        print("触发火球")
        return dmg
    end

    --冰球
    Abi.orbHandle[2] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --毒球
    Abi.orbHandle[3] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --腐蚀
    Abi.orbHandle[4] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --电球
    Abi.orbHandle[5] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --流血
    Abi.orbHandle[6] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --重击
    Abi.orbHandle[7] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --恐惧
    Abi.orbHandle[8] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --缓慢
    Abi.orbHandle[9] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --吸血
    Abi.orbHandle[10] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --吸蓝
    Abi.orbHandle[11] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --烧蓝
    Abi.orbHandle[12] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end

    --反馈
    Abi.orbHandle[13] = function (dmgUnit,srcUnit,dmg)

        return dmg
    end
end

return _pack
