<?php

declare(strict_types=1);

namespace plugins\admin\service;

use mon\log\Logger;
use RuntimeException;
use mon\util\Instance;
use plugins\admin\dao\CounterDao;

/**
 * 计数器相关服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CounterService
{
    use Instance;

    /**
     * 错误信息
     *
     * @var string
     */
    protected $error = '';

    /**
     * 获取计数器计数
     *
     * @param string $app       应用索引
     * @param string $module    模块索引
     * @param integer $uid      用户索引
     * @return integer
     */
    public function get(string $app, string $module, int $uid = 0): int
    {
        $info = CounterDao::instance()->where('app', $app)->where('module', $module)->where('uid', $uid)->field('count')->get();
        if (!$info) {
            throw new RuntimeException('计数器不存在');
        }

        return intval($info['count']);
    }

    /**
     * 创建计数器
     *
     * @param string $app       应用索引
     * @param string $module    模块索引
     * @param integer $uid      用户索引
     * @param integer $count    计数
     * @param string $remark    备注
     * @return boolean
     */
    public function create(string $app, string $module, int $uid = 0, int $count = 0, string $remark = ''): bool
    {
        $where = [
            'app' => $app,
            'module' => $module,
            'uid' => $uid
        ];
        $counter = CounterDao::instance()->where($where)->field('id')->get();
        if ($counter) {
            $this->error = '计数器已存在';
            return false;
        }

        Logger::instance()->channel()->info('Create Counter: ' . $app . '-' . $module . '-' . $uid);
        $save = CounterDao::instance()->save([
            'app' => $app,
            'module' => $module,
            'uid' => $uid,
            'count' => $count,
            'remark' => $remark
        ], true);
        if (!$save) {
            $this->error = '新增计数器失败';
            return false;
        }

        return true;
    }

    /**
     * 计数器是否存在
     *
     * @param string $app       应用索引
     * @param string $module    模块索引
     * @param integer $uid      用户索引
     * @return boolean
     */
    public function has(string $app, string $module, int $uid = 0): bool
    {
        $where = [
            'app' => $app,
            'module' => $module,
            'uid' => $uid
        ];
        $counter = CounterDao::instance()->where($where)->field('id')->find();
        return !empty($counter);
    }

    /**
     * 增加计数
     *
     * @param string $app       应用索引
     * @param string $module    模块索引
     * @param integer $uid      用户索引
     * @param integer $count    计数
     * @return boolean
     */
    public function add(string $app, string $module, int $uid = 0, int $count = 1): bool
    {
        $where = [
            'app' => $app,
            'module' => $module,
            'uid' => $uid
        ];
        $counter = CounterDao::instance()->where($where)->field('id')->findOrEmpty();
        Logger::instance()->channel()->info('Add Counter: ' . $app . '-' . $module . '-' . $uid . ', count: ' . $count);
        if (!$counter) {
            // 计数器不存，直接创建
            $save = CounterDao::instance()->save([
                'app' => $app,
                'module' => $module,
                'uid' => $uid,
                'count' => $count,
            ], true);
        } else {
            // 存在计数器，修改计数值
            $save = CounterDao::instance()->inc('count', $count)->where('id', $counter['id'])->save();
        }
        if (!$save) {
            $this->error = '增加计数失败';
            return false;
        }

        return true;
    }

    /**
     * 减少计数
     *
     * @param string $app       应用索引
     * @param string $module    模块索引
     * @param integer $uid      用户索引
     * @param integer $count    计数
     * @return boolean
     */
    public function reduce(string $app, string $module, int $uid = 0, int $count = 1): bool
    {
        $where = [
            'app' => $app,
            'module' => $module,
            'uid' => $uid
        ];
        $counter = CounterDao::instance()->where($where)->field(['id', 'count'])->get();
        if (!$counter) {
            $this->error = '计数器不存在';
            return false;
        }
        if ($counter['count'] < $count) {
            $this->error = '计数器计数小于减少值';
            return false;
        }

        Logger::instance()->channel()->info('Reduce Counter: ' . $app . '-' . $module . '-' . $uid . ', count: ' . $count);
        $save = CounterDao::instance()->dec('count', $count)->where('id', $counter['id'])->save([]);
        if (!$save) {
            $this->error = '减少计数失败';
            return false;
        }

        return true;
    }

    /**
     * 修改计数
     *
     * @param string $app       应用索引
     * @param string $module    模块索引
     * @param integer $uid      用户索引
     * @param integer $count    计数
     * @return boolean
     */
    public function modify(string $app, string $module, int $uid = 0, int $count = 1): bool
    {
        $where = [
            'app' => $app,
            'module' => $module,
            'uid' => $uid
        ];
        $counter = CounterDao::instance()->where($where)->field('id')->get();
        Logger::instance()->channel()->info('Modify Counter: ' . $app . '-' . $module . '-' . $uid . ', count: ' . $count);
        if (!$counter) {
            // 计数器不存，直接创建
            $save = CounterDao::instance()->save([
                'app' => $app,
                'module' => $module,
                'uid' => $uid,
                'count' => $count,
            ], true);
        } else {
            // 存在计数器，修改计数值
            $save = CounterDao::instance()->where('id', $counter['id'])->save(['count' => $count]);
        }
        if (!$save) {
            $this->error = '修改计数失败';
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
