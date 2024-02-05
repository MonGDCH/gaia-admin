<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\dev;

use mon\http\Request;
use mon\http\Response;
use plugins\admin\comm\Controller;
use plugins\admin\dao\FormDesignDao;

/**
 * 表单模型
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class FormController extends Controller
{
    /**
     * 表单模型
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = FormDesignDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        };

        return $this->fetch('sys/dev/form/index', ['uid' => $request->uid]);
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
            $config = $request->post('config', '', false);
            $option['config'] = $config;
            // 固定头像
            $save = FormDesignDao::instance()->add($option, $request->uid);
            if (!$save) {
                return $this->error(FormDesignDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        return $this->fetch('sys/dev/form/add', ['align' => 1]);
    }

    /**
     * 编辑
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        // 修改
        if ($request->isPost()) {
            $option = $request->post();
            $config = $request->post('config', '', false);
            $option['config'] = $config;
            $save = FormDesignDao::instance()->edit($option, $request->uid);
            if (!$save) {
                return $this->error(FormDesignDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }

        $info = FormDesignDao::instance()->where('id', $id)->get();
        if (!$info) {
            return $this->error('表单模型不存在');
        }

        return $this->fetch('sys/dev/form/edit', $info);
    }

    /**
     * 修改状态
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

        $option = $request->post();
        $save = FormDesignDao::instance()->status($option, $request->uid);
        if (!$save) {
            return $this->error(FormDesignDao::instance()->getError());
        }
        return $this->success('操作成功');
    }

    /**
     * 预览
     *
     * @return Response
     */
    public function preview(): Response
    {
        return $this->fetch('sys/dev/form/preview');
    }
}
