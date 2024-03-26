<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\log\Logger;
use mon\util\Common;
use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\validate\AdminValidate;

/**
 * 管理员Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AdminDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'admin';

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
    protected $validate = AdminValidate::class;

    /**
     * 新增
     *
     * @param array $data 请求参数
     * @param integer $adminID 操作用户ID
     * @return integer 用户ID
     */
    public function add(array $data, int $adminID): int
    {
        $check = $this->validate()->data($data)->scope('add')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        // 判断用户名是否已存在
        $userInfo = $this->where('username', $data['username'])->get();
        if ($userInfo) {
            $this->error = '用户名已存在';
            return 0;
        }

        // 生成密码
        $salt = Common::instance()->randString(6, 0);
        $password = $this->encodePassword($data['password'], $salt);

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('add admin');
            $deadline = (isset($data['deadline']) && !empty($data['deadline'])) ? strtotime($data['deadline'] . ' 23:59:59') : 0;
            $uid = $this->save([
                'username'  => $data['username'],
                'salt'      => $salt,
                'password'  => $password,
                'status'    => $data['status'],
                'avatar'    => $data['avatar'],
                'sender'    => $data['sender'],
                'receiver'  => $data['receiver'],
                'deadline'  => $deadline
            ], true, true);
            if (!$uid) {
                $this->rollback();
                $this->error = '新增用户失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增管理员',
                    'content' => '新增管理员: ' . $data['username'] . ', 管理员ID: ' . $uid,
                    'sid' => $uid
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                    return 0;
                }
            }

            $this->commit();
            return intval($uid);
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '新增管理员异常';
            Logger::instance()->channel()->error('add admin exception, msg => ' . $e->getMessage());
            return 0;
        }
    }

    /**
     * 修改
     *
     * @param array $data   操作参数
     * @param integer $adminID  当前管理员ID
     * @return boolean
     */
    public function edit(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('edit')->check();
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
        $this->startTrans();
        try {
            Logger::instance()->channel()->info('edit admin info');
            // 存在过期时间，设置过期时间
            if (isset($data['deadline'])) {
                $data['deadline'] = !empty($data['deadline']) ? strtotime($data['deadline'] . ' 23:59:59') : 0;
            }
            $save = $this->allowField(['deadline', 'avatar', 'sender', 'receiver'])->where('id', $info['id'])->save($data);
            if (!$save) {
                $this->rollBack();
                $this->error = '编辑管理员信息失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改管理员信息',
                    'content' => '管理员账号：' . $info['username'] . ', 管理员账号ID：' . $info['id'],
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
            $this->error = '编辑管理员异常';
            Logger::instance()->channel()->error('edit admin exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 修改密码
     *
     * @param array $data 请求参数
     * @param integer $adminID 管理员ID
     * @param boolean $checkOld 是否验证旧密码
     * @return boolean
     */
    public function password(array $data, int $adminID, bool $checkOld = false): bool
    {
        $check = $this->validate()->data($data)->scope('pwd')->check();
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
        // 判断是否需要验证旧密码，需验证旧密码时，需要多传oldpwd参数
        if ($checkOld) {
            $old_pwd = $data['oldpwd'] ?? '';
            $checkOldPwd = $this->validate()->data(['password' => $old_pwd])->scope(['password'])->check();
            if (!$checkOldPwd) {
                $this->error = $this->validate()->getError();
                return false;
            }
            if ($info['password'] != $this->encodePassword($old_pwd, $info['salt'])) {
                $this->error = '旧密码错误';
                return false;
            }
        }

        // 重新生成密码
        $salt = Common::instance()->randString(6, 0);
        $password = $this->encodePassword($data['password'], $salt);
        $this->startTrans();
        try {
            Logger::instance()->channel()->info('modify admin password');
            $save = $this->where('id', $info['id'])->save([
                'salt'      => $salt,
                'password'  => $password,
            ]);
            if (!$save) {
                $this->rollback();
                $this->error = '修改用户密码失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改管理员密码',
                    'content' => '修改管理员密码, 管理员ID：' . $info['id'],
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
            $this->error = '修改管理员密码异常';
            Logger::instance()->channel()->error('modify admin password exception, msg => ' . $e->getMessage());
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
            Logger::instance()->channel()->info('modify admin status');
            $save = $this->where('id', $info['id'])->save(['status' => $data['status']]);
            if (!$save) {
                $this->rollback();
                $this->error = '修改用户状态失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '修改管理员状态',
                    'content' => '修改管理员状态为: ' . $data['status'] . ', 管理员ID: ' . $info['id'],
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
            $this->error = '修改管理员状态异常';
            Logger::instance()->channel()->error('modify admin status exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 查询列表
     *
     * @param array $data 请求参数
     * @param boolean $forGroup 是否为组别查询
     * @return array
     */
    public function getList(array $data, bool $forGroup = false): array
    {
        $limit = isset($data['limit']) ? intval($data['limit']) : 10;
        $page = isset($data['page']) && is_numeric($data['page']) ? intval($data['page']) : 1;

        // 查询
        if ($forGroup) {
            $field = ['a.id', 'a.username', 'a.avatar', 'a.status', 'a.login_ip', 'a.login_time', 'a.create_time', 'a.update_time', 'b.group_id', 'c.title as group_title'];
            $list = $this->scope('group', $data)->page($page, $limit)->field($field)->all();
            $total = $this->scope('group', $data)->count('a.id');
        } else {
            $field = ['id', 'username', 'avatar', 'status', 'login_ip', 'login_time', 'create_time', 'update_time', 'deadline'];
            $list = $this->scope('list', $data)->page($page, $limit)->field($field)->all();
            $total = $this->scope('list', $data)->count('id');
        }

        return [
            'list'      => $list,
            'count'     => $total,
            'pageSize'  => $limit,
            'page'      => $page
        ];
    }

    /**
     * 查询用户列表场景
     *
     * @param \mon\thinkORM\extend\Query $query
     * @param array $option
     * @return mixed
     */
    protected function scopeList($query, $option)
    {
        // ID搜索
        if (isset($option['idx']) &&  $this->validate()->id($option['idx'])) {
            $query->where('id', intval($option['idx']));
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 按用户名
        if (isset($option['username']) && is_string($option['username']) && !empty($option['username'])) {
            $query->whereLike('username', trim($option['username']) . '%');
        }
        // 创建时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('create_time', '<=', intval($option['end_time']));
        }
        // 登录时间搜索
        if (isset($option['login_start_time']) && $this->validate()->int($option['login_start_time'])) {
            $query->where('login_time', '>=', intval($option['login_start_time']));
        }
        if (isset($option['login_end_time']) && $this->validate()->int($option['login_end_time'])) {
            $query->where('login_time', '<=', intval($option['login_end_time']));
        }
        // 过期时间搜索
        if (isset($option['deadline_start_time']) && $this->validate()->int($option['deadline_start_time'])) {
            $query->where('deadline', '>=', intval($option['deadline_start_time']));
        }
        if (isset($option['deadline_end_time']) && $this->validate()->int($option['deadline_end_time'])) {
            $query->where('deadline', '<=', intval($option['deadline_end_time']));
        }
        // 排序字段，默认id
        $order = 'id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'login_time', 'create_time', 'update_time', 'deadline'])) {
            $order = $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }

    /**
     * 查询组别用户相关列表场景
     *
     * @param \mon\thinkORM\extend\Query $query 查询实例
     * @param array $option  查询参数
     * @return mixed
     */
    protected function scopeGroup($query, $option)
    {
        // 查询
        $query->alias('a')->join(AuthAccessDao::instance()->getTable() . ' b', 'a.id=b.uid', 'left')
            ->join(AuthGroupDao::instance()->getTable() . ' c', 'b.group_id=c.id', 'left');
        // 存在组别
        if (isset($option['gid']) && $this->validate()->id($option['gid'])) {
            $query->where('b.group_id', $option['gid']);
        }
        // 存在指定非组别
        if (isset($option['not_gid']) && $this->validate()->id($option['not_gid'])) {
            $query->where('b.group_id', '<>', $option['not_gid']);
        }
        // ID搜索
        if (isset($option['idx']) && $this->validate()->id($option['idx'])) {
            $query->where('a.id', intval($option['idx']));
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('a.status', intval($option['status']));
        }
        // 按用户名
        if (isset($option['username']) && is_string($option['username']) && !empty($option['username'])) {
            $query->whereLike('a.username', trim($option['username']) . '%');
        }
        // 创建时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('a.create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('a.create_time', '<=', intval($option['end_time']));
        }
        // 登录时间搜索
        if (isset($option['login_start_time']) && $this->validate()->int($option['login_start_time'])) {
            $query->where('a.login_time', '>=', intval($option['login_start_time']));
        }
        if (isset($option['login_end_time']) && $this->validate()->int($option['login_end_time'])) {
            $query->where('a.login_time', '<=', intval($option['login_end_time']));
        }
        // 排序字段，默认id
        $order = 'a.id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'login_time', 'create_time', 'update_time', 'deadline'])) {
            $order = 'a.' . $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }

    /**
     * 混淆加密密码
     *
     * @param string $password  密码
     * @param string $salt      加密盐
     * @return string
     */
    public function encodePassword(string $password, string $salt): string
    {
        return md5($password . $salt);
    }
}
