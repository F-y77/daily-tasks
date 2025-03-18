-- 首先定义全局变量
GLOBAL.DAILYTASKS = {}

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
    TASK_COUNT = TASK_COUNT,
    TASK_DIFFICULTY = TASK_DIFFICULTY,
    REWARD_MULTIPLIER = REWARD_MULTIPLIER,
    SHOW_NOTIFICATIONS = SHOW_NOTIFICATIONS,
    DIFFICULTY_MULTIPLIER = DIFFICULTY_MULTIPLIERS[TASK_DIFFICULTY] or 1.0,
    CHECK_TASK_KEY = CHECK_TASK_KEY,
    CHECK_PROGRESS_KEY = CHECK_PROGRESS_KEY,
    DEVELOPER_MODE = DEVELOPER_MODE
}

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

-- 使用ActionHandler处理键盘输入，兼容洞穴
AddModRPCHandler("DailyTasks", "CheckTasks", function(player)
    if player and player.components.dailytasks then
        -- 显示当前任务
        local tasks = player.components.dailytasks
        
        local msg = "当前每日任务：\n"
        
        if tasks.config.TASK_COUNT > 1 and #tasks.current_tasks > 0 then
            -- 多任务模式
            for i, task in ipairs(tasks.current_tasks) do
                local desc = type(task.description) == "function" and task.description() or task.description
                local reward = type(task.reward_description) == "function" and task.reward_description() or task.reward_description
                local status = tasks.tasks_completed[i] and "已完成" or "未完成"
                
                msg = msg .. "#" .. i .. ": " .. task.name .. "\n"
                msg = msg .. desc .. "\n"
                msg = msg .. "奖励: " .. reward .. "\n"
                msg = msg .. "状态: " .. status .. "\n\n"
            end
        else if tasks.current_task then
            -- 单任务模式
            local desc = type(tasks.current_task.description) == "function" and tasks.current_task.description() or tasks.current_task.description
            local reward = type(tasks.current_task.reward_description) == "function" and tasks.current_task.reward_description() or tasks.current_task.reward_description
            local status = tasks.task_completed and "已完成" or "未完成"
            
            msg = msg .. tasks.current_task.name .. "\n"
            msg = msg .. desc .. "\n"
            msg = msg .. "奖励: " .. reward .. "\n"
            msg = msg .. "状态: " .. status
        else
            msg = msg .. "暂无任务"
        end
        end
        
        if player.components.talker then
            player.components.talker:Say(msg)
        end
    end
end)

AddModRPCHandler("DailyTasks", "CheckProgress", function(player)
    if player then
        local msg = "当前任务进度:\n"
        
        if player.daily_rocks_mined then
            msg = msg .. "已采矿: " .. player.daily_rocks_mined .. "\n"
        end
        
        if player.daily_gold_mined then
            msg = msg .. "已采金: " .. player.daily_gold_mined .. "\n"
        end
        
        if player.daily_marble_mined then
            msg = msg .. "已开采大理石: " .. player.daily_marble_mined .. "\n"
        end
        
        if player.daily_fish_caught then
            msg = msg .. "已钓鱼: " .. player.daily_fish_caught .. "\n"
        end
        
        if player.daily_big_fish_caught then
            msg = msg .. "已钓大鱼: " .. player.daily_big_fish_caught .. "\n"
        end
        
        if player.daily_kills then
            msg = msg .. "已击杀: \n"
            for k, v in pairs(player.daily_kills) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_bosses_killed then
            msg = msg .. "已击杀Boss: \n"
            for k, v in pairs(player.daily_bosses_killed) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_structures_built then
            msg = msg .. "已建造: \n"
            for k, v in pairs(player.daily_structures_built) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_items_crafted then
            msg = msg .. "已制作: \n"
            for k, v in pairs(player.daily_items_crafted) do
                msg = msg .. "  " .. k .. ": " .. v .. "\n"
            end
        end
        
        if player.daily_treasures_dug then
            msg = msg .. "已挖掘宝藏: " .. player.daily_treasures_dug .. "\n"
        end
        
        if player.daily_areas_discovered then
            msg = msg .. "已探索新区域: " .. player.daily_areas_discovered .. "\n"
        end
        
        if player.daily_tools_crafted then
            msg = msg .. "已制作工具: " .. player.daily_tools_crafted .. "\n"
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
        "保持饱腹任务"
    }
end 