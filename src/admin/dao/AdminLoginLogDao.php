<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\http\Context;
use mon\http\Request;
use mon\thinkORM\Dao;
use mon\util\Instance;

/**
 * 管理员登录日志Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AdminLoginLogDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'admin_login_log';

    /**
     * 记录日志
     *
     * @param array $option     请求参数
     * @return integer  日志ID
     */
    public function record(array $option): int
    {
        $check = $this->validate()->rule([
            'uid'       => ['required', 'int', 'min:0'],
            'type'      => ['required', 'int', 'min:0'],
            'action'    => ['required', 'str'],
            'content'   => ['str'],
            'ua'        => ['str'],
            'ip'        => ['ip'],
            'sid'       => ['int', 'min:0'],
        ])->message([
            'uid'       => '请输入用户ID',
            'type'      => '请输入合法的记录类型',
            'action'    => '请输入操作类型',
            'content'   => '请输入操作内容',
            'ua'        => '请输入合法的ua标识',
            'ip'        => '请输入合法的IP地址',
            'sid'       => '请输入关联记录ID',
        ])->data($option)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }

        /** @var Request $request 上下文请求实例 */
        $request = Context::get(Request::class);

        $info = [];
        $info['uid'] = $option['uid'];
        $info['type'] = $option['type'];
        $info['action'] = $option['action'];
        $info['content'] = $option['content'] ?? '';
        $info['sid'] = $option['sid'] ?? 0;
        $info['ua'] = $option['ua'] ?? ($request ? $request->header('user-agent', '') : '');
        $info['ip'] = $option['ip'] ?? ($request ? $request->ip() : '0.0.0.0');
        $info['create_time'] = time();

        // 保存
        $saveLogID = $this->save($info, true, true);
        if (!$saveLogID) {
            $this->error = '记录登录日志失败';
            return 0;
        }

        return $saveLogID;
    }

    /**
     * 查询日志列表
     *
     * @param array $data 请求参数
     * @param bool  $format 是否格式获取数据
     * @return array
     */
    public function getList(array $data): array
    {
        $limit = isset($data['limit']) ? intval($data['limit']) : 10;
        $page = isset($data['page']) && is_numeric($data['page']) ? intval($data['page']) : 1;
        // 查询
        $list = $this->scope('list', $data)->page($page, $limit)->field(['log.*', 'user.username'])->all();
        $total = $this->scope('list', $data)->count('log.id');

        return [
            'list'      => $list,
            'count'     => $total,
            'pageSize'  => $limit,
            'page'      => $page
        ];
    }

    /**
     * 查询列表场景
     *
     * @param \mon\thinkORM\extend\Query $query
     * @param array $option
     * @return mixed
     */
    protected function scopeList($query, $option)
    {
        $query->alias('log')->join(AdminDao::instance()->getTable() . ' user', 'log.uid=user.id', 'left');
        // 按用户ID
        if (isset($option['uid']) && $this->validate()->id($option['uid'])) {
            $query->where('log.uid', intval($option['uid']));
        }
        // 按用户名
        if (isset($option['username']) && is_string($option['username']) && !empty($option['username'])) {
            $query->whereLike('user.username', trim($option['username']));
        }
        // 时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('log.create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('log.create_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'log.id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'create_time'])) {
            $order = 'log.' . $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }
}
