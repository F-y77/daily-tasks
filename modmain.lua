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
    
    -- 初始化统计数据
    inst.daily_kills = {}
    inst.daily_trees_chopped = 0
    inst.daily_rocks_mined = 0
    inst.daily_fish_caught = 0
    inst.daily_foods_cooked = 0
    inst.daily_gold_mined = 0
    inst.daily_marble_mined = 0
    inst.daily_big_fish_caught = 0
    inst.daily_gourmet_foods_cooked = 0
    inst.daily_meat_foods_cooked = 0
    inst.daily_items_collected = {}
    inst.daily_items_planted = 0
    inst.daily_distance_walked = 0
    inst.daily_structures_built = {}
    inst.daily_items_crafted = {}
    inst.daily_bosses_killed = {}
    inst.daily_health_restored = 0
    inst.daily_sanity_restored = 0
    inst.daily_hunger_restored = 0
    inst.daily_evergreen_chopped = 0
    inst.daily_birchnut_chopped = 0
    inst.daily_moon_tree_chopped = 0
    inst.daily_red_mushtree_chopped = 0
    inst.daily_blue_mushtree_chopped = 0
    inst.daily_green_mushtree_chopped = 0
    inst.daily_ocean_fish_caught = 0
    inst.daily_special_fish_caught = 0
    inst.daily_veggie_foods_cooked = 0
    inst.daily_seafood_foods_cooked = 0
    inst.daily_treasures_dug = 0
    inst.daily_areas_discovered = 0
    inst.daily_tools_crafted = 0
    
    -- 监听杀死生物事件
    inst:ListenForEvent("killed", OnKilled)
    
    -- 监听烹饪事件
    inst:ListenForEvent("donecooking", function(inst, data)
        inst.daily_foods_cooked = (inst.daily_foods_cooked or 0) + 1
        print("已烹饪食物: " .. inst.daily_foods_cooked)
        
        -- 检查是否是高级食物
        if data and data.product and (
           data.product.prefab == "honeynuggets" or 
           data.product.prefab == "honeyham" or 
           data.product.prefab == "dragonpie" or 
           data.product.prefab == "baconeggs" or 
           data.product.prefab == "butterflymuffin" or 
           data.product.prefab == "fruitmedley" or 
           data.product.prefab == "fishtacos" or 
           data.product.prefab == "waffles") then
            inst.daily_gourmet_foods_cooked = (inst.daily_gourmet_foods_cooked or 0) + 1
            print("已烹饪高级食物: " .. inst.daily_gourmet_foods_cooked)
        end
        
        -- 检查是否含肉食物
        if data and data.product and (
           data.product.prefab == "meatballs" or 
           data.product.prefab == "honeynuggets" or 
           data.product.prefab == "honeyham" or 
           data.product.prefab == "baconeggs" or 
           data.product.prefab == "fishtacos" or 
           data.product.prefab == "fishsticks" or 
           data.product.prefab == "monsterlasagna") then
            inst.daily_meat_foods_cooked = (inst.daily_meat_foods_cooked or 0) + 1
            print("已烹饪肉类食物: " .. inst.daily_meat_foods_cooked)
        end
    end)
    
    -- 添加额外的烹饪事件监听
    inst:ListenForEvent("stewer_cook", function(inst, data)
        inst.daily_foods_cooked = (inst.daily_foods_cooked or 0) + 1
        print("已烹饪食物(炖锅): " .. inst.daily_foods_cooked)
    end)
    
    -- 监听烹饪锅完成事件
    inst:ListenForEvent("harvestable", function(inst, data)
        if data and data.target and data.target.prefab == "cookpot" then
            inst.daily_foods_cooked = (inst.daily_foods_cooked or 0) + 1
            print("烹饪锅完成: " .. inst.daily_foods_cooked)
        end
    end)
    
    -- 监听采矿事件
    inst:ListenForEvent("finishedwork", function(inst, data)
        if data and data.target and data.target.prefab then
            print("完成工作: " .. data.target.prefab) -- 添加调试信息
            
            -- 金矿实际上是rock2
            if data.target.prefab == "rock2" then
                inst.daily_gold_mined = (inst.daily_gold_mined or 0) + 1
                print("已采金: " .. inst.daily_gold_mined)
            
            -- 普通石头
            elseif data.target.prefab == "rock1" or 
                   data.target.prefab == "rocks" or
                   data.target.prefab == "rock_flintless" then
                inst.daily_rocks_mined = (inst.daily_rocks_mined or 0) + 1
                print("已采矿: " .. inst.daily_rocks_mined)
            
            -- 大理石和冰
            elseif data.target.prefab == "rock_ice" or
                   data.target.prefab == "marbletree" or
                   data.target.prefab == "marblepillar" or
                   data.target.prefab == "marble" then
                inst.daily_marble_mined = (inst.daily_marble_mined or 0) + 1
                print("已采大理石/冰: " .. inst.daily_marble_mined)
            end
        end
    end)
    
    -- 再添加一个更全面的工作完成事件处理器
    inst:ListenForEvent("working", function(inst, data)
        if data and data.target then
            if data.target:HasTag("boulder") then
                local target_prefab = data.target.prefab
                print("正在挖掘: " .. target_prefab)
                
                -- 处理不同类型的石头
                if string.find(target_prefab, "gold") then
                    -- 这是金矿
                    if data.action == GLOBAL.ACTIONS.MINE then
                        inst.daily_gold_mined = (inst.daily_gold_mined or 0) + 0.25 -- 通常需要4次才能完成
                        print("采金进度: " .. inst.daily_gold_mined)
                    end
                end
            end
        end
    end)
    
    -- 监听钓鱼事件
    inst:ListenForEvent("fishingcollect", function(inst, data)
        inst.daily_fish_caught = (inst.daily_fish_caught or 0) + 1
        print("已钓鱼: " .. inst.daily_fish_caught)
        
        -- 检查是否是大鱼
        if data and data.fish and (
           data.fish.prefab == "oceanfish_medium_1" or 
           data.fish.prefab == "oceanfish_medium_2" or 
           data.fish.prefab == "oceanfish_medium_3" or 
           data.fish.prefab == "oceanfish_medium_4" or 
           data.fish.prefab == "oceanfish_medium_5" or 
           data.fish.prefab == "oceanfish_large_1" or 
           data.fish.prefab == "oceanfish_large_2" or 
           data.fish.prefab == "oceanfish_large_3" or 
           data.fish.prefab == "oceanfish_large_4" or 
           data.fish.prefab == "oceanfish_large_5") then
            inst.daily_big_fish_caught = (inst.daily_big_fish_caught or 0) + 1
            print("已钓大鱼: " .. inst.daily_big_fish_caught)
        end
    end)
    
    -- 监听种植事件
    inst:ListenForEvent("deployitem", function(inst, data)
        if data and data.prefab then
            inst.daily_items_planted = (inst.daily_items_planted or 0) + 1
            print("已种植: " .. inst.daily_items_planted)
        end
    end)
    
    -- 监听建造事件
    inst:ListenForEvent("buildstructure", function(inst, data)
        if data and data.item then
            if not inst.daily_structures_built then
                inst.daily_structures_built = {}
            end
            
            local structure_type = data.item.prefab
            if not inst.daily_structures_built[structure_type] then
                inst.daily_structures_built[structure_type] = 0
            end
            
            inst.daily_structures_built[structure_type] = inst.daily_structures_built[structure_type] + 1
            print("已建造 " .. structure_type .. ": " .. inst.daily_structures_built[structure_type])
        end
    end)
    
    -- 监听制作物品事件
    inst:ListenForEvent("builditem", function(inst, data)
        if data and data.item and data.item.prefab then
            local item_prefab = data.item.prefab
            print("制作物品: " .. item_prefab)
            
            -- 初始化物品制作统计
            if not inst.daily_items_crafted then
                inst.daily_items_crafted = {}
            end
            
            if not inst.daily_items_crafted[item_prefab] then
                inst.daily_items_crafted[item_prefab] = 0
            end
            
            inst.daily_items_crafted[item_prefab] = inst.daily_items_crafted[item_prefab] + 1
            
            -- 检查是否是工具
            local tools = {
                "axe", "pickaxe", "shovel", "hammer", "pitchfork", "fishingrod", 
                "goldenaxe", "goldenpickaxe", "goldenshovel", "spear", "tentaclespike",
                "hambat", "boomerang", "bugnet", "compass", "houndstooth", "torch",
                "trap", "birdtrap", "wateringcan", "premiumwateringcan"
            }
            
            local is_tool = false
            for _, tool in ipairs(tools) do
                if item_prefab == tool then
                    is_tool = true
                    break
                end
            end
            
            if is_tool then
                print("制作工具: " .. item_prefab)
                -- 将该次制作记为工具制作
                inst.daily_tools_crafted = (inst.daily_tools_crafted or 0) + 1
                print("已制作工具数量: " .. inst.daily_tools_crafted)
            end
        end
    end)
    
    -- 监听恢复生命值事件
    inst:ListenForEvent("healthdelta", function(inst, data)
        if data and data.amount and data.amount > 0 then
            inst.daily_health_restored = (inst.daily_health_restored or 0) + data.amount
            print("已恢复生命值: " .. inst.daily_health_restored)
        end
    end)
    
    -- 监听恢复理智值事件
    inst:ListenForEvent("sanitydelta", function(inst, data)
        if data and data.amount and data.amount > 0 then
            inst.daily_sanity_restored = (inst.daily_sanity_restored or 0) + data.amount
            print("已恢复理智值: " .. inst.daily_sanity_restored)
        end
    end)
    
    -- 监听恢复饥饿值事件
    inst:ListenForEvent("hungerdelta", function(inst, data)
        if data and data.amount and data.amount > 0 then
            inst.daily_hunger_restored = (inst.daily_hunger_restored or 0) + data.amount
            print("已恢复饥饿值: " .. inst.daily_hunger_restored)
        end
    end)
    
    -- 监听收集物品事件
    inst:ListenForEvent("picksomething", function(inst, data)
        if data and data.object and data.object.prefab then
            if not inst.daily_items_collected then
                inst.daily_items_collected = {}
            end
            
            local item_type = data.object.prefab
            if not inst.daily_items_collected[item_type] then
                inst.daily_items_collected[item_type] = 0
            end
            
            inst.daily_items_collected[item_type] = inst.daily_items_collected[item_type] + 1
            print("已收集 " .. item_type .. ": " .. inst.daily_items_collected[item_type])
        end
    end)

    -- 监听砍桦树事件
    inst:ListenForEvent("performaction", function(inst, data)
        if data and data.action and data.action.id == "CHOP" and 
           data.target and data.target.prefab == "deciduoustree" then
            inst.daily_birchnut_chopped = (inst.daily_birchnut_chopped or 0) + 1
            print("已砍桦树: " .. inst.daily_birchnut_chopped)
        end
    end)

    -- 监听砍大树事件
    local function OnTreeChop(inst, chopper)
        if chopper and chopper:HasTag("player") then
            if inst.size and inst.size == "tall" then
                chopper.daily_trees_chopped = (chopper.daily_trees_chopped or 0) + 1
                print("已砍大树: " .. chopper.daily_trees_chopped)
            end
        end
    end

    -- 为海钓添加监听
    inst:ListenForEvent("fishingcollect", function(inst, data)
        if data and data.fish then
            if data.fish.prefab and string.find(data.fish.prefab, "oceanfish") then
                inst.daily_ocean_fish_caught = (inst.daily_ocean_fish_caught or 0) + 1
                print("已海钓: " .. inst.daily_ocean_fish_caught)
            end
            
            -- 特殊鱼
            if data.fish.prefab and (
               data.fish.prefab == "oceanfish_medium_8" or -- 彩虹鳟鱼
               data.fish.prefab == "oceanfish_medium_3") then -- 花纹鳄鱼
                inst.daily_special_fish_caught = (inst.daily_special_fish_caught or 0) + 1
                print("已钓特殊鱼: " .. inst.daily_special_fish_caught)
            end
        end
    end)

    -- 监听烹饪素食料理
    inst:ListenForEvent("donecooking", function(inst, data)
        if data and data.product then
            if data.product.prefab == "ratatouille" or 
               data.product.prefab == "fruitmedley" or
               data.product.prefab == "jammypreserves" or
               data.product.prefab == "dragonpie" or
               data.product.prefab == "trailmix" or
               data.product.prefab == "butterflymuffin" or
               data.product.prefab == "vegstinger" then
                inst.daily_veggie_foods_cooked = (inst.daily_veggie_foods_cooked or 0) + 1
                print("已烹饪素食料理: " .. inst.daily_veggie_foods_cooked)
            end
            
            if data.product.prefab == "fishsticks" or
               data.product.prefab == "fishtacos" or
               data.product.prefab == "californiaroll" or
               data.product.prefab == "seafoodgumbo" or
               data.product.prefab == "surfnturf" then
                inst.daily_seafood_foods_cooked = (inst.daily_seafood_foods_cooked or 0) + 1
                print("已烹饪海鲜料理: " .. inst.daily_seafood_foods_cooked)
            end
        end
    end)

    -- 监听挖宝事件
    inst:ListenForEvent("performaction", function(inst, data)
        if data and data.action and data.action.id == "DIG" then
            if data.target and (
               data.target.prefab == "buriedtreasure" or
               (data.target.components and data.target.components.workable and 
                data.target.components.workable.action == GLOBAL.ACTIONS.DIG and
                math.random() < 0.2)) then -- 有20%几率算作宝藏
                inst.daily_treasures_dug = (inst.daily_treasures_dug or 0) + 1
                print("已挖掘宝藏: " .. inst.daily_treasures_dug)
            end
        end
    end)

    -- 监听探索新区域，使用正确的Vector3引用
    inst:DoPeriodicTask(3, function()
        -- 使用玩家位置变化来代替地图API
        if not inst.last_position then
            inst.last_position = GLOBAL.Vector3(inst.Transform:GetWorldPosition())
            inst.daily_areas_discovered = 0
        else
            local current_pos = GLOBAL.Vector3(inst.Transform:GetWorldPosition())
            local dist = inst.last_position:DistSq(current_pos)
            
            -- 如果距离超过一定值，认为探索了新区域
            if dist > 2500 then -- 50单位的距离的平方
                inst.daily_areas_discovered = (inst.daily_areas_discovered or 0) + 1
                print("已探索新区域: " .. inst.daily_areas_discovered)
                inst.last_position = current_pos
            end
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
        
        if player.daily_trees_chopped then
            msg = msg .. "已砍树: " .. player.daily_trees_chopped .. "\n"
        end
        
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
        
        if player.daily_foods_cooked then
            msg = msg .. "已烹饪食物: " .. player.daily_foods_cooked .. "\n"
        end
        
        if player.daily_meat_foods_cooked then
            msg = msg .. "已烹饪肉类食物: " .. player.daily_meat_foods_cooked .. "\n"
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
        
        if player.daily_evergreen_chopped then
            msg = msg .. "已砍常青树: " .. player.daily_evergreen_chopped .. "\n"
        end
        
        if player.daily_birchnut_chopped then
            msg = msg .. "已砍桦树: " .. player.daily_birchnut_chopped .. "\n"
        end
        
        if player.daily_moon_tree_chopped then
            msg = msg .. "已砍月树: " .. player.daily_moon_tree_chopped .. "\n"
        end
        
        if player.daily_red_mushtree_chopped then
            msg = msg .. "已砍红蘑菇树: " .. player.daily_red_mushtree_chopped .. "\n"
        end
        
        if player.daily_blue_mushtree_chopped then
            msg = msg .. "已砍蓝蘑菇树: " .. player.daily_blue_mushtree_chopped .. "\n"
        end
        
        if player.daily_green_mushtree_chopped then
            msg = msg .. "已砍绿蘑菇树: " .. player.daily_green_mushtree_chopped .. "\n"
        end
        
        if player.daily_ocean_fish_caught then
            msg = msg .. "已海钓: " .. player.daily_ocean_fish_caught .. "\n"
        end
        
        if player.daily_special_fish_caught then
            msg = msg .. "已钓特殊鱼: " .. player.daily_special_fish_caught .. "\n"
        end
        
        if player.daily_veggie_foods_cooked then
            msg = msg .. "已烹饪素食料理: " .. player.daily_veggie_foods_cooked .. "\n"
        end
        
        if player.daily_seafood_foods_cooked then
            msg = msg .. "已烹饪海鲜料理: " .. player.daily_seafood_foods_cooked .. "\n"
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
                
                -- 打印所有统计数据
                local stats = {
                    "daily_trees_chopped",
                    "daily_rocks_mined",
                    "daily_gold_mined",
                    "daily_marble_mined",
                    "daily_fish_caught",
                    "daily_big_fish_caught",
                    "daily_foods_cooked",
                    "daily_gourmet_foods_cooked",
                    "daily_meat_foods_cooked",
                    "daily_kills",
                    "daily_items_collected",
                    "daily_items_planted",
                    "daily_structures_built",
                    "daily_items_crafted",
                    "daily_bosses_killed",
                    "daily_evergreen_chopped",
                    "daily_birchnut_chopped",
                    "daily_moon_tree_chopped",
                    "daily_red_mushtree_chopped",
                    "daily_blue_mushtree_chopped",
                    "daily_green_mushtree_chopped",
                    "daily_ocean_fish_caught",
                    "daily_special_fish_caught",
                    "daily_veggie_foods_cooked",
                    "daily_seafood_foods_cooked",
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

-- 导出全局函数，可以在其他地方使用
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
        "烹饪任务",
        "烹饪素食任务",
        "烹饪肉类食物任务",
        "烹饪海鲜食物任务",
        "生存任务",
        "保持健康任务",
        "保持理智任务",
        "保持饱腹任务"
    }
end 