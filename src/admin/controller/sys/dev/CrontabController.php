<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\dev;

use Throwable;
use mon\env\Config;
use mon\http\Request;
use gaia\crontab\CrontabEnum;
use plugins\admin\dao\CrontabDao;
use plugins\admin\comm\Controller;
use support\crontab\CrontabService;
use plugins\admin\dao\CrontabLogDao;


/**
 * 产品管理插件控制器基类
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CrontabController extends Controller
{
    /**
     * 查看
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = CrontabDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        $this->assign('driver', Config::instance()->get('crontab.app.driver'));
        $this->assign('allowOper', Config::instance()->get('crontab.app.driver') != \gaia\crontab\driver\Job::class);
        $this->assign('type', CrontabEnum::TASK_TYPE_TITLE);
        $this->assign('status', CrontabEnum::TASK_STATUS_TITLE);
        $this->assign('typeList', json_encode(CrontabEnum::TASK_TYPE_TITLE, JSON_UNESCAPED_UNICODE));
        $this->assign('logList', json_encode(CrontabEnum::TASK_LOG_TITLE, JSON_UNESCAPED_UNICODE));
        $this->assign('statusList', json_encode(CrontabEnum::TASK_STATUS_TITLE, JSON_UNESCAPED_UNICODE));
        $this->assign('singletonList', json_encode(CrontabEnum::SINGLETON_STATUS_TITLE, JSON_UNESCAPED_UNICODE));
        return $this->fetch('sys/dev/crontab/index', ['uid' => $request->uid]);
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
            $option['params'] = $request->post('params', '', false);
            $task_id = CrontabDao::instance()->add($option, $request->uid);
            if (!$task_id) {
                return $this->error(CrontabDao::instance()->getError());
            }
            $reload = false;
            $msg = '操作成功';
            // 启动任务
            if ($option['status'] == CrontabEnum::TASK_STATUS['enable'] && Config::instance()->get('crontab.app.driver') != \gaia\crontab\driver\Job::class) {
                try {
                    $reload = CrontabService::instance()->reload([$task_id]);
                } catch (Throwable $e) {
                    $reload = false;
                }
            }
            $msg .= $reload ? '，任务已启动，下一分钟开始生效' : '，任务启动失败，请手动重载任务';

            return $this->success($msg);
        }

        $this->assign('urlType', CrontabEnum::TASK_TYPE['http']);
        $this->assign('log', CrontabEnum::TASK_LOG_TITLE);
        $this->assign('type', CrontabEnum::TASK_TYPE_TITLE);
        $this->assign('status', CrontabEnum::TASK_STATUS_TITLE);
        $this->assign('singleton', CrontabEnum::SINGLETON_STATUS_TITLE);
        return $this->fetch('sys/dev/crontab/add');
    }

    /**
     * 编辑
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        // post更新操作
        if ($request->isPost()) {
            $option = $request->post();
            $option['params'] = $request->post('params', '', false);
            $edit = CrontabDao::instance()->edit($option, $request->uid);
            if (!$edit) {
                return $this->error(CrontabDao::instance()->getError());
            }

            $reload = false;
            $msg = '操作成功';
            // 重启任务
            if (Config::instance()->get('crontab.app.driver') != \gaia\crontab\driver\Job::class) {
                try {
                    $reload = CrontabService::instance()->reload([$option['idx']]);
                } catch (Throwable $e) {
                    $reload = false;
                }
            }

            $msg .= $reload ? '，任务已重载，下一分钟开始生效' : '，任务重载失败，请手动重载任务';


            return $this->success($msg);
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        // 查询规则
        $data = CrontabDao::instance()->where('id', $id)->get();
        if (!$data) {
            return $this->error('获取任务信息失败');
        }

        $params = json_decode($data['params'], true);
        $method = '';
        $header = [];
        $queryData = [];
        if ($data['type'] == CrontabEnum::TASK_TYPE['http']) {
            $method = $params['method'] ?? 'GET';
            if (isset($params['header']) && is_array($params['header']) && !empty($params['header'])) {
                foreach ($params['header'] as $k => $v) {
                    $header[] = ['title' => $k, 'value' => $v];
                }
            }
            if (isset($params['data']) && is_array($params['data']) && !empty($params['data'])) {
                foreach ($params['data'] as $k => $v) {
                    $queryData[] = ['title' => $k, 'value' => $v];
                }
            }
        } else {
            foreach ($params as $k => $v) {
                $queryData[] = ['title' => $k, 'value' => $v];
            }
        }

        $this->assign('data', $data);
        $this->assign('method', $method);
        $this->assign('header', json_encode($header, JSON_UNESCAPED_UNICODE));
        $this->assign('queryData', json_encode($queryData, JSON_UNESCAPED_UNICODE));
        $this->assign('urlType', CrontabEnum::TASK_TYPE['http']);
        $this->assign('log', CrontabEnum::TASK_LOG_TITLE);
        $this->assign('type', CrontabEnum::TASK_TYPE_TITLE);
        $this->assign('status', CrontabEnum::TASK_STATUS_TITLE);
        $this->assign('singleton', CrontabEnum::SINGLETON_STATUS_TITLE);
        return $this->fetch('sys/dev/crontab/edit');
    }

    /**
     * 查看运行日志
     *
     * @param Request $request
     * @return mixed
     */
    public function log(Request $request)
    {
        $crontab_id = $request->get('crontab_id');
        if (!check('id', $crontab_id)) {
            return $this->error('params faild');
        }
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = CrontabLogDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        return $this->fetch('sys/dev/crontab/log', ['crontab_id' => $crontab_id]);
    }

    /**
     * 重载任务
     *
     * @param Request $request
     * @return mixed
     */
    public function reload(Request $request)
    {
        $crontab_id = $request->post('crontab_id');
        if (!check('id', $crontab_id)) {
            return $this->error('params faild');
        }

        try {
            $reload = CrontabService::instance()->reload([$crontab_id]);
            if (!$reload) {
                return $this->error('重载任务失败');
            }
            return $this->success('操作成功，将在下一分钟生效');
        } catch (Throwable $e) {
            return $this->error($e->getMessage());
        }
    }

    /**
     * 定时任务脚本运行状态
     *
     * @return mixed
     */
    public function ping()
    {
        try {
            $ret = CrontabService::instance()->communication('ping');
            return $this->success('ok');
        } catch (Throwable $e) {
            return $this->error($e->getMessage());
        }
    }

    /**
     * 查看运行任务
     *
     * @return mixed
     */
    public function pool()
    {
        try {
            $data = CrontabService::instance()->getPool();
            return $this->success('ok', $data);
        } catch (Throwable $e) {
            return $this->error($e->getMessage());
        }
    }
}
