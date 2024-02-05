<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use Throwable;
use mon\util\Tree;
use mon\log\Logger;
use mon\thinkOrm\Dao;
use mon\util\Instance;
use plugins\admin\contract\RegionEnum;
use plugins\admin\validate\RegionValidate;

/**
 * 省市区Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class RegionDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'region';

    /**
     * 自动写入时间戳
     *
     * @var boolean
     */
    protected $autoWriteTimestamp = true;

    /**
     * 验证器
     *
     * @var string
     */
    protected $validate = RegionValidate::class;

    /**
     * 新增
     *
     * @param array $data
     * @param integer $adminID
     * @return integer
     */
    public function add(array $data, int $adminID): int
    {
        $check = $this->validate()->data($data)->scope('add')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }
        if ($data['pid'] != 0) {
            $parentInfo = $this->where('id', $data['pid'])->get();
            if (!$parentInfo) {
                $this->error = '父级地区不存在';
                return 0;
            }
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Add region');
            $field = ['pid', 'status', 'code', 'sort', 'name',  'type'];
            $region_id = $this->allowField($field)->save($data, true, true);
            if (!$region_id) {
                $this->rollback();
                $this->error = '新增失败';
                return 0;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '新增省市地区',
                    'content' => '新增省市地区：' . $data['name'],
                    'sid' => $region_id
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                    return 0;
                }
            }

            $this->commit();
            return $region_id;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '新增省市地区异常';
            Logger::instance()->channel()->error('Add region exception, msg => ' . $e->getMessage(), ['trace' => true]);
            return 0;
        }
    }

    /**
     * 编辑
     *
     * @param array $data
     * @param integer $adminID
     * @return boolean
     */
    public function edit(array $data, int $adminID): bool
    {
        $check = $this->validate()->data($data)->scope('edit')->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return false;
        }

        if ($data['pid'] == $data['idx']) {
            $this->error = '父级不能为自身';
            return false;
        }

        $baseInfo = $this->where('id', $data['idx'])->get();
        if (!$baseInfo) {
            $this->error = '记录不存在';
            return false;
        }

        $this->startTrans();
        try {
            Logger::instance()->channel()->info('Edit region info');
            $field = ['pid', 'status', 'code', 'sort', 'name',  'type'];
            $save = $this->allowField($field)->where('id', $data['idx'])->save($data);
            if (!$save) {
                $this->rollback();
                $this->error = '修改失败';
                return false;
            }

            // 记录操作日志
            if ($adminID > 0) {
                $record = AdminLogDao::instance()->record([
                    'uid' => $adminID,
                    'module' => 'sys',
                    'action' => '编辑省市地区',
                    'content' => '编辑省市地区：' . $data['name'] . ', ID：' . $data['idx'],
                    'sid' => $data['idx']
                ]);
                if (!$record) {
                    $this->rollback();
                    $this->error = '记录操作日志失败,' . AdminLogDao::instance()->getError();;
                    return false;
                }
            }

            $this->commit();
            return true;
        } catch (Throwable $e) {
            $this->rollback();
            $this->error = '编辑省市地区异常';
            Logger::instance()->channel()->error('Edit region exception, msg => ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 获取编辑允许权限菜单
     *
     * @param integer $id
     * @param string $childrenName
     * @return array
     */
    public function getTreeData(int $id, string $childrenName = 'children'): array
    {
        $field = ['id', 'pid', 'name', 'code', 'IF(id = ' . intval($id) . ', 1, 0) AS disabled'];
        $data = $this->where('status', RegionEnum::REGION_STATUS['enable'])->field($field)->order('sort', 'DESC')->all();
        $dataArr = Tree::instance()->data($data)->getTree($childrenName);
        return $this->formatTreeData($dataArr, $childrenName);
    }

    /**
     * 整理获取编辑允许权限菜单数据
     *
     * @param array $data
     * @param string $childrenName
     * @param boolean $disable
     * @return array
     */
    protected function formatTreeData(array $data, string $childrenName = 'children', bool $disable = false): array
    {
        foreach ($data as &$item) {
            $item['disabled'] = ($item['disabled'] == 1 || $disable);
            if (!empty($item[$childrenName])) {
                $item[$childrenName] = $this->formatTreeData($item[$childrenName], $childrenName, $item['disabled']);
            }
        }

        return $data;
    }
}
