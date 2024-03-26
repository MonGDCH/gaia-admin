<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\validate\FormDesignValidate;

/**
 * 表单设计Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class FormDesignDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'form_design';

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
    protected $validate = FormDesignValidate::class;

    /**
     * 新增
     *
     * @param array $data
     * @param integer $adminID
     * @return boolean
     */
    public function add(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('add')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add form design');
            $data['uid'] = $adminID;
            $field = ['uid', 'title', 'remark', 'align', 'config'];
            $form_id = $this->allowField($field)->save($data, true, true);
            if (!$form_id) {
                $this->rollback();
                $this->error = '新增失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增表单模型',
                    'content' => '新增表单模型：' . $data['title'],
                    'sid' => $form_id
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
            $this->error = '新增表单模型异常';
            Logger::instance()->channel()->error('Add form design exception, msg => ' . $e->getMessage());
            return false;
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

        $baseInfo = $this->where('id', $data['idx'])->get();
        if (!$baseInfo) {
            $this->error = '表单模型不存在';
            return false;
        }
        if ($baseInfo['uid'] != $adminID) {
            $this->error = '不允许修改其它用户表单模型';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit form design');
            $field = ['title', 'remark', 'align', 'config'];
            $save = $this->allowField($field)->where('id', $baseInfo['id'])->save($data);
            if (!$save) {
                $this->rollback();
                $this->error = '修改表单模型失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '编辑表单模型',
                    'content' => '编辑表单模型：' . $data['title'] . ', ID：' . $data['idx'],
                    'sid' => $data['idx']
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
            $this->error = '编辑表单模型异常';
            Logger::instance()->channel()->error('Edit form design exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 修改状态
     *
     * @param array $data 参数
     * @param integer $adminID  管理员ID
     * @return boolean
     */
    public function status(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('status')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        // 获取用户信息
        $info = $this->where('id', $data['idx'])->get();
        if (!$info) {
            $this->error = '获取用户信息失败';
            return false;
        }

        if ($data['status'] == $info['status']) {
            $this->error = '修改的状态与原状态一致';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('modify form design status');
            $save = $this->where('id', $info['id'])->save(['status' => $data['status']]);
            if (!$save) {
                $this->rollback();
                $this->error = '修改表单模型状态失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改表单模型状态',
                    'content' => '修改表单模型状态为: ' . $data['status'] . ', 表单模型ID: ' . $info['id'],
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
            $this->error = '修改表单模型状态异常';
            Logger::instance()->channel()->error('modify form design status exception, msg => ' . $e->getMessage());
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
     * @return mixed
     */
    public function scopeList($query, array $option)
    {
        // ID搜索
        if (isset($option['idx']) &&  $this->validate()->id($option['idx'])) {
            $query->where('id', intval($option['idx']));
        }
        // 按用户ID
        if (isset($option['uid']) && $this->validate()->int($option['uid'])) {
            $query->where('uid', intval($option['uid']));
        }
        // 按名称
        if (isset($option['title']) && is_string($option['title']) && !empty($option['title'])) {
            $query->whereLike('title', trim($option['title']) . '%');
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('create_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'create_time', 'update_time', 'sort'])) {
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
