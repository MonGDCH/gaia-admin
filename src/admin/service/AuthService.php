<?php

declare(strict_types=1);

namespace plugins\admin\service;

use think\db\Raw;
use mon\util\Tree;
use mon\env\Config;
use RuntimeException;
use mon\util\Instance;
use support\auth\RbacService;
use plugins\admin\dao\MenuDao;
use plugins\admin\dao\AdminDao;
use plugins\admin\dao\AuthRuleDao;
use plugins\admin\dao\AuthGroupDao;
use plugins\admin\dao\AuthAccessDao;
use plugins\admin\contract\AuthEnum;
use plugins\admin\contract\MenuEnum;

/**
 * 权限相关服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class AuthService
{
    use Instance;

    /**
     * 错误信息
     *
     * @var string
     */
    protected $error = '';

    /**
     * 管理员是否超级管理员
     *
     * @param integer $adminID
     * @return boolean
     */
    public function isSuperAdmin(int $adminID): bool
    {
        // 获取当前用户拥有的权限节点
        $userRule = RbacService::instance()->getAuthList($adminID);
        return in_array(Config::instance()->get('auth.rbac.admin_mark', '*'), $userRule);
    }

    /**
     * 获取未绑定组别用户
     *
     * @param array $field  查询字段
     * @param array $where  查询条件
     * @return array
     */
    public function getUnbindUser(array $field = ['*'], array $where = []): array
    {
        $accessTable = AuthAccessDao::instance()->getTable();
        return AdminDao::instance()->field($field)->where($where)->whereNotIn('id', new Raw("SELECT uid FROM `{$accessTable}` GROUP BY uid"))->select()->toArray();
    }

    /**
     * 获取绑定组别用户
     *
     * @param integer $group_id 组别ID
     * @param array $field      查询字段
     * @param array $where      查询条件
     * @return array
     */
    public function getBindUser(int $group_id, array $field = ['*'], array $where = []): array
    {
        $accessTable = AuthAccessDao::instance()->getTable();
        return AdminDao::instance()->field($field)->where($where)->whereIn('id', new Raw("SELECT uid FROM `{$accessTable}` WHERE group_id = '{$group_id}' GROUP BY uid"))->select()->toArray();
    }

    /**
     * 获取允许操作的权限菜单
     *
     * @param integer $id   菜单ID，0则所有权限
     * @param string $childrenName
     * @return array
     */
    public function getAuthMenuList(int $id, string $childrenName = 'children'): array
    {
        $field = ['id', 'pid', 'title', 'IF(id = ' . intval($id) . ', 1, 0) AS disabled'];
        $data = MenuDao::instance()->where('status', MenuEnum::MENU_STATUS['enable'])->field($field)->order('sort', 'DESC')->all();
        $dataArr = Tree::instance()->data($data)->getTree($childrenName);
        return $this->formatAuthDataList($dataArr);
    }

    /**
     * 获取编辑允许权限菜单
     *
     * @param integer $id
     * @param string $childrenName
     * @return array
     */
    public function getAuthRuleList(int $id, string $childrenName = 'children'): array
    {
        $field = ['id', 'pid', 'title', 'IF(id = ' . intval($id) . ', 1, 0) AS disabled'];
        $data = AuthRuleDao::instance()->where('status', AuthEnum::AUTH_STATUS['enable'])->field($field)->all();
        $dataArr = Tree::instance()->data($data)->getTree($childrenName);
        return $this->formatAuthDataList($dataArr);
    }

    /**
     * 整理允许操作的权限菜单数据
     *
     * @param array $data
     * @param boolean $disable
     * @param string $childrenName
     * @return array
     */
    protected function formatAuthDataList(array $data, bool $disable = false, string $childrenName = 'children'): array
    {
        foreach ($data as &$item) {
            $item['disabled'] = ($item['disabled'] == 1 || $disable);
            if (!empty($item[$childrenName])) {
                $item[$childrenName] = $this->formatAuthDataList($item[$childrenName], $item['disabled'], $childrenName);
            }
        }

        return $data;
    }

    /**
     * 获取用户组下所有权限
     *
     * @param integer $gid      权限角色组ID
     * @param integer $pid      权限角色组父级ID
     * @param boolean $format   格式化数据
     * @throws RuntimeException
     * @return array
     */
    public function getGrupRole(int $gid = 0, int $pid = 0, bool $format = false): array
    {
        $userRule = [];
        // 存在组别ID，获取组别权限节点
        if ($gid > 0) {
            $rules = AuthGroupDao::instance()->where('id', $gid)->field('rules')->get();
            if (!$rules) {
                throw new RuntimeException('获取组别规则信息失败');
            }
            $userRule = explode(',', $rules['rules']);
        }

        // 获取规则列表
        $ruleListQuery = AuthRuleDao::instance()->field('id, pid, title');
        if ($pid > 0) {
            // 存在父级，获取父级所有权限规则
            $parentGroup = AuthGroupDao::instance()->where('id', $pid)->field('rules')->get();
            if (!$parentGroup) {
                throw new RuntimeException('获取父级组别规则信息失败');
            }
            $parnetRule = explode(',', $parentGroup['rules']);
            if (!in_array(Config::instance()->get('auth.rbac.admin_mark', '*'), $parnetRule)) {
                $ruleListQuery->whereIn('id', $parnetRule);
            }
        }
        $ruleList = $ruleListQuery->all();
        if (!$format) {
            return $ruleList;
        }

        // 格式化节点数据
        $result = [];
        foreach ($ruleList as $v) {
            $result[] = [
                'id'        => $v['id'],
                'parent'    => ($v['pid'] == 0) ? '#' : $v['pid'],
                'state'     => [
                    'selected' => $this->getChecked($v['id'], $userRule, $ruleList)
                ],
                'text'      => $v['title'],
                'type'      => 'menu'
            ];
        }

        return $result;
    }

    /**
     * getRoleTree辅助方法，获取state的值
     *
     * @param  integer  $id         ID值
     * @param  array    $rules      用户规则
     * @param  array    $ruleList   规则列表
     * @return boolean
     */
    protected function getChecked(int $id, array $rules, array $ruleList): bool
    {
        // 超级管理员
        if (in_array("*", $rules)) {
            return true;
        }

        // 获取当前节点子节点，不为空则存在子集，false
        $rule = Tree::instance()->data($ruleList)->getChild($id);
        return (empty($rule) && in_array($id, $rules));
    }

    /**
     * 获取错误信息
     *
     * @return mixed
     */
    public function getError()
    {
        $error = $this->error;
        $this->error = null;
        return $error;
    }
}
