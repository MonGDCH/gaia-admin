<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\thinkORM\Dao;
use mon\util\Instance;
use plugins\admin\contract\MenuEnum;

/**
 * 快捷菜单Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class FastMenuDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'fast_menu';

    /**
     * 获取列表
     *
     * @param integer $uid
     * @return array
     */
    public function getList(int $uid): array
    {
        $field = ['menu.id', 'menu.title', 'menu.name', 'menu.icon', 'menu.openType'];
        $where = ['fast.uid' => $uid, 'menu.status' => MenuEnum::MENU_STATUS['enable'], 'menu.type' => MenuEnum::MENU_TYPE['link']];
        return $this->alias('fast')->join(MenuDao::instance()->getTable() . ' menu', 'fast.menu_id = menu.id')->where($where)->field($field)->all();
    }

    /**
     * 新增
     *
     * @param integer $uid  用户ID
     * @param integer $menu_id  菜单ID
     * @return boolean
     */
    public function add(int $uid, int $menu_id): bool
    {
        $info = $this->where('uid', $uid)->where('menu_id', $menu_id)->get();
        if ($info) {
            $this->error = '菜单已存在';
            return false;
        }

        $save = $this->save(['uid' => $uid, 'menu_id' => $menu_id, 'create_time' => time()]);
        if (!$save) {
            $this->error = '保存失败';
            return false;
        }

        return true;
    }

    /**
     * 删除快捷菜单
     *
     * @param integer $uid  用户ID
     * @param integer $menu_id  菜单ID
     * @return boolean
     */
    public function remove(int $uid, int $menu_id): bool
    {
        $info = $this->where('uid', $uid)->where('menu_id', $menu_id)->get();
        if (!$info) {
            $this->error = '快捷菜单已移除';
            return false;
        }

        $del = $this->where('uid', $uid)->where('menu_id', $menu_id)->delete();
        if (!$del) {
            $this->error = '删除失败';
            return false;
        }

        return true;
    }
}
