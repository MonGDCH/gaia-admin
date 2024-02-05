<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\auth;

use mon\http\Request;
use plugins\admin\comm\Controller;
use plugins\admin\dao\AuthRuleDao;
use plugins\admin\contract\AuthEnum;
use plugins\admin\service\AuthService;

/**
 * 权限规则控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class RuleController extends Controller
{
    /**
     * 规则管理
     *
     * @param Request $request  请求实例
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $data = AuthRuleDao::instance()->all();
            return $this->success('ok', $data);
        }

        return $this->fetch('sys/auth/rule/index', ['uid' => $request->uid]);
    }

    /**
     * 新增
     *
     * @param Request $request
     * @return mixed
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $option = $request->post();
            $edit = AuthRuleDao::instance()->add($option, $request->uid);
            if (!$edit) {
                return $this->error(AuthRuleDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $rule = AuthService::instance()->getAuthRuleList(0);
        array_unshift($rule, ['id' => 0, 'title' => '无', 'disabled' => false, 'children' => []]);
        $this->assign('rule', json_encode($rule, JSON_UNESCAPED_UNICODE));
        $this->assign('status', AuthEnum::AUTH_STATUS_TITLE);
        $this->assign('idx', $request->get('idx', 0));
        return $this->fetch('sys/auth/rule/add');
    }

    /**
     * 编辑
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        // post更新操作
        if ($request->isPost()) {
            $option = $request->post();
            $edit = AuthRuleDao::instance()->edit($option, $request->uid);
            if (!$edit) {
                return $this->error(AuthRuleDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('params faild');
        }
        // 查询规则
        $data = AuthRuleDao::instance()->where('id', $id)->get();
        if (!$data) {
            return $this->error('权限规则不存在');
        }
        $rule = AuthService::instance()->getAuthRuleList(intval($id));
        array_unshift($rule, ['id' => 0, 'title' => '无', 'disabled' => false, 'children' => []]);
        $this->assign('rule', json_encode($rule, JSON_UNESCAPED_UNICODE));
        $this->assign('status', AuthEnum::AUTH_STATUS_TITLE);
        $this->assign('data', $data);
        $this->assign('data', $data);
        return $this->fetch('sys/auth/rule/edit');
    }
}
