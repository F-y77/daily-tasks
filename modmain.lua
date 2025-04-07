-- 首先定义全局变量
GLOBAL.DAILYTASKS = {}

GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})

-- 设置元表以简化全局变量访问
local env = env


-- 获取语言设置
local LANGUAGE = GetModConfigData("LANGUAGE") or "zh"

-- 获取配置选项
local TASK_COUNT = GetModConfigData("TASK_COUNT") or 3
local TASK_DIFFICULTY = GetModConfigData("TASK_DIFFICULTY") or "medium"
local REWARD_MULTIPLIER = GetModConfigData("REWARD_MULTIPLIER") or 1
local SHOW_NOTIFICATIONS = GetModConfigData("SHOW_NOTIFICATIONS") or true
local CHECK_TASK_KEY = GetModConfigData("CHECK_TASK_KEY") or "KEY_R"
local CHECK_PROGRESS_KEY = GetModConfigData("CHECK_PROGRESS_KEY") or "KEY_V"

-- 根据难度调整任务要求
local DIFFICULTY_MULTIPLIERS = {
    easy = 0.7,
    medium = 1.0,
    hard = 1.5
}

-- 将配置选项导出到全局变量
DAILYTASKS.CONFIG = {
    LANGUAGE = LANGUAGE,
    TASK_COUNT = TASK_COUNT,
    TASK_DIFFICULTY = TASK_DIFFICULTY,
    REWARD_MULTIPLIER = REWARD_MULTIPLIER,
    SHOW_NOTIFICATIONS = SHOW_NOTIFICATIONS,
    DIFFICULTY_MULTIPLIER = DIFFICULTY_MULTIPLIERS[TASK_DIFFICULTY] or 1.0,
    CHECK_TASK_KEY = CHECK_TASK_KEY,
    CHECK_PROGRESS_KEY = CHECK_PROGRESS_KEY
}

-- 定义英文翻译
DAILYTASKS.TRANSLATIONS = {
    -- 任务名称
    ["采集浆果任务"] = "Berry Gathering",
    ["采集胡萝卜任务"] = "Carrot Gathering",
    ["采集芦苇任务"] = "Reed Gathering",
    ["采集蘑菇任务"] = "Mushroom Gathering",
    ["狩猎兔子任务"] = "Rabbit Hunting",
    ["狩猎蜘蛛任务"] = "Spider Hunting",
    ["狩猎猪人任务"] = "Pigman Hunting",
    ["狩猎蜜蜂任务"] = "Bee Hunting",
    ["采矿任务"] = "Rock Mining",
    ["采金任务"] = "Gold Mining",
    ["采集大理石任务"] = "Marble Mining",
    ["钓鱼任务"] = "Fishing",
    ["钓大鱼任务"] = "Big Fish Fishing",
    ["生存任务"] = "Survival",
    ["保持健康任务"] = "Health Task",
    ["保持理智任务"] = "Sanity Task",
    ["保持饱腹任务"] = "Hunger Task",
    ["制作长矛任务"] = "Craft Spear",
    ["制作火腿棒任务"] = "Craft Hambat",
    ["制作暗夜剑任务"] = "Craft Night Sword",
    ["制作排箫任务"] = "Craft Pan Flute",
    ["制作火魔杖任务"] = "Craft Fire Staff",
    ["制作冰魔杖任务"] = "Craft Ice Staff",
    ["制作铥矿棒任务"] = "Craft Thulecite Club",
    ["制作唤星者魔杖任务"] = "Craft Star Caller's Staff",
    ["制作懒人魔杖任务"] = "Craft Lazy Explorer",
    ["制作玻璃刀任务"] = "Craft Glass Cutter",
    ["制作木甲任务"] = "Craft Wooden Armor",
    ["制作暗夜甲任务"] = "Craft Night Armor",
    ["制作大理石甲任务"] = "Craft Marble Armor",
    ["制作绝望石盔甲任务"] = "Craft Thulecite Armor",
    ["制作橄榄球头盔任务"] = "Craft Football Helmet",
    ["制作养蜂帽任务"] = "Craft Beekeeper Hat",
    ["制作背包任务"] = "Craft Backpack",
    ["制作雨伞任务"] = "Craft Umbrella",
    ["制作羽毛扇任务"] = "Craft Feather Fan",
    ["制作花环任务"] = "Craft Flower Crown",
    ["制作草帽任务"] = "Craft Straw Hat",
    ["制作高礼帽任务"] = "Craft Top Hat",
    ["制作冬帽任务"] = "Craft Winter Hat",
    ["制作牛角帽任务"] = "Craft Beefalo Hat",
    ["制作步行手杖任务"] = "Craft Walking Cane",
    ["制作黄金斧头任务"] = "Craft Golden Axe",
    ["制作黄金鹤嘴锄任务"] = "Craft Golden Pickaxe",
    ["制作黄金铲子任务"] = "Craft Golden Shovel",
    ["制作黄金园艺锄任务"] = "Craft Golden Hoe",
    ["制作黄金干草叉任务"] = "Craft Golden Pitchfork",
    
    -- UI文本
    ["当前每日任务："] = "Current Daily Tasks:",
    ["暂无任务"] = "No active tasks",
    ["已完成"] = "Completed",
    ["未完成"] = "In Progress",
    ["奖励:"] = "Reward:",
    ["状态:"] = "Status:",
    ["新的每日任务:"] = "New daily task:",
    ["任务完成！获得奖励:"] = "Task completed! Reward:",
    ["当前任务进度:"] = "Current Task Progress:",
    ["已采矿:"] = "Mining:",
    ["已采金:"] = "Gold Mining:",
    ["已开采大理石:"] = "Marble Mining:",
    ["已钓鱼:"] = "Fishing:",
    ["已钓大鱼:"] = "Big Fish Caught:",
    ["已击杀:"] = "Kills:",
    ["已击杀Boss:"] = "Boss Kills:",
    
    -- 任务描述模式
    ["采集(%d+)个浆果"] = "Collect %s berries",
    ["采集(%d+)个胡萝卜"] = "Collect %s carrots",
    ["采集(%d+)个芦苇"] = "Collect %s reeds",
    ["采集(%d+)个蘑菇"] = "Collect %s mushrooms",
    ["杀死(%d+)只兔子"] = "Kill %s rabbits",
    ["杀死(%d+)只蜘蛛"] = "Kill %s spiders",
    ["杀死(%d+)只猪人"] = "Kill %s pigmen",
    ["杀死(%d+)只蜜蜂"] = "Kill %s bees",
    ["采集(%d+)个岩石"] = "Mine %s rocks",
    ["采集(%d+)个金块"] = "Mine %s gold nuggets",
    ["采集(%d+)个大理石"] = "Mine %s marble",
    ["钓(%d+)条鱼"] = "Catch %s fish",
    ["钓(%d+)条大鱼"] = "Catch %s big fish",
    ["存活(%d+)天"] = "Survive for %s days",
    
    -- 奖励描述
    ["(%d+)个肉"] = "%s meat",
    ["(%d+)个莎草纸"] = "%s papyrus",
    ["(%d+)个蝴蝶松饼"] = "%s butterfly muffin",
    ["(%d+)个小肉"] = "%s morsels",
    ["(%d+)个蜘蛛腺体"] = "%s spider glands",
    ["制作1个长矛"] = "Craft 1 Spear",
    ["制作1个火腿棒"] = "Craft 1 Ham Bat",
    ["制作1个暗夜剑"] = "Craft 1 Night Sword",
    ["制作1个排箫"] = "Craft 1 Pan Flute",
    ["制作1个火魔杖"] = "Craft 1 Fire Staff",
    ["制作1个冰魔杖"] = "Craft 1 Ice Staff",
    ["制作1个铥矿棒"] = "Craft 1 Thulecite Club",
    ["制作1个唤星者魔杖"] = "Craft 1 Star Caller's Staff",
    ["制作1个懒人魔杖"] = "Craft 1 Lazy Explorer",
    ["制作1个玻璃刀"] = "Craft 1 Glass Cutter",
    ["制作1个木甲"] = "Craft 1 Log Suit",
    ["制作1个暗夜甲"] = "Craft 1 Night Armor",
    ["制作1个大理石甲"] = "Craft 1 Marble Suit",
    ["制作1个绝望石盔甲"] = "Craft 1 Thulecite Suit",
    ["制作1个橄榄球头盔"] = "Craft 1 Football Helmet",
    ["制作1个养蜂帽"] = "Craft 1 Beekeeper Hat",
    ["制作1个背包"] = "Craft 1 Backpack",
    ["制作1个雨伞"] = "Craft 1 Umbrella",
    ["制作1个羽毛扇"] = "Craft 1 Feather Fan",
    ["制作1个花环"] = "Craft 1 Flower Crown",
    ["制作1个草帽"] = "Craft 1 Straw Hat",
    ["制作1个高礼帽"] = "Craft 1 Top Hat",
    ["制作1个冬帽"] = "Craft 1 Winter Hat",
    ["制作1个牛角帽"] = "Craft 1 Beefalo Hat",
    ["制作1个步行手杖"] = "Craft 1 Walking Cane",
    ["制作1个黄金斧头"] = "Craft 1 Golden Axe",
    ["制作1个黄金鹤嘴锄"] = "Craft 1 Golden Pickaxe",
    ["制作1个黄金铲子"] = "Craft 1 Golden Shovel",
    ["制作1个黄金园艺锄"] = "Craft 1 Golden Hoe",
    ["制作1个黄金干草叉"] = "Craft 1 Golden Pitchfork",
    
    -- 添加新的翻译
    ["今日统计："] = "Today's Statistics:",
    ["已采矿："] = "Rocks Mined:",
    ["已钓鱼："] = "Fish Caught:",
    ["已击杀："] = "Kills:",
    ["已击杀BOSS："] = "Boss Kills:",
    ["已制作："] = "Items Crafted:",

    -- 采矿任务相关
    ["采集石头任务"] = "Rock Mining Task",
    ["采集金矿石任务（只包含主世界金矿石）"] = "Gold Mining Task (Overworld Only)",
    ["采集硝石任务"] = "Nitre Mining Task",
    ["采集燧石任务"] = "Flint Mining Task",
    ["采冰任务"] = "Ice Mining Task",
    ["挖掘%d个金矿石"] = "Mine %d gold nuggets",
    ["开采%d块大理石"] = "Mine %d marble",
    ["采集%d块石头"] = "Mine %d rocks",
    ["采集%d个硝石"] = "Mine %d nitre",
    ["采集%d个燧石"] = "Mine %d flint",
    ["采集%d块冰"] = "Mine %d ice",
    ["%d块石头"] = "%d rocks",
    ["%d个金块"] = "%d gold nuggets",
    ["%d个大理石"] = "%d marble pieces",
    ["%d个火药"] = "%d gunpowder",
    ["%d个镐子"] = "%d pickaxes",
    ["%d块冰"] = "%d ice",

    -- 钓鱼任务相关
    ["钓上%d条鱼"] = "Catch %d fish",
    ["钓%d条大鱼"] = "Catch %d big fish",
    ["%d个鱼肉"] = "%d fish meat",
    ["%d个大鱼肉"] = "%d big fish meat",

    -- 制作魔法物品任务

    ["%d个曼德拉草"] = "%d Mandrakes",
    ["%d个红宝石"] = "%d Red Gems",
    ["%d个蓝宝石"] = "%d Blue Gems",

    -- 制作装备任务

    ["%d个花瓣"] = "%d Petals",
    ["%d个割下的草"] = "%d Cut Grass",
    ["%d个蜘蛛丝"] = "%d Silk",
    ["%d只兔子"] = "%d Rabbits",
    ["%d个牛毛"] = "%d Beefalo Wool",
    ["%d个海象牙"] = "%d Walrus Tusks",

    -- 制作黄金工具任务


    -- 状态和进度提示
    ["任务完成: "] = "Task Completed: ",
    ["任务进度: "] = "Task Progress: ",

    -- 狩猎任务相关
    ["狩猎兔人任务"] = "Hunt Bunnyman Task",
    ["狩猎鱼人任务"] = "Hunt Merm Task",
    ["狩猎海象任务"] = "Hunt Walrus Task",
    ["狩猎发条骑士任务"] = "Hunt Clockwork Knight Task",
    ["狩猎火鸡任务"] = "Hunt Gobbler Task",
    ["狩猎鼹鼠任务"] = "Hunt Mole Task",
    ["狩猎皮弗娄牛任务"] = "Hunt Beefalo Task",
    ["狩猎蜘蛛战士任务"] = "Hunt Spider Warrior Task",
    ["狩猎猎犬任务"] = "Hunt Hound Task",
    ["狩猎蓝色猎犬任务"] = "Hunt Blue Hound Task",
    ["狩猎红色猎犬任务"] = "Hunt Red Hound Task",

    -- 特殊任务相关
    ["超级马里奥挑战"] = "Super Mario Challenge",
    ["Among Us 厨房危机"] = "Among Us Kitchen Crisis",
    ["社恐波奇酱"] = "Social Anxiety Challenge",
    ["恐怖游轮循环"] = "Horror Cruise Loop",
    ["咩咩羊启示录"] = "Sheep Apocalypse",
    ["工匠大师"] = "Master Craftsman",
    ["资源收集者"] = "Resource Collector",
    ["钓鱼大师"] = "Master Fisherman",
    ["家园设计师"] = "Home Designer",
    ["室内装饰师"] = "Interior Decorator",
    ["灯光设计师"] = "Lighting Designer",
    ["救援专家"] = "Rescue Expert",
    ["慷慨的厨师"] = "Generous Chef",
    ["建筑大师"] = "Master Builder",
    ["团队治疗师"] = "Team Healer",
    ["裸奔挑战"] = "Naked Runner Challenge",
    ["猪人派对"] = "Pigman Party",
    ["疯狂钓鱼佬"] = "Crazy Fisher",
    ["熊孩子"] = "Naughty Kid",
    ["无敌挑战者"] = "Invincible Challenger",
    ["疯狂科学家"] = "Mad Scientist",
    ["暗影征服者"] = "Shadow Conqueror",
    ["巨人杀手"] = "Giant Slayer",
    ["月光舞者"] = "Moonlight Dancer",

    -- 任务描述相关
    ["戴着红色蘑菇帽击杀蘑菇地精"] = "Kill a Mushgnome while wearing a Red Mushroom Hat",
    ["给队友喂食怪物千层饼"] = "Feed a teammate Monster Lasagna",
    ["保持独处4小时"] = "Stay alone for 4 hours",
    ["完成死亡复仇循环"] = "Complete the death revenge cycle",
    ["封你为神 - 拥有20个信徒"] = "Become a God - Have 20 followers",
    ["在一天内制作10件不同的物品"] = "Craft 10 different items in one day",
    ["在一天内收集50个基础资源"] = "Collect 50 basic resources in one day",
    ["在一天内钓上5条鱼"] = "Catch 5 fish in one day",
    ["在一天内收集5种不同的墙体材料"] = "Collect 5 different types of wall materials in one day",
    ["在一天内收集3种不同的家具物品"] = "Collect 3 different types of furniture in one day",
    ["在一天内收集3种不同的照明物品"] = "Collect 3 different types of lighting items in one day",
    ["在一天内复活1名队友"] = "Revive 1 teammate in one day",
    ["在一天内给其他玩家提供5次食物"] = "Provide food to other players 5 times in one day",
    ["在一天内建造3种不同的建筑物"] = "Build 3 different structures in one day",
    ["在一天内治疗队友总计100点生命值"] = "Heal teammates for a total of 100 health in one day",
    ["不穿任何装备跑步5分钟"] = "Run for 5 minutes without wearing any equipment",
    ["让5只猪人同时跟随你"] = "Have 5 pigmen following you at the same time",
    ["连续钓鱼5分钟不做其他事"] = "Fish continuously for 5 minutes without doing anything else",
    ["破坏5个蜘蛛网、兔子洞或蜜蜂窝"] = "Destroy 5 spider dens, rabbit holes, or beehives",
    ["在一天内不受到任何伤害"] = "Take no damage for an entire day",
    ["在一天内制作15种不同的科技物品"] = "Craft 15 different tech items in one day",
    ["在一天内击杀5个暗影生物"] = "Kill 5 shadow creatures in one day",
    ["在一天内单独击杀一个季节BOSS"] = "Solo kill a seasonal boss in one day",
    ["在满月夜晚不使用任何光源生存整晚"] = "Survive a full moon night without using any light source",

    -- 季节提示相关
    ["冬季出没"] = "Winter Only",
    ["夏季出没"] = "Summer Only",
    ["只能在冬季完成"] = "Can only be completed in winter",
    ["只能在夏季完成"] = "Can only be completed in summer",

    -- 奖励描述翻译
    ["%d个肉"] = "%d Meat",
    ["%d个莎草纸"] = "%d Papyrus",
    ["%d个蝴蝶松饼"] = "%d Butterfly Muffin",
    ["%d个小肉"] = "%d Morsels",
    ["%d个蜘蛛腺体"] = "%d Spider Glands",
    ["%d个蜂蜜"] = "%d Honey",
    ["%d个绳子"] = "%d Rope",
    ["%d个燧石"] = "%d Flint",
    ["%d个树枝"] = "%d Twigs",
    ["%d个木头"] = "%d Logs",

    -- 宝石和特殊材料
    ["%d个紫宝石"] = "%d Purple Gems",
    ["%d个黄宝石"] = "%d Yellow Gems",
    ["%d个橙宝石"] = "%d Orange Gems",
    ["%d个绿宝石"] = "%d Green Gems",
    ["%d个噩梦燃料"] = "%d Nightmare Fuel",
    ["%d个月亮碎片"] = "%d Moon Shards",
    ["%d个铥矿"] = "%d Thulecite",
    ["%d个铥矿碎片"] = "%d Thulecite Fragments",
    ["%d个虚空布料"] = "%d Void Cloth",

    -- 食物奖励

    ["%d个熟鱼肉"] = "%d Cooked Fish",
    ["%d个熟蛙腿"] = "%d Cooked Frog Legs",
    ["%d条鱼"] = "%d Fish",
    ["%d个鸡腿"] = "%d Drumsticks",
    ["%d个蜂巢"] = "%d Honeycomb",


    -- 装备和工具奖励
    ["1个生命注射器"] = "1 Life Giving Amulet",
    ["2个噩梦燃料"] = "2 Nightmare Fuel",
    ["1个培根煎蛋"] = "1 Bacon and Eggs",
    ["1个蝴蝶翅膀"] = "1 Butterfly Wings",
    ["1个太妃糖"] = "1 Taffy",
    ["1个冰淇淋"] = "1 Ice Cream",
    ["1个海鲜牛排"] = "1 Surf'n'Turf",
    ["1顶贝雷帽和%d个吹箭"] = "1 Tam o' Shanter and %d Blow Darts",
    ["%d个齿轮"] = "%d Gears",
    ["1个触手皮"] = "1 Tentacle Spots",
    ["%d个犬牙"] = "%d Hound's Teeth",

    -- 复杂奖励描述
    ["2个金块、1个木板、1个石砖"] = "2 Gold Nuggets, 1 Board, 1 Cut Stone",
    ["1个背包，以及5分钟的采集速度提升(+50%)"] = "1 Backpack and 5 minutes of gathering speed boost (+50%)",
    ["3个鱼肉，以及8分钟的钓鱼效率提升(+100%)"] = "3 Fish Meat and 8 minutes of fishing efficiency boost (+100%)",
    ["5个石墙，以及6分钟的建造速度提升(+100%)"] = "5 Stone Walls and 6 minutes of building speed boost (+100%)",
    ["1个盆栽蕨类、1个木牌，以及8分钟的负面精神光环减少(50%)"] = "1 Potted Fern, 1 Sign and 8 minutes of negative sanity aura reduction (50%)",
    ["1个提灯，以及6分钟的夜视能力"] = "1 Lantern and 6 minutes of night vision",
    ["1个生命护符，以及8分钟的生命上限提升(+25%)"] = "1 Life Amulet and 8 minutes of max health boost (+25%)",
    ["1本食谱、1块黄油，以及8分钟的烹饪时间减少(50%)"] = "1 Cookbook, 1 Butter and 8 minutes of cooking time reduction (50%)",
    ["2个木板、2个石砖，以及6分钟的建造速度提升(+100%)"] = "2 Boards, 2 Cut Stone and 6 minutes of building speed boost (+100%)",
    ["2个治疗药膏、1个生命注射器，以及8分钟的治疗效果提升(+20点)"] = "2 Healing Salve, 1 Life Injector and 8 minutes of healing boost (+20)",
    ["1个木甲、1个橄榄球头盔、1个背包"] = "1 Log Suit, 1 Football Helmet, 1 Backpack",
    ["5个猪皮、3个肉"] = "5 Pigskin, 3 Meat",
    ["1个钓鱼竿、10个鱼肉"] = "1 Fishing Rod, 10 Fish Meat",
    ["1个橄榄球头盔、5个糖果"] = "1 Football Helmet, 5 Candy",
    ["唤星者魔杖、大理石甲，以及5分钟的75%伤害减免"] = "Star Caller's Staff, Marble Suit and 5 minutes of 75% damage reduction",
    ["3个齿轮、1个紫宝石、1个橙宝石，以及8分钟的材料消耗减少50%"] = "3 Gears, 1 Purple Gem, 1 Orange Gem and 8 minutes of material cost reduction (50%)",
    ["1把暗夜剑、5个噩梦燃料，以及8分钟的理智恢复提升"] = "1 Night Sword, 5 Nightmare Fuel and 8 minutes of sanity regeneration boost",
    ["远古头盔、远古棒，以及10分钟的双倍伤害"] = "Ancient Helmet, Thulecite Club and 10 minutes of double damage",
    ["1个月岩雕像、3个月岩"] = "1 Moon Rock Idol, 3 Moon Rock",

    -- 补充任务描述翻译

    ["制作2个电子元件"] = "Craft 2 Electrical Components",
    ["制作3个铥矿墙"] = "Craft 3 Thulecite Walls",
    ["制作1个铥矿徽章"] = "Craft 1 Thulecite Medallion",
    ["制作1个铥矿皇冠"] = "Craft 1 Thulecite Crown",

    -- 补充特殊任务描述翻译
    ["在一天内收集10种不同的材料"] = "Collect 10 different materials in one day",
    ["在一天内制作5种不同的工具"] = "Craft 5 different tools in one day",
    ["在一天内建造3个不同的建筑"] = "Build 3 different structures in one day",
    ["在一天内钓上10条鱼"] = "Catch 10 fish in one day",
    ["在一天内采集20个基础资源"] = "Collect 20 basic resources in one day",
    ["在一天内击杀15个敌人"] = "Kill 15 enemies in one day",
    ["在一天内恢复200点生命值"] = "Restore 200 health in one day",
    ["在一天内恢复100点理智值"] = "Restore 100 sanity in one day",
    ["在一天内食用10个不同的食物"] = "Eat 10 different foods in one day",

    -- 补充漏掉的奖励描述翻译
    ["获得一个随机宝石"] = "Get a random gem",
    ["获得一个随机装备"] = "Get a random equipment",
    ["获得一个随机工具"] = "Get a random tool",
    ["获得一个随机食物"] = "Get a random food",
    ["获得一个随机材料"] = "Get a random material",
    ["获得一个随机魔法物品"] = "Get a random magical item",
    ["获得一个随机帽子"] = "Get a random hat",
    ["获得一个随机武器"] = "Get a random weapon",
    ["获得一个随机护甲"] = "Get a random armor",
    ["获得一个随机背包"] = "Get a random backpack",
    ["获得一个随机装饰品"] = "Get a random decoration",
    ["获得一个随机建筑材料"] = "Get a random building material",
    ["获得一个随机科技物品"] = "Get a random tech item",
    ["获得一个随机季节物品"] = "Get a random seasonal item",
    ["获得一个随机Boss掉落物"] = "Get a random boss drop",
    
    -- 补充复杂奖励描述翻译
    ["2个铥矿和3个噩梦燃料"] = "2 Thulecite and 3 Nightmare Fuel",
    ["1个生命护符和2个红宝石"] = "1 Life Amulet and 2 Red Gems",
    ["3个齿轮和2个电子元件"] = "3 Gears and 2 Electrical Components",
    ["1个铥矿皇冠和4个噩梦燃料"] = "1 Thulecite Crown and 4 Nightmare Fuel",
    ["2个紫宝石和2个橙宝石"] = "2 Purple Gems and 2 Orange Gems",
    ["1个暗影操纵者和3个噩梦燃料"] = "1 Shadow Manipulator and 3 Nightmare Fuel",
    ["1个铥矿套装和5个噩梦燃料"] = "1 Thulecite Suit and 5 Nightmare Fuel",
    ["获得8分钟的力量提升"] = "Get 8 minutes of strength boost",
    ["获得10分钟的速度提升"] = "Get 10 minutes of speed boost",
    ["获得12分钟的生命恢复提升"] = "Get 12 minutes of health regeneration boost",
    ["获得15分钟的理智恢复提升"] = "Get 15 minutes of sanity regeneration boost",
    ["获得20分钟的饥饿值降低减缓"] = "Get 20 minutes of hunger rate reduction",
    ["获得5分钟的全属性提升"] = "Get 5 minutes of all stats boost",
    
    -- 补充状态和进度相关翻译
    ["任务进度"] = "Task Progress",
    ["任务完成度"] = "Task Completion",
    ["剩余时间"] = "Time Remaining",
    ["当前状态"] = "Current Status",
    ["任务要求"] = "Task Requirements",
    ["任务奖励"] = "Task Rewards",
    ["任务难度"] = "Task Difficulty",
    ["任务类型"] = "Task Type",
    ["任务描述"] = "Task Description",

    -- 补充漏掉的任务描述翻译
    ["制作2个蜘蛛帽"] = "Craft 2 Spider Hats",
    ["制作3个蜘蛛巢"] = "Craft 3 Spider Dens",
    ["制作2个蜂箱"] = "Craft 2 Bee Boxes",
    ["制作2个鸟笼"] = "Craft 2 Bird Cages",
    ["制作1个暗影操纵者"] = "Craft 1 Shadow Manipulator",
    ["制作1个月石"] = "Craft 1 Moon Rock",
    ["制作2个蘑菇农场"] = "Craft 2 Mushroom Planters",
    ["制作1个避雷针"] = "Craft 1 Lightning Rod",
    ["制作1个温度计"] = "Craft 1 Thermal Measurer",
    ["制作1个雨量计"] = "Craft 1 Rain Meter",
    ["制作1个晾肉架"] = "Craft 1 Drying Rack",
    ["制作1个烹饪锅"] = "Craft 1 Crock Pot",
    ["制作1个科学机器"] = "Craft 1 Science Machine",
    ["制作1个炼金引擎"] = "Craft 1 Alchemy Engine",
    ["制作1个影子基地"] = "Craft 1 Shadow Base",

    -- 补充漏掉的奖励描述翻译
    ["1个蜘蛛帽和2个蜘蛛腺体"] = "1 Spider Hat and 2 Spider Glands",
    ["2个蜘蛛巢和3个蜘蛛丝"] = "2 Spider Dens and 3 Silk",
    ["1个蜂箱和3个蜂蜜"] = "1 Bee Box and 3 Honey",
    ["1个鸟笼和2个鸟肉"] = "1 Bird Cage and 2 Morsels",
    ["2个噩梦燃料和1个紫宝石"] = "2 Nightmare Fuel and 1 Purple Gem",
    ["1个月岩和2个月亮碎片"] = "1 Moon Rock and 2 Moon Shards",
    ["2个蘑菇农场和3个蘑菇"] = "2 Mushroom Planters and 3 Mushrooms",
    ["1个避雷针和2个电子元件"] = "1 Lightning Rod and 2 Electrical Components",
    ["1个温度计和2个金块"] = "1 Thermal Measurer and 2 Gold Nuggets",
    ["1个雨量计和2个金块"] = "1 Rain Meter and 2 Gold Nuggets",
    ["1个晾肉架和3个肉干"] = "1 Drying Rack and 3 Jerky",
    ["1个烹饪锅和2个肉丸"] = "1 Crock Pot and 2 Meatballs",
    ["1个科学机器和3个齿轮"] = "1 Science Machine and 3 Gears",
    ["1个炼金引擎和4个齿轮"] = "1 Alchemy Engine and 4 Gears",
    ["1个影子基地和3个噩梦燃料"] = "1 Shadow Base and 3 Nightmare Fuel",

    -- 补充漏掉的状态描述翻译
    ["保持健康状态一整天"] = "Maintain full health for a whole day",
    ["保持理智状态一整天"] = "Maintain full sanity for a whole day",
    ["保持饱腹状态一整天"] = "Maintain full hunger for a whole day",
    ["在一天内恢复超过100点生命值"] = "Restore over 100 health in one day",
    ["在一天内恢复超过200点理智值"] = "Restore over 200 sanity in one day",
    ["在一天内恢复超过300点饥饿值"] = "Restore over 300 hunger in one day",

    -- 补充漏掉的进度描述翻译
    ["已恢复生命值："] = "Health Restored: ",
    ["已恢复理智值："] = "Sanity Restored: ",
    ["已恢复饥饿值："] = "Hunger Restored: ",
    ["已制作物品："] = "Items Crafted: ",
    ["已建造建筑："] = "Structures Built: ",
    ["已收集资源："] = "Resources Collected: ",
    ["已发现区域："] = "Areas Discovered: ",
    ["已挖掘宝藏："] = "Treasures Dug: ",
    ["已钓上鱼："] = "Fish Caught: ",
    ["已击杀敌人："] = "Enemies Killed: ",
    ["已击杀Boss："] = "Bosses Killed: ",

    -- 补充漏掉的特殊任务描述翻译
    ["在满月之夜制作月石"] = "Craft Moon Rock during a full moon",
    ["在暴风雨中建造避雷针"] = "Build Lightning Rod during a thunderstorm",
    ["在冬天制作暖石"] = "Craft Thermal Stone in winter",
    ["在夏天制作冰"] = "Make Ice in summer",
    ["在春天种植花朵"] = "Plant flowers in spring",
    ["在秋天收获浆果"] = "Harvest berries in autumn",

    -- 任务描述翻译
    ["制作%d个%s"] = "Craft %d %s",
    ["采集%d个%s"] = "Collect %d %s",
    ["杀死%d只%s"] = "Kill %d %s",
    ["钓上%d条%s"] = "Catch %d %s",
    ["开采%d块%s"] = "Mine %d %s",
    ["存活%d天"] = "Survive for %d days",
    ["在一天内恢复%d点生命值"] = "Restore %d health in one day",
    ["在一天内恢复%d点理智值"] = "Restore %d sanity in one day",
    ["在一天内恢复%d点饥饿值"] = "Restore %d hunger in one day",

    -- 物品名称翻译
    ["浆果"] = "berries",
    ["胡萝卜"] = "carrots",
    ["芦苇"] = "reeds",
    ["蘑菇"] = "mushrooms",
    ["兔子"] = "rabbits",
    ["蜘蛛"] = "spiders",
    ["猪人"] = "pigmen",
    ["蜜蜂"] = "bees",
    ["石头"] = "rocks",
    ["金矿石"] = "gold nuggets",
    ["大理石"] = "marble",
    ["鱼"] = "fish",
    ["大鱼"] = "big fish",
    ["青蛙"] = "frogs",
    ["浣熊"] = "raccoons",
    ["高脚鸟"] = "tallbirds",
    ["触手"] = "tentacles",
    ["硝石"] = "nitre",
    ["燧石"] = "flint",
    ["冰"] = "ice",
    ["花朵"] = "flowers",
    ["蜂蜜"] = "honey",
    ["树枝"] = "twigs",
    ["蜘蛛战士"] = "spider warriors",
    ["猎犬"] = "hounds",
    ["蓝色猎犬"] = "blue hounds",
    ["红色猎犬"] = "red hounds",

    -- 制作任务描述翻译

    ["制作1个月光玻璃斧"] = "Craft 1 Moon Glass Axe",
    ["制作1个月亮蘑菇帽"] = "Craft 1 Moon Cap Hat",
    ["制作3个绳子"] = "Craft 3 Ropes",
    ["制作3个木板"] = "Craft 3 Wooden Planks",
    ["制作3个石砖"] = "Craft 3 Stone Bricks",
    ["制作3个莎草纸"] = "Craft 3 Papyrus",
    ["制作2个蜂蜡"] = "Craft 2 Beeswax",
    ["制作3个大理石豌豆"] = "Craft 3 Marble Beans",
    ["制作1个熊皮"] = "Craft 1 Bearger Fur",
    ["制作5个噩梦燃料"] = "Craft 5 Nightmare Fuel",
    ["制作1个紫宝石"] = "Craft 1 Purple Gem",

    -- 特殊任务描述翻译

}

-- 修改翻译函数以支持更复杂的模式匹配
DAILYTASKS.Translate = function(text)
    -- 只有当语言设置为英文时才翻译
    if DAILYTASKS.CONFIG.LANGUAGE ~= "en" then
        return text
    end
    
    -- 直接翻译
    if DAILYTASKS.TRANSLATIONS[text] then
        return DAILYTASKS.TRANSLATIONS[text]
    end
    
    -- 处理带数字的文本
    for pattern, replacement in pairs(DAILYTASKS.TRANSLATIONS) do
        if string.find(pattern, "%%d") then
            local number = string.match(text, "%d+")
            if number then
                local test_text = string.gsub(text, number, "%%d")
                if test_text == pattern then
                    return string.format(replacement, number)
                end
            end
        end
    end
    
    return text
end

-- 杀死生物处理函数
local function OnKilled(inst, data)
    if not inst.daily_kills then
        inst.daily_kills = {}
    end
    
    local victim = data.victim
    if victim and victim.prefab then
        if not inst.daily_kills[victim.prefab] then
            inst.daily_kills[victim.prefab] = 0
        end
        inst.daily_kills[victim.prefab] = inst.daily_kills[victim.prefab] + 1
        print("已击杀 " .. victim.prefab .. ": " .. inst.daily_kills[victim.prefab])
        
        -- 检查是否是boss
        if victim:HasTag("epic") or 
           victim.prefab == "deerclops" or 
           victim.prefab == "moose" or 
           victim.prefab == "dragonfly" or 
           victim.prefab == "bearger" or 
           victim.prefab == "klaus" or 
           victim.prefab == "antlion" or 
           victim.prefab == "minotaur" or 
           victim.prefab == "beequeen" or 
           victim.prefab == "toadstool" or 
           victim.prefab == "stalker" or 
           victim.prefab == "stalker_atrium" then
            
            if not inst.daily_bosses_killed then
                inst.daily_bosses_killed = {}
            end
            
            if not inst.daily_bosses_killed[victim.prefab] then
                inst.daily_bosses_killed[victim.prefab] = 0
            end
            
            inst.daily_bosses_killed[victim.prefab] = inst.daily_bosses_killed[victim.prefab] + 1
            print("已击杀Boss " .. victim.prefab .. ": " .. inst.daily_bosses_killed[victim.prefab])
        end
    end
end

local function OnPlayerSpawn(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    
    -- 添加每日任务组件
    if not inst.components.dailytasks then
        inst:AddComponent("dailytasks")
    end
    
    -- 初始化统计数据（移除所有烹饪相关的初始化）
    inst.daily_kills = {}
    inst.daily_rocks_mined = 0
    inst.daily_fish_caught = 0
    inst.daily_gold_mined = 0
    inst.daily_marble_mined = 0
    inst.daily_big_fish_caught = 0
    inst.daily_items_collected = {}
    inst.daily_items_planted = 0
    inst.daily_distance_walked = 0          
    inst.daily_structures_built = {}
    inst.daily_items_crafted = {}
    inst.daily_bosses_killed = {}
    inst.daily_health_restored = 0
    inst.daily_sanity_restored = 0
    inst.daily_hunger_restored = 0
    inst.daily_ocean_fish_caught = 0
    inst.daily_treasures_dug = 0
    inst.daily_areas_discovered = 0
    inst.daily_tools_crafted = 0
    
    -- 监听杀死生物事件
    inst:ListenForEvent("killed", OnKilled)
    
    -- 监听采矿事件
    inst:ListenForEvent("working", function(inst, data)
        if data and data.target and data.target:HasTag("boulder") then
            inst.daily_rocks_mined = (inst.daily_rocks_mined or 0) + 1
            print("已采矿: " .. inst.daily_rocks_mined)
            
            -- 检查是否是金矿
            if data.target.prefab == "rock1" or data.target.prefab == "rock2" then
                inst.daily_gold_mined = (inst.daily_gold_mined or 0) + 1
                print("已采金: " .. inst.daily_gold_mined)
            end
            
            -- 检查是否是大理石
            if data.target.prefab == "rock_ice" or data.target.prefab == "rock_moon" then
                inst.daily_marble_mined = (inst.daily_marble_mined or 0) + 1
                print("已采集大理石: " .. inst.daily_marble_mined)
            end
        end
    end)
    
    -- 监听采集事件
    inst:ListenForEvent("picksomething", function(inst, data)
        if data and data.object and data.object.prefab then
            if not inst.daily_items_collected then
                inst.daily_items_collected = {}
            end
            
            if not inst.daily_items_collected[data.object.prefab] then
                inst.daily_items_collected[data.object.prefab] = 0
            end
            
            inst.daily_items_collected[data.object.prefab] = inst.daily_items_collected[data.object.prefab] + 1
            print("已采集 " .. data.object.prefab .. ": " .. inst.daily_items_collected[data.object.prefab])
        end
    end)
end

-- 当玩家生成时添加组件
AddPlayerPostInit(OnPlayerSpawn)

-- 修改RPC处理函数
AddModRPCHandler("DailyTasks", "CheckTasks", function(player)
    if player and player.components.dailytasks then
        local tasks = player.components.dailytasks
        
        local msg = DAILYTASKS.Translate("当前每日任务：") .. "\n"
        
        if tasks.config.TASK_COUNT > 1 and #tasks.current_tasks > 0 then
            for i, task in ipairs(tasks.current_tasks) do
                local task_name = type(task.name) == "function" and task.name() or task.name
                local desc = type(task.description) == "function" and task.description() or task.description
                local reward = type(task.reward_description) == "function" and task.reward_description() or task.reward_description
                local status = tasks.tasks_completed[i] and DAILYTASKS.Translate("已完成") or DAILYTASKS.Translate("未完成")
                
                msg = msg .. "#" .. i .. ": " .. task_name .. "\n"
                msg = msg .. desc .. "\n"
                msg = msg .. DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
                msg = msg .. DAILYTASKS.Translate("状态:") .. " " .. status .. "\n\n"
            end
        elseif tasks.current_task then
            local task_name = type(tasks.current_task.name) == "function" and tasks.current_task.name() or tasks.current_task.name
            local desc = type(tasks.current_task.description) == "function" and tasks.current_task.description() or tasks.current_task.description
            local reward = type(tasks.current_task.reward_description) == "function" and tasks.current_task.reward_description() or tasks.current_task.reward_description
            local status = tasks.task_completed and DAILYTASKS.Translate("已完成") or DAILYTASKS.Translate("未完成")
            
            msg = msg .. task_name .. "\n"
            msg = msg .. desc .. "\n"
            msg = msg .. DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
            msg = msg .. DAILYTASKS.Translate("状态:") .. " " .. status
        else
            msg = msg .. DAILYTASKS.Translate("暂无任务")
        end
        
        if player.components.talker then
            player.components.talker:Say(msg)
        end
    end
end)

AddModRPCHandler("DailyTasks", "CheckProgress", function(player)
    if player then
        local msg = DAILYTASKS.Translate("当前任务进度:") .. "\n"
        
        -- 采矿统计
        if player.daily_rocks_mined then
            msg = msg .. DAILYTASKS.Translate("已采矿:") .. " " .. player.daily_rocks_mined .. "\n"
        end
        
        -- 击杀统计
        if player.daily_kills then
            msg = msg .. DAILYTASKS.Translate("已击杀:") .. "\n"
            for k, v in pairs(player.daily_kills) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        -- BOSS击杀统计
        if player.daily_bosses_killed then
            msg = msg .. DAILYTASKS.Translate("已击杀Boss:") .. "\n"
            for k, v in pairs(player.daily_bosses_killed) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.components.talker then
            player.components.talker:Say(msg)
        end
    end
end)

-- 修改全局任务列表函数，移除所有烹饪相关任务
DAILYTASKS.GetTaskList = function()
    return {
        "采集浆果任务",
        "采集胡萝卜任务",
        "采集芦苇任务",
        "采集蘑菇任务",
        "狩猎兔子任务",
        "狩猎蜘蛛任务",
        "狩猎猪人任务",
        "狩猎蜜蜂任务",
        "采矿任务",
        "采金任务",
        "采集大理石任务",
        "钓鱼任务",
        "生存任务",
        "保持健康任务",
        "保持理智任务",
        "保持饱腹任务",
        "制作长矛任务",
        "制作火腿棒任务",
        "制作暗夜剑任务",
        "制作排箫任务",
        "制作火魔杖任务",
        "制作冰魔杖任务",
        "制作铥矿棒任务",
        "制作唤星者魔杖任务",
        "制作懒人魔杖任务",
        "制作玻璃刀任务",
        "制作木甲任务",
        "制作暗夜甲任务",
        "制作大理石甲任务",
        "制作绝望石盔甲任务",
        "制作橄榄球头盔任务",
        "制作养蜂帽任务",
        "制作背包任务",
        "制作雨伞任务",
        "制作羽毛扇任务",
        "制作花环任务",
        "制作草帽任务",
        "制作高礼帽任务",
        "制作冬帽任务",
        "制作牛角帽任务",
        "制作步行手杖任务",
        "制作黄金斧头任务",
        "制作黄金鹤嘴锄任务",
        "制作黄金铲子任务",
        "制作黄金园艺锄任务",
        "制作黄金干草叉任务"
    }
end

-- 在modmain.lua中添加一个函数来翻译任务名称和描述
DAILYTASKS.TranslateTaskName = function(name)
    -- 只有当语言设置为英文时才翻译
    if DAILYTASKS.CONFIG.LANGUAGE ~= "en" then
        return name
    end
    
    -- 直接使用已定义的翻译表
    return DAILYTASKS.TRANSLATIONS[name] or name
end

-- 添加一个函数来翻译任务描述
DAILYTASKS.TranslateTaskDescription = function(desc)
    -- 只有当语言设置为英文时才翻译
    if DAILYTASKS.CONFIG.LANGUAGE ~= "en" then
        return desc
    end
    
    -- 首先尝试直接翻译
    if DAILYTASKS.TRANSLATIONS[desc] then
        return DAILYTASKS.TRANSLATIONS[desc]
    end
    
    -- 尝试使用模式匹配翻译
    for pattern, replacement in pairs(DAILYTASKS.TRANSLATIONS) do
        if string.find(pattern, "%%d") then
            local number = string.match(desc, "%d+")
            if number then
                local test_text = string.gsub(desc, number, "%%d")
                if test_text == pattern then
                    return string.format(replacement, number)
                end
            end
        end
    end
    
    -- 使用备用的模式匹配方法
    local count = desc:match("(%d+)")
    
    if desc:find("采集") and desc:find("浆果") then
        return "Collect " .. count .. " berries"
    elseif desc:find("采集") and desc:find("胡萝卜") then
        return "Collect " .. count .. " carrots"
    elseif desc:find("采集") and desc:find("芦苇") then
        return "Collect " .. count .. " reeds"
    elseif desc:find("采集") and desc:find("蘑菇") then
        return "Collect " .. count .. " mushrooms"
    elseif desc:find("杀死") and desc:find("兔子") then
        return "Kill " .. count .. " rabbits"
    -- 添加更多模式匹配...
    end
    
    return desc
end

-- 添加一个函数来翻译奖励描述
DAILYTASKS.TranslateRewardDescription = function(desc)
    -- 只有当语言设置为英文时才翻译
    if DAILYTASKS.CONFIG.LANGUAGE ~= "en" then
        return desc
    end
    
    -- 首先尝试直接翻译
    if DAILYTASKS.TRANSLATIONS[desc] then
        return DAILYTASKS.TRANSLATIONS[desc]
    end
    
    -- 尝试使用模式匹配翻译
    for pattern, replacement in pairs(DAILYTASKS.TRANSLATIONS) do
        if string.find(pattern, "%%d") then
            local number = string.match(desc, "%d+")
            if number then
                local test_text = string.gsub(desc, number, "%%d")
                if test_text == pattern then
                    return string.format(replacement, number)
                end
            end
        end
    end
    
    -- 使用备用的模式匹配方法
    local count = desc:match("(%d+)")
    
    if desc:find("肉") then
        return count .. " meat"
    elseif desc:find("莎草纸") then
        return count .. " papyrus"
    elseif desc:find("蝴蝶松饼") then
        return count .. " butterfly muffin"
    elseif desc:find("小肉") then
        return count .. " morsels"
    elseif desc:find("蜘蛛腺体") then
        return count .. " spider glands"
    -- 添加更多模式匹配...
    end
    
    return desc
end

-- 修改快捷键绑定部分
local function BindKeys()
    if not TheInput then
        return
    end
    
    -- 绑定查看任务快捷键
    TheInput:AddKeyDownHandler(_G[CHECK_TASK_KEY], function()
        if ThePlayer then
            SendModRPCToServer(MOD_RPC["DailyTasks"]["CheckTasks"])
        end
    end)
    
    -- 绑定查看进度快捷键
    TheInput:AddKeyDownHandler(_G[CHECK_PROGRESS_KEY], function()
        if ThePlayer then
            SendModRPCToServer(MOD_RPC["DailyTasks"]["CheckProgress"])
        end
    end)
end

-- 在适当的地方调用BindKeys函数
AddSimPostInit(function()
    if TheInput then
        BindKeys()
    end
end)

-- 注册新食物类型（用于Among Us任务）
AddPrefabPostInit("monstertartare", function(inst)
    if inst.components and inst.components.edible then
        local old_oneatenfn = inst.components.edible.oneatenfn
        inst.components.edible:SetOnEatenFn(function(inst, eater)
            -- 调用原始函数
            if old_oneatenfn then
                old_oneatenfn(inst, eater)
            end
            
            -- 触发全局事件
            if inst.components.inventoryitem and inst.components.inventoryitem.owner then
                local feeder = inst.components.inventoryitem.owner
                if feeder and feeder:HasTag("player") and eater and eater:HasTag("player") then
                    feeder:PushEvent("feedplayer", {food = inst, target = eater})
                end
            end
        end)
    end
end)

-- 添加红色蘑菇帽
AddPrefabPostInit("red_mushroomhat", function(inst)
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
end)

-- 初始化特殊任务状态
AddPlayerPostInit(function(inst)
    inst:ListenForEvent("newstate", function(inst, data)
        if data and data.state == "taskreset" then
            inst.curse_cycle_completed = nil
            inst.social_anxiety_days = nil
            inst.among_us_kills = nil
        end
    end)
end) 