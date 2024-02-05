<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkOrm\Dao;
use mon\util\Instance;
use plugins\admin\validate\MenuValidate;

/**
 * 菜单Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MenuDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'menu';

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
    protected $validate = MenuValidate::class;

    /**
     * 新增路由规则
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

        if ($data['pid'] != 0) {
            $parentInfo = $this->where('id', $data['pid'])->get();
            if (!$parentInfo) {
                $this->error = '父级菜单不存在';
                return 0;
            }
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add admin menu');
            $field = ['pid', 'title', 'name', 'icon', 'type', 'openType', 'sort', 'status', 'remark'];
            $menu_id = $this->allowField($field)->save($data, true, true);
            if (!$menu_id) {
                $this->rollback();
                $this->error = '新增菜单失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增菜单',
                    'content' => '新增菜单：' . $data['title'],
                    'sid' => $menu_id
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                    return 0;
                }
            }

            $this->commit();
            return $menu_id;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '新增菜单异常';
            Logger::instance()->channel()->error('Add admin menu exception, msg => ' . $e->getMessage(), ['trace' => true]);
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

        if ($data['pid'] == $data['idx']) {
            $this->error = '父级不能为自身';
            return false;
        }

        $info = $this->where('id', $data['idx'])->get();
        if (!$info) {
            $this->error = '菜单不存在';
            return false;
        }
        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit admin menu info');
            $field = ['pid', 'title', 'name', 'icon', 'type', 'openType', 'sort', 'status', 'remark'];
            $save = $this->allowField($field)->where('id', $info['id'])->save($data);
            if (!$save) {
                $this->rollback();
                $this->error = '修改菜单信息失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '编辑菜单',
                    'content' => '编辑菜单：' . $data['title'] . ', ID：' . $info['id'],
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
            $this->error = '编辑菜单异常';
            Logger::instance()->channel()->error('Edit admin menu exception, msg => ' . $e->getMessage());
            return false;
        }
    }
}
