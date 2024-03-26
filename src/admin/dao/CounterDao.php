<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;

/**
 * 计数器Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CounterDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'counter';

    /**
     * 自动写入时间戳
     *
     * @var boolean
     */
    protected $autoWriteTimestamp = true;

    /**
     * 管理员修改计数
     *
     * @param integer $id       计数器ID
     * @param integer $adminID  管理员ID
     * @param integer $count    计数值
     * @param string $remark    备注信息
     * @return boolean
     */
    public function edit(int $id, int $adminID, int $count, string $remark = ''): bool
    {
        if ($count < 0) {
            $this->error = '计数器值不能小于0';
            return false;
        }
        $info = $this->where('id', $id)->get();
        if (!$info) {
            $this->error = '计数器已移除';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit counter: ' . $id . ' old count: ' . $info['count']);
            $save = $this->where('id', $id)->where('count', $info['count'])->save(['count' => $count, 'remark' => $remark]);
            if (!$save) {
                $this->rollBack();
                $this->error = '修改失败，原计数值已修改或计时器已移除';
                return false;
            }

            // 记录操作日志
            $record = AdminLogDao::instance()->record([
                'uid' => $adminID,
                'module' => 'sys',
                'action' => '修改计数器',
                'content' => '计数器ID：' . $id . ', 原值：' . $info['count'] . ', 修改值：' . $count,
                'sid' => $id
            ]);
            if (!$record) {
                $this->rollback();
                $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                return false;
            }

            $this->commit();
            return true;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '修改计数器异常';
            Logger::instance()->channel()->error('Edit counter exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 管理员删除计数
     *
     * @param integer $id       计数器ID
     * @param integer $adminID  管理员ID
     * @return boolean
     */
    public function remove(int $id, int $adminID): bool
    {
        $info = $this->where('id', $id)->get();
        if (!$info) {
            $this->error = '计数器已移除';
            return false;
        }
        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Remove counter: ' . $id);
            $delete = $this->where('id', $id)->delete();
            if ($delete === false) {
                $this->error = '移除失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '移除计数器',
                    'content' => '计数器ID：' . $id,
                    'sid' => $id
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
            $this->error = '移除计数器异常';
            Logger::instance()->channel()->error('Remove counter exception, msg => ' . $e->getMessage());
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
     * @param \mon\thinkORM\extend\Query $query 查询实例
     * @param array $option  查询参数
     * @return mixed
     */
    protected function scopeList($query, $option)
    {
        // 按应用
        if (isset($option['app']) && is_string($option['app']) && !empty($option['app'])) {
            $query->whereLike('app', trim($option['app']));
        }
        // 按模块
        if (isset($option['module']) && is_string($option['module']) && !empty($option['module'])) {
            $query->whereLike('module', trim($option['module']));
        }
        // 按用户
        if (isset($option['uid']) && $this->validate()->int($option['uid'])) {
            $query->where('uid', intval($option['uid']));
        }
        // 时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('update_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('update_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'create_time', 'update_time'])) {
            $order = $option['order'];
        }
        // 排序类型，默认 ASC
        $sort = 'ASC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }
}
