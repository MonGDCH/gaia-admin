<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 菜单相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface MenuEnum
{
    /**
     * 菜单状态
     * 
     * @var array
     */
    const MENU_STATUS = [
        // 禁用
        'disable'   => 0,
        // 正常
        'enable'    => 1,
    ];

    /**
     * 菜单状态名称
     * 
     * @var array
     */
    const MENU_STATUS_TITLE = [
        // 禁用
        self::MENU_STATUS['disable']   => '禁用',
        // 正常
        self::MENU_STATUS['enable']    => '正常',
    ];

    /**
     * 菜单类型
     * 
     * @var array
     */
    const MENU_TYPE = [
        // 目录
        'dir'   => 0,
        // 菜单
        'link'  => 1
    ];

    /**
     * 菜单类型名称
     * 
     * @var array
     */
    const MENU_TYPE_TITLE = [
        // 目录
        self::MENU_TYPE['dir']  => '目录',
        // 菜单
        self::MENU_TYPE['link'] => '菜单',
    ];

    /**
     * 菜单类型
     * 
     * @var array
     */
    const MENU_OPEN_TYPE = [
        // 框架内
        '_iframe'   => 0,
        // 新窗口
        '_blank'    => 1
    ];

    /**
     * 菜单类型名称
     * 
     * @var array
     */
    const MENU_OPEN_TYPE_TITLE = [
        // 框架内
        self::MENU_OPEN_TYPE['_iframe'] => '框架内',
        // 新窗口
        self::MENU_OPEN_TYPE['_blank']  => '新窗口',
    ];

    /**
     * 菜单类型名称
     * 
     * @var array
     */
    const MENU_OPEN_TYPE_MARK = [
        // 框架内
        self::MENU_OPEN_TYPE['_iframe'] => '_iframe',
        // 新窗口
        self::MENU_OPEN_TYPE['_blank']  => '_blank',
    ];
}
