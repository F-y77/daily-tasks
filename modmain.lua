-- 首先定义全局变量
GLOBAL.DAILYTASKS = {}

-- 获取配置选项
local TASK_COUNT = GetModConfigData("TASK_COUNT") or 3
local TASK_DIFFICULTY = GetModConfigData("TASK_DIFFICULTY") or "medium"
local REWARD_MULTIPLIER = GetModConfigData("REWARD_MULTIPLIER") or 1
local SHOW_NOTIFICATIONS = GetModConfigData("SHOW_NOTIFICATIONS") or true
local CHECK_TASK_KEY = GetModConfigData("CHECK_TASK_KEY") or "KEY_T"
local CHECK_PROGRESS_KEY = GetModConfigData("CHECK_PROGRESS_KEY") or "KEY_Y"

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
    CHECK_PROGRESS_KEY = CHECK_PROGRESS_KEY
}

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
            print("已击杀Boss: " .. victim.prefab)
        end
    end
end

local function OnChopTree(inst, data)
    if data and data.target and data.target:HasTag("tree") and 
       not data.target:HasTag("stump") and data.action and data.action.id == "CHOP" then
        print("树被砍倒了！")
        if not inst.daily_trees_chopped then
            inst.daily_trees_chopped = 0
        end
        inst.daily_trees_chopped = inst.daily_trees_chopped + 1
        print("已砍树数量: " .. inst.daily_trees_chopped)
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
    
    -- 监听杀死生物事件
    inst:ListenForEvent("killed", OnKilled)
    
    -- 监听砍树事件
    inst:ListenForEvent("performaction", OnChopTree)
    
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
            if data.target.prefab == "rock1" or 
               data.target.prefab == "rock2" or 
               data.target.prefab == "rock_flintless" then
                inst.daily_rocks_mined = (inst.daily_rocks_mined or 0) + 1
                print("已采矿: " .. inst.daily_rocks_mined)
            elseif data.target.prefab == "goldnugget" or 
                   data.target.prefab == "rock_gold" then
                inst.daily_gold_mined = (inst.daily_gold_mined or 0) + 1
                print("已采金: " .. inst.daily_gold_mined)
            elseif data.target.prefab == "marble" or 
                   data.target.prefab == "rock_ice" then
                inst.daily_marble_mined = (inst.daily_marble_mined or 0) + 1
                print("已采大理石: " .. inst.daily_marble_mined)
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
    
    -- 监听制作事件
    inst:ListenForEvent("itemcrafted", function(inst, data)
        if data and data.item then
            if not inst.daily_items_crafted then
                inst.daily_items_crafted = {}
            end
            
            local item_type = data.item.prefab
            if not inst.daily_items_crafted[item_type] then
                inst.daily_items_crafted[item_type] = 0
            end
            
            inst.daily_items_crafted[item_type] = inst.daily_items_crafted[item_type] + 1
            print("已制作 " .. item_type .. ": " .. inst.daily_items_crafted[item_type])
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
end

-- 当玩家生成时添加组件
AddPlayerPostInit(OnPlayerSpawn)

-- 添加检查任务的命令
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL[CHECK_TASK_KEY], function()
    if GLOBAL.ThePlayer and GLOBAL.ThePlayer.components.dailytasks then
        local dailytasks = GLOBAL.ThePlayer.components.dailytasks
        local msg = "当前任务:\n"
        
        if dailytasks.current_tasks and #dailytasks.current_tasks > 0 then
            for i, task in ipairs(dailytasks.current_tasks) do
                local status = dailytasks.tasks_completed[i] and "[已完成]" or "[未完成]"
                local desc = type(task.description) == "function" and task.description() or task.description
                local reward = type(task.reward_description) == "function" and task.reward_description() or task.reward_description
                msg = msg .. status .. " " .. task.name .. ": " .. desc .. "\n奖励: " .. reward .. "\n\n"
            end
        else if dailytasks.current_task then
            local status = dailytasks.task_completed and "[已完成]" or "[未完成]"
            local desc = type(dailytasks.current_task.description) == "function" and dailytasks.current_task.description() or dailytasks.current_task.description
            local reward = type(dailytasks.current_task.reward_description) == "function" and dailytasks.current_task.reward_description() or dailytasks.current_task.reward_description
            msg = msg .. status .. " " .. dailytasks.current_task.name .. ": " .. desc .. "\n奖励: " .. reward
        else
            msg = "当前没有任务"
        end
        end
        
        GLOBAL.ThePlayer.components.talker:Say(msg)
    end
end)

-- 添加显示任务进度的命令
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL[CHECK_PROGRESS_KEY], function()
    if GLOBAL.ThePlayer then
        local player = GLOBAL.ThePlayer
        local msg = "任务进度:\n"
        
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
            msg = msg .. "已采大理石: " .. player.daily_marble_mined .. "\n"
        end
        
        if player.daily_fish_caught then
            msg = msg .. "已钓鱼: " .. player.daily_fish_caught .. "\n"
        end
        
        if player.daily_big_fish_caught then
            msg = msg .. "已钓大鱼: " .. player.daily_big_fish_caught .. "\n"
        end
        
        if player.daily_foods_cooked then
            msg = msg .. "已烹饪: " .. player.daily_foods_cooked .. "\n"
        end
        
        if player.daily_gourmet_foods_cooked then
            msg = msg .. "已烹饪高级食物: " .. player.daily_gourmet_foods_cooked .. "\n"
        end
        
        if player.daily_meat_foods_cooked then
            msg = msg .. "已烹饪肉类食物: " .. player.daily_meat_foods_cooked .. "\n"
        end
        
        if player.daily_items_planted then
            msg = msg .. "已种植: " .. player.daily_items_planted .. "\n"
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
        
        player.components.talker:Say(msg)
    end
end)

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
        "砍树任务",
        "砍松树任务",
        "采矿任务",
        "采金任务",
        "采集大理石任务",
        "钓鱼任务",
        "钓大鱼任务",
        "烹饪任务",
        "烹饪高级食物任务",
        "烹饪肉类食物任务",
        "生存任务",
        "保持健康任务",
        "保持理智任务",
        "保持饱腹任务"
    }
end

-- 监听树木砍伐事件
local function OnTreeChop(inst, chopper)
    if chopper and chopper:HasTag("player") and chopper.daily_trees_chopped ~= nil then
        chopper.daily_trees_chopped = chopper.daily_trees_chopped + 1
    end
end

-- 为所有树添加砍伐监听器
local function AddChopListener(inst)
    if inst.components.workable and inst:HasTag("tree") then
        local oldOnFinish = inst.components.workable.onfinish
        inst.components.workable.onfinish = function(inst, chopper)
            OnTreeChop(inst, chopper)
            if oldOnFinish then
                oldOnFinish(inst, chopper)
            end
        end
    end
end

-- 为现有树添加监听器
AddPrefabPostInit("evergreen", AddChopListener)
AddPrefabPostInit("deciduoustree", AddChopListener)
AddPrefabPostInit("marsh_tree", AddChopListener)
AddPrefabPostInit("mushtree_tall", AddChopListener)
AddPrefabPostInit("mushtree_medium", AddChopListener)
AddPrefabPostInit("mushtree_small", AddChopListener) 