<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\thinkOrm\Dao;
use mon\util\Instance;
use plugins\admin\validate\MessageValidate;

/**
 * 管理员站内信Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AdminMessageDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'admin_message';

    /**
     * 自动写入时间戳
     *
     * @var boolean
     */
    protected $autoWriteTimestamp = true;

    /**
     * 验证器
     *
     * @var string
     */
    protected $validate = MessageValidate::class;

    /**
     * 获取站内信信息
     *
     * @param integer $id   记录ID
     * @param integer $uid  用户ID
     * @return array
     */
    public function getInfo(int $id, int $uid): array
    {
        $field = ['u.id', 'u.message_id', 'u.send_time', 'u.read_time', 'u.status', 'm.title', 'm.uid', 'm.type', 'c.content'];
        $data = $this->alias('u')->field($field)
            ->join(MessageDao::instance()->getTable() . ' m', 'u.message_id=m.id')
            ->join(MessageContentDao::instance()->getTable() . ' c', 'm.id=c.message_id')
            ->where('u.id', $id)->where('u.uid', $uid)->get();
        if (!$data) {
            $this->error = '站内信不存在';
            return [];
        }
        if ($data['type'] == 0) {
            // 个人消息，获取发送用户信息
            $userInfo = AdminDao::instance()->where('id', $data['uid'])->field('username')->get();
            if (!$userInfo) {
                $this->error = '获取发送人信息失败';
                return [];
            }
            $user = $userInfo['username'];
            $type = '用户私信';
            $img = '';
        } else {
            // 系统信息，获取消息类型
            $typeInfo = MessageTypeDao::instance()->where('id', $data['type'])->field(['title', 'img'])->get();
            if (!$typeInfo) {
                $this->error = '获取消息类型失败';
                return [];
            }
            // 统一系统名称
            $user = '系统';
            $type = $typeInfo['title'];
            $img = $typeInfo['img'];
        }

        return [
            'id' => $data['id'],
            'message_id' => $data['message_id'],
            'send_time' => $data['send_time'],
            'read_time' => $data['read_time'],
            'title' => $data['title'],
            'type' => $data['type'],
            'content' => $data['content'],
            'status' => $data['status'],
            'send_type' => $type,
            'user' => $user,
            'img' => $img
        ];
    }

    /**
     * 查询列表
     *
     * @param array $data   查询数据
     * @param boolean $isSysMessage 是否查询系统信息
     * @return array
     */
    public function getList(array $data, bool $isSysMessage = true): array
    {
        $limit = isset($data['limit']) ? intval($data['limit']) : 10;
        $page = isset($data['page']) && is_numeric($data['page']) ? intval($data['page']) : 1;

        if ($isSysMessage) {
            // 查询系统消息
            $field = ['u.id', 'u.message_id', 'u.send_time', 'u.read_time', 'u.status', 'm.title', 'm.type', 't.title AS type_name', 't.img', "'系统' AS username"];
            $list = $this->scope('sys', $data)->page($page, $limit)->field($field)->all();
            $count = $this->scope('sys', $data)->count('u.id');
        } else {
            // 查询用户消息
            $field = ['u.id', 'u.message_id', 'u.send_time', 'u.read_time', 'u.status', 'm.title', 'm.type', "'用户私信' AS type_name", "'' AS img", 'a.username'];
            $list = $this->scope('user', $data)->page($page, $limit)->field($field)->all();
            $count = $this->scope('user', $data)->count('u.id');
        }

        return [
            'list'      => $list,
            'count'     => $count,
            'pageSize'  => $limit,
            'page'      => $page
        ];
    }

    /**
     * 查询系统信息场景
     *
     * @param \mon\thinkOrm\extend\Query $query
     * @param array $option
     * @return mixed
     */
    public function scopeSys($query, array $option)
    {
        $query->alias('u')->where('m.type', '>', 0)
            ->join(MessageDao::instance()->getTable() . ' m', 'u.message_id=m.id')
            ->join(MessageTypeDao::instance()->getTable() . ' t', 'm.type=t.id');

        return $this->parseWhere($query, $option);
    }

    /**
     * 查询用户信息场景
     *
     * @param \mon\thinkOrm\extend\Query $query
     * @param array $option
     * @return mixed
     */
    public function scopeUser($query, array $option)
    {
        $query->alias('u')->where('m.type', '=', 0)
            ->join(MessageDao::instance()->getTable() . ' m', 'u.message_id=m.id')
            ->join(AdminDao::instance()->getTable() . ' a', 'a.id=m.uid');

        return $this->parseWhere($query, $option);
    }

    /**
     * 解析查询条件
     *
     * @param \mon\thinkOrm\extend\Query $query
     * @param array $option
     * @return mixed
     */
    protected function parseWhere($query, array $option)
    {
        // ID搜索
        if (isset($option['idx']) && $this->validate()->int($option['idx'])) {
            $query->where('u.id', intval($option['idx']));
        }
        // ID搜索
        if (isset($option['uid']) && $this->validate()->int($option['uid'])) {
            $query->where('u.uid', intval($option['uid']));
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('u.status', intval($option['status']));
        }
        // 按类型
        if (isset($option['type']) && $this->validate()->int($option['type'])) {
            $query->where('m.type', intval($option['type']));
        }
        // 按标签
        if (isset($option['title']) && is_string($option['title']) && !empty($option['title'])) {
            $query->whereLike('m.title', '%' . trim($option['title']) . '%');
        }
        // 发送时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('u.send_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('u.send_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'u.send_time';
        if (isset($option['order']) && in_array($option['order'], ['id', 'send_time', 'read_time', 'status'])) {
            $order = 'u.' . $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }
}
