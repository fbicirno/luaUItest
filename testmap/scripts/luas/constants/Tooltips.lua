local _pack = {

template_item = [=[
$add0
物品等级:$lv
物品类型:$type$only
$add1$add2
$tip
]=],

template_weap_add= [=[

武器类型:$aty
武器伤害:$atk
武器攻速:$asp
伤害类型:$adt
]=],

template_chest_add= [=[

装备类型:$ety
护甲类型:$cdt
]=],

template_equip_add= [=[

装备类型:$ety
]=],

template_equip = [=[

属性:$p1
属性:$p2
属性:$p3
属性:$p4

]=],

template_ingem = [=[

镶嵌属性:$p1+$p2
]=],

template_role = [=[
人物等级:%s  人物职业:%s

攻击强度:%s  攻击速度:%s 

法术强度:%s  冷却速度:%s 

暴击几率:%s  暴击伤害:%s 

物理防御:%s  法术防御:%s 

生命上限:%s  生命回复:%s 

魔法上限:%s  魔法回复:%s 

移动速度:%s  护甲类型:%s 

武器伤害:%s  武器攻速:%s 
]=],

template_unit=
[=[
单位等级:%s  攻   击:%s

物理防御:%s  法术防御:%s 

生命上限:%s  生命回复:%s

魔法上限:%s  魔法回复:%s

移动速度:%s  护甲类型:%s
]=],

template_save = 
[==[当前存档:%s

游戏时间:%s  累积时间:%s

银行物品:%s  商城币:%s

拥有皮肤:%s  
]==],


template_skill = [==[
技能等级:$lv
技能类型:$type

$tip
]==],

}

return _pack
