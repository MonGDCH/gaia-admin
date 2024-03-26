<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\validate\ExpressValidate;

/**
 * 物流公司Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class ExpressDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'express';

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
    protected $validate = ExpressValidate::class;

    /**
     * 新增
     *
     * @param array $data
     * @param integer $adminID
     * @return integer
     */
    public function add(array $data, int $adminID): int
    {
        $check = $this->validate()->data($data)->scope('add')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        $info = $this->where('code', $data['code'])->get();
        if ($info) {
            $this->error = '编号已存在';
            return 0;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add express');
            $express_id = $this->allowField(['remark', 'status', 'code', 'sort', 'name'])->save($data, true, true);
            if (!$express_id) {
                $this->rollback();
                $this->error = '新增失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '添加物流公司',
                    'content' => '添加物流公司: ' . $data['name'] . ', ID: ' . $express_id,
                    'sid' => $express_id
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                    return 0;
                }
            }

            $this->commit();
            return $express_id;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '添加物流公司异常';
            Logger::instance()->channel()->error('Add express exception. msg: ' . $e->getMessage());
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
        $check = $this->validate()->data($data)->scope('edit')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $info = $this->where('id', $data['idx'])->get();
        if (!$info) {
            $this->error = '记录不存在';
            return false;
        }
        $exists = $this->where('code', $data['code'])->where('id', '<>', $info['id'])->get();
        if ($exists) {
            $this->error = '编号已存在';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit express');
            $save = $this->allowField(['remark', 'status', 'code', 'sort', 'name'])->where('id', $info['id'])->save($data);
            if (!$save) {
                $this->rollback();
                $this->error = '编辑失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '编辑物流公司',
                    'content' => '编辑物流公司: ' . $data['name'] . ', ID: ' . $info['id'],
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
            $this->error = '编辑物流公司异常';
            Logger::instance()->channel()->error('Edit express exception. msg: ' . $e->getMessage());
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
     * 查询场景
     *
     * @param \mon\orm\db\Query $query
     * @param array $option
     * @return \mon\orm\db\Query
     */
    public function scopeList($query, array $option)
    {
        // ID搜索
        if (isset($option['idx']) &&  $this->validate()->id($option['idx'])) {
            $query->where('id', intval($option['idx']));
        }
        // 按编号
        if (isset($option['code']) && is_string($option['code']) && !empty($option['code'])) {
            $query->where('code', $option['code']);
        }
        // 按名称
        if (isset($option['name']) && is_string($option['name']) && !empty($option['name'])) {
            $query->whereLike('name', '%' . trim($option['name']) . '%');
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 按上传时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('create_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'sort';
        if (isset($option['order']) && in_array($option['order'], ['id', 'sort', 'create_time'])) {
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
