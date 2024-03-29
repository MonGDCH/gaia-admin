<?php
/*
|--------------------------------------------------------------------------
| 管理端pear配置文件
|--------------------------------------------------------------------------
| 定义管理端pear配置信息
|
*/

return [
    "menu" => [
        // 菜单数据来源
        "data"          => '/admin/nav',
        // 菜单接口的请求方式 GET / POST
        "method"        => "GET",
        // 是否同时只打开一个菜单目录
        "accordion"     => true,
        // 侧边默认折叠状态
        "collapse"      => false,
        // 是否开启多系统菜单模式
        "control"       => true,
        // 顶部菜单宽度 PX
        "controlWidth"  => 500,
        // 默认选中的菜单项，对应菜单ID
        "select"        => "1",
        // 是否开启异步菜单，false 时 data 属性设置为静态数据，true 时为后端接口
        "async"         => true
    ],
    "tab" => [
        // 是否开启多选项卡
        "enable"    => true,
        // 保持视图状态
        "keepState" => true,
        // 开启选项卡记忆
        "session"   => false,
        // 浏览器刷新时是否预加载非激活标签页
        "preload"   => false,
        // 可打开的数量, false 不限制极值
        "max"       => "20",
        // 首页
        "index"     => [
            // 标识 ID , 建议与菜单项中的 ID 一致
            "id"    => "console",
            // 页面地址
            "href"  => '/admin/console',
            // 标题
            "title" => "控制台"
        ]
    ],
    "theme" => [
        // 默认主题色，对应 colors 配置中的 ID 标识
        "defaultColor"  => "2",
        // 默认的菜单主题 dark-theme 黑 / light-theme 白
        "defaultMenu"   => "dark-theme",
        // 默认的顶部主题 dark-theme 黑 / light-theme 白
        "defaultHeader" => "light-theme",
        // 是否允许用户切换主题，false 时关闭自定义主题面板
        "allowCustom"   => true,
        // 通栏配置
        "banner"        => false
    ],
    // 主题色配置列表
    "colors" => [
        ["id" => "1", "color" => "#2d8cf0", "second" => "#ecf5ff"],
        ["id" => "2", "color" => "#36b368", "second" => "#f0f9eb"],
        ["id" => "3", "color" => "#f6ad55", "second" => "#fdf6ec"],
        ["id" => "4", "color" => "#f56c6c", "second" => "#fef0f0"],
        ["id" => "5", "color" => "#3963bc", "second" => "#ecf5ff"]
    ],
    "other" => [
        // 主页动画时长
        "keepLoad"  => "800",
        // 布局顶部主题
        "autoHead"  => false,
        // 页脚
        "footer"    => false
    ],
    'jwt' => [
        // 是否启用jwt权限控制
        'enable'        => true,
        // 缓存请求头名称，需要与jwt权限配置一致
        'tokenName'     => 'Mon-Auth-Token',
        // Token刷新URL
        'refreshURL'    => '/admin/profile/refresh',
        // Token刷新请求方式
        'refreshMethod' => 'POST',
        // 登录页URL
        'loginURL'      => '/admin/login',
        // 不需要Token的API
        'notNeedToken'  => ['/admin/login']
    ]
];
