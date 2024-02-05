<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys;

use mon\env\Config;
use mon\http\Request;
use plugins\admin\dao\AdminDao;
use plugins\admin\comm\Controller;
use plugins\admin\contract\AdminEnum;

/**
 * 管理员控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AdminController extends Controller
{
    /**
     * 管理员列表
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = AdminDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        };
        return $this->fetch('sys/admin/index', [
            'uid'   => $request->uid,
            'admin' => implode(',', Config::instance()->get('admin.app.supper_admin', [])),
            'status' => AdminEnum::ADMIN_STATUS_TITLE
        ]);
    }

    /**
     * 新增管理员
     *
     * @param Request $request
     * @return mixed
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $option = $request->post();
            // 固定头像
            $option['avatar'] = '/static/img/avatar.png';
            $save = AdminDao::instance()->add($option, $request->uid);
            if (!$save) {
                return $this->error(AdminDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        return $this->fetch('sys/admin/add', ['status' => AdminEnum::ADMIN_STATUS_TITLE]);
    }

    /**
     * 修改密码
     *
     * @param Request $request
     * @return mixed
     */
    public function password(Request $request)
    {
        // 修改密码
        if ($request->isPost()) {
            $option = $request->post();
            $save = AdminDao::instance()->password($option, $request->uid, false);
            if (!$save) {
                return $this->error(AdminDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        if (in_array($id, Config::instance()->get('admin.app.supper_admin', []))) {
            return $this->error('不允许操作超级管理员用户');
        }
        $info = AdminDao::instance()->where('id', $id)->get();
        if (!$info) {
            return $this->error('获取用户信息失败');
        }

        $this->assign('data', $info);
        return $this->fetch('sys/admin/password');
    }

    /**
     * 修改信息
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        // 修改信息
        if ($request->isPost()) {
            $option = $request->post();
            $save = AdminDao::instance()->edit($option, $request->uid);
            if (!$save) {
                return $this->error(AdminDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        if (in_array($id, Config::instance()->get('admin.app.supper_admin', []))) {
            return $this->error('不允许操作超级管理员用户');
        }
        $info = AdminDao::instance()->where('id', $id)->get();
        if (!$info) {
            return $this->error('获取用户信息失败');
        }

        return $this->fetch('sys/admin/edit', ['data' => $info]);
    }

    /**
     * 停启用用户
     *
     * @param Request $request
     * @return mixed
     */
    public function toggle(Request $request)
    {
        $id = $request->post('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        if (in_array($id, Config::instance()->get('admin.app.supper_admin', []))) {
            return $this->error('不允许操作超级管理员用户');
        }

        $option = $request->post();
        $save = AdminDao::instance()->status($option, $request->uid);
        if (!$save) {
            return $this->error(AdminDao::instance()->getError());
        }
        return $this->success('操作成功');
    }
}
