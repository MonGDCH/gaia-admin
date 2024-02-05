<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\thinkOrm\Dao;
use mon\util\Instance;
use support\auth\RbacService;
use plugins\admin\contract\AuthEnum;
use plugins\admin\validate\AuthValidate;

/**
 * 权限规则Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AuthRuleDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'auth_rule';

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
     * 新增
     *
     * @param array $data 请求参数
     * @param integer $adminID 操作用户ID
     * @return boolean
     */
    public function add(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('add_rule')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }
        // 判断neme值是否已存在
        $exists = $this->where('name', $data['name'])->get();
        if ($exists) {
            $this->error = '权限规则已存在';
            return false;
        }

        if ($data['pid'] != '0') {
            $parentInfo = $this->where('id', $data['pid'])->where('status', AuthEnum::AUTH_STATUS['enable'])->get();
            if (!$parentInfo) {
                $this->error = '父级权限规则不存在或无效';
                return false;
            }
        }

        $info = [
            'pid' => $data['pid'],
            'title' => $data['title'],
            'name' => $data['name'],
            'remark' => $data['remark'] ?? '',
        ];

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add auth rule');
            $authRuleDao = RbacService::instance()->dao('rule');
            $save = $authRuleDao->add($info, ['status' => $data['status']]);
            if (!$save) {
                $this->rollback();
                $this->error = $authRuleDao->getError();
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增权限规则',
                    'content' => '新增权限规则: ' . $info['title'] . ', ID: ' . $save,
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
            $this->error = '新增权限规则异常';
            Logger::instance()->channel()->error('Add auth rule exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 编辑
     *
     * @param array $data 请求参数
     * @param integer $adminID 操作用户ID
     * @return boolean
     */
    public function edit(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('edit_rule')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        if ($data['pid'] == $data['idx']) {
            $this->error = '父级不能为自身';
            return false;
        }

        $baseInfo = $this->where('id', $data['idx'])->get();
        if (!$baseInfo) {
            $this->error = '权限规则不存在';
            return false;
        }
        // 判断neme值是否已存在
        $exists = $this->where('name', $data['name'])->where('id', '<>', $data['idx'])->get();
        if ($exists) {
            $this->error = '路由规则已存在';
            return false;
        }

        $info = [
            'idx'       => $data['idx'],
            'pid'       => $data['pid'],
            'title'     => $data['title'],
            'name'      => $data['name'],
            'remark'    => $data['remark'] ?? '',
            'status'    => $data['status']
        ];

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit auth rule');
            $authRuleDao = RbacService::instance()->dao('rule');
            $save = $authRuleDao->modify($info);
            if (!$save) {
                $this->rollback();
                $this->error = $authRuleDao->getError();
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改权限规则',
                    'content' => '修改权限规则：' . $info['title'] . ', ID: ' . $info['idx'],
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
            $this->error = '编辑权限规则异常';
            Logger::instance()->channel()->error('Edit auth rule exception, msg => ' . $e->getMessage());
            return false;
        }
    }
}
