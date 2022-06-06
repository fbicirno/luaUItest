-- local keys = {

--     ['MOUSE_LEFT']=1,
--     ['MOUSE_RIGHT']=4,
--     ['MOUSE_MIDDILE']=2,

--     ['ESC']=512,
--     ['TILDE']=256,
--     ['TAB']=515,
--     ['CAPSLOCK']=526,
--     ['SHIFT']=0,
--     ['CTRL']=1,
--     ['ALT']=2,
--     ['SPACE']=32,
--     ['ENTER']=513,
--     ['BACKSPACE']=514,

--     ['NUMLOCK']=527,
--     ['NUMPAD0']=257,
--     ['NUMPAD1']=258,
--     ['NUMPAD2']=259,
--     ['NUMPAD3']=260,
--     ['NUMPAD4']=261,
--     ['NUMPAD5']=262,
--     ['NUMPAD6']=263,
--     ['NUMPAD7']=264,
--     ['NUMPAD8']=265,
--     ['NUMPAD9']=266,
--     ['ADD']=267,
--     ['SUBTRACT']=268,
--     ['MULTIPLY']=269,
--     ['DIVIDE']=270,
--     ['DECIMAL']=271,

--     ['F1']=768,
--     ['F2']=769,
--     ['F3']=770,
--     ['F4']=771,
--     ['F5']=772,
--     ['F6']=773,
--     ['F7']=774,
--     ['F8']=775,
--     ['F9']=776,
--     ['F10']=777,
--     ['F11']=778,
--     ['F12']=779,

--     ['RIGHT']=516,
--     ['UP']=517,
--     ['LEFT']=518,
--     ['DOWN']=519,
    
--     ['0']=48,
--     ['1']=49,
--     ['2']=50,
--     ['3']=51,
--     ['4']=52,
--     ['5']=53,
--     ['6']=54,
--     ['7']=55,
--     ['8']=56,
--     ['9']=57,

--     ['A']=65,
--     ['B']=66,
--     ['C']=67,
--     ['D']=68,
--     ['E']=69,
--     ['F']=70,
--     ['G']=71,
--     ['H']=72,
--     ['I']=73,
--     ['J']=74,
--     ['K']=75,
--     ['L']=76,
--     ['M']=77,
--     ['N']=78,
--     ['O']=79,
--     ['P']=80,
--     ['Q']=81,
--     ['R']=82,
--     ['S']=83,
--     ['T']=84,
--     ['U']=85,
--     ['V']=86,
--     ['W']=87,
--     ['X']=88,
--     ['Y']=89,
--     ['Z']=90,

--     ['PRINTSCREEN']=530,
--     ['SCROLLLOCK']=528,
--     ['PAUSE']=529,
--     ['INSERT']=520,
--     ['DELETE']=521,
--     ['HOME']=522,
--     ['END']=523,
--     ['PAGEUP']=524,
--     ['PAGEDOWN']=525,

--     ['OEM_PLUS']=272,
--     ['OEM_MINUS']=273,
--     ['OEM_OBRACKE']=274,
--     ['OEM_CBRACKE']=275,
--     ['OEM_BACKSLASH']=276,
--     ['OEM_SEMICOLON']=277,
--     ['OEM_SQUOTMARKS']=278,
--     ['OEM_COMMA']=279,
--     ['OEM_PERIOD']=280,
--     ['OEM_SLASH']=281
-- }

local _pack = {}

jmessage.keyboard['MOUSE_LEFT']=1
jmessage.keyboard['MOUSE_MIDDILE']=2
jmessage.keyboard["MOUSE_UP"]=3
jmessage.keyboard['MOUSE_RIGHT']=4

for k,v in pairs (jmessage.keyboard) do
    _pack[k] = v
end

return _pack
