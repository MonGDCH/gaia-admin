<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\thinkOrm\Dao;
use mon\util\Instance;
use plugins\admin\validate\MessageValidate;

/**
 * 站内信收件人Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageReceiverDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'message_receiver';

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
     * @param \mon\thinkOrm\extend\Query $query
     * @param array $option
     * @return mixed
     */
    protected function scopeList($query, $option)
    {
        $field = ['r.message_id', 'r.receive_id', 'r.send_time', 'a.username', 'a.avatar', 'a.status'];
        $query->alias('r')->join(AdminDao::instance()->getTable() . ' a', 'r.receive_id = a.id')->field($field);
        // 信息ID搜索
        if (isset($option['message_id']) &&  $this->validate()->id($option['message_id'])) {
            $query->where('r.message_id', intval($option['message_id']));
        }
        if (isset($option['receive_id']) &&  $this->validate()->int($option['receive_id'])) {
            $query->where('r.receive_id', intval($option['receive_id']));
        }
        // 创建时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('send_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('send_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认消息id
        $order = 'r.send_time';
        if (isset($option['order']) && in_array($option['order'], ['send_time', 'update_time', 'create_time'])) {
            $order = 'r.' . $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }
        return $query->order($order, $sort);
    }
}
