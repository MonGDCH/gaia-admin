<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 站内信相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface MessageEnum
{

    /**
     * 站内信状态
     * 
     * @var array
     */
    const MESSAGE_STATUS = [
        // 已回收
        'remove'    => 0,
        // 草稿
        'draft'     => 1,
        // 已发送
        'publish'   => 2,
    ];

    /**
     * 站内信状态名称
     * 
     * @var array
     */
    const MESSAGE_STATUS_TITLE = [
        // 已回收
        self::MESSAGE_STATUS['remove']  => '已回收',
        // 草稿
        self::MESSAGE_STATUS['draft']   => '草稿',
        // 已发送
        self::MESSAGE_STATUS['publish'] => '已发送',
    ];

    /**
     * 站内信类型状态
     * 
     * @var array
     */
    const MESSAGE_TYPE_STATUS = [
        // 禁用
        'disable'   => 0,
        // 正常
        'enable'    => 1,
    ];

    /**
     * 站内信类型状态名称
     * 
     * @var array
     */
    const MESSAGE_TYPE_STATUS_TITLE = [
        // 禁用
        self::MESSAGE_TYPE_STATUS['disable']    => '禁用',
        // 正常
        self::MESSAGE_TYPE_STATUS['enable']     => '正常',
    ];

    /**
     * 站内信读取状态
     * 
     * @var array
     */
    const MESSAGE_READ_STATUS = [
        // 未读
        'unread'    => 0,
        // 已读
        'read'      => 1,
    ];

    /**
     * 站内信读取状态名称
     * 
     * @var array
     */
    const MESSAGE_READ_STATUS_TITLE = [
        // 未读
        self::MESSAGE_READ_STATUS['unread'] => '未读',
        // 已读
        self::MESSAGE_READ_STATUS['read']   => '已读',
    ];

    /**
     * 站内信发送类型状态
     * 
     * @var array
     */
    const MESSAGE_SEND_TYPE = [
        // 全部
        'all'   => 0,
        // 指定用户
        'user'  => 1,
        // 指定角色用户
        'role'  => 2,
        // 指定角色组别
        'group' => 3,
    ];

    /**
     * 站内信发送类型状态名称
     * 
     * @var array
     */
    const MESSAGE_SEND_TYPE_TITLE = [
        // 全部
        self::MESSAGE_SEND_TYPE['all']      => '全部用户',
        // 指定用户
        self::MESSAGE_SEND_TYPE['user']     => '指定用户',
        // 指定角色用户
        self::MESSAGE_SEND_TYPE['role']     => '指定角色用户',
        // 指定角色组别
        self::MESSAGE_SEND_TYPE['group']    => '指定角色组别',
    ];
}
