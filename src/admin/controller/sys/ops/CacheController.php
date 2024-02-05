<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\ops;

use mon\http\Request;
use support\cache\CacheService;
use plugins\admin\comm\Controller;

/**
 * 清空控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CacheController extends Controller
{
    /**
     * 清除缓存页
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->isPost() && $request->post('key')) {
            $key = $request->post('key');
            $value = CacheService::instance()->get($key);
            return $this->success('ok', ['value' => $value]);
        }

        return $this->fetch('sys/ops/cache/index', ['uid' => $request->uid]);
    }

    /**
     * 清除缓存
     *
     * @param Request $request
     * @return mixed
     */
    public function clear(Request $request)
    {
        $key = $request->post('key');
        if (!$key && $key !== '0' && $key !== 0) {
            // 清除所有缓存
            $clear = CacheService::instance()->clear();
        } else {
            $clear = CacheService::instance()->delete($key);
        }

        if (!$clear) {
            return $this->error('清除缓存失败');
        }

        return $this->success('操作成功');
    }
}
