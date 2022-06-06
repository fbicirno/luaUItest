local pack = {
    RED    = '|cFFFF0000',
    GREEN  = '|cFF00FF00',
    BLUE   = '|cFF0000FF',
    PURPLE = '|cFFFF00FF',
    YELLOW = '|cFFFFFF00',
    SYSTEM = '|cFFFFFF00',
    WARN   = '|cFFFF0000',

    GAMER = {
        [0] = '|cFFFB1334',
        [1] = '|cFF0066FF',
        [2] = '|cFF1BE6B8',
        [3] = '|cFFAC40EA',
        [4] = '|cFF1207F0',
        [5] = '|cFFFF0000'
    },

    QUALITY= {
        '|cff33ff99',
        '|cff0084ff',
        '|cffb700ff',
        '|cffff7b00',
        '|cFFFF0000',
    },
}

function pack.getColorStringByQt(str,qt)
    if (qt == 0) then 
        return str
    else
        return pack.QUALITY[qt] .. str .."|r"
    end
end

return pack