<?php

declare(strict_types=1);

namespace plugins\admin\middleware;

use mon\env\Config;
use mon\http\interfaces\RequestInterface;
use support\auth\middleware\RbacMiddleware;

/**
 * 管理端RBAC权限控制器，继承基础RBAC权限控制器，可按需定制
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AuthMiddleware extends RbacMiddleware
{
    /**
     * 重载获取验证路径
     *
     * @param RequestInterface $request
     * @return string
     */
    public function getPath(RequestInterface $request): string
    {
        $path = $request->path();
        $root_path = Config::instance()->get('admin.app.root_path', '');
        if (!empty($root_path) && mb_strpos($path, $root_path) === 0) {
            $path = mb_substr($path, mb_strlen($root_path));
        }

        return $path;
    }
}
