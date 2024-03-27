<?php

declare(strict_types=1);

namespace plugins\admin\controller;

use Throwable;
use mon\util\Tree;
use mon\env\Config;
use mon\log\Logger;
use mon\http\Request;
use support\auth\RbacService;
use plugins\admin\dao\MenuDao;
use plugins\admin\dao\FilesDao;
use plugins\admin\dao\FastMenuDao;
use plugins\admin\comm\Controller;
use plugins\admin\contract\MenuEnum;
use plugins\admin\comm\view\Template;
use plugins\admin\service\DictService;
use plugins\admin\service\AdminService;
use plugins\admin\service\UploadService;
use plugins\admin\service\CaptchaService;

/**
 * 首页
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class HomeController extends Controller
{
    /**
     * 验证码
     *
     * @param Request $request
     * @return mixed
     */
    public function captcha(Request $request)
    {
        // 创建验证码
        try {
            $app = $request->get('app');
            $id = sha1($app . microtime(true) . $request->ip() . mt_rand(0, 1000));
            $img = CaptchaService::instance()->create($app, $id, ['scalar', 'calcul']);
            return $this->success('ok', [
                'img' => $img->getBase64(),
                'key' => $id
            ]);
        } catch (Throwable $e) {
            Logger::instance()->channel()->error('Create captcha faild: ' . $e->getMessage());
            return $this->error('create captcha faild');
        }
    }

    /**
     * 登录
     *
     * @param Request $request
     * @return mixed
     */
    public function login(Request $request)
    {
        // 登录
        if ($request->isPost()) {
            // 校验验证码
            $captcha = $request->post('captcha', '');
            if (!$captcha) {
                return $this->error('验证码参数错误');
            }
            $id = $request->post('key', '');
            if (!$captcha) {
                return $this->error('验证码参数错误!');
            }
            if (!CaptchaService::instance()->check($captcha, 'login', $id)) {
                return $this->error('验证码错误');
            }

            // 登录
            $userInfo = AdminService::instance()->login($request->post('username', ''), $request->post('password', ''), $request->ip());
            if (!$userInfo) {
                return $this->error(AdminService::instance()->getError());
            }

            return $this->success('ok', [
                'index' => Template::buildURL('/'),
                'token' => AdminService::instance()->getToken($userInfo, $request->ip())
            ]);
        }

        // 页面配置
        $data = DictService::instance()->get('web', '', []);
        $key = Config::instance()->get('admin.page.jwt.tokenName', 'Mon-Auth-Token');
        $this->assign('key', $key);
        // 登录页
        return $this->fetch('login', $data);
    }

    /**
     * 框架页
     *
     * @return mixed
     */
    public function index(Request $request)
    {
        // 获取页面配置
        if ($request->get('isApi')) {
            $config = Config::instance()->get('admin.page', []);
            $pear = json_encode($config, JSON_UNESCAPED_UNICODE);
            return $this->view($pear, ['Content-Type' => 'application/json']);
        }

        // 页面配置
        $web = DictService::instance()->get('web', '', []);
        // 渲染页面
        return $this->fetch('index', [
            // 首页
            'index' => Config::instance()->get('admin.page.tab.index.id', 1),
            // 页面配置
            'web' => $web,
            // 用户信息
            'userInfo' => $request->userInfo
        ]);
    }

    /**
     * 获取菜单配置
     *
     * @param Request $request
     * @return mixed
     */
    public function nav(Request $request)
    {
        // 获取首页
        $fixedPage = Config::instance()->get('admin.page.tab.href');
        // 获取当前用户拥有的权限节点
        $userRule = RbacService::instance()->getAuthList($request->uid);
        // 是否超级管理员
        $isSuperAdmin = in_array(Config::instance()->get('auth.rbac.admin_mark', '*'), $userRule);
        // 获取菜单列表
        $field = ['id', 'pid', 'icon', 'name', 'title', 'type', 'openType'];
        $menuList = MenuDao::instance()->where('status', MenuEnum::MENU_STATUS['enable'])->order('sort DESC, id ASC')->field($field)->all();
        // 过滤没有权限的菜单，生成菜单配置
        foreach ($menuList as $k => &$v) {
            // 具有权限或为第三方地址或为默认页面，则渲染
            if ($v['name'] != $fixedPage && !$isSuperAdmin && !in_array(strtolower($v['name']), $userRule) && strpos($v['name'], '://') === false) {
                unset($menuList[$k]);
                continue;
            }
            // 打开方式
            $v['openType'] = MenuEnum::MENU_OPEN_TYPE_MARK[$v['openType']];
            // 打开链接
            $v['href'] = $v['type'] == 1 ? Template::buildURL($v['name']) : '';
        }
        // 生成树状结构
        $data = Tree::instance()->data($menuList)->getTree('children');

        return $this->view(json_encode($data, JSON_UNESCAPED_UNICODE), ['Content-Type' => 'application/json']);
    }

    /**
     * 控制台桌面
     *
     * @return mixed
     */
    public function console(Request $request)
    {
        if ($request->get('isApi')) {
            // 获取快捷菜单
            $data = FastMenuDao::instance()->getList($request->uid);
            foreach ($data as &$item) {
                // 打开链接
                $item['href'] = Template::buildURL($item['name']);
            }
            return $this->success('ok', $data);
        }

        $this->assign('page_title', '控制台桌面');
        $this->assign('userInfo', $request->userInfo);
        return $this->fetch('console');
    }

    /**
     * 添加快捷菜单
     *
     * @param Request $request
     * @return mixed
     */
    public function addFastMenu(Request $request)
    {
        $menu_id = $request->post('menu', 0);
        if (!check('int', $menu_id) || $menu_id < 1) {
            return $this->error('请选择菜单');
        }

        $save = FastMenuDao::instance()->add(intval($request->uid), intval($menu_id));
        if (!$save) {
            return $this->error(FastMenuDao::instance()->getError());
        }

        return $this->success('操作成功');
    }

    /**
     * 删除快捷菜单
     *
     * @param Request $request
     * @return mixed
     */
    public function delFastMenu(Request $request)
    {
        $menu_id = $request->post('menu', 0);
        if (!check('int', $menu_id) || $menu_id < 1) {
            return $this->error('请选择菜单');
        }

        $save = FastMenuDao::instance()->remove(intval($request->uid), intval($menu_id));
        if (!$save) {
            return $this->error(FastMenuDao::instance()->getError());
        }
        return $this->success('操作成功');
    }

    /**
     * 文件上传
     *
     * @param Request $request
     * @return mixed
     */
    public function upload(Request $request)
    {
        $file = $request->file('file');
        if (!$file) {
            return $this->error('未上传文件');
        }

        $module = $request->post('module', '');
        if (!is_string($module)) {
            return $this->error('params module faild');
        }

        $result = [];
        if (is_array($file)) {
            foreach ($file as $item) {
                $fileInfo = UploadService::instance()->save($item, $module);
                if (!$fileInfo) {
                    return $this->error(UploadService::instance()->getError());
                }
                $result[] = [
                    'name' => $fileInfo['filename'],
                    'path' => $fileInfo['path'],
                    'url' => Template::buildAssets($fileInfo['path'])
                ];
            }
        } else {
            $fileInfo = UploadService::instance()->save($file, $module);
            if (!$fileInfo) {
                return $this->error(UploadService::instance()->getError());
            }
            $result[] = [
                'name' => $fileInfo['filename'],
                'path' => $fileInfo['path'],
                'url' => Template::buildAssets($fileInfo['path'])
            ];
        }

        return $this->success('ok', $result);
    }

    /**
     * 获取上传文件列表信息
     *
     * @param Request $request
     * @return mixed
     */
    public function files(Request $request)
    {
        $query = $request->get();
        $type = $request->get('type');
        if (in_array($type, ['img', 'video', 'audio', 'document', 'package'])) {
            $extList = [];
            switch ($type) {
                case 'img':
                    $extList = ['jpg', 'jpeg', 'png', 'gif'];
                    break;
                case 'audio':
                    $extList = ['mp3'];
                    break;
                case 'video':
                    $extList = ['mp4', 'avi', 'mkv', 'flv', 'rmvb'];
                    break;
                case 'document':
                    $extList = ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'xls', 'xlsx', 'csv', 'md', 'txt'];
                    break;
                case 'package':
                    $extList = ['zip'];
                    break;
            }
            $query['extList'] = $extList;
        }

        $result = FilesDao::instance()->getList($query);
        return $this->success('ok', $result['list'], ['count' => $result['count']]);
    }
}
