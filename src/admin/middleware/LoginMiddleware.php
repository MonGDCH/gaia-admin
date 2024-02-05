<?php

declare(strict_types=1);

namespace plugins\admin\middleware;

use Closure;
use mon\http\Jump;
use mon\env\Config;
use mon\http\Session;
use mon\http\Response;
use plugins\admin\dao\AdminDao;
use plugins\admin\comm\view\Template;
use plugins\admin\contract\AdminEnum;
use mon\http\interfaces\RequestInterface;
use mon\http\interfaces\Middlewareinterface;

/**
 * 登录
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class LoginMiddleware implements Middlewareinterface
{
    /**
     * 中间件实现接口
     *
     * @param RequestInterface $request  请求实例
     * @param Closure $next 执行下一个中间件回调方法
     * @return Response
     */
    public function process(RequestInterface $request, Closure $next): Response
    {
        // 验证登录态
        $sessionUserInfo = $this->getSessionUserInfo();
        if (!$sessionUserInfo) {
            $loginPage = Template::buildURL('/login');
            return Jump::instance()->redirect($loginPage);
        }
        // 获取用户信息
        $userInfo = AdminDao::instance()->where('id', $sessionUserInfo['id'])->where('status', AdminEnum::ADMIN_STATUS['enable'])->get();
        if (!$userInfo) {
            Session::instance()->clear();
            return Jump::instance()->abort(404, '您的账号已被管理员禁用，请联系管理员。');
        }
        // 判断过期时间
        if ($userInfo['deadline'] > 0 && time() > $userInfo['deadline']) {
            Session::instance()->clear();
            return Jump::instance()->abort(403, '您的账号已过期，请联系管理员。');
        }
        // 单点登录
        $ssoConfig = Config::instance()->get('admin.app.sso');
        if ($ssoConfig['enable'] && !in_array($userInfo['id'], $ssoConfig['filter']) && $userInfo['login_token'] != $sessionUserInfo['login_token']) {
            Session::instance()->clear();
            $loginPage = Template::buildURL('/login');
            return Jump::instance()->abort(401, '您的账号存在异地登录，如非本人操作请修改密码并<a href="' . $loginPage . '">重新登录</a>');
        }

        // 更新session
        $this->refreshSessionUserInfo($sessionUserInfo);

        // 透传用户信息
        $request->uid = $userInfo['id'];
        $request->userInfo = $userInfo;

        return $next($request);
    }

    /**
     * 获取session中用户信息
     *
     * @return array
     */
    public function getSessionUserInfo(): array
    {
        $key = Config::instance()->get('admin.app.login_key', 'admin_info');
        return Session::instance()->get($key, []);
    }

    /**
     * 刷新session中用户信息
     *
     * @param array $userInfo
     * @return void
     */
    public function refreshSessionUserInfo(array $userInfo)
    {
        Session::instance()->set(Config::instance()->get('admin.app.login_key', 'admin_info'), $userInfo);
    }
}
