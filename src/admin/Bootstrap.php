<?php

declare(strict_types=1);

namespace plugins\admin;

use mon\env\Config;
use gaia\interfaces\PluginInterface;
use mon\http\interfaces\AppInterface;

/**
 * 插件启动
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class Bootstrap implements PluginInterface
{
    /**
     * 是否启用插件
     *
     * @return boolean
     */
    public static function enable(): bool
    {
        return true;
    }

    /**
     * 初始化插件
     *
     * @return void
     */
    public static function register(array $options = [])
    {
        // 加载配置
        Config::instance()->loadDir(__DIR__ . '/config', true, [], 'admin');
        /** @var AppInterface $app  */
        $app = $options['app'];
        // 注册路由
        $route = $app->route();
        require_once __DIR__ . '/router/router.php';
    }
    /**
     * 安装
     *
     * @return void
     */
    public static function install()
    {
    }

    /**
     * 卸载
     *
     * @return void
     */
    public static function uninstall()
    {
    }
}
