<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\MenuEnum;

/**
 * 菜单验证器
 *
 * Class Menu
 * @copyright 2021-03-24 mon-console
 * @version 1.0.0
 */
class MenuValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'       => ['required', 'id'],
        'type'      => ['required', 'type'],
        'openType'  => ['required', 'openType'],
        'icon'      => ['required', 'str'],
        'name'      => ['required', 'str'],
        'pid'       => ['required', 'num', 'min:0'],
        'status'    => ['required', 'status'],
        'title'     => ['required', 'str'],
        'sort'      => ['required', 'num', 'min:0', 'max:99'],
        'remark'    => ['isset', 'str', 'maxLength:250'],
    ];

    /**
     * 错误提示信息
     *
     * @var array
     */
    public $message = [
        'idx'       => '参数异常',
        'type'      => '请选择菜单类型',
        'openType'  => '请选择打开方式',
        'icon'      => '请选择对应icon',
        'name'      => '请输入正确的规则',
        'pid'       => '请选择对应的父级',
        'status'    => '请选择正确的状态',
        'title'     => '请输入对应的标题',
        'sort'      => '请输入正确的权重值(0 <= x < 100)',
        'remark'    => '请输入合法的备注',
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        // 新增菜单
        'add'   => ['icon', 'pid', 'status', 'title', 'sort', 'name', 'openType', 'type', 'remark'],
        // 编辑菜单
        'edit'  => ['icon', 'pid', 'status', 'title', 'sort', 'name', 'openType', 'type', 'remark', 'idx'],
    ];

    /**
     * 类型合法值
     *
     * @param string $value
     * @return boolean
     */
    public function type($value): bool
    {
        return isset(MenuEnum::MENU_TYPE_TITLE[$value]);
    }

    /**
     * 打开方式合法值
     *
     * @param string $value
     * @return boolean
     */
    public function openType($value): bool
    {
        return isset(MenuEnum::MENU_OPEN_TYPE_TITLE[$value]);
    }

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(MenuEnum::MENU_STATUS_TITLE[$value]);
    }
}
