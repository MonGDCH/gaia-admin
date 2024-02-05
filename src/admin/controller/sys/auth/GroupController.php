<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\auth;

use Throwable;
use mon\util\Tree;
use mon\env\Config;
use mon\http\Request;
use mon\http\Response;
use plugins\admin\dao\AdminDao;
use plugins\admin\comm\Controller;
use plugins\admin\dao\AuthGroupDao;
use plugins\admin\dao\AuthAccessDao;
use plugins\admin\contract\AuthEnum;
use plugins\admin\contract\AdminEnum;
use plugins\admin\service\AuthService;

/**
 * 权限规则分组控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class GroupController extends Controller
{
    /**
     * 角色组管理
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $groups = AuthGroupDao::instance()->getGroupTree();
            return $this->success('ok', $groups);
        };

        return $this->fetch('sys/auth/group/index', [
            'uid'   => $request->uid,
            'group' => implode(',', Config::instance()->get('admin.app.supper_group', []))
        ]);
    }

    /**
     * 获取角色组别用户列表
     *
     * @param Request $request
     * @return mixed
     */
    public function user(Request $request)
    {
        $option = $request->get();
        if (!isset($option['gid']) || !check('id', $option['gid'])) {
            return $this->success('ok', [], ['count' => 0]);
        }

        $result = AdminDao::instance()->getList($option, true);
        return $this->success('ok', $result['list'], ['count' => $result['count']]);
    }

    /**
     * 获取用户组下所有权限
     *
     * @param Request $request
     * @return mixed
     */
    public function role(Request $request)
    {
        // 自身ID
        $id = $request->get("id", 0);
        // 父级ID
        $pid = $request->get("pid", 0);
        if (!check('id', $id) || !check('int', $pid)) {
            return $this->error('params faild');
        }
        // 获取数据
        try {
            $data = AuthService::instance()->getGrupRole(intval($id), intval($pid), true);
            return $this->success('ok', $data);
        } catch (Throwable $e) {
            return $this->error($e->getMessage());
        }
    }

    /**
     * 新增组别
     *
     * @param Request $request
     * @return mixed
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            // 新增操作
            $data = $request->post();
            $add = AuthGroupDao::instance()->add($data, $request->uid);
            if (!$add) {
                return $this->error(AuthGroupDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $groups = AuthGroupDao::instance()->getGroupTree(true);
        array_unshift($groups, ['id' => 0, 'title' => '无', 'pid' => 0]);
        $this->assign('groups', $groups);
        return $this->fetch('sys/auth/group/add');
    }

    /**
     * 编辑组别
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        if ($request->isPost()) {
            // 编辑操作
            $data = $request->post();
            $edit = AuthGroupDao::instance()->edit($data, $request->uid);
            if (!$edit) {
                return $this->error(AuthGroupDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $idx = $request->get('idx');
        if (!check('id', $idx)) {
            return $this->error('params faild');
        }
        if (in_array($idx, Config::instance()->get('admin.app.supper_group', []))) {
            return $this->error('不允许操作超级管理员组别');
        }
        $info = AuthGroupDao::instance()->where('id', $idx)->get();
        if (!$info) {
            return $this->error('角色组不存在');
        }
        // 获取组别数据，并移除自己及后代节点
        $baseGroups = AuthGroupDao::instance()->getGroupTree(true);
        // 获取自己及后代的节点id
        $childrenIds = Tree::instance()->data($baseGroups)->getChildrenIds($info['id'], true);
        // 移除自己及后代的节点
        $groups = [];
        foreach ($baseGroups as $item) {
            if (!in_array($item['id'], $childrenIds)) {
                $groups[] = $item;
            }
        }
        array_unshift($groups, ['id' => 0, 'title' => '无', 'pid' => 0]);

        // 所有规则
        $rules = AuthService::instance()->getAuthRuleList(0);
        // 当前组权限规则
        $groupRules = [];
        if (!empty($info['rules'])) {
            $groupRules = explode(',', $info['rules']);
            $groupRules = array_map(function ($item) {
                return intval($item);
            }, $groupRules);
        }

        $this->assign('status', AuthEnum::AUTH_STATUS_TITLE);
        $this->assign('rules', json_encode($rules, JSON_UNESCAPED_UNICODE));
        $this->assign('groupRules', json_encode($groupRules, JSON_UNESCAPED_UNICODE));
        $this->assign('groups', $groups);
        $this->assign('data', $info);
        return $this->fetch('sys/auth/group/edit');
    }

    /**
     * 关联角色组别用户
     *
     * @param Request $request
     * @return mixed
     */
    public function bind(Request $request): Response
    {
        if ($request->isPost()) {
            $option = $request->post();
            $save = AuthAccessDao::instance()->bind($option, $request->uid);
            if (!$save) {
                return $this->error(AuthAccessDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $idx = $request->get('idx');
        if (!check('id', $idx)) {
            return $this->error('params faild');
        }
        if (in_array($idx, Config::instance()->get('admin.app.supper_group', []))) {
            return $this->error('不允许操作超级管理员组别');
        }
        $info = AuthGroupDao::instance()->where('id', $idx)->get();
        if (!$info) {
            return $this->error('获取组别信息失败');
        }
        // 获取所有可选用户id, username
        $field = ['id AS value', 'username AS title'];
        $users = AdminDao::instance()->field($field)->where('status', AdminEnum::ADMIN_STATUS['enable'])->whereNotIn('id', Config::instance()->get('admin.app.supper_admin', []))->all();
        // 获取所有已绑定关联的用户id
        $selects = AuthAccessDao::instance()->field('uid')->where('group_id', $idx)->column('uid');

        return $this->fetch('sys/auth/group/bind', [
            'idx'       => $idx,
            'users'     => $users,
            'selects'   => $selects
        ]);
    }

    /**
     * 移除用户角色组绑定
     *
     * @param Request $request
     * @return mixed
     */
    public function unbind(Request $request)
    {
        $data = $request->post();
        $save = AuthAccessDao::instance()->unbind($data, $request->uid);
        if (!$save) {
            return $this->error(AuthAccessDao::instance()->getError());
        }
        return $this->success('操作成功');
    }
}
