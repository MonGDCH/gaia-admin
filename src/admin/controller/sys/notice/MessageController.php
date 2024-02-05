<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\notice;

use mon\http\Request;
use mon\http\Response;
use plugins\admin\dao\AdminDao;
use plugins\admin\dao\MessageDao;
use plugins\admin\comm\Controller;
use plugins\admin\dao\AuthGroupDao;
use plugins\admin\dao\AuthAccessDao;
use plugins\admin\contract\AuthEnum;
use plugins\admin\dao\MessageTypeDao;
use plugins\admin\contract\AdminEnum;
use plugins\admin\service\AuthService;
use plugins\admin\contract\MessageEnum;
use plugins\admin\dao\MessageReceiverDao;
use plugins\admin\service\MessageService;

/**
 * 站内信控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageController extends Controller
{
    /**
     * 查看
     *
     * @param Request $request
     * @return Response
     */
    public function index(Request $request)
    {
        // 查看列表
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = MessageDao::instance()->getList($option, true);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        };
        // 查看收件人列表
        if ($request->get('send')) {
            $send = $request->get('send');
            if (!check('id', $send)) {
                return $this->error('Send params faild');
            }

            // 先获取判断消息是否全部
            $receiverInfo = MessageReceiverDao::instance()->where('message_id', $send)->get();
            if (!$receiverInfo) {
                return $this->error('获取发送人信息失败');
            }
            if ($receiverInfo['receive_id'] == '0') {
                // 全部用户，结合layui-table提示全部用户
                return $this->error('全部用户');
            }

            $option = $request->get();
            $option['message_id'] = intval($send);
            $result = MessageReceiverDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }
        // 预览
        if ($request->get('read')) {
            $read = $request->get('read');
            if (!check('id', $read)) {
                return $this->error('Read params faild');
            }

            $info = MessageDao::instance()->getInfo(intval($read));
            if (!$info) {
                return $this->error('站内信不存在');
            }

            return $this->fetch('/msg/read', ['data' => $info]);
        }

        // 消息类型
        $typeList = MessageTypeDao::instance()->field(['id', 'title'])->all();
        array_unshift($typeList, ['id' => '', 'title' => '']);
        return $this->fetch('sys/notice/message/index', [
            'type' => $typeList,
            'uid' => $request->uid,
            'status' => json_encode(MessageEnum::MESSAGE_STATUS, JSON_UNESCAPED_UNICODE)
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
            // 重载 content 参数
            $content = $request->post('content', '', false);
            $option['content'] = $content;
            $save = MessageDao::instance()->add($option, $request->uid);
            if (!$save) {
                return $this->error(MessageDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        // 消息类型
        $type = MessageTypeDao::instance()->where('status', MessageEnum::MESSAGE_TYPE_STATUS['enable'])->field(['id', 'title'])->all();
        return $this->fetch('sys/notice/message/add', ['type' => $type]);
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
            $option = $request->post();
            // 重载 content 参数
            $content = $request->post('content', '', false);
            $option['content'] = $content;
            $save = MessageDao::instance()->edit($option, $request->uid);
            if (!$save) {
                return $this->error(MessageDao::instance()->getError());
            }
            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        $info = MessageDao::instance()->getInfo(intval($id));
        if (!$info) {
            return $this->error('消息类型不存在');
        }

        $type = MessageTypeDao::instance()->where('status', MessageEnum::MESSAGE_TYPE_STATUS['enable'])->field(['id', 'title'])->all();
        return $this->fetch('sys/notice/message/edit', [
            'data' => $info,
            'type' => $type
        ]);
    }

    /**
     * 发送
     *
     * @param Request $request
     * @return Response
     */
    public function send(Request $request): Response
    {
        if ($request->isPost()) {
            // 操作数据
            $message_id = $request->post('idx');
            if (!check('id', $message_id)) {
                return $this->error('params faild');
            }
            // 发送操作， 0-全部 1-指定用户 2-指定组别用户 3-指定组别
            $type = $request->post('type');
            if (!in_array($type, array_values(MessageEnum::MESSAGE_SEND_TYPE))) {
                return $this->error('发送方式错误');
            }
            if ($type == MessageEnum::MESSAGE_SEND_TYPE['group']) {
                // 类型为 3 按角色组别发送，ids为组别ID
                $ids = $request->post('ids', '');
                $uids = AuthAccessDao::instance()->where('group_id', 'IN', explode(',', $ids))->distinct(true)->column('uid');
            } else {
                $ids = $request->post('ids', '');
                $uids = explode(',', $ids);
                foreach ($uids as $v) {
                    if (!check('id', $v)) {
                        return $this->error('请选择用户错误');
                    }
                }
            }

            // 发送
            $send = MessageService::instance()->sys_send(intval($message_id), $uids, $request->uid, $type == MessageEnum::MESSAGE_SEND_TYPE['all']);
            if (!$send) {
                return $this->error(MessageService::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        $info = MessageDao::instance()->where('id', $id)->get();
        if (!$info) {
            return $this->error('消息不存在');
        }
        if ($info['status'] != MessageEnum::MESSAGE_STATUS['draft']) {
            $msg = $info['status'] == MessageEnum::MESSAGE_STATUS['publish'] ? '已发送' : '不可发送';
            return $this->error('消息' . $msg);
        }

        // 请求类型
        $type = $request->get('type');
        switch ($type) {
            case 'user':
                // 用户名模糊查询
                $username = $request->get('username');
                if (!$username) {
                    return $this->success('ok', []);
                }

                $data = AdminDao::instance()->where('status', AdminEnum::ADMIN_STATUS['enable'])->whereLike('username', trim($username) . '%')->field(['id AS value', 'username AS name', 'avatar'])->all();
                return $this->success('ok', $data);
            case 'group':
                // 获取组别
                $data = AuthGroupDao::instance()->getGroupTree(false, ['status' => AuthEnum::AUTH_STATUS['enable']]);
                $data[] = ['id' => '0', 'title' => '未分组用户'];
                return $this->success('ok', $data);
            case 'groupUser':
                // 获取用户
                $group = $request->get('group');
                if (!check('id', $group)) {
                    return $this->error('请先选择组别');
                }

                $field = ['id', 'username', 'avatar'];
                $where = ['status' => AdminEnum::ADMIN_STATUS['enable']];
                $data = ($group == '0') ? AuthService::instance()->getUnbindUser($field, $where) : AuthService::instance()->getBindUser(intval($group), $field, $where);

                return $this->success('ok', $data);
            case 'groupList':
                $data = AuthGroupDao::instance()->field(['id', 'title'])->where('status', AuthEnum::AUTH_STATUS['enable'])->all();
                return $this->success('ok', $data);
            default:
                // 加载页面
                return $this->fetch('sys/notice/message/send', [
                    'data' => $info,
                    'sendType' => json_encode(MessageEnum::MESSAGE_SEND_TYPE, JSON_UNESCAPED_UNICODE),
                    'sendTypeTitle' => json_encode(MessageEnum::MESSAGE_SEND_TYPE_TITLE, JSON_UNESCAPED_UNICODE)
                ]);
        }
    }

    /**
     * 删除恢复
     *
     * @param Request $request
     * @return Response
     */
    public function toggle(Request $request): Response
    {
        $id = $request->post('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }

        $option = $request->post();
        $save = MessageDao::instance()->status($option, $request->uid);
        if (!$save) {
            return $this->error(MessageDao::instance()->getError());
        }
        return $this->success('操作成功');
    }
}
