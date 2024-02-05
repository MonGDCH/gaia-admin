<?php

declare(strict_types=1);

namespace plugins\admin\service;

use Throwable;
use mon\log\Logger;
use think\facade\Db;
use RuntimeException;
use mon\util\Instance;
use plugins\admin\dao\AdminDao;
use plugins\admin\dao\MessageDao;
use plugins\admin\dao\AdminLogDao;
use plugins\admin\contract\AdminEnum;
use plugins\admin\dao\AdminMessageDao;
use plugins\admin\contract\MessageEnum;
use plugins\admin\dao\MessageContentDao;
use plugins\admin\dao\MessageReceiverDao;

/**
 * 站内信相关服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageService
{
    use Instance;

    /**
     * 错误信息
     *
     * @var string
     */
    protected $error = '';

    /**
     * 读取站内信
     *
     * @param integer $id
     * @param integer $uid
     * @return array
     */
    public function read(int $id, int $uid): array
    {
        $info = AdminMessageDao::instance()->getInfo($id, $uid);
        if (!$info) {
            return [];
        }

        // 记录读取时间, 只记录一次，不判断成功失败
        AdminMessageDao::instance()->where('id', $id)->where('uid', $uid)->where('status', MessageEnum::MESSAGE_READ_STATUS['unread'])->save([
            'read_time' => time(),
            'status' => MessageEnum::MESSAGE_READ_STATUS['read']
        ]);
        return $info;
    }

    /**
     * 用户发送个人私信
     * 注意：只能通过 pull 方法同步，不能直接新增，否则系统信息会获取不到
     *
     * @param string $receive   收件人账号名称
     * @param string $title     私信标题
     * @param string $content   私信内容
     * @param integer $adminID  发送用户ID
     * @return boolean
     */
    public function send(string $receive, string $title, string $content, int $adminID): bool
    {
        $userInfo = AdminDao::instance()->where('username', $receive)->get();
        if (!$userInfo) {
            $this->error = '收件人不存在';
            return false;
        }
        if ($userInfo['status'] != AdminEnum::ADMIN_STATUS['enable']) {
            $this->error = '无效收件人';
            return false;
        }
        // 验证收件人是否接收站内信
        if ($userInfo['receiver'] != AdminEnum::ADMIN_STATUS['enable']) {
            $this->error = '收件人拒绝接收私信';
            return false;
        }

        $now = time();
        Db::startTrans();
        try {
            Logger::instance()->channel()->info('Add user message');
            // 创建站内信
            $message_id = MessageDao::instance()->save([
                'type'      => 0,
                'uid'       => $adminID,
                'title'     => $title,
                'send_time' => $now,
                'send_uid'  => $adminID,
                'status'    => MessageEnum::MESSAGE_STATUS['publish']
            ], true, true);
            if (!$message_id) {
                Db::rollback();
                $this->error = '发送站内信失败';
                return false;
            }
            // 保存内容
            $saveContent = MessageContentDao::instance()->add($message_id, $content);
            if (!$saveContent) {
                Db::rollback();
                $this->error = MessageContentDao::instance()->getError();
                return false;
            }
            // 发送
            $saveReceiver = $this->push($message_id, [$userInfo['id']], $now);
            if (!$saveReceiver) {
                Db::rollback();
                $this->error = '发送私信失败';
                return false;
            }

            // 记录日志
            $record = AdminLogDao::instance()->record([
                'uid' => $adminID,
                'module' => 'sys',
                'action' => '发送用户消息',
                'content' => '发送用户消息: ' . $title . ', ID: ' . $message_id . ', 收信人：' . $userInfo['username'],
                'sid' => $message_id
            ]);
            if (!$record) {
                Db::rollback();
                $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                return false;
            }

            Db::commit();
            return true;
        } catch (Throwable $e) {
            Db::rollback();
            $this->error = '发送消息异常';
            Logger::instance()->channel()->error('Send user message exception. msg: ' . $e->getMessage());
            return false;
        }

        return true;
    }

    /**
     * 系统发送站内信
     *
     * @param integer $message_id   消息ID
     * @param array   $uids         用户ID列表，收件人
     * @param integer $adminID      管理员ID，发件人
     * @param boolean $isAll        是否全员发布
     * @return boolean
     */
    public function sys_send(int $message_id, array $uids, int $adminID, bool $isAll = false): bool
    {
        $info = MessageDao::instance()->where('id', $message_id)->get();
        if (!$info) {
            $this->error = '站内信不存在';
            return false;
        }
        switch ($info['status']) {
            case MessageEnum::MESSAGE_STATUS['remove']:
                $this->error = '该站内信已删除';
                return false;
            case MessageEnum::MESSAGE_STATUS['publish']:
                $this->error = '该站内信已发布, 请勿重复操作';
                return false;
        }

        Db::startTrans();
        try {
            Logger::instance()->channel()->info('Send message');
            $now = time();
            $saveMessage = MessageDao::instance()->where('id', $message_id)->save([
                'status' => MessageEnum::MESSAGE_STATUS['publish'],
                'send_uid' => $adminID,
                'send_time' => $now
            ]);
            if (!$saveMessage) {
                Db::rollback();
                $this->error = '发送站内信失败';
                return false;
            }

            // 是否全量发送
            if ($isAll) {
                $uids = [0];
            }
            $send = $this->push($info['id'], $uids, $now);
            if (!$send) {
                Db::rollback();
                $this->error = '发送站内信失败';
                return false;
            }
            // 记录日志
            $record = AdminLogDao::instance()->record([
                'uid' => $adminID,
                'module' => 'sys',
                'action' => '发送站内信',
                'content' => '发送站内信: ' . $info['title'] . ', ID: ' . $info['id'],
                'sid' => $info['id']
            ]);
            if (!$record) {
                Db::rollback();
                $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();
                return false;
            }

            Db::commit();
            return true;
        } catch (Throwable $e) {
            Db::rollback();
            $this->error = '发送站内信异常';
            Logger::instance()->channel()->error('Send message exception. msg: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 拉取站内信
     *
     * @param integer $uid  用户ID
     * @throws RuntimeException 拉取失败
     * @return integer|bool 有新数据返回新数据数，其他返回成功失败
     */
    public function pull(int $uid): int
    {
        // 获取用户已拉取最新的站内信ID
        $lastMessage = AdminMessageDao::instance()->order('message_id', 'DESC')->where('uid', $uid)->field(['message_id', 'send_time'])->get();
        $lastMsgID = $lastMessage ? $lastMessage['message_id'] : 0;
        // 获取未拉取的站内信列表
        $list = MessageReceiverDao::instance()->where('message_id', '>', $lastMsgID)->whereRaw("`receive_id` = {$uid} OR `receive_id` = 0")->all();
        if (!$list) {
            // 没有新消息
            return 0;
        }
        // 保存
        $data = [];
        foreach ($list as $item) {
            $data[] = [
                'uid' => $uid,
                'message_id' => $item['message_id'],
                'send_time' => $item['send_time']
            ];
        }
        $save = AdminMessageDao::instance()->saveAll($data);
        if (!$save) {
            throw new RuntimeException('获取最新站内信消息失败');
        }

        return count($data);
    }

    /**
     * 写入发送的站内信，待pull拉取
     *
     * @param integer $message_id   站内信ID
     * @param array $receive 接收人ID列表
     * @param integer $send_time   发信时间，默认当前时间
     * @return boolean
     */
    public function push(int $message_id, array $receive, int $send_time = null): bool
    {
        $send_time = is_null($send_time) ? time() : $send_time;
        $data = [];
        foreach ($receive as $id) {
            $data[] = [
                'message_id' => $message_id,
                'receive_id' => $id,
                'send_time'  => $send_time
            ];
        }
        $save = MessageReceiverDao::instance()->saveAll($data);
        if (!$save) {
            $this->error = '发送失败';
            return false;
        }

        return true;
    }

    /**
     * 获取错误信息
     *
     * @return mixed
     */
    public function getError()
    {
        $error = $this->error;
        $this->error = null;
        return $error;
    }
}
