<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\notice;

use mon\http\Request;
use plugins\admin\comm\Controller;
use plugins\admin\dao\MessageTypeDao;
use plugins\admin\contract\MessageEnum;
use plugins\admin\model\MessageTypeModel;

/**
 * 站内信类型控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageTypeController extends Controller
{
    /**
     * 查看
     *
     * @param Request $request
     * @param MessageTypeModel $model
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = MessageTypeDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        };
        return $this->fetch('sys/notice/messageType/index', [
            'uid' => $request->uid,
            'status' => MessageEnum::MESSAGE_TYPE_STATUS_TITLE
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
            // 提交表单
            $option = $request->post();
            $save = MessageTypeDao::instance()->add($option, $request->uid);
            if (!$save) {
                return $this->error(MessageTypeDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        return $this->fetch('sys/notice/messageType/add', ['status' => MessageEnum::MESSAGE_TYPE_STATUS_TITLE]);
    }

    /**
     * 编辑
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        if ($request->isPost()) {
            // 提交表单
            $option = $request->post();
            $save = MessageTypeDao::instance()->edit($option, $request->uid);
            if (!$save) {
                return $this->error(MessageTypeDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        $info = MessageTypeDao::instance()->where('id', $id)->get();
        if (!$info) {
            return $this->error('消息类型不存在');
        }

        return $this->fetch('sys/notice/messageType/edit', [
            'data' => $info,
            'status' => MessageEnum::MESSAGE_TYPE_STATUS_TITLE
        ]);
    }
}
