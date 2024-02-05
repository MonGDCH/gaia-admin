<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\util\Tree;
use mon\log\Logger;
use mon\thinkOrm\Dao;
use mon\util\Instance;
use support\auth\RbacService;
use plugins\admin\validate\AuthValidate;

/**
 * 角色组Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AuthGroupDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'auth_group';

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
    protected $validate = AuthValidate::class;

    /**
     * 获取树状组别数据
     *
     * @param boolean $parseList 是否转换格式
     * @param array $where 查询条件
     * @param string $children 树状数据节点名
     * @return array
     */
    public function getGroupTree(bool $parseList = false, array $where = [], string $children = 'children'): array
    {
        $groups = $this->field('id, pid, title, status')->where($where)->all();
        if ($parseList) {
            $dataArr = Tree::instance()->data($groups)->getTreeArray(0);
            $result = Tree::instance()->getTreeList($dataArr, 'title');
        } else {
            $result = Tree::instance()->data($groups)->getTree($children);
        }

        return $result;
    }

    /**
     * 新增
     *
     * @param array $data 请求参数
     * @param integer $adminID 管理员ID，大于0则记录日志
     * @return boolean
     */
    public function add(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('add_group')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        $this->startTrans();
        try {
            $info = [
                'pid'       => $data['pid'],
                'title'     => $data['title'],
                'rules'     => [],
            ];
            Logger::instance()->channel()->info('add admin group');
            $groupAuthDap = RbacService::instance()->dao('group');
            $save = $groupAuthDap->add($info);
            if (!$save) {
                $this->rollback();
                $this->error = $groupAuthDap->getError();
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增角色组',
                    'content' => '新增角色组: ' . $data['title'] . ', ID: ' . $save,
                    'sid' => $save
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
            $this->error = '新增角色组异常';
            Logger::instance()->channel()->error('add admin group exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 编辑
     *
     * @param array $data 请求参数
     * @param integer $adminID 管理员ID，大于0则记录日志
     * @return boolean
     */
    public function edit(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('edit_group')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }
        // 获取数据
        $groupInfo = $this->where('id', $data['idx'])->get();
        if (!$groupInfo) {
            $this->error = '获取权限组别信息失败';
            return false;
        }
        // 处理权限规则为数组
        $rules = explode(',', $data['rules']);
        foreach ($rules as $k => $item) {
            if (empty($item)) {
                unset($rules[$k]);
            }
        }
        $info = [
            'idx'       => $data['idx'],
            'pid'       => $data['pid'],
            'title'     => $data['title'],
            'rules'     => $rules,
            'status'    => $data['status'],
        ];

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('edit admin group');
            $groupAuthDap = RbacService::instance()->dao('group');
            $save = $groupAuthDap->modify($info);
            if (!$save) {
                $this->rollback();
                $this->error = $groupAuthDap->getError();
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改角色组',
                    'content' => '修改角色组：' . $info['title'] . ', ID: ' . $info['idx'],
                    'sid' => $info['idx']
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
            $this->error = '编辑角色组异常';
            Logger::instance()->channel()->error('edit admin group exception, msg => ' . $e->getMessage());
            return false;
        }
    }
}
