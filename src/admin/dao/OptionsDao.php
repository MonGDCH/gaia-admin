<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\contract\DictEnum;

/**
 * 配置字典Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class OptionsDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'dictionary';

    /**
     * 自动写入时间戳
     *
     * @var boolean
     */
    protected $autoWriteTimestamp = true;

    /**
     * 修改配置信息
     *
     * @param string $group
     * @param string $key
     * @param string|integer $value
     * @return boolean
     */
    public function editItem(string $group, string $key, $value): bool
    {
        $info = $this->where('group', $group)->where('index', $key)->get();
        if (!$info) {
            $this->error = '配置不存在';
            return false;
        }

        $save = $this->where('id', $info['id'])->save(['value' => $value]);
        if (!$save) {
            $this->error = '修改失败';
            return false;
        }

        return true;
    }

    /**
     * 新增配置
     *
     * @param array $data 操作参数
     * @param integer $adminID  操作管理员ID
     * @return integer
     */
    public function add(array $data, int $adminID): int
    {
        // 校验数据
        $check = $this->validate()->data($data)->rule([
            'group'     => ['required', 'str', 'account'],
            'index'     => ['required', 'str', 'account'],
            'value'     => ['str'],
            'remark'    => ['str'],
            'status'    => ['required', 'in:' . DictEnum::DICT_STATUS['disable'] . ',' . DictEnum::DICT_STATUS['enable']],
        ])->message([
            'group'     => '请输入合法的字典索引名称(只允许字母、数字、下划线和破折号)',
            'index'     => '请输入合法的配置索引名称(只允许字母、数字、下划线和破折号)',
            'value'     => '请输入合法的配置值',
            'remark'    => '请输入合法的备注信息',
            'status'    => '请选择合法的状态'
        ])->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }
        if ($data['group'] == DictEnum::DICT_NAME && $data['index'] == DictEnum::DICT_NAME) {
            $this->error = '索引名称不能为:' . DictEnum::DICT_NAME;
            return 0;
        }
        // 校验配置节点是否已存在
        $extsis = $this->where('group', $data['group'])->where('index', $data['index'])->get();
        if ($extsis) {
            $this->error = '字典配置已存在';
            return 0;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('add config');
            $data['remark'] = $data['remark'] ?? '';
            $idx = $this->allowField(['group', 'index', 'value', 'remark', 'status'])->save($data, true, true);
            if (!$idx) {
                $this->rollback();
                $this->error = '增加字典配置失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增字典配置',
                    'content' => '新增字典配置: ' . $data['group'] . '，索引标签: ' . $data['index'],
                    'sid' => $idx
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                    return 0;
                }
            }

            $this->commit();
            return $idx;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '新增字典配置异常';
            Logger::instance()->channel()->error('add config exception, msg => ' . $e->getMessage());
            return 0;
        }
    }

    /**
     * 编辑字典信息
     *
     * @param array $data 操作参数
     * @param integer $adminID 操作管理员ID
     * @return boolean
     */
    public function edit(array $data, int $adminID): bool
    {
        $check = $this->validate()->rule([
            'id'        => ['required', 'id'],
            'index'     => ['required', 'account'],
            'value'     => ['str'],
            'remark'    => ['str'],
        ])->message([
            'id'        => '参数错误',
            'index'     => '请输入合法的字典索引标签',
            'value'     => '请输入合法的字典索引标签值',
            'remark'    => '请输入合法的备注信息',
        ])->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $info = $this->where('id', $data['id'])->get();
        if (!$info) {
            $this->error = '字典不存在';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit dictionary info');
            $save = $this->allowField(['index', 'value', 'remark'])->where('id', $info['id'])->save($data);
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
                    'action' => '编辑字典',
                    'content' => '编辑字典：' . $info['group'] . ', 索引标签: ' . $data['index'] . ', ID: ' . $info['id'],
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
            $this->error = '编辑字典异常';
            Logger::instance()->channel()->error('Edit dictionary info exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 修改状态
     *
     * @param array $data 操作参数
     * @param integer $adminID 操作管理员ID
     * @return boolean
     */
    public function status(array $data, int $adminID): bool
    {
        $check = $this->validate()->rule([
            'idx'       => ['required', 'id'],
            'status'    => ['required', 'in:' . DictEnum::DICT_STATUS['disable'] . ',' . DictEnum::DICT_STATUS['enable']]
        ])->message([
            'idx'       => '参数错误',
            'status'    => '请选择合法的状态'
        ])->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit dictionary status');
            $save = $this->where('id', $data['idx'])->save(['status' => $data['status']]);
            if (!$save) {
                $this->rollback();
                $this->error = '修改状态失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改字典状态',
                    'content' => '修改字典状态：' . ($data['status'] == DictEnum::DICT_STATUS['enable'] ? '正常' : '禁用') . ', ID: ' . $data['idx'],
                    'sid' => $data['idx']
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
            $this->error = '删除字典异常';
            Logger::instance()->channel()->error('Edit dictionary status exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 删除字典
     *
     * @param array $ids    字典ID列表
     * @param integer $adminID  操作管理员ID
     * @return boolean
     */
    public function remove(array $ids, int $adminID): bool
    {
        if (empty($ids)) {
            return true;
        }
        $data = $this->where('id', 'in', $ids)->all();
        $group = '';
        $logs = [];
        foreach ($data as $item) {
            // 只能删除同一组别字典
            $group = $group ?: $item['group'];
            if ($group != $item['group']) {
                $this->error = '删除字典参数异常';
                return false;
            }
            // 删除字典组别
            if ($group == DictEnum::DICT_NAME) {
                $logs[] = $item['value'] . ' [' . $item['index'] . ']';
            } else {
                // 一般字典
                $logs[] = $item['group'] . ' [' . $item['index'] . ']';
            }
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Delete dictionary');
            $save = $this->where('id', 'in', $ids)->delete();
            if (!$save) {
                $this->rollback();
                $this->error = '删除字典失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '删除配置字典',
                    'content' => '删除配置字典：' . implode(', ', $logs)
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
            $this->error = '删除字典异常';
            Logger::instance()->channel()->error('Delete dictionary exception, msg => ' . $e->getMessage());
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
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 按组
        if (isset($option['group']) && is_string($option['group']) && !empty($option['group'])) {
            $query->whereLike('group', trim($option['group']));
        }
        // 按索引
        if (isset($option['index']) && is_string($option['index']) && !empty($option['index'])) {
            $query->whereLike('index', trim($option['index']));
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
