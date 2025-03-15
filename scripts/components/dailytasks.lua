local DailyTasks = Class(function(self, inst)
    self.inst = inst
    self.current_task = nil
    self.current_tasks = {}
    self.tasks_completed = {}
    self.task_completed = false
    self.last_day = nil
    
    -- 获取配置
    self.config = DAILYTASKS.CONFIG
    
    -- 初始化玩家的每日统计
    self.inst.daily_kills = {}
    self.inst.daily_trees_chopped = 0
    self.inst.daily_rocks_mined = 0
    self.inst.daily_fish_caught = 0
    self.inst.daily_foods_cooked = 0
    self.inst.daily_items_collected = {}
    self.inst.daily_items_planted = 0
    self.inst.daily_distance_walked = 0
    self.inst.daily_structures_built = {}
    self.inst.daily_items_crafted = {}
    self.inst.daily_bosses_killed = {}
    self.inst.daily_health_restored = 0
    self.inst.daily_sanity_restored = 0
    self.inst.daily_hunger_restored = 0
    
    -- 任务列表
    self.tasks = {
        -- 采集任务
        {
            name = "采集浆果任务",
            description = function() 
                local count = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个浆果" 
            end,
            check = function(player) 
                local required = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                if player.components.inventory then
                    local count = 0
                    local items = player.components.inventory:FindItems(function(item) 
                        return item.prefab == "berries" or item.prefab == "berries_cooked"
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
                        player.components.inventory:GiveItem(SpawnPrefab("goldnugget"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个金块"
            end
        },
        {
            name = "采集胡萝卜任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个胡萝卜" 
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
                return count .. "个肉"
            end
        },
        {
            name = "采集芦苇任务",
            description = function() 
                local count = math.ceil(10 * self.config.DIFFICULTY_MULTIPLIER)
                return "采集" .. count .. "个芦苇" 
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
                return count .. "个莎草纸"
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
        
        -- 砍树任务
        {
            name = "砍树任务",
            description = function() 
                local count = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                return "砍倒" .. count .. "棵树" 
            end,
            check = function(player)
                local required = math.ceil(5 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_trees_chopped and player.daily_trees_chopped >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("log"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(5 * self.config.REWARD_MULTIPLIER)
                return count .. "个木头"
            end
        },
        {
            name = "砍松树任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "砍倒" .. count .. "棵松树" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_trees_chopped and player.daily_trees_chopped >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("pinecone"))
                    end
                    for i=1, count do
                        player.components.inventory:GiveItem(SpawnPrefab("log"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(2 * self.config.REWARD_MULTIPLIER)
                return count .. "个松果和" .. count .. "个木头"
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
                    local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                    player.components.inventory:GiveItem(SpawnPrefab("nitre"))
                    for i=1, count*2 do
                        player.components.inventory:GiveItem(SpawnPrefab("flint"))
                    end
                end
            end,
            reward_description = function()
                local count = math.ceil(1 * self.config.REWARD_MULTIPLIER)
                return "1个硝石和" .. count*2 .. "个燧石"
            end
        },
        {
            name = "采金任务",
            description = function() 
                local count = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return "开采" .. count .. "块金矿" 
            end,
            check = function(player)
                local required = math.ceil(1 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_gold_mined and player.daily_gold_mined >= required
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
            description = "钓上一条大鱼",
            check = function(player)
                return player.daily_big_fish_caught and player.daily_big_fish_caught >= 1
            end,
            reward = function(player)
                if player.components.inventory then
                    player.components.inventory:GiveItem(SpawnPrefab("fishmeat_cooked"))
                    player.components.inventory:GiveItem(SpawnPrefab("fishmeat_cooked"))
                    player.components.inventory:GiveItem(SpawnPrefab("fishmeat_cooked"))
                end
            end,
            reward_description = "3个熟鱼肉"
        },
        
        -- 烹饪任务
        {
            name = "烹饪任务",
            description = function() 
                local count = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return "烹饪" .. count .. "个食物" 
            end,
            check = function(player)
                local required = math.ceil(3 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_foods_cooked and player.daily_foods_cooked >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local food = SpawnPrefab("meatballs")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个肉丸"
        },
        {
            name = "烹饪高级食物任务",
            description = "烹饪一个高级食物",
            check = function(player)
                return player.daily_gourmet_foods_cooked and player.daily_gourmet_foods_cooked >= 1
            end,
            reward = function(player)
                if player.components.inventory then
                    local food = SpawnPrefab("honeynuggets")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个蜜汁火腿"
        },
        {
            name = "烹饪肉类食物任务",
            description = function() 
                local count = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return "烹饪" .. count .. "个含肉食物" 
            end,
            check = function(player)
                local required = math.ceil(2 * self.config.DIFFICULTY_MULTIPLIER)
                return player.daily_meat_foods_cooked and player.daily_meat_foods_cooked >= required
            end,
            reward = function(player)
                if player.components.inventory then
                    local food = SpawnPrefab("meatballs")
                    if food then
                        player.components.inventory:GiveItem(food)
                    end
                end
            end,
            reward_description = "1个肉丸"
        },
        
        -- 生存任务
        {
            name = "生存任务",
            description = "存活一整天",
            check = function(player)
                return true -- 这个任务会在新的一天自动完成
            end,
            reward = function(player)
                if player.components.inventory then
                    player.components.inventory:GiveItem(SpawnPrefab("healingsalve"))
                end
            end,
            reward_description = "1个治疗药膏"
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
    
    self.inst:ListenForEvent("performaction", function(inst, data)
        if data and data.action and data.action.id == "CHOP" and 
           data.target and data.target:HasTag("tree") then
            -- 树木砍伐事件已经在这里处理
        end
    end)
    
    self.inst:ListenForEvent("killed", function(inst, data)
        if data and data.victim then
            local victim_type = data.victim.prefab
            self.inst.daily_kills[victim_type] = (self.inst.daily_kills[victim_type] or 0) + 1
        end
    end)
    
    self.inst:ListenForEvent("donecooking", function(inst, data)
        print("完成烹饪!")
        if not inst.daily_foods_cooked then
            inst.daily_foods_cooked = 0
        end
        inst.daily_foods_cooked = inst.daily_foods_cooked + 1
        print("已烹饪食物数量: " .. inst.daily_foods_cooked)
    end)

    -- 添加额外的烹饪事件监听
    self.inst:ListenForEvent("stewer_cook", function(inst, data)
        print("使用烹饪锅烹饪!")
        if not inst.daily_foods_cooked then
            inst.daily_foods_cooked = 0
        end
        inst.daily_foods_cooked = inst.daily_foods_cooked + 1
        print("已烹饪食物数量: " .. inst.daily_foods_cooked)
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
    else if self.current_task and not self.task_completed then
        -- 单任务模式
        if self.current_task.check(self.inst) then
            self:CompleteTask()
        end
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
    self.inst.daily_trees_chopped = 0
    self.inst.daily_rocks_mined = 0
    self.inst.daily_fish_caught = 0
    self.inst.daily_foods_cooked = 0
    
    -- 选择新任务
    if self.config.TASK_COUNT > 1 then
        -- 多任务模式
        local available_tasks = {}
        for i, task in ipairs(self.tasks) do
            table.insert(available_tasks, i)
        end
        
        for i=1, math.min(self.config.TASK_COUNT, #self.tasks) do
            if #available_tasks > 0 then
                local index = math.random(1, #available_tasks)
                local task_index = available_tasks[index]
                table.remove(available_tasks, index)
                
                local task = self.tasks[task_index]
                table.insert(self.current_tasks, task)
                self.tasks_completed[i] = false
                
                -- 通知玩家新任务
                if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
                    local desc = type(task.description) == "function" and task.description() or task.description
                    local reward = type(task.reward_description) == "function" and task.reward_description() or task.reward_description
                    self.inst.components.talker:Say("新的每日任务 #" .. i .. ": " .. task.name .. "\n" .. desc .. "\n奖励: " .. reward)
                end
            end
        end
    else
        -- 单任务模式（兼容旧版）
        local task_index = math.random(1, #self.tasks)
        self.current_task = self.tasks[task_index]
        
        -- 通知玩家新任务
        if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
            local desc = type(self.current_task.description) == "function" and self.current_task.description() or self.current_task.description
            local reward = type(self.current_task.reward_description) == "function" and self.current_task.reward_description() or self.current_task.reward_description
            self.inst.components.talker:Say("新的每日任务: " .. self.current_task.name .. "\n" .. desc .. "\n奖励: " .. reward)
        end
    end
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
            self.inst.components.talker:Say("任务 #" .. task_index .. " 完成！获得奖励: " .. reward)
        end
    else
        -- 单任务模式
        self.task_completed = true
        
        -- 给予奖励
        self.current_task.reward(self.inst)
        
        -- 通知玩家
        if self.config.SHOW_NOTIFICATIONS and self.inst.components.talker then
            local reward = type(self.current_task.reward_description) == "function" and self.current_task.reward_description() or self.current_task.reward_description
            self.inst.components.talker:Say("任务完成！获得奖励: " .. reward)
        end
    end
end

return DailyTasks 