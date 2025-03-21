local DailyTasks = Class(function(self, inst)
    self.inst = inst
    self.current_task = nil
    self.current_tasks = {}
    self.tasks_completed = {}
    self.task_completed = false
    self.last_day = nil
    
    -- 获取配置
    self.config = DAILYTASKS.CONFIG
    
    -- 初始化玩家的每日统计（移除烹饪相关的初始化）
    self.inst.daily_kills = {}
    self.inst.daily_rocks_mined = 0
    self.inst.daily_items_collected = {}
    self.inst.daily_items_planted = 0
    self.inst.daily_distance_walked = 0
    self.inst.daily_structures_built = {}
    self.inst.daily_bosses_killed = {}
    self.inst.daily_health_restored = 0
    self.inst.daily_sanity_restored = 0
    self.inst.daily_hunger_restored = 0
    
    -- 任务列表
    self.tasks = {
        -- 采集任务
        {
            name = function() 
                return DAILYTASKS.CONFIG.LANGUAGE == "en" 
                    and "Berry Gathering" 
                    or "采集浆果任务"
            end,
            description = function() 
                local count = math.ceil(10 * self.config.DIFFICULTY_MULTIPLIER)
                return DAILYTASKS.CONFIG.LANGUAGE == "en"
                    and "Collect " .. count .. " berries"
                    or "采集" .. count .. "个浆果" 
            end,
            check = function(player)
                local required = math.ceil(10 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "berries" or item.prefab == "berries_cooked"
                    end)
                    
                    for _, item in ipairs(items) do
                        count = count + (item.components.stackable and item.components.stackable:StackSize() or 1)
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return DAILYTASKS.CONFIG.LANGUAGE == "en"
                    and count .. " meat"
                    or count .. "个肉"
            end
        },
        {
            name = function() 
                return DAILYTASKS.CONFIG.LANGUAGE == "en" 
                    and "Carrot Gathering" 
                    or "采集胡萝卜任务"
            end,
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return DAILYTASKS.CONFIG.LANGUAGE == "en"
                    and "Collect " .. count .. " carrots"
                    or "采集" .. count .. "个胡萝卜" 
            end,
            check = function(player) 
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "carrot" or item.prefab == "carrot_cooked"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return DAILYTASKS.CONFIG.LANGUAGE == "en"
                    and count .. " meat"
                    or count .. "个肉"
            end
        },
        {
            name = function() 
                return DAILYTASKS.CONFIG.LANGUAGE == "en" 
                    and "Reed Gathering" 
                    or "采集芦苇任务"
            end,
            description = function() 
                local count = math.ceil(10 * self.config.DIFFICULTY_MULTIPLIER)
                return DAILYTASKS.CONFIG.LANGUAGE == "en"
                    and "Collect " .. count .. " reeds"
                    or "采集" .. count .. "个芦苇" 
            end,
            check = function(player) 
                local required = math.ceil(10 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "cutreeds"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("papyrus"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return DAILYTASKS.CONFIG.LANGUAGE == "en"
                    and count .. " papyrus"
                    or count .. "个莎草纸"
            end
        },
        {
            name = "采集蘑菇任务",
            description = function() 
                local count = math.ceil(4 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个蘑菇(任意种类)" 
            end,
            check = function(player) 
                local required = math.ceil(4 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "red_cap" or item.prefab == "green_cap" or 
                               item.prefab == "blue_cap" or item.prefab == "red_cap_cooked" or 
                               item.prefab == "green_cap_cooked" or item.prefab == "blue_cap_cooked"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local food = SpawnPrefab("butterflymuffin")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个蝴蝶松饼"
        },
        
        -- 狩猎任务
        {
            name = "狩猎兔子任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只兔子" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.rabbit and player.daily_kills.rabbit >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个肉"
            end
        },
        {
            name = "狩猎蜘蛛任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只蜘蛛" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                local spider_count = 0
                if player.daily_kills then
                    if player.daily_kills.spider then
                        spider_count = spider_count + player.daily_kills.spider
                    end
                    if player.daily_kills.spider_warrior then
                        spider_count = spider_count + player.daily_kills.spider_warrior
                    end
                end
                return spider_count >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("silk"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个蜘蛛丝"
            end
        },
        {
            name = "狩猎猪人任务",
            description = function() 
                local count = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只猪人" 
            end,
            check = function(player)
                local required = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.pigman and player.daily_kills.pigman >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个肉"
            end
        },
        {
            name = "狩猎蜜蜂任务",
            description = function() 
                local count = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只蜜蜂" 
            end,
            check = function(player)
                local required = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                local bee_count = 0
                if player.daily_kills then
                    if player.daily_kills.bee then
                        bee_count = bee_count + player.daily_kills.bee
                    end
                    if player.daily_kills.killerbee then
                        bee_count = bee_count + player.daily_kills.killerbee
                    end
                end
                return bee_count >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("honey"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个蜂蜜"
            end
        },
        
        -- 采矿任务
        {
            name = "采矿任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "开采" .. count .. "块石头" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_rocks_mined and player.daily_rocks_mined >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("rocks"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "块石头"
            end
        },
        {
            name = "采金矿石任务（只包含主世界金矿石）",
            description = function() 
                local count = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "挖掘" .. count .. "个金矿石" 
            end,
            check = function(player) 
                return player.daily_gold_mined and player.daily_gold_mined >= math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "采集大理石任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "开采" .. count .. "块大理石" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_marble_mined and player.daily_marble_mined >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("marble"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个大理石"
            end
        },
        
        -- 钓鱼任务
        {
            name = "钓鱼任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "钓上" .. count .. "条鱼" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_fish_caught and player.daily_fish_caught >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("fishmeat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个鱼肉"
            end
        },
        {
            name = "钓大鱼任务",
            description = function() 
                local count = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "钓" .. count .. "条大鱼" 
            end,
            check = function(player)
                local required = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_big_fish_caught and player.daily_big_fish_caught >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("fish_cooked"))
                    end
                end
            end,
            reward_description = "3个熟鱼肉"
        },
        
        -- 生存任务
        {
            name = "生存任务",
            description = function() 
                local days = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "存活" .. days .. "天" 
            end,
            check = function(player)
                -- 这个任务总是完成的，因为它是在新的一天检查的
                return true
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "保持健康任务",
            description = "保持健康状态一整天",
            check = function(player)
                if player.components.health then
                    return player.components.health:GetPercent() > 0.8
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    player.components.inventory:GiveItem(SpawnPrefab("lifeinjector"))
                end
            end,
            reward_description = "1个生命注射器"
        },
        {
            name = "保持理智任务",
            description = "保持理智状态一整天",
            check = function(player)
                if player.components.sanity then
                    return player.components.sanity:GetPercent() > 0.8
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    player.components.inventory:GiveItem(SpawnPrefab("nightmarefuel"))
                    player.components.inventory:GiveItem(SpawnPrefab("nightmarefuel"))
                end
            end,
            reward_description = "2个噩梦燃料"
        },
        {
            name = "保持饱腹任务",
            description = "保持饱腹状态一整天",
            check = function(player)
                if player.components.hunger then
                    return player.components.hunger:GetPercent() > 0.8
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    player.components.inventory:GiveItem(SpawnPrefab("baconeggs"))
                end
            end,
            reward_description = "1个培根煎蛋"
        },
        {
            name = "采集花朵任务",
            description = function() 
                local count = math.ceil(6 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "朵花" 
            end,
            check = function(player) 
                local required = math.ceil(6 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "petals" or item.prefab == "petals_evil"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("butterflywings"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return count .. "个蝴蝶翅膀"
            end
        },
        {
            name = "采集蜂蜜任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "份蜂蜜" 
            end,
            check = function(player) 
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "honey"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local food = SpawnPrefab("taffy")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个太妃糖"
        },
        {
            name = "采集树枝任务",
            description = function() 
                local count = math.ceil(15 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个树枝" 
            end,
            check = function(player) 
                local required = math.ceil(15 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "twigs"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("rope"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个绳子"
            end
        },
        {
            name = "狩猎青蛙任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只青蛙" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.frog and player.daily_kills.frog >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("froglegs_cooked"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个熟蛙腿"
            end
        },
        {
            name = "狩猎浣熊任务",
            description = function() 
                local count = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只浣熊" 
            end,
            check = function(player)
                local required = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.merm and player.daily_kills.merm >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("fish"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "条鱼"
            end
        },
        {
            name = "击败高鸟任务",
            description = "击败一只高脚鸟",
            check = function(player)
                return player.daily_kills and player.daily_kills.tallbird and player.daily_kills.tallbird >= 1
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("tallbirdegg"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return count .. "个高鸟蛋"
            end
        },
        {
            name = "狩猎触手任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "个触手" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.tentacle and player.daily_kills.tentacle >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("tentaclespots"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return count .. "个触手皮"
            end
        },
        {
            name = "采集硝石任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个硝石" 
            end,
            check = function(player) 
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "nitre"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("gunpowder"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个火药"
            end
        },
        {
            name = "采集燧石任务",
            description = function() 
                local count = math.ceil(8 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个燧石" 
            end,
            check = function(player) 
                local required = math.ceil(8 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "flint"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("pickaxe"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return count .. "个镐子"
            end
        },
        {
            name = "采冰任务",
            description = function() 
                local count = math.ceil(6 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "块冰" 
            end,
            check = function(player) 
                -- 首先检查是否是冬季
                if not (TheWorld.state.season == "winter") then
                    -- 如果不是冬季，任务无法完成
                    return false
                end
                
                local required = math.ceil(6 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "ice"
                    end)
                    
                    for _, item in ipairs(items) do
                        if item.components.stackable then
                            count = count + item.components.stackable:StackSize()
                        else
                            count = count + 1
                        end
                    end
                    
                    return count >= required
                end
                return false
            end,
            reward = function(player) 
                if player.components.inventory then
                    local food = SpawnPrefab("icecream")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个冰淇淋",
            season_hint = "只能在冬季完成"  -- 添加季节提示
        },
        {
            name = "海钓任务",
            description = function() 
                local count = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "在海边钓到" .. count .. "条鱼" 
            end,
            check = function(player)
                local required = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_ocean_fish_caught and player.daily_ocean_fish_caught >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local food = SpawnPrefab("surfnturf")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个海鲜牛排"
        },
        {
            name = "寻找宝藏任务",
            description = "挖掘一处宝藏",
            check = function(player)
                return player.daily_treasures_dug and player.daily_treasures_dug >= 1
            end,
            reward = function(player)
                if player.components.inventory then
                    local item = SpawnPrefab("trinket_1") -- 一个装饰品
                    if item then
                        player.components.inventory:GiveItem(item)
                    end
                end
            end,
            reward_description = "1个装饰品"
        },
        {
            name = "探索任务",
            description = function() 
                local count = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                return "探索" .. count .. "个新地区" 
            end,
            check = function(player)
                local required = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_areas_discovered and player.daily_areas_discovered >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local item = SpawnPrefab("compass")
                    if item then
                        player.components.inventory:GiveItem(item)
                    end
                end
            end,
            reward_description = "1个指南针"
        },
        {
            name = "制作工具任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "制作" .. count .. "个工具" 
            end,
            check = function(player) 
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_tools_crafted and player.daily_tools_crafted >= required
            end,
            reward = function(player) 
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    if count > 1 then
                        for i=2, count do
                            player.components.inventory:GiveItem(SpawnPrefab("cutstone"))
                        end
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                if count > 1 then
                    return "1个金块和" .. (count-1) .. "个石砖"
                else
                    return "1个金块"
                end
            end
        },
        {
            name = "建造房子任务",
            description = "建造一个房子结构",
            check = function(player)
                local count = 0
                
                if player.daily_structures_built then
                    for structure_type, num in pairs(player.daily_structures_built) do
                        if structure_type == "wall_hay" or structure_type == "wall_wood" or 
                           structure_type == "wall_stone" or structure_type == "wall_ruins" or 
                           structure_type == "pighouse" or structure_type == "rabbithouse" then
                            count = count + num
                        end
                    end
                end
                
                return count >= 1
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(4 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("boards"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(4 * self.config.REWARD_MULTIPLIER)
                return count .. "个木板"
            end
        },
        {
            name = "狩猎兔人任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "个兔人" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.bunnyman and player.daily_kills.bunnyman >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("carrot"))
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个胡萝卜和" .. count .. "个肉"
            end
        },
        {
            name = "狩猎鱼人任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "个鱼人" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.merm and player.daily_kills.merm >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("fish"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "条生鱼"
            end
        },
        {
            name = "狩猎海象任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只海象" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.walrus and player.daily_kills.walrus >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    player.components.inventory:GiveItem(SpawnPrefab("walrushat"))
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("blowdart_pipe"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return "1顶贝雷帽和" .. count .. "个吹箭"
            end,
            season_hint = "冬季出没"
        },
        {
            name = "狩猎发条骑士任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "个发条骑士" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.knight and player.daily_kills.knight >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("gears"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个齿轮"
            end
        },
        {
            name = "狩猎火鸡任务",
            description = function() 
                local count = math.ceil(4 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只火鸡" 
            end,
            check = function(player)
                local required = math.ceil(4 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.perd and player.daily_kills.perd >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("drumstick"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个鸡腿"
            end
        },
        {
            name = "狩猎鼹鼠任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只鼹鼠" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.mole and player.daily_kills.mole >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("mole"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个鼹鼠"
            end
        },
        {
            name = "狩猎皮弗娄牛任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只皮弗娄牛" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.beefalo and player.daily_kills.beefalo >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                    player.components.inventory:GiveItem(SpawnPrefab("beefalowool"))
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个肉和1个牛毛"
            end
        },
        {
            name = "狩猎爬行梦魇任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "个爬行梦魇" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and 
                       ((player.daily_kills.crawlingnightmare and player.daily_kills.crawlingnightmare >= required) or
                        (player.daily_kills.terrorbeak and player.daily_kills.terrorbeak >= required))
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("nightmarefuel"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个噩梦燃料"
            end
        },
        {
            name = "狩猎蜘蛛战士任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只蜘蛛战士" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.spider_warrior and player.daily_kills.spider_warrior >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("spidergland"))
                    end
                    player.components.inventory:GiveItem(SpawnPrefab("monstermeat"))
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个蜘蛛腺体和1个怪物肉"
            end
        },
        {
            name = "狩猎猎犬任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只猎犬" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.hound and player.daily_kills.hound >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("houndstooth"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个犬牙"
            end
        },
        {
            name = "狩猎蓝色猎犬任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只蓝色猎犬" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.icehound and player.daily_kills.icehound >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("bluegem"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "颗蓝宝石"
            end,
            season_hint = "冬季出没"
        },
        {
            name = "狩猎红色猎犬任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "杀死" .. count .. "只红色猎犬" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_kills and player.daily_kills.firehound and player.daily_kills.firehound >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("redgem"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "颗红宝石"
            end,
            season_hint = "夏季出没"
        },
        {
            name = "制作长矛任务",
            description = function() 
                return "制作1个长矛" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "spear"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("flint"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个燧石"
            end
        },
        {
            name = "制作火腿棒任务",
            description = function() 
                return "制作1个火腿棒" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "hambat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个肉"
            end
        },
        {
            name = "制作暗夜剑任务",
            description = function() 
                return "制作1个暗夜剑" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "nightsword"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("nightmarefuel"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个噩梦燃料"
            end
        },
        {
            name = "制作排箫任务",
            description = function() 
                return "制作1个排箫" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "panflute"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("mandrake"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个曼德拉草"
            end
        },
        {
            name = "制作火魔杖任务",
            description = function() 
                return "制作1个火魔杖" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "firestaff"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("redgem"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个红宝石"
            end
        },
        {
            name = "制作冰魔杖任务",
            description = function() 
                return "制作1个冰魔杖" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "icestaff"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("bluegem"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个蓝宝石"
            end
        },
        {
            name = "制作铥矿棒任务",
            description = function() 
                return "制作1个铥矿棒" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "ruins_bat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("thulecite"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个铥矿"
            end
        },
        {
            name = "制作唤星者魔杖任务",
            description = function() 
                return "制作1个唤星者魔杖" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "yellowstaff"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("yellowgem"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个黄宝石"
            end
        },
        {
            name = "制作懒人魔杖任务",
            description = function() 
                return "制作1个懒人魔杖" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "orangestaff"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("orangegem"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个橙宝石"
            end
        },
        {
            name = "制作玻璃刀任务",
            description = function() 
                return "制作1个玻璃刀" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "glasscutter"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("moonglass"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个月亮碎片"
            end
        },
        {
            name = "制作木甲任务",
            description = function() 
                return "制作1个木甲" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "armorwood"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(8 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("log"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(8 * self.config.REWARD_MULTIPLIER)
                return count .. "个木头"
            end
        },
        {
            name = "制作暗夜甲任务",
            description = function() 
                return "制作1个暗夜甲" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "armor_sanity"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(4 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("nightmarefuel"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(4 * self.config.REWARD_MULTIPLIER)
                return count .. "个噩梦燃料"
            end
        },
        {
            name = "制作大理石甲任务",
            description = function() 
                return "制作1个大理石甲" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "armormarble"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("marble"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个大理石"
            end
        },
        {
            name = "制作绝望石盔甲任务",
            description = function() 
                return "制作1个绝望石盔甲" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "armorruins"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("thulecite"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个铥矿"
            end
        },
        {
            name = "制作橄榄球头盔任务",
            description = function() 
                return "制作1个橄榄球头盔" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "footballhat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("pigskin"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个猪皮"
            end
        },
        {
            name = "制作养蜂帽任务",
            description = function() 
                return "制作1个养蜂帽" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "beehat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("honey"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个蜂蜜"
            end
        },
        {
            name = "制作背包任务",
            description = function() 
                return "制作1个背包" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "backpack"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(8 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("cutgrass"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(8 * self.config.REWARD_MULTIPLIER)
                return count .. "个割下的草"
            end
        },
        {
            name = "制作雨伞任务",
            description = function() 
                return "制作1个雨伞" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "umbrella"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("pigskin"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个猪皮"
            end
        },
        {
            name = "制作羽毛扇任务",
            description = function() 
                return "制作1个羽毛扇" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "featherfan"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goose_feather"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个鹅毛"
            end
        },
        {
            name = "制作花环任务",
            description = function() 
                return "制作1个花环" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "flowerhat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("petals"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个花瓣"
            end
        },
        {
            name = "制作草帽任务",
            description = function() 
                return "制作1个草帽" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "strawhat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(10 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("cutgrass"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(10 * self.config.REWARD_MULTIPLIER)
                return count .. "个割下的草"
            end
        },
        {
            name = "制作高礼帽任务",
            description = function() 
                return "制作1个高礼帽" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "tophat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(6 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("silk"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(6 * self.config.REWARD_MULTIPLIER)
                return count .. "个蜘蛛丝"
            end
        },
        {
            name = "制作冬帽任务",
            description = function() 
                return "制作1个冬帽" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "winterhat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(4 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("rabbit"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(4 * self.config.REWARD_MULTIPLIER)
                return count .. "只兔子"
            end
        },
        {
            name = "制作牛角帽任务",
            description = function() 
                return "制作1个牛角帽" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "beefalohat"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("beefalowool"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个牛毛"
            end
        },
        {
            name = "制作步行手杖任务",
            description = function() 
                return "制作1个步行手杖" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "cane"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("walrus_tusk"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个海象牙"
            end
        },
        {
            name = "制作黄金斧头任务",
            description = function() 
                return "制作1个黄金斧头" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "goldenaxe"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "制作黄金鹤嘴锄任务",
            description = function() 
                return "制作1个黄金鹤嘴锄" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "goldenpickaxe"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "制作黄金铲子任务",
            description = function() 
                return "制作1个黄金铲子" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "goldenshovel"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "制作黄金园艺锄任务",
            description = function() 
                return "制作1个黄金园艺锄" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "golden_farm_hoe"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "制作黄金干草叉任务",
            description = function() 
                return "制作1个黄金干草叉" 
            end,
            check = function(player)
                if player.components.inventory then
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "goldenpitchfork"
                    end)
                    return #items > 0
                end
                return false
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(3 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "超级马里奥挑战",
            description = "戴着红色蘑菇帽击杀蘑菇地精(mushgnome)",
            check = function(player)
                -- 检查是否戴着红色蘑菇帽
                local hat = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                if hat and hat.prefab == "red_mushroomhat" then
                    -- 检查是否击杀了蘑菇地精
                    return player.daily_kills and player.daily_kills.mushgnome and player.daily_kills.mushgnome >= 1
                end
                return false
            end,
            reward = function(player)
                player.components.inventory:GiveItem(SpawnPrefab("mushroom_light"))
                player.components.inventory:GiveItem(SpawnPrefab("red_cap"))
                player.components.health:SetInvincible(true)
                player:DoTaskInTime(60, function() 
                    player.components.health:SetInvincible(false)
                end)
            end,
            reward_description = "蘑菇灯+红蘑菇+60秒无敌",
            special = true
        },
        {
            name = "Among Us 厨房危机",
            description = "给队友喂食扣血食物",
            check = function(player)
                return player.among_us_feeds and player.among_us_feeds >= 1
            end,
            start = function(player)
                player:ListenForEvent("oneat", function(inst, data)
                    if data and data.food and data.feeder == player then
                        if data.food.prefab == "monstertartare" and data.eater ~= player then
                            player.among_us_feeds = (player.among_us_feeds or 0) + 1
                        end
                    end
                end)
            end,
            reward = function(player)
                player.components.inventory:GiveItem(SpawnPrefab("krampus_sack"))
                player.components.sanity:SetMax(50)
            end,
            reward_description = "坎普斯背包+50理智上限",
            special = true
        },
        {
            name = "社恐波奇酱",
            description = "保持独处一整天",
            check = function(player)
                return player.social_anxiety_days and player.social_anxiety_days >= 1
            end,
            start = function(player)
                player.social_anxiety_days = 0
                player:DoPeriodicTask(10, function() 
                    local x,y,z = player.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,y,z, 5, {"_combat","player"})
                    -- 排除自己后判断是否有其他实体
                    if #ents > 1 then 
                        player.social_anxiety_days = 0
                    else
                        -- 每10秒增加1/240天（现实1天=游戏8分钟）
                        player.social_anxiety_days = (player.social_anxiety_days or 0) + (10/480)
                    end
                end)
            end,
            reward = function(player)
                player.components.inventory:GiveItem(SpawnPrefab("flowerhat"))
                player.components.sanity:SetRateMultiplier(2.0)
            end,
            reward_description = "花环+双倍理智恢复",
            special = true
        },
        {
            name = "恐怖游轮循环",
            description = "完成死亡复仇循环",
            check = function(player)
                return player.curse_cycle_completed
            end,
            start = function(player)
                player.curse_kills = {}
                player:ListenForEvent("death", function(inst, data)
                    if data and data.attacker then
                        local killer_type = data.attacker.prefab
                        player:DoTaskInTime(0.5, function()  -- 稍后检查复活
                            if player:IsValid() and player.components.health:IsDead() then
                                player:ListenForEvent("respawn", function()
                                    player:DoTaskInTime(1, function()
                                        player:ListenForEvent("death", function(_, data2)
                                            if data2 and data2.attacker and 
                                               data2.attacker.prefab == killer_type then
                                                player.curse_cycle_completed = true
                                            end
                                        end)
                                    end)
                                end)
                            end
                        end)
                    end
                end)
            end,
            reward = function(player)
                player.components.inventory:GiveItem(SpawnPrefab("reviver"))
                player.components.health:StartRegen(2, 1)
            end,
            reward_description = "复活护符+生命恢复",
            special = true
        },
        {
            name = "咩咩羊启示录",
            description = "封你为神 - 拥有20个信徒(被驯服的猪人、兔人、鱼人)",
            check = function(player)
                -- 检查是否拥有足够的信徒
                local follower_count = 0
                for k, v in pairs(player.components.leader.followers) do
                    if k:HasTag("pig") or k:HasTag("rabbit") or k:HasTag("merm") then
                        follower_count = follower_count + 1
                    end
                end
                return follower_count >= 20  -- 改为20个
            end,
            start = function(player)
                -- 初始化任务状态
                player.sheep_cult_started = true
                
                -- 给予玩家一些肉来吸引信徒
                if player.components.inventory then
                    for i=1, 10 do
                        player.components.inventory:GiveItem(SpawnPrefab("meat"))
                    end
                end
                
                -- 通知玩家
                if player.components.talker then
                    player.components.talker:Say("咩咩羊启示录任务开始！收集20个信徒来崇拜你...")
                end
                
                return true
            end,
            reward = function(player)
                if player.components.inventory then
                    -- 给予咩咩羊主题奖励
                    -- 神圣权杖(步行手杖)
                    local cane = SpawnPrefab("cane")
                    if cane and cane.components.colouradder then
                        cane.components.colouradder:SetColour(1, 0.8, 0)
                    end
                    player.components.inventory:GiveItem(cane)
                    
                    -- 神圣头冠(蜂后帽)
                    player.components.inventory:GiveItem(SpawnPrefab("beehat"))
                    
                    -- 信徒贡品(各种食物)
                    player.components.inventory:GiveItem(SpawnPrefab("butterflymuffin"))
                    player.components.inventory:GiveItem(SpawnPrefab("honeynuggets"))
                    player.components.inventory:GiveItem(SpawnPrefab("dragonpie"))
                    player.components.inventory:GiveItem(SpawnPrefab("taffy"))
                    player.components.inventory:GiveItem(SpawnPrefab("baconeggs"))
                    
                    -- 特殊奖励：神圣光环(发光浆果)
                    for i=1, 5 do
                        player.components.inventory:GiveItem(SpawnPrefab("wormlight"))
                    end
                    
                    -- 临时神圣光环效果
                    local light = SpawnPrefab("minerhatlight")
                    light.entity:SetParent(player.entity)
                    light.AnimState:SetMultColour(1, 0.8, 0, 0.8)
                    
                    player:DoTaskInTime(600, function()
                        if light and light:IsValid() then
                            light:Remove()
                            if player and player.components and player.components.talker then
                                player.components.talker:Say("神圣光环效果已结束！")
                            end
                        end
                    end)
                    
                    -- 增强领导能力
                    if player.components.leader then
                        player.components.leader.oldmaxfollowers = player.components.leader.maxfollowers
                        player.components.leader.maxfollowers = 40
                        
                        player:DoTaskInTime(600, function()
                            if player and player.components and player.components.leader then
                                player.components.leader.maxfollowers = player.components.leader.oldmaxfollowers or 10
                            end
                        end)
                    end
                    
                    if player.components.talker then
                        player.components.talker:Say("获得神圣光环！10分钟内你将拥有光环效果和增强的领导能力！")
                    end
                end
            end,
            reward_description = "1根神圣权杖(步行手杖)、1顶神圣头冠(蜂后帽)、5种信徒贡品(美食)、5个神圣光环(发光浆果)，以及10分钟神圣光环效果和增强的领导能力",
            special = true, -- 标记为特殊任务
            
            -- 特殊事件监听器设置函数
            setup_listeners = function(self, player)
                -- 监听跟随者变化
                player:ListenForEvent("followerchange", function(inst)
                    if player.sheep_cult_started then
                        local follower_count = 0
                        
                        -- 计算所有跟随者
                        for k, v in pairs(player.components.leader.followers) do
                            if k:HasTag("pig") or k:HasTag("rabbit") or k:HasTag("merm") then
                                follower_count = follower_count + 1
                                
                                -- 添加视觉效果给信徒
                                if not k:HasTag("cult_follower") then
                                    k:AddTag("cult_follower")
                                    
                                    -- 添加光环效果
                                    local fx = SpawnPrefab("small_puff")
                                    fx.entity:SetParent(k.entity)
                                    fx.Transform:SetPosition(0, 2, 0)
                                    
                                    -- 改变外观
                                    k.AnimState:SetMultColour(1, 0.9, 0.7, 1)
                                end
                            end
                        end
                        
                        -- 通知玩家
                        if player.components.talker then
                            player.components.talker:Say("信徒数量: " .. follower_count .. "/20")
                        end
                        
                        -- 当达到一定数量时，信徒开始崇拜玩家
                        if follower_count >= 10 and follower_count % 5 == 0 then
                            -- 信徒围绕玩家跳舞
                            for k, v in pairs(player.components.leader.followers) do
                                if k:HasTag("cult_follower") and k.sg and k.sg.GoToState then
                                    k.sg:GoToState("happy")
                                end
                            end
                            
                            -- 播放特殊音效
                            player.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/idle_med")
                            
                            -- 通知玩家
                            if player.components.talker then
                                player.components.talker:Say("信徒们开始崇拜你！")
                            end
                        end
                    end
                end)
            end
        },
        {
            name = "猎人的荣耀",
            description = "在一天内猎杀3种不同的大型生物",
            check = function(player)
                if not player.daily_boss_kills then return false end
                local count = 0
                for boss, _ in pairs(player.daily_boss_kills) do
                    count = count + 1
                end
                return count >= 3
            end,
            start = function(player)
                player.daily_boss_kills = {}
                player:ListenForEvent("killed", function(inst, data)
                    if data and data.victim then
                        if data.victim:HasTag("epic") or 
                           data.victim.prefab == "koalefant_summer" or 
                           data.victim.prefab == "koalefant_winter" or
                           data.victim.prefab == "warg" or
                           data.victim.prefab == "spat" then
                            player.daily_boss_kills[data.victim.prefab] = true
                        end
                    end
                end)
            end,
            reward = function(player)
                -- 给予猎人奖励
                player.components.inventory:GiveItem(SpawnPrefab("meat"))
                player.components.inventory:GiveItem(SpawnPrefab("meat"))
                player.components.inventory:GiveItem(SpawnPrefab("meat"))
                player.components.inventory:GiveItem(SpawnPrefab("houndstooth"))
                player.components.inventory:GiveItem(SpawnPrefab("houndstooth"))
                
                -- 临时提升伤害
                if player.components.combat then
                    local old_damage_mult = player.components.combat.externaldamagemultipliers:Get("hunter_bonus")
                    player.components.combat.externaldamagemultipliers:SetModifier("hunter_bonus", 1.5)
                    player:DoTaskInTime(300, function() -- 5分钟后恢复
                        if player.components.combat then
                            player.components.combat.externaldamagemultipliers:RemoveModifier("hunter_bonus")
                        end
                    end)
                end
            end,
            reward_description = "3个肉、2个狗牙，以及5分钟的伤害提升(+50%)"
        },
        {
            name = "工匠大师",
            description = "在一天内制作10件不同的物品",
            check = function(player)
                return player.daily_crafted_items and #player.daily_crafted_items >= 10
            end,
            start = function(player)
                player.daily_crafted_items = {}
                player:ListenForEvent("builditem", function(inst, data)
                    if data and data.item then
                        if not table.contains(player.daily_crafted_items, data.item.prefab) then
                            table.insert(player.daily_crafted_items, data.item.prefab)
                        end
                    end
                end)
                player:ListenForEvent("buildstructure", function(inst, data)
                    if data and data.item then
                        if not table.contains(player.daily_crafted_items, data.item.prefab) then
                            table.insert(player.daily_crafted_items, data.item.prefab)
                        end
                    end
                end)
            end,
            reward = function(player)
                -- 给予工匠奖励
                player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                player.components.inventory:GiveItem(SpawnPrefab("boards"))
                player.components.inventory:GiveItem(SpawnPrefab("cutstone"))
                
                -- 临时提升制作效率
                if player.components.builder then
                    local old_ingredientmod = player.components.builder.ingredientmod
                    player.components.builder.ingredientmod = 0.75 -- 减少25%材料消耗
                    player:DoTaskInTime(480, function() -- 8分钟后恢复
                        if player.components.builder then
                            player.components.builder.ingredientmod = old_ingredientmod
                        end
                    end)
                end
            end,
            reward_description = "2个金块、1个木板、1个石砖，以及8分钟的制作材料减少(25%)"
        },
        {
            name = "资源收集者",
            description = "在一天内收集50个基础资源(树枝/草/石头/木头)",
            check = function(player)
                local count = 0
                if player.daily_resources_collected then
                    for resource, amount in pairs(player.daily_resources_collected) do
                        count = count + amount
                    end
                end
                return count >= 50
            end,
            start = function(player)
                player.daily_resources_collected = {
                    twigs = 0,
                    cutgrass = 0,
                    rocks = 0,
                    log = 0
                }
                player:ListenForEvent("picksomething", function(inst, data)
                    if data and data.object and data.object.components.pickable then
                        local product = data.object.components.pickable.product
                        if player.daily_resources_collected[product] ~= nil then
                            player.daily_resources_collected[product] = player.daily_resources_collected[product] + 1
                        end
                    end
                end)
                player:ListenForEvent("finishedwork", function(inst, data)
                    if data and data.target then
                        if data.target.prefab == "rock1" or data.target.prefab == "rock2" then
                            player.daily_resources_collected.rocks = player.daily_resources_collected.rocks + 2
                        elseif data.target:HasTag("tree") then
                            player.daily_resources_collected.log = player.daily_resources_collected.log + 1
                        end
                    end
                end)
            end,
            reward = function(player)
                -- 给予资源收集者奖励
                player.components.inventory:GiveItem(SpawnPrefab("backpack"))
                
                -- 临时提升采集速度
                if player.components.workmultiplier then
                    player.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 1.5, 300)
                    player.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 1.5, 300)
                    player.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.5, 300)
                end
            end,
            reward_description = "1个背包，以及5分钟的采集速度提升(+50%)"
        },
        {
            name = "探险家",
            description = "在一天内探索10个新的地图区域",
            check = function(player)
                return player.daily_areas_discovered and player.daily_areas_discovered >= 10
            end,
            start = function(player)
                player.daily_areas_discovered = 0
                player:ListenForEvent("discoveredarea", function(inst, area)
                    player.daily_areas_discovered = (player.daily_areas_discovered or 0) + 1
                end)
            end,
            reward = function(player)
                -- 给予探险家奖励
                player.components.inventory:GiveItem(SpawnPrefab("compass"))
                player.components.inventory:GiveItem(SpawnPrefab("wormlight"))
                
                -- 临时提升移动速度
                player.components.locomotor:SetExternalSpeedMultiplier(player, "explorer_bonus", 1.4)
                player:DoTaskInTime(360, function() -- 6分钟后恢复
                    player.components.locomotor:RemoveExternalSpeedMultiplier(player, "explorer_bonus")
                end)
            end,
            reward_description = "1个指南针、1个发光浆果，以及6分钟的移动速度提升(+40%)"
        },
        {
            name = "钓鱼大师",
            description = "在一天内钓上5条鱼",
            check = function(player)
                return player.daily_fish_caught and player.daily_fish_caught >= 5
            end,
            start = function(player)
                player.daily_fish_caught = 0
                player:ListenForEvent("fishingcollect", function(inst, data)
                    player.daily_fish_caught = (player.daily_fish_caught or 0) + 1
                end)
            end,
            reward = function(player)
                -- 给予钓鱼大师奖励
                player.components.inventory:GiveItem(SpawnPrefab("fishmeat"))
                player.components.inventory:GiveItem(SpawnPrefab("fishmeat"))
                player.components.inventory:GiveItem(SpawnPrefab("fishmeat"))
                
                -- 临时提升钓鱼效率
                if player.components.fishingrod then
                    local old_lure_effectiveness = player.components.fishingrod.lure_effectiveness
                    player.components.fishingrod.lure_effectiveness = 2.0 -- 双倍钓鱼效率
                    player:DoTaskInTime(480, function() -- 8分钟后恢复
                        if player.components.fishingrod then
                            player.components.fishingrod.lure_effectiveness = old_lure_effectiveness
                        end
                    end)
                end
            end,
            reward_description = "3个鱼肉，以及8分钟的钓鱼效率提升(+100%)"
        },
        {
            name = "家园设计师",
            description = "在一天内收集5种不同的墙体材料",
            check = function(player)
                if not player.components.inventory then return false end
                
                local wall_types = {
                    "fence_item",       -- 木栅栏
                    "fence_gate_item",  -- 木门
                    "wall_hay_item",    -- 草墙
                    "wall_wood_item",   -- 木墙
                    "wall_stone_item",  -- 石墙
                    "wall_ruins_item",  -- 废料墙
                    "wall_moonrock_item" -- 月岩墙
                }
                
                local found_count = 0
                for _, wall_type in ipairs(wall_types) do
                    if player.components.inventory:FindItem(function(item) return item.prefab == wall_type end) then
                        found_count = found_count + 1
                    end
                end
                
                return found_count >= 5
            end,
            reward = function(player)
                -- 给予家园设计师奖励
                player.components.inventory:GiveItem(SpawnPrefab("wall_stone_item"))
                player.components.inventory:GiveItem(SpawnPrefab("wall_stone_item"))
                player.components.inventory:GiveItem(SpawnPrefab("wall_stone_item"))
                player.components.inventory:GiveItem(SpawnPrefab("wall_stone_item"))
                player.components.inventory:GiveItem(SpawnPrefab("wall_stone_item"))
                
                -- 临时提升建造速度
                if player.components.builder then
                    local old_buildbonus = player.components.builder.buildbonus or 1
                    player.components.builder.buildbonus = 2 -- 双倍建造速度
                    player:DoTaskInTime(360, function() -- 6分钟后恢复
                        if player.components.builder then
                            player.components.builder.buildbonus = old_buildbonus
                        end
                    end)
                end
            end,
            reward_description = "5个石墙，以及6分钟的建造速度提升(+100%)"
        },
        {
            name = "室内装饰师",
            description = "在一天内收集3种不同的家具物品",
            check = function(player)
                if not player.components.inventory then return false end
                
                local furniture_types = {
                    "homesign",        -- 木牌
                    "treasurechest",   -- 箱子
                    "dragonflychest",  -- 龙鳞箱
                    "icebox",          -- 冰箱
                    "researchlab",     -- 科学机器
                    "researchlab2",    -- 炼金引擎
                    "researchlab3",    -- 暗影操控器
                    "researchlab4",    -- 灵子分解器
                    "cartographydesk", -- 制图桌
                    "birdcage",        -- 鸟笼
                    "pottedfern",      -- 盆栽蕨类
                    "endtable",        -- 茶几
                    "dragonflyfurnace" -- 龙鳞火炉
                }
                
                local found_count = 0
                for _, furniture_type in ipairs(furniture_types) do
                    if player.components.inventory:FindItem(function(item) return item.prefab == furniture_type end) then
                        found_count = found_count + 1
                    end
                end
                
                return found_count >= 3
            end,
            reward = function(player)
                -- 给予室内装饰师奖励
                player.components.inventory:GiveItem(SpawnPrefab("pottedfern"))
                player.components.inventory:GiveItem(SpawnPrefab("homesign_item"))
                
                -- 临时提升精神恢复
                if player.components.sanity then
                    local old_modifier = player.components.sanity.neg_aura_mult
                    player.components.sanity.neg_aura_mult = 0.5 -- 减少50%负面精神光环
                    player:DoTaskInTime(480, function() -- 8分钟后恢复
                        if player.components.sanity then
                            player.components.sanity.neg_aura_mult = old_modifier
                        end
                    end)
                end
            end,
            reward_description = "1个盆栽蕨类、1个木牌，以及8分钟的负面精神光环减少(50%)"
        },
        {
            name = "地板铺设师",
            description = "在一天内收集20块地板材料",
            check = function(player)
                if not player.components.inventory then return false end
                
                local floor_types = {
                    "turf_road",        -- 卵石路
                    "turf_rocky",       -- 岩石地皮
                    "turf_forest",      -- 森林地皮
                    "turf_grass",       -- 草地地皮
                    "turf_savanna",     -- 热带草原地皮
                    "turf_dirt",        -- 泥土地皮
                    "turf_woodfloor",   -- 木地板
                    "turf_carpetfloor", -- 地毯地板
                    "turf_checkerfloor",-- 棋盘地板
                    "turf_cave",        -- 洞穴地皮
                    "turf_fungus",      -- 菌类地皮
                    "turf_fungus_red",  -- 红色菌类地皮
                    "turf_fungus_green" -- 绿色菌类地皮
                }
                
                local total_count = 0
                for _, floor_type in ipairs(floor_types) do
                    local count = player.components.inventory:CountItems(function(item) return item.prefab == floor_type end)
                    total_count = total_count + count
                end
                
                return total_count >= 20
            end,
            reward = function(player)
                -- 给予地板铺设师奖励
                player.components.inventory:GiveItem(SpawnPrefab("turf_carpetfloor"))
                player.components.inventory:GiveItem(SpawnPrefab("turf_carpetfloor"))
                player.components.inventory:GiveItem(SpawnPrefab("turf_carpetfloor"))
                player.components.inventory:GiveItem(SpawnPrefab("turf_carpetfloor"))
                player.components.inventory:GiveItem(SpawnPrefab("turf_carpetfloor"))
                
                -- 临时提升移动速度（在基地内）
                player.components.locomotor:SetExternalSpeedMultiplier(player, "floor_bonus", 1.3)
                player:DoTaskInTime(600, function() -- 10分钟后恢复
                    player.components.locomotor:RemoveExternalSpeedMultiplier(player, "floor_bonus")
                end)
            end,
            reward_description = "5块地毯地板，以及10分钟的移动速度提升(+30%)"
        },
        {
            name = "灯光设计师",
            description = "在一天内收集3种不同的照明物品",
            check = function(player)
                if not player.components.inventory then return false end
                
                local light_types = {
                    "torch",           -- 火把
                    "campfire",        -- 营火
                    "firepit",         -- 火坑
                    "lantern",         -- 提灯
                    "minerhat",        -- 矿工帽
                    "molehat",         -- 鼹鼠帽
                    "nightlight",      -- 暗夜照明灯
                    "mushroom_light",  -- 蘑菇灯
                    "mushroom_light2", -- 蘑菇灯（中）
                    "mushroom_light3"  -- 蘑菇灯（大）
                }
                
                local found_count = 0
                for _, light_type in ipairs(light_types) do
                    if player.components.inventory:FindItem(function(item) return item.prefab == light_type end) then
                        found_count = found_count + 1
                    end
                end
                
                return found_count >= 3
            end,
            reward = function(player)
                -- 给予灯光设计师奖励
                player.components.inventory:GiveItem(SpawnPrefab("lantern"))
                
                -- 临时提升夜视能力
                player.components.playervision:ForceNightVision(true)
                player:DoTaskInTime(360, function() -- 6分钟后恢复
                    player.components.playervision:ForceNightVision(false)
                end)
            end,
            reward_description = "1个提灯，以及6分钟的夜视能力"
        },
        {
            name = "救援专家",
            description = "在一天内复活3名队友",
            check = function(player)
                return player.daily_revives and player.daily_revives >= 3
            end,
            start = function(player)
                player.daily_revives = 0
                player:ListenForEvent("respawnfromghost", function(inst, data)
                    if data and data.source and data.source == player then
                        player.daily_revives = (player.daily_revives or 0) + 1
                    end
                end)
            end,
            reward = function(player)
                -- 给予救援专家奖励
                player.components.inventory:GiveItem(SpawnPrefab("amulet"))
                
                -- 临时提升生命上限
                if player.components.health then
                    local old_max = player.components.health.maxhealth
                    player.components.health:SetMaxHealth(old_max * 1.25)
                    player:DoTaskInTime(480, function() -- 8分钟后恢复
                        if player.components.health then
                            player.components.health:SetMaxHealth(old_max)
                        end
                    end)
                end
            end,
            reward_description = "1个生命护符，以及8分钟的生命上限提升(+25%)"
        },
        {
            name = "慷慨的厨师",
            description = "在一天内给其他玩家提供5次食物",
            check = function(player)
                return player.daily_food_given and player.daily_food_given >= 5
            end,
            start = function(player)
                player.daily_food_given = 0
                player:ListenForEvent("trade", function(inst, data)
                    if data and data.target and data.target:HasTag("player") and data.target ~= player then
                        if data.item and data.item.components.edible then
                            player.daily_food_given = (player.daily_food_given or 0) + 1
                        end
                    end
                end)
            end,
            reward = function(player)
                -- 给予慷慨的厨师奖励
                player.components.inventory:GiveItem(SpawnPrefab("cookbook"))
                player.components.inventory:GiveItem(SpawnPrefab("butter"))
                
                -- 临时提升烹饪效率
                if player.components.cooker then
                    local old_cooktime = player.components.cooker.cooktime
                    player.components.cooker.cooktime = old_cooktime * 0.5 -- 减少50%烹饪时间
                    player:DoTaskInTime(480, function() -- 8分钟后恢复
                        if player.components.cooker then
                            player.components.cooker.cooktime = old_cooktime
                        end
                    end)
                end
            end,
            reward_description = "1本食谱、1块黄油，以及8分钟的烹饪时间减少(50%)"
        },
        {
            name = "建筑大师",
            description = "在一天内建造3种不同的建筑物",
            check = function(player)
                return player.daily_structures_built and #player.daily_structures_built >= 3
            end,
            start = function(player)
                player.daily_structures_built = {}
                player:ListenForEvent("buildstructure", function(inst, data)
                    if data and data.item then
                        if not table.contains(player.daily_structures_built, data.item.prefab) then
                            table.insert(player.daily_structures_built, data.item.prefab)
                        end
                    end
                end)
            end,
            reward = function(player)
                -- 给予建筑大师奖励
                player.components.inventory:GiveItem(SpawnPrefab("boards"))
                player.components.inventory:GiveItem(SpawnPrefab("boards"))
                player.components.inventory:GiveItem(SpawnPrefab("cutstone"))
                player.components.inventory:GiveItem(SpawnPrefab("cutstone"))
                
                -- 临时提升建造速度
                if player.components.builder then
                    local old_buildbonus = player.components.builder.buildbonus or 1
                    player.components.builder.buildbonus = 2 -- 双倍建造速度
                    player:DoTaskInTime(360, function() -- 6分钟后恢复
                        if player.components.builder then
                            player.components.builder.buildbonus = old_buildbonus
                        end
                    end)
                end
            end,
            reward_description = "2个木板、2个石砖，以及6分钟的建造速度提升(+100%)"
        },
        {
            name = "团队治疗师",
            description = "在一天内治疗队友总计100点生命值",
            check = function(player)
                return player.daily_healing_done and player.daily_healing_done >= 100
            end,
            start = function(player)
                player.daily_healing_done = 0
                player:ListenForEvent("healed", function(inst, data)
                    if data and data.target and data.target:HasTag("player") and data.target ~= player and data.amount then
                        player.daily_healing_done = (player.daily_healing_done or 0) + data.amount
                    end
                end)
            end,
            reward = function(player)
                -- 给予团队治疗师奖励
                player.components.inventory:GiveItem(SpawnPrefab("healingsalve"))
                player.components.inventory:GiveItem(SpawnPrefab("healingsalve"))
                player.components.inventory:GiveItem(SpawnPrefab("lifeinjector"))
                
                -- 临时提升治疗效果
                player:AddTag("healer_bonus")
                player:DoTaskInTime(480, function() -- 8分钟后恢复
                    player:RemoveTag("healer_bonus")
                end)
                
                -- 添加治疗效果修改器
                local old_DoHeal = ACTIONS.HEAL.fn
                ACTIONS.HEAL.fn = function(act)
                    local result = old_DoHeal(act)
                    if act.doer and act.doer:HasTag("healer_bonus") and result and act.target ~= act.doer then
                        if act.target.components.health then
                            act.target.components.health:DoDelta(20) -- 额外治疗20点
                        end
                    end
                    return result
                end
            end,
            reward_description = "2个治疗药膏、1个生命注射器，以及8分钟的治疗效果提升(+20点)"
        }
    }
    
    -- 初始化
    self:Init()
    
    -- 可以访问全局变量
    if DAILYTASKS then
        -- 使用全局变量
        print("每日任务模组已加载")
    end
end)

function DailyTasks:Init()
    self.inst:DoPeriodicTask(1, function() self:OnUpdate() end)
    
    -- 添加事件监听器
    self.inst:ListenForEvent("finishedwork", function(inst, data)
        if data and data.target and data.target.prefab and 
           (data.target.prefab == "rock1" or 
            data.target.prefab == "rock2" or 
            data.target.prefab == "rock_flintless") then
            self.inst.daily_rocks_mined = (self.inst.daily_rocks_mined or 0) + 1
        end
    end)
    
    self.inst:ListenForEvent("fishingcollect", function(inst, data)
        self.inst.daily_fish_caught = (self.inst.daily_fish_caught or 0) + 1
    end)
    
    self.inst:ListenForEvent("killed", function(inst, data)
        if data and data.victim then
            local victim_type = data.victim.prefab
            self.inst.daily_kills[victim_type] = (self.inst.daily_kills[victim_type] or 0) + 1
        end
    end)
end

function DailyTasks:OnUpdate()
    local current_day = TheWorld.state.cycles
    
    -- 检查是否是新的一天
    if self.last_day ~= current_day then
        self.last_day = current_day
        self:NewDay()
    end
    
    -- 检查任务是否完成
    if self.config.TASK_COUNT > 1 and #self.current_tasks > 0 then
        -- 多任务模式
        for i, task in ipairs(self.current_tasks) do
            if not self.tasks_completed[i] and task.check(self.inst) then
                self:CompleteTask(i)
            end
        end
    elseif self.current_task and not self.task_completed then
        -- 单任务模式
        if self.current_task.check(self.inst) then
            self:CompleteTask()
        end
    end
end

function DailyTasks:NewDay()
    -- 重置任务状态
    self.task_completed = false
    self.tasks_completed = {}
    self.current_tasks = {}
    
    -- 重置玩家的每日统计
    self.inst.daily_kills = {}
    
    -- 其他统计数据重置...
    self.inst.daily_rocks_mined = 0
    self.inst.daily_fish_caught = 0
    self.inst.daily_items_planted = 0
    self.inst.daily_distance_walked = 0
    self.inst.daily_structures_built = {}
    self.inst.daily_bosses_killed = {}
    self.inst.daily_health_restored = 0
    self.inst.daily_sanity_restored = 0
    self.inst.daily_hunger_restored = 0
    
    -- 选择新任务
    self:GenerateTasks()
end

function DailyTasks:CompleteTask(task_index)
    if task_index then
        -- 多任务模式
        self.tasks_completed[task_index] = true
        
        -- 给予奖励
        local task = self.current_tasks[task_index]
        task.reward(self.inst)
        
        -- 通知玩家
        if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
            local reward = type(task.reward_description) == "function" and task.reward_description() or task.reward_description
            local msg = "任务 #" .. task_index .. " 完成！获得奖励: " .. reward
            self.inst.components.talker:Say(DAILYTASKS.Translate(msg))
        end
    else
        -- 单任务模式
        self.task_completed = true
        
        -- 给予奖励
        self.current_task.reward(self.inst)
        
        -- 通知玩家
        if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
            local reward = type(self.current_task.reward_description) == "function" and self.current_task.reward_description() or self.current_task.reward_description
            local msg = "任务完成！获得奖励: " .. reward
            self.inst.components.talker:Say(DAILYTASKS.Translate(msg))
        end
    end
end

function DailyTasks:GenerateTasks()
    -- 检查是否是多任务模式
    if self.config.TASK_COUNT > 1 then
        -- 多任务模式
        local available_tasks = {}
        local current_season = TheWorld.state.season
        
        -- 收集所有可用任务
        for i, task in ipairs(self.tasks) do
            -- 季节检查
            local season_ok = true
            if task.season_hint then
                if task.season_hint == "冬季出没" and current_season ~= "winter" then
                    season_ok = false
                elseif task.season_hint == "夏季出没" and current_season ~= "summer" then
                    season_ok = false
                end
            end
            
            -- 如果任务适合当前季节，添加到可用任务列表
            if season_ok then
                table.insert(available_tasks, i)
            end
        end
        
        -- 随机选择指定数量的任务
        for i = 1, self.config.TASK_COUNT do
            if #available_tasks > 0 then
                local index = math.random(1, #available_tasks)
                local task_index = available_tasks[index]
                table.remove(available_tasks, index)
                
                local task = self.tasks[task_index]
                table.insert(self.current_tasks, task)
                self.tasks_completed[i] = false
                
                -- 通知玩家新任务
                if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
                    local task_name = type(task.name) == "function" and task.name() or task.name
                    local desc = type(task.description) == "function" and task.description() or task.description
                    local reward = type(task.reward_description) == "function" and task.reward_description() or task.reward_description
                    
                    local msg = "新的每日任务 #" .. i .. ": " .. task_name .. "\n" .. desc .. "\n奖励: " .. reward
                    self.inst.components.talker:Say(DAILYTASKS.Translate(msg))
                end
                
                -- 如果任务有特殊的setup_listeners函数，调用它
                if task.setup_listeners then
                    task.setup_listeners(self, self.inst)
                end
                
                -- 如果任务有start函数，调用它
                if task.start then
                    task.start(self.inst)
                end
            end
        end
    else
        -- 单任务模式
        local available_tasks = {}
        local current_season = TheWorld.state.season
        
        for i, task in ipairs(self.tasks) do
            -- 季节检查
            local season_ok = true
            if task.season_hint then
                if task.season_hint == "冬季出没" and current_season ~= "winter" then
                    season_ok = false
                elseif task.season_hint == "夏季出没" and current_season ~= "summer" then
                    season_ok = false
                end
            end
            
            -- 如果任务适合当前季节，添加到可用任务列表
            if season_ok then
                table.insert(available_tasks, i)
            end
        end
        
        if #available_tasks > 0 then
            local task_index = available_tasks[math.random(1, #available_tasks)]
            self.current_task = self.tasks[task_index]
            
            -- 通知玩家新任务
            if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
                local task_name = type(self.current_task.name) == "function" and self.current_task.name() or self.current_task.name
                local desc = type(self.current_task.description) == "function" and self.current_task.description() or self.current_task.description
                local reward = type(self.current_task.reward_description) == "function" and self.current_task.reward_description() or self.current_task.reward_description
                
                local msg = "新的每日任务: " .. task_name .. "\n" .. desc .. "\n奖励: " .. reward
                self.inst.components.talker:Say(DAILYTASKS.Translate(msg))
            end
            
            -- 如果任务有特殊的setup_listeners函数，调用它
            if self.current_task.setup_listeners then
                self.current_task.setup_listeners(self, self.inst)
            end
            
            -- 如果任务有start函数，调用它
            if self.current_task.start then
                self.current_task.start(self.inst)
            end
        end
    end
end

return DailyTasks 