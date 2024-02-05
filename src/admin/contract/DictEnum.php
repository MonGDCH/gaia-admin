<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 数据字典相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface DictEnum
{
    /**
     * 字典组名
     *
     * @var string
     */
    const DICT_NAME = 'dictionary';

    /**
     * 字典状态
     * 
     * @var array
     */
    const DICT_STATUS = [
        // 禁用
        'disable'   => 0,
        // 正常
        'enable'    => 1,
    ];

    /**
     * 字典状态名称
     * 
     * @var array
     */
    const DICT_STATUS_TITLE = [
        // 禁用
        self::DICT_STATUS['disable']   => '禁用',
        // 正常
        self::DICT_STATUS['enable']    => '正常',
    ];
}
