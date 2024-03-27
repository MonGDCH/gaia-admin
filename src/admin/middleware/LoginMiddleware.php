<?php

declare(strict_types=1);

namespace plugins\admin\middleware;

use Closure;
use mon\http\Jump;
use mon\env\Config;
use mon\http\Context;
use mon\http\Response;
use plugins\admin\dao\AdminDao;
use plugins\admin\comm\view\Template;
use plugins\admin\contract\AdminEnum;
use mon\http\interfaces\RequestInterface;
use support\auth\middleware\JwtMiddleware;

/**
 * 登录
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class LoginMiddleware extends JwtMiddleware
{
    /**
     * 中间件实现接口(重载实现)
     *
     * @param RequestInterface $request  请求实例
     * @param Closure $next 执行下一个中间件回调方法
     * @return Response
     */
    public function process(RequestInterface $request, Closure $next): Response
    {
        // 获取Token，优先的请求头中获取，不存在则从cookie中获取
        $token = $this->getToken($request);
        if (!$token) {
            // 未登录，跳转登录页
            $loginPage = Template::buildURL('/login');
            return Jump::instance()->redirect($loginPage);
        }
        // 验证Token
        $check = $this->getService()->check($token);
        // Token验证不通过
        if (!$check) {
            // 错误码
            $code = $this->getService()->getErrorCode();
            // 错误信息
            $msg = $this->getService()->getError();
            return $this->getHandler()->checkError($code, $msg);
        }

        // 获取Token数据
        $data = $this->getService()->getData();
        // 获取用户信息
        $userInfo = AdminDao::instance()->where('id', $data['aud'])->where('status', AdminEnum::ADMIN_STATUS['enable'])->get();
        if (!$userInfo) {
            return Jump::instance()->abort(401, '您的账号已被管理员禁用，请联系管理员。');
        }
        // 判断过期时间
        if ($userInfo['deadline'] > 0 && time() > $userInfo['deadline']) {
            return Jump::instance()->abort(401, '您的账号已过期，请联系管理员。');
        }
        // 单点登录
        $ssoConfig = Config::instance()->get('admin.app.sso');
        // dump($userInfo);
        if ($ssoConfig['enable'] && !in_array($userInfo['id'], $ssoConfig['filter']) && $userInfo['login_token'] != $data['ext']['token']) {
            $loginPage = Template::buildURL('/login');
            return Jump::instance()->abort(401, '您的账号存在异地登录，如非本人操作请修改密码并<a href="' . $loginPage . '">重新登录</a>');
        }

        // 透传用户信息
        $request->uid = $userInfo['id'];
        $request->userInfo = $userInfo;
        $request->jwt = $data;
        Context::set('userInfo', $userInfo);

        return $next($request);
    }
}
