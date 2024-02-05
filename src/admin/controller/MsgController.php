<?php

declare(strict_types=1);

namespace plugins\admin\controller;

use mon\http\Request;
use plugins\admin\dao\MessageDao;
use plugins\admin\comm\Controller;
use plugins\admin\dao\AdminMessageDao;
use plugins\admin\service\MessageService;
use plugins\admin\validate\MessageValidate;

/**
 * 用户站内信控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MsgController extends Controller
{    
    /**
     * 站内信
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            // 0-系统通知 1-用户私信 2-发信箱
            $cate = $request->get('cate');
            if (!in_array($cate, [0, 1, 2])) {
                return $this->error('params faild');
            }
            $query = $request->get();
            $query['uid'] = $request->uid;
            if (in_array($cate, [0, 1])) {
                // 查看收件信息
                $result = AdminMessageDao::instance()->getList($query, $cate == 0);
                return $this->success('ok', $result['list'], ['count' => $result['count']]);
            }
            // 查看发件箱
            $result = MessageDao::instance()->getList($query, false);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        return $this->fetch('msg/index', ['userInfo' => $request->userInfo]);
    }

    /**
     * 拉取站内信
     *
     * @param Request $request
     * @return mixed
     */
    public function pull(Request $request)
    {
        // 拉取站内信
        $pull = MessageService::instance()->pull($request->uid);
        // 是否存在未读信息
        $info = AdminMessageDao::instance()->where('uid', $request->uid)->where('status', 0)->get();

        return $this->success('ok', [
            'isNew' => is_numeric($pull) && $pull > 0,
            'isDot' => !empty($info)
        ]);
    }

    /**
     * 读取站内信
     *
     * @param Request $request
     * @return mixed
     */
    public function read(Request $request)
    {
        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('params faild');
        }
        $info = MessageService::instance()->read(intval($id), $request->uid);
        return $this->fetch('msg/read', ['data' => $info]);
    }

    /**
     * 预览站内信
     *
     * @param Request $request
     * @return mixed
     */
    public function preview(Request $request)
    {
        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('params faild');
        }

        $info = MessageDao::instance()->getInfo(intval($id), $request->uid, false);
        return $this->fetch('msg/read', ['data' => $info]);
    }

    /**
     * 发送站内信私信
     *
     * @param Request $request
     * @return mixed
     */
    public function send(Request $request)
    {
        if ($request->userInfo['sender'] != 1) {
            return $this->error('抱歉，您没有发送私信的权限');
        }
        if ($request->isPost()) {
            // 发送私信
            $data = $request->post();
            $content = $request->post('content', '', false);
            $data['content'] = $content;
            // 验证参数
            $validate = new MessageValidate();
            $check = $validate->data($data)->scope('send_letter')->check();
            if (!$check) {
                return $this->error($validate->getError());
            }

            $send = MessageService::instance()->send($data['username'], $data['title'], $data['content'], $request->uid);
            if (!$send) {
                return $this->error(MessageService::instance()->getError());
            }
            return $this->success('发送成功');
        }

        $username = $request->get('username', '');
        return $this->fetch('msg/add', ['username' => $username]);
    }
}
