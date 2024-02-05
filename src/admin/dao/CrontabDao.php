<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkOrm\Dao;
use mon\util\Instance;
use plugins\admin\validate\CrontabValidate;


/**
 * 定时任务Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CrontabDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'crontab';

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
    protected $validate = CrontabValidate::class;

    /**
     * 新增
     *
     * @param array $data 参数
     * @param integer $adminID 管理员ID
     * @return integer  新增记录ID
     */
    public function add(array $data, int $adminID): int
    {
        $check = $this->validate()->scope('add')->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add crontab task');
            $field = ['type', 'title', 'rule', 'target', 'params', 'remark', 'sort', 'singleton', 'status', 'savelog'];
            $task_id = $this->allowField($field)->save($data, true, true);
            if (!$task_id) {
                $this->rollback();
                $this->error = '添加失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'crontab',
                    'action' => '新增定时任务',
                    'content' => '新增定时任务：' . $data['title'],
                    'sid' => $task_id
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                    return 0;
                }
            }

            $this->commit();
            return $task_id;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '新增定时任务异常';
            Logger::instance()->channel()->error('Add crontab task exception, msg => ' . $e->getMessage(), ['trace' => true]);
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
        $check = $this->validate()->scope('edit')->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $info = $this->where('id', $data['idx'])->get();
        if (!$info) {
            $this->error = '任务不存在';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit crontab task');
            $field = ['type', 'title', 'rule', 'target', 'params', 'remark', 'sort', 'singleton', 'status', 'savelog'];
            $save = $this->allowField($field)->where('id', $info['id'])->save($data);
            if (!$save) {
                $this->rollback();
                $this->error = '修改失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'crontab',
                    'action' => '编辑定时任务',
                    'content' => '编辑定时任务' . $data['title'] . ' ID：' . $info['id'],
                    'sid' => $info['id']
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                    return false;
                }
            }

            $this->commit();
            return true;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '编辑定时任务异常';
            Logger::instance()->channel()->error('Edit crontab task exception, msg => ' . $e->getMessage(), ['trace' => true]);
            return false;
        }
    }

    /**
     * 更新任务运行次数
     *
     * @param integer $id   任务ID 
     * @param integer $running_time 最近运行时间
     * @param integer $times    运行次数
     * @return boolean
     */
    public function updateRunning(int $id, int $running_time, int $times = 1): bool
    {
        $save = $this->where('id', $id)->inc('running_times', $times)->save(['last_running_time' => $running_time]);
        if (!$save) {
            $this->error = '更新运行次数失败';
            return false;
        }

        return true;
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
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 按类型
        if (isset($option['type']) && $this->validate()->int($option['type'])) {
            $query->where('type', intval($option['type']));
        }
        // 按名
        if (isset($option['title']) && is_string($option['title']) && !empty($option['title'])) {
            $query->whereLike('title', '%' . trim($option['title']) . '%');
        }
        // 时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('last_running_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('last_running_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认 sort
        $order = 'sort';
        if (isset($option['order']) && in_array($option['order'], ['id', 'type', 'status', 'update_time', 'sort', 'create_time'])) {
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
