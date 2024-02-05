<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\ExpressEnum;

/**
 * 物流公司验证器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class ExpressValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'       => ['required', 'id'],
        'name'      => ['required', 'str'],
        'code'      => ['required', 'str'],
        'remark'    => ['isset', 'str'],
        'sort'      => ['required', 'int', 'min:0', 'max:99'],
        'status'    => ['required', 'status'],
    ];

    /**
     * 错误提示信息
     *
     * @var array
     */
    public $message = [
        'idx'       => '参数异常',
        'name'      => '请输入名称',
        'code'      => '请输入编号',
        'remark'    => '请输入合法的备注',
        'sort'      => '请输入排序权重',
        'status'    => '请选择正确的状态',
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        // 新增
        'add'      => ['remark', 'status', 'code', 'sort', 'name'],
        // 编辑
        'edit'     => ['remark', 'status', 'code', 'sort', 'name', 'idx'],
    ];

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(ExpressEnum::EXPRESS_STATUS_TITLE[$value]);
    }
}
