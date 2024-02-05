<?php

/*
|--------------------------------------------------------------------------
| 后台管理端配置文件
|--------------------------------------------------------------------------
| 定义管理端及管理员配置信息
|
*/

return [
    // 系统版本
    'version'           => '20231215',
    // URL根路径
    'root_path'         => '/admin',
    // 登录态session
    'login_key'         => 'admin_info',
    // 不允许修改组别ID
    'supper_group'      => [1],
    // 不允许修改管理员ID
    'supper_admin'      => [1],
    // 过期天数距离多少天提示
    'deadline_tips'     => 3,
    // 单点登录
    'sso'          => [
        // 开启单点登录
        'enable'    => true,
        // 开启单点登录后，仍可以多点登录的用户ID
        'filter'    => [],
    ],
    // 登录失败次数限制
    'login_faild' => [
        // 账号登录失败次数
        'account_error_limit'   => 5,
        // IP登录失败次数
        'ip_error_limit'        => 8,
        // 间隔时间多少分钟
        'login_gap'             => 10,
    ],
    // 数据备份
    'migrate'       => [
        // 数据库备份路径
        'path'      => RUNTIME_PATH . '/database/',
        // 数据库备份卷大小
        'part'      => 20971520,
        // 数据库备份文件是否启用压缩 0不压缩 1 压缩
        'compress'  => 1,
        // 压缩级别
        'level'     => 5,
        // 数据库配置
        'db'        => [
            // 数据库类型
            'type'          => env('DB_TYPE', 'mysql'),
            // 服务器地址
            'host'          => env('DB_HOST', '127.0.0.1'),
            // 数据库名
            'database'      => env('DB_NAME', 'gaia-plugins'),
            // 用户名
            'username'      => env('DB_USER', 'root'),
            // 密码
            'password'      => env('DB_PASSWORD', '123456'),
            // 端口
            'port'          => env('DB_PORT', 3306)
        ]
    ],
];
