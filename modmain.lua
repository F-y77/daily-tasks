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
    ["制作1个长矛"] = "Craft 1 spear",
    ["制作1个火腿棒"] = "Craft 1 hambat",
    ["制作1个暗夜剑"] = "Craft 1 night sword",
    ["制作1个排箫"] = "Craft 1 pan flute",
    ["制作1个火魔杖"] = "Craft 1 fire staff",
    ["制作1个冰魔杖"] = "Craft 1 ice staff",
    ["制作1个铥矿棒"] = "Craft 1 thulecite club",
    ["制作1个唤星者魔杖"] = "Craft 1 star caller's staff",
    ["制作1个懒人魔杖"] = "Craft 1 lazy explorer",
    ["制作1个玻璃刀"] = "Craft 1 glass cutter",
    ["制作1个木甲"] = "Craft 1 wooden armor",
    ["制作1个暗夜甲"] = "Craft 1 night armor",
    ["制作1个大理石甲"] = "Craft 1 marble armor",
    ["制作1个绝望石盔甲"] = "Craft 1 thulecite armor",
    ["制作1个橄榄球头盔"] = "Craft 1 football helmet",
    ["制作1个养蜂帽"] = "Craft 1 beekeeper hat",
    ["制作1个背包"] = "Craft 1 backpack",
    ["制作1个雨伞"] = "Craft 1 umbrella",
    ["制作1个羽毛扇"] = "Craft 1 feather fan",
    ["制作1个花环"] = "Craft 1 flower crown",
    ["制作1个草帽"] = "Craft 1 straw hat",
    ["制作1个高礼帽"] = "Craft 1 top hat",
    ["制作1个冬帽"] = "Craft 1 winter hat",
    ["制作1个牛角帽"] = "Craft 1 beefalo hat",
    ["制作1个步行手杖"] = "Craft 1 walking cane",
    ["制作1个黄金斧头"] = "Craft 1 golden axe",
    ["制作1个黄金鹤嘴锄"] = "Craft 1 golden pickaxe",
    ["制作1个黄金铲子"] = "Craft 1 golden shovel",
    ["制作1个黄金园艺锄"] = "Craft 1 golden hoe",
    ["制作1个黄金干草叉"] = "Craft 1 golden pitchfork",
    
    -- 添加新的翻译
    ["今日统计："] = "Today's Statistics:",
    ["已采矿："] = "Rocks Mined:",
    ["已钓鱼："] = "Fish Caught:",
    ["已击杀："] = "Kills:",
    ["已击杀BOSS："] = "Boss Kills:",
    ["已制作："] = "Items Crafted:",
}

-- 添加翻译函数
DAILYTASKS.Translate = function(text)
    if DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return text
    end
    
    -- 直接翻译
    if DAILYTASKS.TRANSLATIONS[text] then
        return DAILYTASKS.TRANSLATIONS[text]
    end
    
    -- 模式匹配翻译
    for pattern, replacement in pairs(DAILYTASKS.TRANSLATIONS) do
        if string.find(pattern, "%%d%+") then
            local number = string.match(text, pattern)
            if number then
                return string.format(replacement, number)
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
                local task_name = type(task.name) == "function" and task.name() or DAILYTASKS.Translate(task.name)
                local desc = type(task.description) == "function" and task.description() or DAILYTASKS.Translate(task.description)
                local reward = type(task.reward_description) == "function" and task.reward_description() or DAILYTASKS.Translate(task.reward_description)
                local status = tasks.tasks_completed[i] and DAILYTASKS.Translate("已完成") or DAILYTASKS.Translate("未完成")
                
                msg = msg .. "#" .. i .. ": " .. task_name .. "\n"
                msg = msg .. desc .. "\n"
                msg = msg .. DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
                msg = msg .. DAILYTASKS.Translate("状态:") .. " " .. status .. "\n\n"
            end
        elseif tasks.current_task then
            local task_name = type(tasks.current_task.name) == "function" and tasks.current_task.name() or DAILYTASKS.Translate(tasks.current_task.name)
            local desc = type(tasks.current_task.description) == "function" and tasks.current_task.description() or DAILYTASKS.Translate(tasks.current_task.description)
            local reward = type(tasks.current_task.reward_description) == "function" and tasks.current_task.reward_description() or DAILYTASKS.Translate(tasks.current_task.reward_description)
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
    if DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return name
    end
    
    -- 直接使用已定义的翻译表
    return DAILYTASKS.TRANSLATIONS[name] or name
end

-- 添加一个函数来翻译任务描述
DAILYTASKS.TranslateTaskDescription = function(desc)
    if DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return desc
    end
    
    -- 首先尝试使用已有的翻译表
    for pattern, replacement in pairs(DAILYTASKS.TRANSLATIONS) do
        if string.find(pattern, "%%d%+") then
            local number = string.match(desc, pattern)
            if number then
                return string.format(replacement, number)
            end
        end
    end
    
    -- 如果没有匹配到，使用备用的模式匹配
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
    if DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return desc
    end
    
    -- 首先尝试使用已有的翻译表
    for pattern, replacement in pairs(DAILYTASKS.TRANSLATIONS) do
        if string.find(pattern, "%%d%+") and string.find(pattern, "个") then
            local number = string.match(desc, pattern)
            if number then
                return string.format(replacement, number)
            end
        end
    end
    
    -- 如果没有匹配到，使用备用的模式匹配
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

-- 修改按V键的处理函数，优化任务统计面板

GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_V, function()
    if GLOBAL.ThePlayer and GLOBAL.ThePlayer.components.dailytasks then
        local tasks = GLOBAL.ThePlayer.components.dailytasks
        local msg = DAILYTASKS.Translate("当前每日任务：") .. "\n\n"
        
        -- 显示任务信息
        if tasks.config.TASK_COUNT > 1 and #tasks.current_tasks > 0 then
            for i, task in ipairs(tasks.current_tasks) do
                local task_name = type(task.name) == "function" and task.name() or DAILYTASKS.Translate(task.name)
                local desc = type(task.description) == "function" and task.description() or DAILYTASKS.Translate(task.description)
                local reward = type(task.reward_description) == "function" and task.reward_description() or DAILYTASKS.Translate(task.reward_description)
                local status = tasks.tasks_completed[i] and DAILYTASKS.Translate("已完成") or DAILYTASKS.Translate("未完成")
                
                msg = msg .. "#" .. i .. ": " .. task_name .. "\n"
                msg = msg .. desc .. "\n"
                msg = msg .. DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
                msg = msg .. DAILYTASKS.Translate("状态:") .. " " .. status .. "\n\n"
            end
        elseif tasks.current_task then
            local task_name = type(tasks.current_task.name) == "function" and tasks.current_task.name() or DAILYTASKS.Translate(tasks.current_task.name)
            local desc = type(tasks.current_task.description) == "function" and tasks.current_task.description() or DAILYTASKS.Translate(tasks.current_task.description)
            local reward = type(tasks.current_task.reward_description) == "function" and tasks.current_task.reward_description() or DAILYTASKS.Translate(tasks.current_task.reward_description)
            local status = tasks.task_completed and DAILYTASKS.Translate("已完成") or DAILYTASKS.Translate("未完成")
            
            msg = msg .. task_name .. "\n"
            msg = msg .. desc .. "\n"
            msg = msg .. DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
            msg = msg .. DAILYTASKS.Translate("状态:") .. " " .. status
        else
            msg = msg .. DAILYTASKS.Translate("暂无任务")
        end
        
        -- 添加简化的统计信息
        msg = msg .. "\n\n" .. DAILYTASKS.Translate("今日统计：") .. "\n"
        
        -- 采矿统计
        msg = msg .. DAILYTASKS.Translate("已采矿：") .. " " .. (GLOBAL.ThePlayer.daily_rocks_mined or 0) .. "\n"
        
        -- 击杀统计
        local total_kills = 0
        local boss_kills = 0
        if GLOBAL.ThePlayer.daily_kills then
            for creature, count in pairs(GLOBAL.ThePlayer.daily_kills) do
                total_kills = total_kills + count
            end
        end
        msg = msg .. DAILYTASKS.Translate("已击杀：") .. " " .. total_kills .. "\n"
        
        -- BOSS击杀统计
        local boss_kills = 0
        if GLOBAL.ThePlayer.daily_kills then
            for creature, count in pairs(GLOBAL.ThePlayer.daily_kills) do
                -- 检查是否是BOSS
                if creature == "deerclops" or 
                   creature == "moose" or 
                   creature == "dragonfly" or 
                   creature == "bearger" or 
                   creature == "klaus" or 
                   creature == "antlion" or 
                   creature == "minotaur" or 
                   creature == "beequeen" or 
                   creature == "toadstool" or 
                   creature == "stalker" or 
                   creature == "stalker_atrium" then
                    boss_kills = boss_kills + count
                end
            end
        end
        msg = msg .. DAILYTASKS.Translate("已击杀BOSS：") .. " " .. boss_kills .. "\n"
        
        -- 显示消息
        if GLOBAL.ThePlayer.components.talker then
            GLOBAL.ThePlayer.components.talker:Say(msg)
        end
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

-- 修改快捷键绑定部分
local function BindKeys()
    if not TheInput then
        return
    end
    
    -- 检查是否禁用了查看任务快捷键
    if CHECK_TASK_KEY ~= "DISABLED" then
        TheInput:AddKeyDownHandler(_G[CHECK_TASK_KEY], function()
            if ThePlayer then
                -- 使用RPC方式，这样更可靠
                SendModRPCToServer(MOD_RPC["DailyTasks"]["CheckTasks"])
            end
        end)
    end
    
    -- 检查是否禁用了查看进度快捷键
    if CHECK_PROGRESS_KEY ~= "DISABLED" then
        TheInput:AddKeyDownHandler(_G[CHECK_PROGRESS_KEY], function()
            if ThePlayer then
                -- 使用RPC方式
                SendModRPCToServer(MOD_RPC["DailyTasks"]["CheckProgress"])
            end
        end)
    end
end

-- 在适当的地方调用BindKeys函数
AddSimPostInit(function()
    if TheInput then
        BindKeys()
    end
end) 