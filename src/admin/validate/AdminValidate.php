<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\AdminEnum;

/**
 * 管理员验证器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AdminValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'           => ['required', 'id'],
        'username'      => ['required', 'str', 'maxLength:12', 'minLength:3'],
        'password'      => ['required', 'str', 'maxLength:16', 'minLength:6'],
        'avatar'        => ['required', 'str', 'avatar:jpg,jpeg,png'],
        'status'        => ['required', 'status'],
        'deadline'      => ['isset', 'str', 'deadline'],
        'sender'        => ['required', 'in:0,1'],
        'receiver'      => ['required', 'in:0,1'],
    ];

    /**
     * 错误提示信息
     *
     * @var array
     */
    public $message = [
        'idx'           => '参数异常',
        'username'      => [
            'required'  => '用户名必须',
            'maxLength' => '用户名长度不能超过12',
            'minLength' => '用户名长度不能小于3',
        ],
        'password'      => [
            'required'  => '密码必须',
            'maxLength' => '密码长度不能超过16',
            'minLength' => '密码长度不能小于6',
        ],
        'avatar'        => '头像只允许使用jpg,jpeg,png格式',
        'status'        => '无效的用户状态',
        'deadline'      => '无效的过期时间',
        'sender'        => '请选择是否允许发送私信',
        'receiver'      => '请选择是否接收私信',
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        'login'     => ['username', 'password', 'ip'],
        'add'       => ['username', 'password', 'avatar', 'deadline', 'sender', 'receiver', 'status'],
        'edit'      => ['idx', 'deadline', 'sender', 'receiver'],
        'pwd'       => ['idx', 'password'],
        'password'  => ['password'],
        'status'    => ['idx', 'status']
    ];

    /**
     * 自定义验证头像后缀
     *
     * @param  string $val
     * @param  string $rule
     * @return boolean
     */
    public function avatar(string $val, string $rule): bool
    {
        // 获取文件后缀
        $img = explode(".", $val);
        $ext = $img[count($img) - 1];
        $rules = explode(",", $rule);

        return in_array($ext, $rules);
    }

    /**
     * 验证过期时间
     *
     * @param string $val
     * @return bool
     */
    public function deadline(string $val): bool
    {
        return empty($val) || $this->date($val);
    }

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(AdminEnum::ADMIN_STATUS_TITLE[$value]);
    }
}
