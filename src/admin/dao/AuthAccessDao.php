<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkORM\Dao;
use mon\util\Instance;
use support\auth\RbacService;
use plugins\admin\validate\AuthValidate;

/**
 * 用户-角色组别关系Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AuthAccessDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'auth_access';

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
     * 绑定用户到角色组
     *
     * @param array   $data    请求参数
     * @param integer $adminID 管理员ID，大于0则记录日志
     * @return boolean
     */
    public function bind(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('bind_group')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }
        // 判断组别是否存在
        $groupInfo = AuthGroupDao::instance()->where('id', $data['idx'])->get();
        if (!$groupInfo) {
            $this->error = '角色组别不存在';
            return false;
        }
        $accessDao = RbacService::instance()->dao('access');
        Logger::instance()->channel()->info('reset bind admin for group');
        // 事务批量绑定用户
        $this->startTrans();
        try {
            // 先删除所有旧的组别用户关联
            $del = $this->where('group_id', $data['idx'])->delete();
            if ($del === false) {
                $this->rollback();
                $this->error = '清空角色组别旧用户绑定失败';
                return false;
            }

            // 绑定用户
            $uids = explode(',', $data['uids']);
            foreach ($uids as $k => $item) {
                if (!empty($item)) {
                    Logger::instance()->channel()->info('bind admin group');
                    $save = $accessDao->bind([
                        'uid'   => $item,
                        'gid'   => $data['idx']
                    ]);
                    if (!$save) {
                        $this->rollback();
                        $this->error = $accessDao->getError();
                        return false;
                    }
                }
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '管理员绑定角色组',
                    'content' => '管理员绑定角色组别，角色组ID：' . $data['idx'] . '，管理员ID列表：' . $data['uids'],
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
            $this->error = '绑定角色组别用户异常';
            Logger::instance()->channel()->error('group bind user exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 用户解除绑定
     *
     * @param integer $gid  组别ID
     * @param integer $uid  用户ID
     * @param integer $adminID  操作用户ID
     * @return boolean
     */
    public function unbind(array $data, int $adminID): bool
    {
        $check = $this->validate()->scope('unbind_group')->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }
        $this->startTrans();
        try {
            $accessDao = RbacService::instance()->dao('access');
            Logger::instance()->channel()->info('unbind admin group');
            $save = $accessDao->unbind([
                'uid'   => $data['idx'],
                'gid'   => $data['gid']
            ]);
            if (!$save) {
                $this->rollback();
                $this->error = $accessDao->getError();
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '管理员解除绑定角色组',
                    'content' => '管理员解除绑定角色组别，角色组ID：' . $data['gid'] . '，管理员ID：' . $data['idx'],
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
            $this->error = '解除绑定角色组别用户异常';
            Logger::instance()->channel()->error('group add bind user exception, msg => ' . $e->getMessage());
            return false;
        }
    }
}
