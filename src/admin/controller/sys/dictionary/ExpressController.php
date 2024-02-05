<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\dictionary;

use mon\http\Request;
use plugins\admin\dao\ExpressDao;
use plugins\admin\comm\Controller;
use plugins\admin\contract\ExpressEnum;

/**
 * 物流快递控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class ExpressController extends Controller
{
    /**
     * 查看
     *
     * @param Request $request  请求实例
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = ExpressDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        return $this->fetch('sys/dictionary/express/index', [
            'uid' => $request->uid,
            'status' => ExpressEnum::EXPRESS_STATUS_TITLE
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
            $edit = ExpressDao::instance()->add($option, $request->uid);
            if (!$edit) {
                return $this->error(ExpressDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        return $this->fetch('sys/dictionary/express/add', ['status' => ExpressEnum::EXPRESS_STATUS_TITLE]);
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
            $edit = ExpressDao::instance()->edit($option, $request->uid);
            if (!$edit) {
                return $this->error(ExpressDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        // 查询
        $data = ExpressDao::instance()->where('id', $id)->get();
        if (!$data) {
            return $this->error('获取物流公司信息失败');
        }

        $this->assign('data', $data);
        return $this->fetch('sys/dictionary/express/edit', ['status' => ExpressEnum::EXPRESS_STATUS_TITLE]);
    }
}
