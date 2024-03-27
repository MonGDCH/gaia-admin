<?php

declare(strict_types=1);

namespace plugins\admin\controller;

use mon\http\Request;
use plugins\admin\dao\AdminDao;
use plugins\admin\dao\AdminLogDao;
use plugins\admin\comm\Controller;
use plugins\admin\model\AdminLogModel;
use plugins\admin\dao\AdminLoginLogDao;
use plugins\admin\service\AdminService;

/**
 * 当前管理员控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class ProfileController extends Controller
{
    /**
     * 个人设置
     *
     * @param Request $request
     * @return void
     */
    public function index(Request $request)
    {
        return $this->fetch('profile/index', ['userInfo' => $request->userInfo]);
    }

    /**
     * 编辑头像
     *
     * @param Request $request
     * @return mixed
     */
    public function avatar(Request $request)
    {
        return $this->fetch('profile/avatar', ['userInfo' => $request->userInfo]);
    }

    /**
     * 修改密码
     *
     * @param Request $request
     * @return mixed
     */
    public function password(Request $request)
    {
        if ($request->isPost()) {
            $option = $request->post();
            $option['idx'] = $request->uid;
            $save = AdminDao::instance()->password($option, $request->uid, true);
            if (!$save) {
                return $this->error(AdminDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        return $this->fetch('profile/password', ['userInfo' => $request->userInfo]);
    }

    /**
     * 修改信息
     *
     * @param Request $request
     * @return mixed
     */
    public function editInfo(Request $request)
    {
        $option = $request->post();
        $basic = array_merge($request->userInfo, $option);
        $data = [
            'idx' => $request->uid,
            'sender' => $request->userInfo['sender'],
            'avatar' => $basic['avatar'],
            'receiver' => $basic['receiver'],
            'deadline' => $request->userInfo['deadline'] ?: ''
        ];
        $save = AdminDao::instance()->edit($data, $request->uid);
        if (!$save) {
            return $this->error(AdminDao::instance()->getError());
        }

        return $this->success('操作成功');
    }

    /**
     * 登录日志
     *
     * @param Request $request
     * @return mixed
     */
    public function loginLog(Request $request)
    {
        $data = $request->get(null, []);
        $data['uid'] = $request->uid;
        $result = AdminLoginLogDao::instance()->getList($data);
        return $this->success('ok', $result['list'], ['count' => $result['count']]);
    }

    /**
     * 操作日志
     *
     * @param Request $request
     * @param AdminLogModel $model
     * @return mixed
     */
    public function operLog(Request $request)
    {
        $data = $request->get(null, []);
        $data['uid'] = $request->uid;
        $result = AdminLogDao::instance()->getList($data);
        return $this->success('ok', $result['list'], ['count' => $result['count']]);
    }

    /**
     * 刷新Token
     *
     * @param Request $request
     * @return mixed
     */
    public function refresh(Request $request)
    {
        $token = AdminService::instance()->getToken($request->userInfo, $request->ip());
        return $this->success('ok', ['token' => $token]);
    }
}
