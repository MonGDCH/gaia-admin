<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\dictionary;

use mon\http\Request;
use plugins\admin\dao\RegionDao;
use plugins\admin\comm\Controller;
use plugins\admin\contract\RegionEnum;

/**
 * 省份城市控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class RegionController extends Controller
{
    /**
     * 首页
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        if ($request->get('isApi')) {
            $data = RegionDao::instance()->order('sort', 'DESC')->all();
            return $this->success('ok', $data);
        }
        return $this->fetch('sys/dictionary/region/index', [
            'uid' => $request->uid,
            'type' => json_encode(RegionEnum::REGION_TYPE_TITLE, JSON_UNESCAPED_UNICODE)
        ]);
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
            $edit = RegionDao::instance()->add($option, $request->uid);
            if (!$edit) {
                return $this->error(RegionDao::instance()->getError());
            }

            return $this->success('操作成功');
        }
        // 输出规则树select
        $region = RegionDao::instance()->getTreeData(0);
        array_unshift($region, ['id' => 0, 'name' => '无', 'code' => '', 'disabled' => false, 'children' => []]);
        $this->assign('region', json_encode($region, JSON_UNESCAPED_UNICODE));
        $this->assign('status', RegionEnum::REGION_STATUS_TITLE);
        $this->assign('type', RegionEnum::REGION_TYPE_TITLE);
        $this->assign('idx', $request->get('idx', 0));
        return $this->fetch('sys/dictionary/region/add');
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
            $edit = RegionDao::instance()->edit($option, $request->uid);
            if (!$edit) {
                return $this->error(RegionDao::instance()->getError());
            }

            return $this->success('操作成功');
        }

        $id = $request->get('idx');
        if (!check('id', $id)) {
            return $this->error('参数错误');
        }
        // 查询规则
        $data = RegionDao::instance()->where('id', $id)->get();
        if (!$data) {
            return $this->error('获取省份城市信息失败');
        }

        $region = RegionDao::instance()->getTreeData($data['id']);
        array_unshift($region, ['id' => 0, 'name' => '无', 'code' => '', 'disabled' => false, 'children' => []]);
        $this->assign('region', json_encode($region, JSON_UNESCAPED_UNICODE));
        $this->assign('status', RegionEnum::REGION_STATUS_TITLE);
        $this->assign('type', RegionEnum::REGION_TYPE_TITLE);
        $this->assign('data', $data);
        return $this->fetch('sys/dictionary/region/edit');
    }
}
