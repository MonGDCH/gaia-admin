<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\RegionEnum;

/**
 * 省市地区验证器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class RegionValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'       => ['required', 'id'],
        'pid'       => ['required', 'int', 'min:0'],
        'type'      => ['required', 'in:0,1,2'],
        'name'      => ['required', 'str'],
        'code'      => ['required', 'str'],
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
        'pid'       => '请选择对应的父级',
        'type'      => '请选择类型',
        'name'      => '请输入正确的规则',
        'code'      => '请输入地区编号',
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
        'add'      => ['pid', 'status', 'code', 'sort', 'name',  'type'],
        // 编辑
        'edit'     => ['pid', 'status', 'code', 'sort', 'name',  'type', 'idx'],
    ];

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(RegionEnum::REGION_STATUS_TITLE[$value]);
    }
}
