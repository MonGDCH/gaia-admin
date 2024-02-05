<?php

declare(strict_types=1);

namespace process\crontab;

use Throwable;
use mon\util\Tool;
use mon\log\Logger;
use mon\env\Config;
use mon\thinkOrm\ORM;
use Workerman\Worker;
use gaia\ProcessTrait;
use Workerman\Crontab\Crontab;
use support\cache\CacheService;
use support\service\RedisService;
use plugins\admin\dao\CrontabDao;
use plugins\admin\dao\CrontabLogDao;
use gaia\interfaces\ProcessInterface;
use Workerman\Connection\TcpConnection;
use plugins\admin\contract\CrontabEnum;
use Workerman\Connection\AsyncTcpConnection;

/**
 * 定时任务服务进程
 *
 * Class Server
 * @author Mon <985558837@qq.com>
 * @copyright Gaia
 * @version 1.0.0 2023-11-23
 */
class Server implements ProcessInterface
{
    use ProcessTrait;

    /**
     * 任务池
     * 
     * @var array
     */
    protected $pool = [];

    /**
     * 业务锁有效时间
     * 
     * @var integer
     */
    protected $lock_expires = 600;

    /**
     * 业务锁缓存前缀
     *
     * @var string
     */
    protected $lock_prefix = 'mon_crontab_';

    /**
     * 允许指令调用调用方法名
     *
     * @var array
     */
    protected $allow_method = ['reload', 'getPool'];

    /**
     * 是否启用进程
     *
     * @return boolean
     */
    public static function enable(): bool
    {
        return Config::instance()->get('admin.crontab.app.enable', false);
    }

    /**
     * 获取进程配置
     *
     * @return array
     */
    public static function getProcessConfig(): array
    {
        return Config::instance()->get('admin.crontab.server', []);
    }

    /**
     * 构造方法
     */
    public function __construct()
    {
        $this->deleteLock();
    }

    /**
     * 进程启动
     *
     * @param Worker $worker worker进程
     * @return void
     */
    public function onWorkerStart(Worker $worker): void
    {
        // 配置信息
        $this->lock_expires = Config::instance()->get('admin.crontab.app.lock_expire', 600);
        $this->lock_prefix = Config::instance()->get('admin.crontab.app.lock_prefix', 'mon_crontab_');
        // 日志通道初始化
        Logger::instance()->createChannel('crontab', Config::instance()->get('admin.crontab.app.log', []));
        Logger::instance()->setDefaultChannel('crontab');
        // 数据库初始化
        $config = Config::instance()->get('database', []);
        ORM::register(defined('IN_WORKERMAN'), $config, Logger::instance()->channel(), CacheService::instance()->getService()->store());
        // 初始化加载现有启动的定时任务
        $taskList = CrontabDao::instance()->where('status', CrontabEnum::TASK_STATUS['enable'])->order('sort', 'DESC')->field('id')->all();
        foreach ($taskList as $item) {
            $this->runTask($item['id']);
        }
    }

    /**
     * 当客户端通过连接发来数据时触发的回调函数
     *
     * @param TcpConnection $connection
     * @param string $data
     * @return void
     */
    public function onMessage(TcpConnection $connection, string $data)
    {
        // 存活判断
        if ($data == 'ping') {
            $connection->send('pong');
            return;
        }

        $data = json_decode($data, true);
        if ($data && isset($data['method']) && in_array($data['method'], $this->allow_method)) {
            $method = $data['method'];
            $data = $data['data'] ?? [];
            $connection->send(call_user_func([$this, $method], $data));
            return;
        }

        $connection->send('Not support command');
    }

    /**
     * 重载任务
     *
     * @param string|array $data    任务ID列表
     * @return string
     */
    protected function reload($data)
    {
        if (is_string($data)) {
            $data = explode(',', $data);
        }

        foreach ($data as $id) {
            // 先删除原任务
            if (isset($this->pool[$id])) {
                $this->pool[$id]['crontab']->destroy();
                unset($this->pool[$id]);
            }

            $this->runTask($id);
        }

        return json_encode(['code' => 1, 'msg' => 'ok']);
    }

    /**
     * 获取任务池数据
     *
     * @return string
     */
    protected function getPool()
    {
        $data = [];
        foreach ($this->pool as $item) {
            $data[] = [
                'id'            => $item['id'],
                'type'          => $item['type'],
                'title'         => $item['title'],
                // 'target'        => $item['target'],
                // 'rule'          => $item['rule'],
                // 'params'        => $item['params'],
                // 'singleton'     => $item['singleton'],
                'create_time'   => $item['create_time'],
            ];
        }
        return json_encode(['code' => 1, 'msg' => 'ok', 'data' => $data], JSON_UNESCAPED_UNICODE);
    }

    /**
     * 运行定时任务
     *
     * @param mixed $id
     * @return string
     */
    protected function runTask($id)
    {
        $data = CrontabDao::instance()->where('id', $id)->where('status', CrontabEnum::TASK_STATUS['enable'])->get();
        if ($data && $this->decorateRunnable($data)) {
            // 处理定时任务
            $crontab = null;
            switch ($data['type']) {
                case CrontabEnum::TASK_TYPE['class']:
                    // 类方法任务
                    $crontab = new Crontab($data['rule'], function () use ($data) {
                        $time = time();
                        $class = trim($data['target']);
                        $startTime = microtime(true);
                        if ($class && strpos($class, '@') !== false) {
                            $class  = explode('@', $class);
                            $method = end($class);
                            array_pop($class);
                            $class = implode('@', $class);
                        } else {
                            $method = 'handler';
                        }

                        try {
                            $code = 1;
                            $exception = 'ok';
                            $params = !empty($data['params']) ? json_decode($data['params'], true) : [];
                            // 异步处理任务
                            $this->delivery([
                                'type' => 'class',
                                'data' => [
                                    'class' => $class,
                                    'method' => $method,
                                    'params' => $params,
                                ]
                            ]);
                        } catch (Throwable $e) {
                            $code = 0;
                            $exception = $e->getMessage();
                        } finally {
                            RedisService::instance()->delete($this->getTaskLockName($data));
                        }
                        $this->isSingleton($data);

                        $endTime = microtime(true);
                        // 记录日志，这里不使用事务，不判断结果，因为日志记录失败不会影响任务执行
                        CrontabDao::instance()->updateRunning(intval($data['id']), $time);
                        if ($data['savelog'] == CrontabEnum::TASK_LOG['enable']) {
                            // 记录运行日志
                            CrontabLogDao::instance()->record([
                                'crontab_id'    => $data['id'],
                                'target'        => $data['target'],
                                'params'        => $data['params'] ?? '',
                                'result'        => $exception ?? '',
                                'return_code'   => $code,
                                'running_time'  => round($endTime - $startTime, 6),
                            ]);
                        }
                    });

                    break;
                case CrontabEnum::TASK_TYPE['url']:
                    // URL请求任务
                    $crontab = new Crontab($data['rule'], function () use ($data) {
                        $time = time();
                        $url = trim($data['target']);
                        $startTime = microtime(true);
                        try {
                            $code = 1;
                            $exception = 'ok';
                            $params = !empty($data['params']) ? json_decode($data['params'], true) : [];
                            $method = $params['method'] ?? 'GET';
                            $header = $params['header'] ?? [];
                            $timeOut = $params['timeOut'] ?? 5;
                            $ua = $params['ua'] ?? '';
                            // 异步处理任务
                            $this->delivery([
                                'type' => 'url',
                                'data' => [
                                    'url' => $url,
                                    'method' => $method,
                                    'header' => $header,
                                    'timeOut' => $timeOut,
                                    'ua' => $ua,
                                    'data' => $params['data'] ?? []
                                ]
                            ]);
                        } catch (Throwable $e) {
                            $code = 0;
                            $exception = $e->getMessage();
                        } finally {
                            RedisService::instance()->delete($this->getTaskLockName($data));
                        }
                        $this->isSingleton($data);

                        $endTime = microtime(true);
                        // 记录日志，这里不使用事务，不判断结果，因为日志记录失败不会影响任务执行
                        CrontabDao::instance()->updateRunning(intval($data['id']), $time);
                        if ($data['savelog'] == CrontabEnum::TASK_LOG['enable']) {
                            // 记录运行日志
                            CrontabLogDao::instance()->record([
                                'crontab_id'    => $data['id'],
                                'target'        => $data['target'],
                                'params'        => $data['params'] ?? '',
                                'result'        => $exception ?? '',
                                'return_code'   => $code,
                                'running_time'  => round($endTime - $startTime, 6),
                            ]);
                        }
                    });

                    break;
                case CrontabEnum::TASK_TYPE['shell']:
                    // Shell脚本任务
                    $crontab = new Crontab($data['rule'], function () use ($data) {
                        $time = time();
                        $startTime = microtime(true);
                        try {
                            $code = 1;
                            $exception = shell_exec($data['target']);
                        } catch (Throwable $e) {
                            $code = 0;
                            $exception = $e->getMessage();
                        } finally {
                            RedisService::instance()->delete($this->getTaskLockName($data));
                        }
                        $this->isSingleton($data);
                        $endTime = microtime(true);
                        // 记录日志，这里不使用事务，不判断结果，因为日志记录失败不会影响任务执行
                        CrontabDao::instance()->updateRunning(intval($data['id']), $time);
                        if ($data['savelog'] == CrontabEnum::TASK_LOG['enable']) {
                            // 记录运行日志
                            CrontabLogDao::instance()->record([
                                'crontab_id'    => $data['id'],
                                'target'        => $data['target'],
                                'params'        => $data['params'] ?? '',
                                'result'        => $exception ?? '',
                                'return_code'   => $code,
                                'running_time'  => round($endTime - $startTime, 6),
                            ]);
                        }
                    });

                    break;
            }
            // 存在定时任务，注册定时任务池
            if (!is_null($crontab)) {
                $this->pool[$data['id']] = [
                    'id'            => $data['id'],
                    'type'          => $data['type'],
                    'title'         => $data['title'],
                    // 'target'        => $data['target'],
                    // 'rule'          => $data['rule'],
                    // 'params'        => $data['params'],
                    // 'singleton'     => $data['singleton'],
                    'create_time'   => date('Y-m-d H:i:s'),
                    'crontab'       => $crontab
                ];
            }
        }
    }

    /**
     * 投递到异步进程
     *
     * @param array $data
     * @return void
     */
    protected function delivery(array $data): void
    {
        $con = new AsyncTcpConnection(Config::instance()->get('admin.crontab.task.listen'));
        $con->onConnect = function (AsyncTcpConnection $con) use ($data) {
            $con->send(json_encode($data, JSON_UNESCAPED_UNICODE));
        };
        $con->onMessage = function (AsyncTcpConnection $con, $result) {
            // 异步处理响应结果
            Logger::instance()->channel()->info($result);
            // 断开链接
            $con->close();
        };
        $con->connect();
    }

    /**
     * 处理单次任务
     *
     * @param array $crontab
     * @return void
     */
    protected function isSingleton(array $crontab)
    {
        if ($crontab['singleton'] == CrontabEnum::SINGLETON_STATUS['once'] && isset($this->pool[$crontab['id']])) {
            $this->pool[$crontab['id']]['crontab']->destroy();
            unset($this->pool[$crontab['id']]);
            // 更新任务状态
            CrontabDao::instance()->where('id', $crontab['id'])->save(['status' => CrontabEnum::TASK_STATUS['disable']]);
        }
    }

    /**
     * 删除执行任务的key
     *
     * @return void
     */
    protected function deleteLock()
    {
        $keys = RedisService::instance()->keys($this->lock_prefix . '*');
        RedisService::instance()->delete($keys);
    }

    /**
     * 处理单一服务运行
     * 
     * @param array $crontab
     * @return boolean
     */
    protected function decorateRunnable(array $crontab): bool
    {
        if ($this->runInSingleton($crontab) && $this->runOnOneServer($crontab)) {
            return true;
        }
        return false;
    }

    /**
     * 解决任务的并发执行问题，服务实例永远只会同时运行1个
     *
     * @param array $crontab
     * @return boolean
     */
    protected function runOnOneServer(array $crontab): bool
    {
        $lockName = $this->getServerLockName($crontab);
        $macAddress = Tool::instance()->mac_address();
        $result = RedisService::instance()->set($lockName, $macAddress, ['NX', 'EX' => $this->lock_expires]);
        if ($result) {
            return true;
        }

        return RedisService::instance()->get($lockName) === $macAddress;
    }

    /**
     * 解决任务的并发执行问题，任务永远只会同时运行 1 个
     *
     * @param array $crontab
     * @return bool
     */
    protected function runInSingleton(array $crontab): bool
    {
        $lockName = $this->getTaskLockName($crontab);
        if (RedisService::instance()->exists($lockName) || !RedisService::instance()->set($lockName, $crontab['title'], ['NX', 'EX' => $this->lock_expires])) {
            return false;
        }

        return true;
    }

    /**
     * 获取任务锁标志名称
     *
     * @param array $crontab
     * @return string
     */
    protected function getTaskLockName(array $crontab): string
    {
        return $this->lock_prefix . 'task_' . sha1($crontab['title'] . $crontab['rule']);
    }

    /**
     * 获取服务锁标志名称
     *
     * @param array $crontab
     * @return string
     */
    protected function getServerLockName(array $crontab): string
    {
        return $this->lock_prefix . 'server_' . sha1($crontab['title'] . $crontab['rule']);
    }
}
