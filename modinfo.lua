name = "每日任务系统"
description = "为玩家提供每日任务，完成后可获得奖励"
author = "凌（Va6gn）"
version = "1.2.4"

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
    "凌"
}

configuration_options = {
    {
        name = "LANGUAGE",
        label = "语言/Language",
        hover = "选择语言/Select language",
        options = {
            {description = "中文", data = "zh", hover = "使用中文,这是默认语言。"},
            {description = "English", data = "en", hover = "Use English,this is test language."}
        },
        default = "zh"
    },
    {
        name = "TASK_COUNT",
        label = "每日任务数量",
        options = {
            {description = "1个任务", data = 1},
            {description = "2个任务", data = 2},
            {description = "3个任务", data = 3, hover = "过去的默认值"},
            {description = "4个任务", data = 4},
            {description = "5个任务", data = 5, hover = "默认超多任务"}
        },
        default = 5
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
            {description = "2倍", data = 2},
            {description = "2.5倍", data = 2.5},
            {description = "3倍", data = 3},
            {description = "3.5倍", data = 3.5},
            {description = "4倍", data = 4},
            {description = "4.5倍", data = 4.5},
            {description = "5倍", data = 5}
        },
        default = 2
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
        label = "查看任务快捷键，可以关闭",
        options = {
            {description = "R键", data = "KEY_R", hover = "默认值"},
            {description = "T键", data = "KEY_T"},
            {description = "F键", data = "KEY_F"},
            {description = "Z键", data = "KEY_Z"},
            {description = "X键", data = "KEY_X"},
            {description = "C键", data = "KEY_C"},
            {description = "V键", data = "KEY_V"},
            {description = "B键", data = "KEY_B"},
            {description = "N键", data = "KEY_N"},
            {description = "M键", data = "KEY_M"},
            {description = "关闭", data = "DISABLED", hover = "关闭快捷键"}
        },
        default = "KEY_R"
    },
    {
        name = "CHECK_PROGRESS_KEY",
        label = "查看进度快捷键，可以关闭",
        options = {
            {description = "F键", data = "KEY_F"},
            {description = "Y键", data = "KEY_Y"},
            {description = "R键", data = "KEY_R"},
            {description = "C键", data = "KEY_C"},
            {description = "V键", data = "KEY_V", hover = "默认值"},
            {description = "B键", data = "KEY_B"},
            {description = "N键", data = "KEY_N"},
            {description = "M键", data = "KEY_M"},
            {description = "关闭", data = "DISABLED", hover = "关闭快捷键"}
        },
        default = "KEY_V"
    }
} 