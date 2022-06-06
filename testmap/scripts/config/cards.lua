local _pack = {
  talent = {
    [0x0006] = {
      index = 0x0006,
      name = [[多重射击]],
      icon = [[ReplaceableTextures/CommandButtons/BTNtalentIcon6.blp]],
      art = [[card/talent/card6.blp]],
      back = nil,
      type = 1,
      quality = 3,
      tip = [[多重射击(天赋)]],
      uber = [[|cFF16CD80穿刺攻击特效[唯一]|r
普通攻击时额外攻击|cFFFF00002/3/4/5|r个目标(每个目标独立触发其他特效)。（多重射击、弹射箭矢、穿透射击、熔岩弹丸只能4选1）]],
      ability = nil,
      bind = nil,
    },
    [0x0007] = {
      index = 0x0007,
      name = [[弹射箭矢]],
      icon = [[ReplaceableTextures/CommandButtons/BTNtalentIcon7.blp]],
      art = [[card/talent/card7.blp]],
      back = nil,
      type = 1,
      quality = 2,
      tip = [[弹射箭矢(天赋)]],
      uber = [[|cFF16CD80穿刺攻击特效[唯一]|r
射出可以弹射的箭矢或子弹，在|cFFFF00002/3/4/5|r个单位之间弹射，每次弹射伤害衰减12%(每个目标独立触发其他特效)。（多重射击、弹射箭矢、穿透射击、熔岩弹丸只能4选1）]],
      ability = nil,
      bind = nil,
    },
    [0x0008] = {
      index = 0x0008,
      name = [[穿透射击]],
      icon = [[ReplaceableTextures/CommandButtons/BTNtalentIcon8.blp]],
      art = [[card/talent/card8.blp]],
      back = nil,
      type = 1,
      quality = 1,
      tip = [[穿透射击(天赋)]],
      uber = [[|cFF16CD80穿刺攻击特效[唯一]|r
射出具有强力穿透能力的箭矢或子弹，可以穿透|cFFFF00001/1/2/2|r个单位，每次穿透伤害衰减|cFFFF000060/50/40/30%|r(每个目标独立触发其他特效)。（多重射击、弹射箭矢、穿透射击、熔岩弹丸只能4选1）]],
      ability = nil,
      bind = nil,
    },
    [0x0009] = {
      index = 0x0009,
      name = [[熔岩弹药]],
      icon = [[ReplaceableTextures/CommandButtons/BTNtalentIcon9.blp]],
      art = [[card/talent/card9.blp]],
      back = nil,
      type = 1,
      quality = 2,
      tip = [[熔岩弹药(天赋)]],
      uber = [[|cFF16CD80穿刺攻击特效[唯一]|r
为箭矢或子弹附魔，击中目标后爆炸，对小范围造成|cFFFF0000150/160/170/180%|r火焰伤害。（多重射击、弹射箭矢、穿透射击、熔岩弹丸只能4选1）]],
      ability = nil,
      bind = nil,
    },
    [0x000A] = {
      index = 0x000A,
      name = [[瘟疫射击]],
      icon = [[ReplaceableTextures/CommandButtons/BTNtalentIcon10.blp]],
      art = [[card/talent/card10.blp]],
      back = nil,
      type = 1,
      quality = 1,
      tip = [[瘟疫射击(天赋)]],
      uber = [[|cFF16CD80穿刺攻击特效[唯一]|r
为箭矢或子弹涂毒，对目标施加瘟疫效果，每秒损失|cFFFF00001/2/3/4%|r生命值。瘟疫效果会感染周围的其他单位。]],
      ability = nil,
      bind = nil,
    },
    [0x0029] = {
      index = 0x0029,
      name = [[希望之花]],
      icon = [[ReplaceableTextures/CommandButtons/BTNtalentIcon41.blp]],
      art = [[card/talent/card41.blp]],
      back = nil,
      type = 1,
      quality = 2,
      tip = [[希望之花(天赋)]],
      uber = [[特效[唯一]
受到致死伤害时免疫本次伤害并无敌5秒，并缓慢恢复|cFFFF000020/25/30/35%|r生命值。(触发间隔60秒)
|cFF808080      --不要停下来啊！！！|r]],
      ability = nil,
      bind = nil,
    },
  },
  ability = {
  },
  card = {
  },
}
return _pack
