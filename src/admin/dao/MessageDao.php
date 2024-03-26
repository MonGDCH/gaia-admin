<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\contract\MessageEnum;
use plugins\admin\validate\MessageValidate;

/**
 * 站内信Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'message';

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
     * 新增
     *
     * @param array $data
     * @param integer $adminID
     * @return integer
     */
    public function add(array $data, int $adminID): int
    {
        $check = $this->validate()->data($data)->scope('add_message')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add message');
            $data['uid'] = $adminID;
            $message_id = $this->allowField(['type', 'title', 'uid'])->save($data, true, true);
            if (!$message_id) {
                $this->rollback();
                $this->error = '添加站内信失败';
                return 0;
            }

            $save = MessageContentDao::instance()->add($message_id, $data['content']);
            if (!$save) {
                $this->rollback();
                $this->error = MessageContentDao::instance()->getError();
                return 0;
            }

            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '添加站内信',
                    'content' => '添加站内信: ' . $data['title'] . ', ID: ' . $message_id,
                    'sid' => $message_id
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                    return 0;
                }
            }

            $this->commit();
            return $message_id;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '添加站内信异常';
            Logger::instance()->channel()->error('Add message exception. msg: ' . $e->getMessage());
            return 0;
        }
    }

    /**
     * 编辑
     *
     * @param array $data
     * @param integer $adminID
     * @return boolean
     */
    public function edit(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('edit_message')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $info = $this->where('id', $data['idx'])->get();
        if (!$info) {
            $this->error = '站内信不存在';
            return false;
        }
        if ($info['status'] != MessageEnum::MESSAGE_STATUS['draft']) {
            $this->error = '站内信不是草稿，不能修改';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit message');
            $saveMessage = $this->allowField(['type', 'title'])->where('id', $info['id'])->save($data);
            if (!$saveMessage) {
                $this->rollback();
                $this->error = '编辑站内信失败';
                return false;
            }

            $save = MessageContentDao::instance()->edit($info['id'], $data['content']);
            if (!$save) {
                $this->rollback();
                $this->error = MessageContentDao::instance()->getError();
                return false;
            }

            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '编辑站内信',
                    'content' => '编辑站内信: ' . $data['title'] . ', ID: ' . $info['id'],
                    'sid' => $info['id']
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                    return false;
                }
            }

            $this->commit();
            return true;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '编辑站内信异常';
            Logger::instance()->channel()->error('Edit message exception. msg: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 修改状态
     *
     * @param array $data
     * @param integer $adminID
     * @return boolean
     */
    public function status(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('status')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }
        if (!in_array($data['status'], [MessageEnum::MESSAGE_STATUS['remove'], MessageEnum::MESSAGE_STATUS['draft']])) {
            $this->error = '状态异常';
            return false;
        }

        $info = $this->where('id', $data['idx'])->get();
        if (!$info) {
            $this->error = '站内信不存在';
            return false;
        }
        if (!in_array($info['status'], [MessageEnum::MESSAGE_STATUS['remove'], MessageEnum::MESSAGE_STATUS['draft']])) {
            $this->error = '站内信状态不可修改';
            return false;
        }
        $msg = $data['status'] == MessageEnum::MESSAGE_STATUS['draft'] ? '恢复草稿' : '删除';
        if ($info['status'] == $data['status']) {
            $this->error = '站内信已' . $msg;
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit message status');
            $saveMessage = $this->where('id', $info['id'])->save(['status' => $data['status']]);
            if (!$saveMessage) {
                $this->rollback();
                $this->error = '站内信' . $msg . '失败';
                return false;
            }

            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '站内信' . $msg,
                    'content' => '站内信' . $msg . ', 标题: ' . $info['title'] . ', ID: ' . $info['id'],
                    'sid' => $info['id']
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                    return false;
                }
            }

            $this->commit();
            return true;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '站内信' . $msg . '异常';
            Logger::instance()->channel()->error('Edit message exception. msg: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 获取信息
     *
     * @param integer $id   消息ID
     * @param integer|null $uid 创建人ID，不为0则验证用户ID
     * @param boolean $isSys    是否系统消息，是则关联查询消息类型
     * @return array
     */
    public function getInfo(int $id, int $uid = null, bool $isSys = true): array
    {
        $field = ['m.*', 'c.content'];
        $query = $this->alias('m')->where('m.id', $id)->join(MessageContentDao::instance()->getTable() . ' c', 'm.id=c.message_id');
        if (!is_null($uid)) {
            $query->where('m.uid', $uid);
        }
        if ($isSys) {
            $query->join(MessageTypeDao::instance()->getTable() . ' t', 'm.type=t.id');
            array_push($field, 't.title AS type_name', 't.img');
        }

        return $query->field($field)->get();
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
            // 查询系统发送消息
            $field = ['m.*', 'a.username', 'a.avatar', 't.title AS type_name', 't.img', 's.username AS send_user', 's.avatar AS send_avatar'];
            $list = $this->scope('sys', $data)->page($page, $limit)->field($field)->all();
            $count = $this->scope('sys', $data)->count('m.id');
        } else {
            // 查询用户发送消息
            $field = [
                'm.*', 'a.username', 'a.avatar', 's.username AS send_user', 's.avatar AS send_avatar',
                'r.receive_id AS receive_id', 'u.username AS receive_user', 'u.avatar AS receive_avatar'
            ];
            $list = $this->scope('user', $data)->page($page, $limit)->field($field)->all();
            $count = $this->scope('user', $data)->count('m.id');
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
     * @param \mon\thinkORM\extend\Query $query
     * @param array $option
     * @return mixed
     */
    public function scopeSys($query, array $option)
    {
        $query->alias('m')->where('m.type', '>', 0)
            ->join(MessageTypeDao::instance()->getTable() . ' t', 'm.type=t.id')
            ->join(AdminDao::instance()->getTable() . ' a', 'a.id=m.uid')
            ->join(AdminDao::instance()->getTable() . ' s', 's.id=m.send_uid', 'LEFT');

        return $this->parseWhere($query, $option);
    }

    /**
     * 查询用户信息场景
     *
     * @param \mon\thinkORM\extend\Query $query
     * @param array $option
     * @return mixed
     */
    public function scopeUser($query, array $option)
    {
        $query->alias('m')->where('m.type', '=', 0)
            ->join(AdminDao::instance()->getTable() . ' a', 'a.id=m.uid')
            ->join(MessageReceiverDao::instance()->getTable() . ' r', 'm.id=r.message_id')
            ->join(AdminDao::instance()->getTable() . ' u', 'r.receive_id=u.id')
            ->join(AdminDao::instance()->getTable() . ' s', 's.id=m.send_uid', 'LEFT');

        return $this->parseWhere($query, $option);
    }

    /**
     * 解析查询条件
     *
     * @param \mon\thinkORM\extend\Query $query
     * @param array $option
     * @return mixed
     */
    protected function parseWhere($query, array $option)
    {
        // ID搜索
        if (isset($option['idx']) && $this->validate()->id($option['idx'])) {
            $query->where('m.id', intval($option['idx']));
        }
        // 按发件人uid
        if (isset($option['uid']) && $this->validate()->id($option['uid'])) {
            $query->where('m.uid', intval($option['uid']));
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('m.status', intval($option['status']));
        }
        // 按类型
        if (isset($option['type']) && $this->validate()->int($option['type'])) {
            $query->where('m.type', intval($option['type']));
        }
        // 按标签
        if (isset($option['title']) && is_string($option['title']) && !empty($option['title'])) {
            $query->whereLike('m.title', trim($option['title']) . '%');
        }
        // 按创建人
        if (isset($option['username']) && is_string($option['username']) && !empty($option['username'])) {
            $query->where('a.username', trim($option['username']));
        }
        // 按创建时间
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('m.create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('m.create_time', '<=', intval($option['end_time']));
        }
        // 按发送时间
        if (isset($option['send_start_time']) && $this->validate()->int($option['send_start_time'])) {
            $query->where('m.send_time', '>=', intval($option['send_start_time']));
        }
        if (isset($option['send_end_time']) && $this->validate()->int($option['send_end_time'])) {
            $query->where('m.send_time', '<=', intval($option['send_end_time']));
        }

        // 排序字段，默认发送时间
        $order = 'm.send_time';
        if (isset($option['order']) && in_array($option['order'], ['create_time', 'update_time', 'send_time'])) {
            $order = 'm.' . $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }
        $query->order($order, $sort);

        return $query;
    }
}
