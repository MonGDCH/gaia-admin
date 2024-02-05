<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\CrontabEnum;

/**
 * 定时任务验证器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CrontabValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'       => ['required', 'id'],
        'title'     => ['required', 'str'],
        'type'      => ['required', 'type'],
        'rule'      => ['required', 'str'],
        'target'    => ['required', 'str'],
        'params'    => ['isset', 'str'],
        'remark'    => ['isset', 'str'],
        'sort'      => ['required', 'int', 'min:0'],
        'singleton' => ['required', 'singleton'],
        'status'    => ['required', 'status'],
        'savelog'   => ['required', 'savelog']
    ];

    /**
     * 错误描述
     *
     * @var array
     */
    public $message = [
        'idx'       => '参数异常',
        'title'     => '请输入任务名称',
        'type'      => '未支持的任务类型',
        'rule'      => '请输入任务规则',
        'target'    => '请输入任务目标',
        'params'    => '请输入任务参数',
        'remark'    => '请输入任务备注',
        'sort'      => '请输入排序权重',
        'singleton' => '请选择是否单次运行',
        'status'    => '请选择合法的状态',
        'savelog'   => '请选择是否记录日志'
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        // 新增
        'add'       => ['type', 'title', 'rule', 'target', 'params', 'remark', 'sort', 'singleton', 'status', 'savelog'],
        // 修改
        'edit'      => ['idx', 'type', 'title', 'rule', 'target', 'params', 'remark', 'sort', 'singleton', 'status', 'savelog'],
    ];

    /**
     * 验证类型合法值
     *
     * @param string $value
     * @return boolean
     */
    public function type($value): bool
    {
        return isset(CrontabEnum::TASK_TYPE_TITLE[$value]);
    }

    /**
     * 验证单次执行合法值
     *
     * @param string $value
     * @return boolean
     */
    public function singleton($value): bool
    {
        return isset(CrontabEnum::SINGLETON_STATUS_TITLE[$value]);
    }

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(CrontabEnum::TASK_STATUS_TITLE[$value]);
    }

    /**
     * 记录日志合法值
     *
     * @param string $value
     * @return boolean
     */
    public function savelog($value): bool
    {
        return isset(CrontabEnum::TASK_LOG_TITLE[$value]);
    }
}
