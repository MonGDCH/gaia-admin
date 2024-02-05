<?php

/*
|--------------------------------------------------------------------------
| 定时任务配置文件
|--------------------------------------------------------------------------
| 定义定时任务配置信息
|
*/


return [
    // 启用
    'enable'        => env('CRON_SERVER_ENABLE', true),
    // 业务锁缓存前缀
    'lock_prefix'   => env('CRON_LOCK_PREFIX', 'mon_crontab_'),
    // 业务锁缓存时间
    'lock_expire'   => env('CRON_LOCK_EXPIRE', 600),
    // 日志
    'log'           => [
        // 解析器
        'format'    => [
            // 类名
            'handler'   => \mon\log\format\LineFormat::class,
            // 配置信息
            'config'    => [
                // 日志是否包含级别
                'level'         => true,
                // 日志是否包含时间
                'date'          => true,
                // 时间格式，启用日志时间时有效
                'date_format'   => 'Y-m-d H:i:s',
                // 是否启用日志追踪
                'trace'         => false,
                // 追踪层级，启用日志追踪时有效
                'layer'         => 3
            ]
        ],
        // 记录器
        'record'    => [
            // 类名
            'handler'   => \mon\log\record\FileRecord::class,
            // 配置信息
            'config'    => [
                // 是否自动写入文件
                'save'      => true,
                // 写入文件后，清除缓存日志
                'clear'     => true,
                // 日志名称，空则使用当前日期作为名称       
                'logName'   => '',
                // 日志文件大小
                'maxSize'   => 20480000,
                // 日志目录
                'logPath'   => RUNTIME_PATH . DIRECTORY_SEPARATOR . 'log' . DIRECTORY_SEPARATOR . 'crontab',
                // 日志滚动卷数   
                'rollNum'   => 3
            ]
        ]
    ]
];
