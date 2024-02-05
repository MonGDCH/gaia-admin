<?php
/*
|--------------------------------------------------------------------------
| 定义应用请求路由
|--------------------------------------------------------------------------
| 通过Route类进行注册
|
*/

use mon\env\Config;
use mon\http\Route;
use plugins\admin\controller\MsgController;
use plugins\admin\middleware\AuthMiddleware;
use plugins\admin\controller\HomeController;
use plugins\admin\middleware\LoginMiddleware;
use plugins\admin\controller\ProfileController;
use plugins\admin\Controller\sys\LogController;
use plugins\admin\controller\sys\MenuController;
use plugins\admin\controller\sys\AdminController;
use plugins\admin\Controller\sys\dev\FormController;
use plugins\admin\controller\sys\ops\CacheController;
use plugins\admin\controller\sys\auth\RuleController;
use plugins\admin\controller\sys\auth\GroupController;
use plugins\admin\controller\sys\dev\CounterController;
use plugins\admin\controller\sys\dev\CrontabController;
use plugins\admin\controller\sys\ops\MigrateController;
use plugins\admin\controller\sys\notice\MessageController;
use plugins\admin\Controller\sys\dictionary\RegionController;
use plugins\admin\controller\sys\notice\MessageTypeController;
use plugins\admin\controller\sys\dictionary\OptionsController;
use plugins\admin\Controller\sys\dictionary\ExpressController;

/** @var Route $route */
$route->group(Config::instance()->get('admin.app.root_path', ''), function (Route $route) {
    // 登录
    $route->map(['GET', 'POST'], '/login', [HomeController::class, 'login']);
    // 验证码
    $route->get('/captcha', [HomeController::class, 'captcha']);

    // 验证登录态
    $route->group(['middleware' => LoginMiddleware::class], function (Route $route) {

        // 首页，及页面配置
        $route->get('', [HomeController::class, 'index']);
        $route->get('/', [HomeController::class, 'index']);
        $route->get('/index', [HomeController::class, 'index']);
        // 菜单
        $route->get('/nav', [HomeController::class, 'nav']);
        // 控制台
        $route->get('/console', [HomeController::class, 'console']);
        // 文件上传
        $route->post('/upload', [HomeController::class, 'upload']);
        // 上传文件列表
        $route->get('/files', [HomeController::class, 'files']);
        // 新增快捷菜单
        $route->post('/addFastMenu', [HomeController::class, 'addFastMenu']);
        // 删除快捷菜单
        $route->post('/delFastMenu', [HomeController::class, 'delFastMenu']);

        // 用户站内信
        $route->group('/msg', function (Route $route) {
            // 查看
            $route->get('', [MsgController::class, 'index']);
            // 读取
            $route->get('/read', [MsgController::class, 'read']);
            // 预览发送的私信
            $route->get('/preview', [MsgController::class, 'preview']);
            // 拉取站内信
            $route->post('/pull', [MsgController::class, 'pull']);
            // 发送站内信
            $route->map(['get', 'post'], '/send', [MsgController::class, 'send']);
        });

        // 用户相关
        $route->group('/profile', function (Route $route) {
            // 个人设置
            $route->get('', [ProfileController::class, 'index']);
            // 编辑用户头像
            $route->get('/avatar', [ProfileController::class, 'avatar']);
            // 登录日志
            $route->get('/loginLog', [ProfileController::class, 'loginLog']);
            // 操作日志
            $route->get('/operLog', [ProfileController::class, 'operLog']);
            // 修改用户信息
            $route->post('/editInfo', [ProfileController::class, 'editInfo']);
            // 修改密码
            $route->map(['GET', 'POST'], '/password', [ProfileController::class, 'password']);
        });

        // 系统管理
        $route->group(['path' => '/sys', 'middleware' => AuthMiddleware::class], function (Route $route) {

            // 站内信
            $route->group('/notice', function (Route $route) {
                // 消息类型
                $route->group('/type', function (Route $route) {
                    // 列表
                    $route->get('', [MessageTypeController::class, 'index']);
                    // 新增
                    $route->map(['get', 'post'], '/add', [MessageTypeController::class, 'add']);
                    // 编辑
                    $route->map(['get', 'post'], '/edit', [MessageTypeController::class, 'edit']);
                });
                // 消息通知
                $route->group('/message', function (Route $route) {
                    // 列表
                    $route->get('', [MessageController::class, 'index']);
                    // 新增
                    $route->map(['get', 'post'], '/add', [MessageController::class, 'add']);
                    // 编辑
                    $route->map(['get', 'post'], '/edit', [MessageController::class, 'edit']);
                    // 发送
                    $route->map(['get', 'post'], '/send', [MessageController::class, 'send']);
                    // 删除恢复
                    $route->post('/toggle', [MessageController::class, 'toggle']);
                });
            });

            // 权限
            $route->group('/auth', function (Route $route) {
                // 权限规则
                $route->group(['path' => '/rule'], function (Route $route) {
                    // 查看权限规则
                    $route->get('', [RuleController::class, 'index']);
                    // 新增权限规则
                    $route->map(['get', 'post'], '/add', [RuleController::class, 'add']);
                    // 编辑权限规则
                    $route->map(['get', 'post'], '/edit', [RuleController::class, 'edit']);
                });

                // 规则角色组别
                $route->group('/group', function (Route $route) {
                    // 查看角色组别
                    $route->get('', [GroupController::class, 'index']);
                    // 新增角色组别
                    $route->map(['get', 'post'], '/add', [GroupController::class, 'add']);
                    // 编辑角色组别
                    $route->map(['get', 'post'], '/edit', [GroupController::class, 'edit']);
                    // 角色组别权限规则树
                    $route->get('/role', [GroupController::class, 'role']);
                    // 角色组别关联用户
                    $route->get('/user', [GroupController::class, 'user']);
                    // 角色组别绑定用户
                    $route->map(['get', 'post'], '/bind', [GroupController::class, 'bind']);
                    // 角色组别用户解绑
                    $route->post('/unbind', [GroupController::class, 'unbind']);
                });
            });

            // 数据字典
            $route->group('/dictionary', function (Route $route) {
                // 配置
                $route->group('/options', function (Route $route) {
                    // 查看字典
                    $route->get('', [OptionsController::class, 'index']);
                    // 新增字典
                    $route->map(['get', 'post'], '/add', [OptionsController::class, 'add']);
                    // 编辑字典
                    $route->post('/edit', [OptionsController::class, 'edit']);
                    // 删除字典
                    $route->post('/delete', [OptionsController::class, 'delete']);
                    // 修改字典状态
                    $route->post('/toggle', [OptionsController::class, 'toggle']);
                    // 缓存字典
                    $route->post('/cache', [OptionsController::class, 'cache']);
                });

                // 省份城市
                $route->group('/region', function (Route $route) {
                    // 列表
                    $route->get('', [RegionController::class, 'index']);
                    // 新增
                    $route->map(['GET', 'POST'], '/add', [RegionController::class, 'add']);
                    // 编辑
                    $route->map(['GET', 'POST'], '/edit', [RegionController::class, 'edit']);
                });

                // 物流公司
                $route->group('/express', function (Route $route) {
                    // 列表
                    $route->get('', [ExpressController::class, 'index']);
                    // 新增
                    $route->map(['GET', 'POST'], '/add', [ExpressController::class, 'add']);
                    // 编辑
                    $route->map(['GET', 'POST'], '/edit', [ExpressController::class, 'edit']);
                });
            });

            // 运维
            $route->group('/ops', function (Route $route) {
                // 数据备份
                $route->group('/migrate', function (Route $route) {
                    // 查看表信息
                    $route->get('', [MigrateController::class, 'index']);
                    // 优化表
                    $route->post('/optimize', [MigrateController::class, 'optimize']);
                    // 修复表
                    $route->post('/repair', [MigrateController::class, 'repair']);
                    // 备份表
                    $route->post('/backup', [MigrateController::class, 'backup']);
                    // 下载备份
                    $route->get('/download', [MigrateController::class, 'download']);
                });

                // 缓存
                $route->group('/cache', function (Route $route) {
                    // 缓存页
                    $route->map(['get', 'post'], '', [CacheController::class, 'index']);
                    // 清除缓存
                    $route->post('/clear', [CacheController::class, 'clear']);
                });
            });

            // 开发辅助
            $route->group('/dev', function (Route $route) {
                // 计数器
                $route->group('/counter', function (Route $route) {
                    // 列表
                    $route->get('', [CounterController::class, 'index']);
                    // 修改
                    $route->map(['get', 'post'], '/edit', [CounterController::class, 'edit']);
                    // 删除
                    $route->post('/remove', [CounterController::class, 'remove']);
                });

                // 定时任务
                $route->group('/crontab', function (Route $route) {
                    // 列表
                    $route->get('', [CrontabController::class, 'index']);
                    // 新增
                    $route->map(['get', 'post'], '/add', [CrontabController::class, 'add']);
                    // 修改
                    $route->map(['get', 'post'], '/edit', [CrontabController::class, 'edit']);
                    // 运行状态
                    $route->get('/ping', [CrontabController::class, 'ping']);
                    // 查看任务池
                    $route->get('/pool', [CrontabController::class, 'pool']);
                    // 查看日志
                    $route->get('/log', [CrontabController::class, 'log']);
                    // 重载任务
                    $route->post('/reload', [CrontabController::class, 'reload']);
                });

                // 表单模型
                $route->group('/form', function (Route $route) {
                    // 列表页
                    $route->get('', [FormController::class, 'index']);
                    // 预览
                    $route->get('/preview', [FormController::class, 'preview']);
                    // 新增
                    $route->map(['get', 'post'], '/add', [FormController::class, 'add']);
                    // 修改
                    $route->map(['get', 'post'], '/edit', [FormController::class, 'edit']);
                    // 封解冻表单模型
                    $route->post('/toggle', [FormController::class, 'toggle']);
                });
            });

            // 日志
            $route->group('/log', function (Route $route) {
                // 管理员操作日志
                $route->get('/admin', [LogController::class, 'adminLog']);
                // 管理员登录日志
                $route->get('/adminLogin', [LogController::class, 'adminLoginLog']);
            });

            // 菜单
            $route->group('/menu', function (Route $route) {
                // 首页
                $route->get('', [MenuController::class, 'index']);
                // 新增
                $route->map(['GET', 'POST'], '/add', [MenuController::class, 'add']);
                // 编辑
                $route->map(['GET', 'POST'], '/edit', [MenuController::class, 'edit']);
            });

            // 用户管理
            $route->group('/admin', function (Route $route) {
                // 查看管理员
                $route->get('', [AdminController::class, 'index']);
                // 新增管理员
                $route->map(['get', 'post'], '/add', [AdminController::class, 'add']);
                // 编辑管理员信息
                $route->map(['get', 'post'], '/edit', [AdminController::class, 'edit']);
                // 重置管理员密码
                $route->map(['get', 'post'], '/password', [AdminController::class, 'password']);
                // 封解冻管理员
                $route->post('/toggle', [AdminController::class, 'toggle']);
            });
        });
    });

    // // 加载管理端插件路由
    // if (is_dir(__DIR__ . DIRECTORY_SEPARATOR . 'admin')) {
    //     $dir = __DIR__ . DIRECTORY_SEPARATOR . 'admin';
    //     $iterator = new RecursiveDirectoryIterator($dir, RecursiveDirectoryIterator::SKIP_DOTS | RecursiveDirectoryIterator::FOLLOW_SYMLINKS);
    //     foreach ($iterator as $file) {
    //         // 过滤目录及非文件
    //         if ($file->isDir() || $file->getExtension() != 'php') {
    //             continue;
    //         }
    //         // 加载文件
    //         require_once $file->getPathname();
    //     }
    // }
});
