<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;

/**
 * 表单设计验证器
 *
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class FormDesignValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'       => ['required', 'id'],
        'title'     => ['required', 'str'],
        'remark'    => ['isset', 'str', 'maxLength:250'],
        'align'     => ['required', 'int', 'in:0,1'],
        'config'    => ['required', 'json'],
        'status'    => ['required', 'in:0,1'],
    ];

    /**
     * 错误提示信息
     *
     * @var array
     */
    public $message = [
        'idx'       => '参数异常',
        'title'     => '请输入表单名称',
        'remark'    => '请输入合法的备注',
        'align'     => '请选择表单对齐方式',
        'config'    => '表单设计参数异常',
        'status'    => '请选择正确的状态',
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        'add'       => ['title', 'remark', 'align', 'config'],
        'edit'      => ['idx', 'title', 'remark', 'align', 'config'],
        'status'    => ['idx', 'status'],
    ];
}
