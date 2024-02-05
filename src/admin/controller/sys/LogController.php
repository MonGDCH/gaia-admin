<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys;

use mon\http\Request;
use plugins\admin\comm\Controller;
use plugins\admin\dao\AdminLogDao;
use plugins\admin\dao\AdminLoginLogDao;

/**
 * 日志控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class LogController extends Controller
{
    /**
     * 查看管理员日志
     *
     * @param Request $request
     * @return mixed
     */
    public function adminLog(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get(null, []);
            $result = AdminLogDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        return $this->fetch('sys/log/admin', ['uid' => $request->uid]);
    }

    /**
     * 查看管理员登录日志
     *
     * @param Request $request
     * @return mixed
     */
    public function adminLoginLog(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get(null, []);
            $result = AdminLoginLogDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        return $this->fetch('sys/log/adminLogin', ['uid' => $request->uid]);
    }
}
