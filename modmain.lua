-- 首先定义全局变量
GLOBAL.DAILYTASKS = {}

-- 获取语言设置
local LANGUAGE = GetModConfigData("LANGUAGE") or "zh"

-- 获取配置选项
local TASK_COUNT = GetModConfigData("TASK_COUNT") or 3
local TASK_DIFFICULTY = GetModConfigData("TASK_DIFFICULTY") or "medium"
local REWARD_MULTIPLIER = GetModConfigData("REWARD_MULTIPLIER") or 1
local SHOW_NOTIFICATIONS = GetModConfigData("SHOW_NOTIFICATIONS") or true
local CHECK_TASK_KEY = GetModConfigData("CHECK_TASK_KEY") or "KEY_T"
local CHECK_PROGRESS_KEY = GetModConfigData("CHECK_PROGRESS_KEY") or "KEY_Y"

-- 获取开发者模式配置
local DEVELOPER_MODE = GetModConfigData("DEVELOPER_MODE") or false

-- 根据难度调整任务要求
local DIFFICULTY_MULTIPLIERS = {
    easy = 0.7,
    medium = 1.0,
    hard = 1.5
}

-- 将配置选项导出到全局变量
GLOBAL.DAILYTASKS.CONFIG = {
    LANGUAGE = LANGUAGE,
    TASK_COUNT = TASK_COUNT,
    TASK_DIFFICULTY = TASK_DIFFICULTY,
    REWARD_MULTIPLIER = REWARD_MULTIPLIER,
    SHOW_NOTIFICATIONS = SHOW_NOTIFICATIONS,
    DIFFICULTY_MULTIPLIER = DIFFICULTY_MULTIPLIERS[TASK_DIFFICULTY] or 1.0,
    CHECK_TASK_KEY = CHECK_TASK_KEY,
    CHECK_PROGRESS_KEY = CHECK_PROGRESS_KEY,
    DEVELOPER_MODE = DEVELOPER_MODE
}

-- 定义英文翻译
GLOBAL.DAILYTASKS.TRANSLATIONS = {
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
    ["制作1个玻璃刀"] = "Craft 1 glass cutter"
}

-- 添加翻译函数
GLOBAL.DAILYTASKS.Translate = function(text)
    if GLOBAL.DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return text
    end
    
    -- 直接翻译
    if GLOBAL.DAILYTASKS.TRANSLATIONS[text] then
        return GLOBAL.DAILYTASKS.TRANSLATIONS[text]
    end
    
    -- 模式匹配翻译
    for pattern, replacement in pairs(GLOBAL.DAILYTASKS.TRANSLATIONS) do
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
    
    -- 监听钓鱼事件
    inst:ListenForEvent("fishingcollect", function(inst, data)
        if data and data.fish then
            inst.daily_fish_caught = (inst.daily_fish_caught or 0) + 1
            print("已钓鱼: " .. inst.daily_fish_caught)
            
            -- 检查是否是大鱼
            if data.fish.components and data.fish.components.perishable and 
               data.fish.components.perishable.perishtime and 
               data.fish.components.perishable.perishtime >= TUNING.PERISH_MED then
                inst.daily_big_fish_caught = (inst.daily_big_fish_caught or 0) + 1
                print("已钓大鱼: " .. inst.daily_big_fish_caught)
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
        
        local msg = GLOBAL.DAILYTASKS.Translate("当前每日任务：") .. "\n"
        
        if tasks.config.TASK_COUNT > 1 and #tasks.current_tasks > 0 then
            for i, task in ipairs(tasks.current_tasks) do
                local task_name = type(task.name) == "function" and task.name() or GLOBAL.DAILYTASKS.Translate(task.name)
                local desc = type(task.description) == "function" and task.description() or GLOBAL.DAILYTASKS.Translate(task.description)
                local reward = type(task.reward_description) == "function" and task.reward_description() or GLOBAL.DAILYTASKS.Translate(task.reward_description)
                local status = tasks.tasks_completed[i] and GLOBAL.DAILYTASKS.Translate("已完成") or GLOBAL.DAILYTASKS.Translate("未完成")
                
                msg = msg .. "#" .. i .. ": " .. task_name .. "\n"
                msg = msg .. desc .. "\n"
                msg = msg .. GLOBAL.DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
                msg = msg .. GLOBAL.DAILYTASKS.Translate("状态:") .. " " .. status .. "\n\n"
            end
        elseif tasks.current_task then
            local task_name = type(tasks.current_task.name) == "function" and tasks.current_task.name() or GLOBAL.DAILYTASKS.Translate(tasks.current_task.name)
            local desc = type(tasks.current_task.description) == "function" and tasks.current_task.description() or GLOBAL.DAILYTASKS.Translate(tasks.current_task.description)
            local reward = type(tasks.current_task.reward_description) == "function" and tasks.current_task.reward_description() or GLOBAL.DAILYTASKS.Translate(tasks.current_task.reward_description)
            local status = tasks.task_completed and GLOBAL.DAILYTASKS.Translate("已完成") or GLOBAL.DAILYTASKS.Translate("未完成")
            
            msg = msg .. task_name .. "\n"
            msg = msg .. desc .. "\n"
            msg = msg .. GLOBAL.DAILYTASKS.Translate("奖励:") .. " " .. reward .. "\n"
            msg = msg .. GLOBAL.DAILYTASKS.Translate("状态:") .. " " .. status
        else
            msg = msg .. GLOBAL.DAILYTASKS.Translate("暂无任务")
        end
        
        if player.components.talker then
            player.components.talker:Say(msg)
        end
    end
end)

AddModRPCHandler("DailyTasks", "CheckProgress", function(player)
    if player then
        local msg = GLOBAL.DAILYTASKS.Translate("当前任务进度:") .. "\n"
        
        if player.daily_rocks_mined then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已采矿:") .. " " .. player.daily_rocks_mined .. "\n"
        end
        
        if player.daily_gold_mined then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已采金:") .. " " .. player.daily_gold_mined .. "\n"
        end
        
        if player.daily_marble_mined then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已开采大理石:") .. " " .. player.daily_marble_mined .. "\n"
        end
        
        if player.daily_fish_caught then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已钓鱼:") .. " " .. player.daily_fish_caught .. "\n"
        end
        
        if player.daily_big_fish_caught then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已钓大鱼:") .. " " .. player.daily_big_fish_caught .. "\n"
        end
        
        if player.daily_kills then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已击杀:") .. "\n"
            for k, v in pairs(player.daily_kills) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_bosses_killed then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已击杀Boss:") .. "\n"
            for k, v in pairs(player.daily_bosses_killed) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_structures_built then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已建造:") .. "\n"
            for k, v in pairs(player.daily_structures_built) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_items_crafted then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已制作:") .. "\n"
            for k, v in pairs(player.daily_items_crafted) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_treasures_dug then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已挖掘宝藏:") .. " " .. player.daily_treasures_dug .. "\n"
        end
        
        if player.daily_areas_discovered then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已探索新区域:") .. " " .. player.daily_areas_discovered .. "\n"
        end
        
        if player.daily_tools_crafted then
            msg = msg .. GLOBAL.DAILYTASKS.Translate("已制作工具:") .. " " .. player.daily_tools_crafted .. "\n"
        end
        
        if player.components.talker then
            player.components.talker:Say(msg)
        end
    end
end)

-- 修改SetupKeyHandlers函数，只在开发者模式启用时添加F1调试键
local function SetupKeyHandlers(inst)
    -- 检查任务键和进度键保持不变
    local check_task_key = GLOBAL.DAILYTASKS.CONFIG.CHECK_TASK_KEY or "KEY_R"
    GLOBAL.TheInput:AddKeyDownHandler(GLOBAL[check_task_key], function()
        if GLOBAL.ThePlayer then
            SendModRPCToServer(MOD_RPC["DailyTasks"]["CheckTasks"])
        end
    end)
    
    local check_progress_key = GLOBAL.DAILYTASKS.CONFIG.CHECK_PROGRESS_KEY or "KEY_F"
    GLOBAL.TheInput:AddKeyDownHandler(GLOBAL[check_progress_key], function()
        if GLOBAL.ThePlayer then
            SendModRPCToServer(MOD_RPC["DailyTasks"]["CheckProgress"])
        end
    end)
    
    -- 只在开发者模式下添加F1调试功能
    if GLOBAL.DAILYTASKS.CONFIG.DEVELOPER_MODE then
        GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_F1, function()
            if GLOBAL.ThePlayer then
                print("========================")
                print("每日任务调试信息")
                print("========================")
                
                -- 打印所有统计数据（移除烹饪相关的统计）
                local stats = {
                    "daily_rocks_mined",
                    "daily_gold_mined",
                    "daily_marble_mined",
                    "daily_fish_caught",
                    "daily_big_fish_caught",
                    "daily_kills",
                    "daily_items_collected",
                    "daily_items_planted",
                    "daily_structures_built",
                    "daily_items_crafted",
                    "daily_bosses_killed",
                    "daily_ocean_fish_caught",
                    "daily_treasures_dug",
                    "daily_areas_discovered"
                }
                
                for _, stat in ipairs(stats) do
                    if GLOBAL.ThePlayer[stat] then
                        if type(GLOBAL.ThePlayer[stat]) == "table" then
                            print(stat .. ":")
                            for k, v in pairs(GLOBAL.ThePlayer[stat]) do
                                print("  " .. k .. ": " .. v)
                            end
                        else
                            print(stat .. ": " .. GLOBAL.ThePlayer[stat])
                        end
                    else
                        print(stat .. ": nil")
                    end
                end
                
                -- 如果有当前任务，打印任务信息
                if GLOBAL.ThePlayer.components.dailytasks then
                    local tasks = GLOBAL.ThePlayer.components.dailytasks
                    print("当前任务信息:")
                    
                    if tasks.config.TASK_COUNT > 1 and #tasks.current_tasks > 0 then
                        print("多任务模式 - " .. #tasks.current_tasks .. "个任务")
                        for i, task in ipairs(tasks.current_tasks) do
                            local completed = tasks.tasks_completed[i] and "已完成" or "未完成"
                            print("#" .. i .. ": " .. task.name .. " - " .. completed)
                        end
                    elseif tasks.current_task then
                        local completed = tasks.task_completed and "已完成" or "未完成"
                        print("单任务模式: " .. tasks.current_task.name .. " - " .. completed)
                    else
                        print("当前没有任务")
                    end
                end
                
                print("========================")
                print("F1调试功能已激活 - 请查看控制台输出")
                
                -- 如果玩家有talker组件，显示一个提示
                if GLOBAL.ThePlayer.components.talker then
                    GLOBAL.ThePlayer.components.talker:Say("调试信息已输出到控制台")
                end
            end
        end)
    end
end

AddPlayerPostInit(SetupKeyHandlers)

-- 修改全局任务列表函数，移除所有烹饪相关任务
GLOBAL.DAILYTASKS.GetTaskList = function()
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
        "钓大鱼任务",
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
        "制作玻璃刀任务"
    }
end

-- 在modmain.lua中添加一个函数来翻译任务名称和描述
GLOBAL.DAILYTASKS.TranslateTaskName = function(name)
    if GLOBAL.DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return name
    end
    
    -- 直接使用已定义的翻译表
    return GLOBAL.DAILYTASKS.TRANSLATIONS[name] or name
end

-- 添加一个函数来翻译任务描述
GLOBAL.DAILYTASKS.TranslateTaskDescription = function(desc)
    if GLOBAL.DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return desc
    end
    
    -- 首先尝试使用已有的翻译表
    for pattern, replacement in pairs(GLOBAL.DAILYTASKS.TRANSLATIONS) do
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
GLOBAL.DAILYTASKS.TranslateRewardDescription = function(desc)
    if GLOBAL.DAILYTASKS.CONFIG.LANGUAGE == "zh" then
        return desc
    end
    
    -- 首先尝试使用已有的翻译表
    for pattern, replacement in pairs(GLOBAL.DAILYTASKS.TRANSLATIONS) do
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