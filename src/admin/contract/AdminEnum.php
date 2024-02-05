<?php

declare(strict_types=1);

namespace plugins\admin\contract;

/**
 * 管理员相关枚举属性
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
interface AdminEnum
{
    /**
     * 管理员状态
     * 
     * @var array
     */
    const ADMIN_STATUS = [
        // 禁用
        'disable'   => 0,
        // 正常
        'enable'    => 1,
    ];

    /**
     * 管理员状态名称
     * 
     * @var array
     */
    const ADMIN_STATUS_TITLE = [
        // 禁用
        self::ADMIN_STATUS['disable']   => '禁用',
        // 正常
        self::ADMIN_STATUS['enable']    => '正常',
    ];

    /**
     * 登录日志类型
     * 
     * @var array
     */
    const LOGIN_LOG_TYPE = [
        // 登出
        'logout'    => 0,
        // 登录成功
        'success'   => 1,
        // 密码错误
        'pwd_faild' => 2,
    ];

    /**
     * 登录日志类型描述
     * 
     * @var array
     */
    const LOGIN_LOG_TYPE_TITLE = [
        // 类方法任务
        self::LOGIN_LOG_TYPE['logout']      => '登出',
        // URL任务
        self::LOGIN_LOG_TYPE['success']     => '登录成功',
        // shell任务
        self::LOGIN_LOG_TYPE['pwd_faild']   => '密码错误',
    ];
}
