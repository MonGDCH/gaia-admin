<?php

declare(strict_types=1);

namespace plugins\admin\service;

use Throwable;
use mon\log\Logger;
use think\facade\Db;
use mon\util\Instance;
use support\cache\CacheService;
use plugins\admin\dao\OptionsDao;
use plugins\admin\dao\AdminLogDao;

/**
 * 字典服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class DictService
{
    use Instance;

    /**
     * 字典缓存标志位
     * 
     * @var string
     */
    const MARK = 'dict_';

    /**
     * 字典索引缓存标志位
     * 
     * @var string
     */
    const KEY_MARK = 'group_key';

    /**
     * 错误信息
     *
     * @var mixed
     */
    protected $error;

    /**
     * 获取字典数据
     *
     * @param string $group     字典名称
     * @param string $key       字典索引
     * @param mixed $default    默认值
     * @return mixed
     */
    public function get(string $group, string $index = '', $default = null)
    {
        $key = $this->getKey($group);
        $data = CacheService::instance()->get($key, []);
        if (!$data) {
            // 不存在缓存，从数据库获取
            $data = OptionsDao::instance()->where('group', $group)->where('status', 1)->column('value', 'index');
            if (!$data) {
                // 不存在数据，返回默认值
                return $default;
            }
            // 缓存数据
            $cache = CacheService::instance()->set($key, $data);
            if (!$cache) {
                // 缓存失败，返回默认值
                Logger::instance()->channel()->error('缓存字典数据失败：' . json_encode($data, JSON_UNESCAPED_UNICODE));
                return $default;
            }
            $keys = CacheService::instance()->get($this->getGroupKey(), []);
            $keys[] = $group;
            $cacheKeys = CacheService::instance()->set($this->getGroupKey(), array_unique($keys));
            if (!$cacheKeys) {
                // 缓存keys失败，记录日志
                Logger::instance()->channel()->error('缓存字典keys数据失败：' . json_encode($keys, JSON_UNESCAPED_UNICODE));
            }
        }

        // 空索引，返回所有
        if (empty($index)) {
            return $data;
        }

        return $data[$index] ?? $default;
    }

    /**
     * 修改字典
     *
     * @param array $data   修改的字典数据 ['group' => ['k1' => 'v1', 'k2' => 'v2']]
     * @param integer $adminID  管理员ID，大于0则记录日志
     * @param boolean $reload   是否重载对应字典缓存
     * @param string  $log_model  管理员日志模块
     * @return boolean
     */
    public function edit(array $data, int $adminID, bool $reload = true, string $log_model = 'sys')
    {
        Db::startTrans();
        try {
            $groups = [];
            // 生成SQL
            $tableName = OptionsDao::instance()->getTable();
            $now = time();
            foreach ($data as $group => $item) {
                $groups[] = $group;
                $case = [];
                foreach ($item as $k => $v) {
                    $case[] = "WHEN '{$k}' THEN '{$v}' ";
                }
                $indexs = implode("','", array_keys($item));
                $cases = implode('', $case);
                $sql = "UPDATE `{$tableName}` SET `update_time` = {$now}, `value` = (CASE `index` {$cases} END) WHERE `group` = '{$group}' AND `index` IN ('{$indexs}')";

                // 分组保存数据
                $save = Db::execute($sql);
                if (!$save) {
                    Db::rollback();
                    $this->error = '修改字典数据失败! group: ' . $group . '，item：' . json_encode($item);
                    return false;
                }
            }

            // 保存操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => $log_model,
                    'action' => '修改配置字典',
                    'content' => '修改配置字典：' . json_encode($data),
                ]);
                if (!$record) {
                    Db::rollback();
                    $this->error = '记录操作日志失败, ' . AdminLogDao::instance()->getError();
                    return false;
                }
            }

            // 刷新字典缓存
            if ($reload) {
                foreach ($groups as $gname) {
                    $reload = $this->reload($gname);
                    if (!$reload) {
                        Db::rollback();
                        $this->error = '刷新字典缓存失败，group：' . $gname;
                        return false;
                    }
                }
            }

            Db::commit();
            return true;
        } catch (Throwable $e) {
            Db::rollback();
            $this->error = '修改字典数据异常：' . $e->getMessage();
            // 记录日志
            Logger::instance()->channel()->error($this->error . PHP_EOL . Db::getLastSql());
            return false;
        }
    }

    /**
     * 重新加载字典缓存
     *
     * @param string $group 字段名
     * @return boolean
     */
    public function reload(string $group = ''): bool
    {
        $query = OptionsDao::instance()->where('status', 1)->field(['group', 'index', 'value']);
        if (!empty($group)) {
            $query->where('group', $group);
        }
        $list = $query->all();
        $data = [];
        $keys = CacheService::instance()->get($this->getGroupKey(), []);
        foreach ($list as $item) {
            $key = $this->getKey($item['group']);
            $keys[] = $key;
            $data[$key][$item['index']] = $item['value'];
        }
        $cacheKeys = CacheService::instance()->set($this->getGroupKey(), array_unique($keys));
        $cache = CacheService::instance()->setMultiple($data);

        return $cacheKeys && $cache;
    }

    /**
     * 清除缓存字典
     *
     * @param string $group
     * @return boolean
     */
    public function clear(string $group = ''): bool
    {
        if (!empty($group)) {
            $key = $this->getKey($group);
            return CacheService::instance()->delete($key);
        }

        $indexKey = $this->getGroupKey();
        $keys = CacheService::instance()->get($indexKey, []);
        $keys[] = $indexKey;
        return CacheService::instance()->deleteMultiple($keys);
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

    /**
     * 获取缓存key名
     *
     * @param string $group
     * @return string
     */
    protected function getKey(string $group): string
    {
        return self::MARK . $group;
    }

    /**
     * 获取字典索引缓存key名
     *
     * @return string
     */
    protected function getGroupKey(): string
    {
        return $this->getKey(self::KEY_MARK);
    }
}
