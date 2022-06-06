# luaUItest

框架开发未完成，目前可以跑起来，代码仅供参考。


使用方法：
	1 使用w3x2lni 将testmap文件夹转为testmap.w3x  右键使用ydwe测试
		或使用test1.bat test2.bat  (需要配置环境变量 w2l->w3x2Lni所在路径 ydweconfig->地图编辑所在路径)
	
	2 进入游戏后输入 -card 开启抽卡测试
	
依赖环境：
	编辑器dzyd v1.2.2 内置japi1.34 dzapi

代码结构：
	代码入口 scripts\luas\core\map.lua    call AbilityId("exec-lua:scripts.luas.core.map") 地图初始化时载入
	测试代码 scripts\luas\core\test.lua   map.lua调用test.lua
	
	scripts\config 放置一些配置文件
	
	scripts\luas\core\grap 界面系统
	testmap\map\MyFrameDef.fdf 界面ui配置  抽卡相关在577行  弹出技能物品提示框在20行
	
	scripts\luas\constants 枚举类
	scripts\luas\core\applic 环境上下文 存储全局变量
	
	scripts\luas\core\behavior 地图核心控制类
		Caption.lua  章节流程控制器
		Keys.lua     按键控制器
		Order.lua    指令系统
		Saves.lua    存档系统
		
	scripts\luas\core\entity  封装类
		Abilities 技能相关
		Damage    伤害相关
		Items     物品相关(卡牌也是物品)
		
	scripts\luas\core\gamer	玩家系统
	
	scripts\luas\core\scoket 同步系统
	
	scripts\luas\po 封装一些实体类 （模块对象数据结构）
	scripts\luas\utils 封装一些工具类
		Dialog.lua 封装对话框 注意不能异步使用
		Console.lua 封装控制台(游戏里面显示消息)
		Id.lua  256进制转换
		UUID.lua  基于时间戳的随机id (不会导致掉线)
		Bj.lua   封装bj函数 和ydwe常用函数
		Dzapi.lua 封装dzapi
		Interface.lua 用于方便调用界面系统的函数
		Japi.lua 封装常用japi函数
		ObjectUtils.lua  封装对table常用操作
		StringUtils.lua 封装对字符串常用操作
		TriggerUtils.lua  封装触发器
		CenterTimer.lua 中心计时器 触发间隔0.02秒
		TimerUtils.lua  封装timer常用操作 注意不能异步使用
		Camera.lua 镜头控制器
		
	

1 卡牌系统：
	绘制抽卡界面 scripts\luas\core\grap\Card.lua
	控制代码 scripts\luas\core\grap\CardControl.lua
	
	scripts\luas\core\applic\Context.lua  
	Content用于全局存储变量  Context.get("GamerLocal")获取本地玩家
	
	scripts\luas\utils\object\Interface.lua 是一个全局接口 用于保存grap下的组件公共方法
		例如 scripts\luas\core\grap\GUI.lua 代码1183行 在Interface中放入一个showTip方法(打开右侧技能说明)
		在 scripts\luas\core\grap\CardControl.lua 代码430行  抽卡模块调用
			
	scripts\luas\core\behavior\Order.lua 指令系统
	scripts\luas\core\test.lua 测试代码  234行 -card指令相关
	
	scripts\luas\core\entity\Items.lua
	物品封装类
	
	scripts\luas\core\scoket\Scoket.lua
	用于异步转同步 (dzapi的ui操作基本都是异步的 需要转同步)
		1 异步调用TimerStart RunableTriggger ForGroup ExecuteFunc 都会导致掉线(无法避免 网易对战平台可防止掉线)
		2 异步使用GetRandom获取随机数 (封装一个同步随机数模块 未实现)
		3 异步创建handle会导致掉线(所有handle初始化时创建 使用CenterTimer中心计时器避免创建timer 使用TriggerUtils触发封装类避免创建触发)
		4 异步添加删除技能、添加删除物品、操作单位物品导致掉线(使用Scoket同步)	
			
2 界面系统：
	scripts\luas\core\grap目录下 
	gui仿lol界面 backpack背包 bank银行 Inventory物品栏 shop商店  mouse鼠标贴图管理  store网易商城
	
	按b打开背包右键拿起左键放下
	物品栏可以和背包交互	
	按v打开银行   
	点击地图上的农民打开商店(需要英雄靠近)

3 封装类型：
	scripts\luas\utils目录下
	
	scripts\luas\utils\time\CenterTimer.lua 中心计时器
	scripts\luas\utils\object\Dzapi.lua  封装dzapi
		注册frame事件  dzapi.RegisterFrameEvent(frameId,function,function,function,function)
			依次为frameid、鼠标移入、鼠标移出、左键点击、右键点击
			
	scripts\luas\utils\object\TriggerUtils.lua  封装触发器
		TriggerUtils.registerEvent()注册触发器 封装了受伤害时间和被攻击事件
	


	
	

			
