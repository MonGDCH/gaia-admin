<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 省份城市相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface RegionEnum
{
    /**
     * 状态
     * 
     * @var array
     */
    const REGION_STATUS = [
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
    const REGION_STATUS_TITLE = [
        // 禁用
        self::REGION_STATUS['disable']  => '禁用',
        // 正常
        self::REGION_STATUS['enable']   => '正常',
    ];

    /**
     * 类型
     * 
     * @var array
     */
    const REGION_TYPE = [
        // 省份
        'province'  => 0,
        // 城市
        'citie'     => 1,
        // 县区
        'area'      => 2,
    ];

    /**
     * 类型名称
     * 
     * @var array
     */
    const REGION_TYPE_TITLE = [
        // 省份
        self::REGION_TYPE['province']   => '省份',
        // 城市
        self::REGION_TYPE['citie']      => '城市',
        // 县区
        self::REGION_TYPE['area']       => '县区',
    ];
}
