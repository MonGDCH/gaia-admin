<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 权限相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface AuthEnum
{
    /**
     * 权限状态
     * 
     * @var array
     */
    const AUTH_STATUS = [
        // 禁用
        'disable'   => 0,
        // 正常
        'enable'    => 1,
    ];

    /**
     * 权限状态名称
     * 
     * @var array
     */
    const AUTH_STATUS_TITLE = [
        // 禁用
        self::AUTH_STATUS['disable']  => '禁用',
        // 正常
        self::AUTH_STATUS['enable']   => '正常',
    ];
}
