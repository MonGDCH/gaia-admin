<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\dictionary;

use mon\http\Request;
use plugins\admin\dao\OptionsDao;
use plugins\admin\comm\Controller;
use plugins\admin\contract\DictEnum;
use plugins\admin\service\DictService;

/**
 * 配置字典控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class OptionsController extends Controller
{
    /**
     * 配置字典
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $option = $request->get();
            $result = OptionsDao::instance()->getList($option);
            return $this->success('ok', $result['list'], ['count' => $result['count']]);
        }

        return $this->fetch('sys/dictionary/options/index', ['group' => DictEnum::DICT_NAME, 'uid' => $request->uid]);
    }

    /**
     * 新增字典
     *
     * @param Request $request
     * @return mixed
     */
    public function add(Request $request)
    {
        $group = $request->get('group');
        if (!$group) {
            return $this->error('Params faild');
        }

        // 新增
        if ($request->isPost()) {
            $option = $request->post();
            if ($group == DictEnum::DICT_NAME) {
                $name = $request->post('name');
                if (!check('required', $name)) {
                    return $this->error('请输入字典名称');
                }
                $option['value'] = $name;
            }
            $save = OptionsDao::instance()->add($option, $request->uid);
            if (!$save) {
                return $this->error(OptionsDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        return $this->fetch('sys/dictionary/options/add', [
            'group' => $group,
            'isDictionary' => $group == DictEnum::DICT_NAME,
            'status' => DictEnum::DICT_STATUS_TITLE
        ]);
    }

    /**
     * 编辑字典
     *
     * @param Request $request
     * @return mixed
     */
    public function edit(Request $request)
    {
        $option = $request->post();
        $save = OptionsDao::instance()->edit($option, $request->uid);
        if (!$save) {
            return $this->error(OptionsDao::instance()->getError());
        }

        return $this->success('操作成功');
    }

    /**
     * 修改字典状态
     *
     * @param Request $request
     * @return mixed
     */
    public function toggle(Request $request)
    {
        $option = $request->post();
        $save = OptionsDao::instance()->status($option, $request->uid);
        if (!$save) {
            return $this->error(OptionsDao::instance()->getError());
        }

        return $this->success('操作成功');
    }

    /**
     * 删除字典
     *
     * @param Request $request
     * @return mixed
     */
    public function delete(Request $request)
    {
        $idx = $request->post('idx', '');
        $ids = explode(',', $idx);
        foreach ($ids as $id) {
            if (!check('id', $id)) {
                return $this->error('Params idx faild');
            }
        }

        $save = OptionsDao::instance()->remove($ids, $request->uid);
        if (!$save) {
            return $this->error(OptionsDao::instance()->getError());
        }

        return $this->success('操作成功');
    }

    /**
     * 缓存字典
     *
     * @return mixed
     */
    public function cache()
    {
        $cache = DictService::instance()->reload();
        if (!$cache) {
            return $this->error('缓存配置字典信息失败');
        }

        return $this->success('操作成功');
    }
}
