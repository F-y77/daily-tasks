name = "每日任务系统"
description = "为玩家提供每日任务，完成后可获得奖励"
author = "Va6gn"
version = "1.16"

forumthread = ""

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "每日任务",
    "Va6gn",
}

configuration_options = {
    {
        name = "TASK_COUNT",
        label = "每日任务数量",
        options = {
            {description = "1个任务", data = 1},
            {description = "2个任务", data = 2},
            {description = "3个任务", data = 3,hover = "默认超大份"}
        },
        default = 3
    },
    {
        name = "TASK_DIFFICULTY",
        label = "任务难度",
        options = {
            {description = "简单", data = "easy"},
            {description = "中等", data = "medium", hover = "默认值"},
            {description = "困难", data = "hard"}
        },
        default = "medium"
    },
    {
        name = "REWARD_MULTIPLIER",
        label = "奖励倍数",
        options = {
            {description = "0.5倍", data = 0.5},
            {description = "1倍", data = 1, hover = "默认值"},
            {description = "1.5倍", data = 1.5},
            {description = "2倍", data = 2}
        },
        default = 1
    },
    {
        name = "SHOW_NOTIFICATIONS",
        label = "显示通知",
        options = {
            {description = "开启", data = true, hover = "默认值"},
            {description = "关闭", data = false}
        },
        default = true
    },
    {
        name = "CHECK_TASK_KEY",
        label = "查看任务快捷键",
        options = {
            {description = "R键", data = "KEY_R", hover = "默认值"},
            {description = "R键", data = "KEY_T"},
            {description = "F键", data = "KEY_F"},
            {description = "Z键", data = "KEY_Z"},
            {description = "X键", data = "KEY_X"}
        },
        default = "KEY_R"
    },
    {
        name = "CHECK_PROGRESS_KEY",
        label = "查看进度快捷键",
        options = {
            {description = "F键", data = "KEY_F", hover = "默认值"},
            {description = "Y键", data = "KEY_Y"},
            {description = "R键", data = "KEY_R"},
            {description = "C键", data = "KEY_C"},
            {description = "V键", data = "KEY_V"}
        },
        default = "KEY_F"
    },
    {
        name = "DEVELOPER_MODE",
        label = "开发者模式",
        options = {
            {description = "关闭", data = false, hover = "禁用调试功能"},
            {description = "开启", data = true, hover = "启用F1调试功能，查看日志。"}
        },
        default = false
    }
} 