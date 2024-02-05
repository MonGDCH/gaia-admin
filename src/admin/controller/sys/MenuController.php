<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys;

use mon\http\Request;
use plugins\admin\dao\MenuDao;
use plugins\admin\comm\Controller;
use plugins\admin\contract\MenuEnum;
use plugins\admin\service\AuthService;

/**
 * 菜单控制台
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MenuController extends Controller
{
    /**
     * 菜单管理
     *
     * @param Request $request  请求实例
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $data = MenuDao::instance()->order('sort DESC, id ASC')->all();
            return $this->success('ok', $data);
        }

        return $this->fetch('sys/menu/index', [
            'uid' => $request->uid,
            'type' => json_encode(MenuEnum::MENU_TYPE_TITLE, JSON_UNESCAPED_UNICODE),
            'openType' => json_encode(MenuEnum::MENU_OPEN_TYPE_TITLE, JSON_UNESCAPED_UNICODE),
        ]);
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
            $edit = MenuDao::instance()->add($option, $request->uid);
            if (!$edit) {
                return $this->error(MenuDao::instance()->getError());
            }

            return $this->success('操作成功');
        }
        // 输出规则树select
        $menu = AuthService::instance()->getAuthMenuList(0);
        array_unshift($menu, ['id' => 0, 'title' => '无', 'disabled' => false, 'children' => []]);
        $this->assign('menu', json_encode($menu, JSON_UNESCAPED_UNICODE));
        $this->assign('status', MenuEnum::MENU_STATUS_TITLE);
        $this->assign('type', MenuEnum::MENU_TYPE_TITLE);
        $this->assign('openType', MenuEnum::MENU_OPEN_TYPE_TITLE);
        $this->assign('idx', $request->get('idx', 0));
        return $this->fetch('sys/menu/add');
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
            $edit = MenuDao::instance()->edit($option, $request->uid);
            if (!$edit) {
                return $this->error(MenuDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        // 查询规则
        $data = MenuDao::instance()->where('id', $id)->get();
        if (!$data) {
            return $this->error('获取菜单信息失败');
        }

        $menu = AuthService::instance()->getAuthMenuList($data['id']);
        array_unshift($menu, ['id' => 0, 'title' => '无', 'disabled' => false, 'children' => []]);
        $this->assign('menu', json_encode($menu, JSON_UNESCAPED_UNICODE));
        $this->assign('status', MenuEnum::MENU_STATUS_TITLE);
        $this->assign('type', MenuEnum::MENU_TYPE_TITLE);
        $this->assign('openType', MenuEnum::MENU_OPEN_TYPE_TITLE);
        $this->assign('data', $data);
        $icon = explode(' ', $data['icon']);
        $this->assign('icon', $icon[1] ?? 'layui-icon-template-1');
        return $this->fetch('sys/menu/edit');
    }
}
