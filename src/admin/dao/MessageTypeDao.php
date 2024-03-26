<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\validate\MessageValidate;

/**
 * 站内信类型Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageTypeDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'message_type';

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
        $check = $this->validate()->data($data)->scope('add_type')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        $info = $this->where('title', $data['title'])->get();
        if ($info) {
            $this->error = '消息标题已存在';
            return 0;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add message type');
            $type_id = $this->allowField(['title', 'img', 'remark', 'status'])->save($data, true, true);
            if (!$type_id) {
                $this->rollback();
                $this->error = '添加消息类型失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '添加消息类型',
                    'content' => '添加消息类型: ' . $data['title'],
                    'sid' => $type_id
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                    return 0;
                }
            }

            $this->commit();
            return $type_id;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '添加消息类型异常';
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
        $check = $this->validate()->data($data)->scope('edit_type')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $typeInfo = $this->where('id', $data['idx'])->find();
        if (!$typeInfo) {
            $this->error = '消息类型不存在';
            return false;
        }

        $info = $this->where('title', $data['title'])->where('id', '<>', $data['idx'])->find();
        if ($info) {
            $this->error = '消息标题已存在';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit message type');
            $save = $this->allowField(['title', 'img', 'remark', 'status'])->where('id', $typeInfo['id'])->save($data);
            if (!$save) {
                $this->rollback();
                $this->error = '修改消息类型失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改消息类型',
                    'content' => '修改消息类型: ' . $data['title'] . ', ID: ' . $typeInfo['id'],
                    'sid' => $typeInfo['id']
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
            $this->error = '修改消息类型异常';
            Logger::instance()->channel()->error('Edit message exception. msg: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 查询列表
     *
     * @param array $data
     * @return array
     */
    public function getList(array $data): array
    {
        $limit = isset($data['limit']) ? intval($data['limit']) : 10;
        $page = isset($data['page']) && is_numeric($data['page']) ? intval($data['page']) : 1;

        // 查询
        $list = $this->scope('list', $data)->page($page, $limit)->all();
        $total = $this->scope('list', $data)->count();
        return [
            'list'      => $list,
            'count'     => $total,
            'pageSize'  => $limit,
            'page'      => $page
        ];
    }

    /**
     * 查询列表场景
     *
     * @param \mon\thinkORM\extend\Query $query
     * @param array $option
     * @return mixed
     */
    protected function scopeList($query, $option)
    {
        // ID搜索
        if (isset($option['idx']) &&  $this->validate()->id($option['idx'])) {
            $query->where('id', intval($option['idx']));
        }
        // 按状态
        if (isset($option['status']) &&  $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 按名称
        if (isset($option['title']) && is_string($option['title']) && !empty($option['title'])) {
            $query->whereLike('title', '%' . trim($option['title']) . '%');
        }
        // 创建时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('create_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'create_time'])) {
            $order = $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }
}
