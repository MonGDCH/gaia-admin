<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\thinkOrm\Dao;
use mon\util\Instance;

/**
 * 定时任务日志Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CrontabLogDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'crontab_log';

    /**
     * 记录日志
     *
     * @param array $data     请求参数
     * @return integer 日志ID
     */
    public function record(array $data): int
    {
        $check = $this->validate()->rule([
            'crontab_id'    => ['required', 'id'],
            'target'        => ['required', 'str'],
            'params'        => ['isset', 'str'],
            'result'        => ['isset', 'str'],
            'return_code'   => ['required', 'int', 'min:0'],
            'running_time'  => ['required', 'num'],
        ])->message([
            'crontab_id'    => '任务ID参数错误',
            'target'        => '请输入任务目标',
            'params'        => '请输入任务参数',
            'result'        => '任务响应参数错误',
            'return_code'   => '任务返回状态参数错误',
            'running_time'  => '请输入执行所用时间',
        ])->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        $data['create_time'] = time();
        $log_id = $this->allowField(['crontab_id', 'target', 'params', 'result', 'return_code', 'running_time', 'create_time'])->save($data, true, true);
        if (!$log_id) {
            $this->error = '记录日志失败';
            return false;
        }

        return $log_id;
    }

    /**
     * 查询列表
     *
     * @param array $data 请求参数
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
     * @param \mon\orm\db\Query $query
     * @param array $option
     * @return mixed
     */
    protected function scopeList($query, $option)
    {
        // 按任务ID
        if (isset($option['crontab_id']) && $this->validate()->id($option['crontab_id'])) {
            $query->where('crontab_id', intval($option['crontab_id']));
        }
        // 时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('update_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('update_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认 sort
        $order = 'id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'update_time', 'create_time'])) {
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
