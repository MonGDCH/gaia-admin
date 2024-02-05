<?php

declare(strict_types=1);

namespace plugins\admin\service;

use Throwable;
use mon\env\Config;
use mon\log\Logger;
use think\facade\Db;
use mon\util\Instance;
use plugins\admin\dao\AdminDao;
use plugins\admin\contract\AdminEnum;
use plugins\admin\dao\AdminLoginLogDao;

/**
 * 系统相关服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AdminService
{
    use Instance;

    /**
     * 错误信息
     *
     * @var string
     */
    protected $error = '';

    /**
     * 管理员登录
     *
     * @param mixed $username   账号
     * @param mixed $password   密码
     * @param mixed $ip         登录IP地址
     * @return array            登录用户信息
     */
    public function login($username, $password, $ip): array
    {
        // 验证IP是否允许登录操作
        if (!$this->checkDisableIP($ip)) {
            $this->error = '异常登录操作，请稍后再登录';
            return [];
        }
        // 获取用户信息
        $userInfo = AdminDao::instance()->where('username', $username)->get();
        if (!$userInfo) {
            $this->error = '用户不存在';
            return [];
        }
        if ($userInfo['status'] != AdminEnum::ADMIN_STATUS['enable']) {
            $this->error = '用户不可用';
            return [];
        }
        // 验证账号是否禁止登录
        if (!$this->checkDisableAccount($userInfo['id'])) {
            $this->error = '账号连续登录异常，请稍后再登录';
            return [];
        }
        // 验证密码
        if ($userInfo['password'] != AdminDao::instance()->encodePassword($password, $userInfo['salt'])) {
            $this->error = '用户密码错误';
            // 记录登录日志，不判断保存结果
            AdminLoginLogDao::instance()->record([
                'type' => AdminEnum::LOGIN_LOG_TYPE['pwd_faild'],
                'uid' => $userInfo['id'],
                'action' => $this->error,
                'ip' => $ip
            ]);
            return [];
        }
        // 验证用户过期时间
        if ($userInfo['deadline'] != 0 && $userInfo['deadline'] < time()) {
            $this->error = '用户已过期';
            return [];
        }

        // 定义登陆token
        $login_token = md5(randString() . $ip . microtime() . $userInfo['username']);
        Db::startTrans();
        try {
            Logger::instance()->channel()->info('User login');
            $saveLogin = AdminDao::instance()->where('id', $userInfo['id'])->save([
                'login_time'    => time(),
                'login_ip'      => $ip,
                'login_token'   => $login_token
            ]);
            if (!$saveLogin) {
                Db::rollBack();
                $this->error = '登陆失败';
                return [];
            }

            $userInfo['login_time'] = time();
            $userInfo['login_ip'] = $ip;
            $userInfo['login_token'] = $login_token;

            // 记录登录日志
            $record = AdminLoginLogDao::instance()->record([
                'type' => AdminEnum::LOGIN_LOG_TYPE['success'],
                'uid' => $userInfo['id'],
                'action' => '管理员登录',
                'ip' => $ip
            ]);
            if (!$record) {
                Db::rollback();
                $this->error = '记录登录日志失败';
                return [];
            }

            Db::commit();
            return $userInfo;
        } catch (Throwable $e) {
            Db::rollback();
            $this->error = '管理员登录异常';
            Logger::instance()->channel()->error('admin login exception, msg => ' . $e->getMessage());
            return [];
        }
    }

    /**
     * 验证登录账号是否已超过登录错误次数限制
     *
     * @param integer $uid 用户ID
     * @return boolean
     */
    public function checkDisableAccount(int $uid): bool
    {
        $config = Config::instance()->get('admin.app.login_faild');
        $start_time = time() - (60 * $config['login_gap']);
        $count = AdminLoginLogDao::instance()->where('uid', $uid)->where('create_time', '>=', $start_time)
            ->where('type', '>', AdminEnum::LOGIN_LOG_TYPE['success'])
            ->order('id', 'desc')->limit($config['account_error_limit'])->count();


        return !($count >= $config['account_error_limit']);
    }

    /**
     * 验证IP是否禁止登陆
     *
     * @param string $ip IP地址
     * @return boolean
     */
    public function checkDisableIP(string $ip): bool
    {
        $config = Config::instance()->get('admin.app.login_faild');
        $start_time = time() - ($config['login_gap'] * 60);
        $count = AdminLoginLogDao::instance()->where('create_time', '>=', $start_time)->where('ip', $ip)
            ->where('type', '>', AdminEnum::LOGIN_LOG_TYPE['success'])
            ->order('id', 'desc')->limit($config['ip_error_limit'])->count();


        return !($count >= $config['ip_error_limit']);
    }

    /**
     * 获取错误信息
     *
     * @return mixed
     */
    public function getError()
    {
        $error = $this->error;
        $this->error = null;
        return $error;
    }
}
