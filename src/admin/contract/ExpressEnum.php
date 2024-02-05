<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 物流相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface ExpressEnum
{
    /**
     * 状态
     * 
     * @var array
     */
    const EXPRESS_STATUS = [
        // 禁用
        'disable'   => 0,
        // 正常
        'enable'    => 1,
    ];

    /**
     * 状态名称
     * 
     * @var array
     */
    const EXPRESS_STATUS_TITLE = [
        // 禁用
        self::EXPRESS_STATUS['disable']  => '禁用',
        // 正常
        self::EXPRESS_STATUS['enable']   => '正常',
    ];
}
