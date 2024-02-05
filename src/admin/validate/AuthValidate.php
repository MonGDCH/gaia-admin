<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\AuthEnum;

/**
 * 权限控制验证器
 *
 * Class Auth
 * @copyright 2021-03-24 mon-console
 * @version 1.0.0
 */
class AuthValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'           => ['required', 'id'],
        'name'          => ['required', 'str'],
        'pid'           => ['required', 'int', 'min:0'],
        'gid'           => ['required', 'id'],
        'title'         => ['required', 'str'],
        'status'        => ['required', 'status'],
        'remark'        => ['isset', 'str', 'maxLength:250'],
        'rules'         => ['required', 'str', 'listCheck:id'],
        'uids'          => ['required', 'str', 'listCheck:id'],
    ];

    /**
     * 错误提示信息
     *
     * @var array
     */
    public $message = [
        'idx'           => '参数异常',
        'name'          => '请输入正确的规则',
        'pid'           => '请选择对应的父级',
        'status'        => '请选择正确的状态',
        'title'         => '请输入对应的标题',
        'remark'        => '请输入合法的备注',
        'rules'         => '权限异常',
        'uids'          => '用户参数错误',
        'gid'           => '组别ID参数错误'
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        'add_rule'      => ['pid', 'name', 'title', 'status', 'remark'],
        'edit_rule'     => ['idx', 'pid', 'name', 'title', 'status',  'remark'],
        'add_group'     => ['pid', 'title'],
        'edit_group'    => ['idx', 'pid', 'title', 'rules', 'status'],
        'bind_group'    => ['idx', 'uids'],
        'unbind_group'  => ['idx', 'gid'],
    ];

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(AuthEnum::AUTH_STATUS_TITLE[$value]);
    }
}
