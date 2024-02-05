<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\dev;

use mon\http\Request;
use plugins\admin\dao\CounterDao;
use plugins\admin\comm\Controller;

/**
 * 计算器控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CounterController extends Controller
{
    /**
     * 列表
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = CounterDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        };

        return $this->fetch('sys/dev/counter/index', ['uid' => $request->uid]);
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
            $idx = $request->post('idx');
            if (!check('id', $idx)) {
                return $this->error('params faild');
            }
            $count = $request->post('count');
            if (!check('id', $count)) {
                return $this->error('计数值必须为大于0的整数');
            }
            $remark = $request->post('remark', '');
            if (!check('str', $remark) || !check('maxLength', $remark, 200)) {
                return $this->error('备注必须为长度小于200的字符串');
            }
            // 修改计数
            $edit = CounterDao::instance()->edit(intval($idx), $request->uid, intval($count), $remark);
            if (!$edit) {
                return $this->error(CounterDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        // 查询规则
        $data = CounterDao::instance()->where('id', $id)->get();
        if (!$data) {
            return $this->error('计数器不存在');
        }
        return $this->fetch('sys/dev/counter/edit', $data);
    }

    /**
     * 移除计数器
     *
     * @param Request $request
     * @return mixed
     */
    public function remove(Request $request)
    {
        $idx = $request->post('idx');
        if (!check('id', $idx)) {
            return $this->error('params faild');
        }

        $remove = CounterDao::instance()->remove(intval($idx), $request->uid);
        if (!$remove) {
            return $this->error(CounterDao::instance()->getError());
        }

        return $this->success('操作成功');
    }
}
