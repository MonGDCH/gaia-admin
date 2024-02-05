<?php

declare(strict_types=1);

namespace plugins\admin\validate;

use mon\util\Validate;
use plugins\admin\contract\MessageEnum;

/**
 * 站内信验证器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageValidate extends Validate
{
    /**
     * 验证规则
     *
     * @var array
     */
    public $rule = [
        'idx'           => ['required', 'id'],
        'type'          => ['required', 'id'],
        'title'         => ['required', 'str', 'maxLength:200'],
        'content'       => ['required', 'str'],
        'img'           => ['required', 'str'],
        'remark'        => ['isset', 'str', 'maxLength:250'],
        'status'        => ['required', 'status'],
        'username'      => ['required', 'str'],
    ];

    /**
     * 错误提示信息
     *
     * @var array
     */
    public $message = [
        'idx'           => '参数异常',
        'type'          => '请选择消息类型',
        'title'         => [
            'required'  => '标题必须',
            'maxLength' => '标题长度不能超过200',
        ],
        'content'       => '请输入消息内容',
        'img'           => '请上传选择图标',
        'remark'        => '备注长度不能超过250',
        'status'        => '无效的状态',
        'username'      => '请输入收件人名称',
    ];

    /**
     * 验证场景
     *
     * @var array
     */
    public $scope = [
        // 新增消息类型
        'add_type'      => ['title', 'img', 'remark', 'status'],
        // 修改消息类型
        'edit_type'     => ['idx', 'title', 'img', 'remark', 'status'],
        // 新增站内信
        'add_message'   => ['type', 'title', 'content'],
        // 编辑站内信
        'edit_message'  => ['idx', 'type', 'title', 'content'],
        // 删除回复站内信
        'status'        => ['idx', 'status'],
        // 用户发送站内信
        'send_letter'   => ['title', 'content', 'username']
    ];

    /**
     * 状态合法值
     *
     * @param string $value
     * @return boolean
     */
    public function status($value): bool
    {
        return isset(MessageEnum::MESSAGE_STATUS_TITLE[$value]);
    }
}
