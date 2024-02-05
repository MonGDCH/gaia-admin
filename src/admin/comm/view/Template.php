<?php

declare(strict_types=1);

namespace plugins\admin\comm\view;

use mon\util\View;
use mon\util\Tool;
use mon\env\Config;
use support\auth\RbacService;

/**
 * 重载优化的管理端模板引擎
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class Template extends View
{
    /**
     * 布局
     *
     * @var array
     */
    protected $layouts = [
        'page'  => __DIR__ . '/../../view/page'
    ];

    /**
     * 生成URL
     *
     * @param string $url   url
     * @param array $params 附加参数
     * @return string
     */
    public static function buildURL(string $url, array $params = []): string
    {
        $root_path = Config::instance()->get('admin.app.root_path', '');
        return Tool::instance()->buildURL($root_path . $url, $params);
    }

    /**
     * 获取静态资源方法
     *
     * @param string $path  资源路径
     * @param array $params 附加参数
     * @return string
     */
    public static function buildAssets(string $path, array $params = []): string
    {
        // 资源携带版本号参数
        $debug = Config::instance()->get('app.debug', false);
        if (!isset($params['v']) && !$debug) {
            // 调试模式
            $params['v'] = Config::instance()->get('admin.app.version', '');
        }

        // 按需要加上CDN路径
        return Tool::instance()->buildURL($path, $params);
    }

    /**
     * 生成URL
     *
     * @param string $url   url
     * @param array $params 附加参数
     * @return string
     */
    public function url(string $url, array $params = []): string
    {
        return self::buildURL($url, $params);
    }

    /**
     * 获取静态资源方法
     *
     * @param string $path  资源路径
     * @param array $params 附加参数
     * @return string
     */
    public function assets(string $path, array $params = []): string
    {
        return static::buildAssets($path, $params);
    }

    /**
     * 校验用户权限
     *
     * @param string $path  权限路径
     * @param mixed  $uid   用户id
     * @return boolean
     */
    public function checkAuth(string $path, $uid): bool
    {
        return RbacService::instance()->check($path, $uid);
    }

    /**
     * 生成表格操作按钮栏
     *
     * @param string $path  路径
     * @param mixed  $uid   用户ID
     * @param array $btns   按钮组
     * @param array $attr   按钮属性值
     * @return string
     */
    public function build_toolbar(string $path, $uid, array $btns = [], array $attr = []): string
    {
        $btns = $btns ?: ['refresh'];
        $btnAttr = [
            'refresh'   => ['layui-btn layui-btn-sm layui-btn-primary', 'layui-icon layui-icon-refresh', '', '刷新'],
            'search'    => ['layui-btn layui-btn-sm', 'layui-icon layui-icon-search', '搜索', '搜索'],
            'reset'     => ['layui-btn layui-btn-sm layui-btn-primary', 'layui-icon layui-icon-refresh-1', '重置', '重置表单'],
            'add'       => ['layui-btn layui-btn-sm layui-btn-success', 'layui-icon layui-icon-add-1', '新增', '新增'],
            'edit'      => ['layui-btn layui-btn-sm layui-btn-normal', 'layui-icon layui-icon-edit', '编辑', '编辑'],
            'delete'    => ['layui-btn layui-btn-sm layui-btn-danger', 'layui-icon layui-icon-delete', '删除', '删除'],
            'searchBar' => []
        ];
        $white = ['refresh', 'search', 'searchBar', 'reset'];
        $btnAttr = array_merge($btnAttr, $attr);
        $html = [];
        foreach ($btns as $v) {
            $checkPath = $path . '/' . $v;
            // 如果未定义或没有权限则不渲染
            if (!isset($btnAttr[$v]) || (!in_array($v, $white) && !$this->checkAuth($checkPath, $uid))) {
                continue;
            }
            if ($v == 'searchBar') {
                $html[] = $this->build_searchBar();
                continue;
            }
            list($class, $icon, $text, $title) = $btnAttr[$v];
            $html[] = '<button class="' . $class . '" lay-event="' . $v . '" title="' . $title . '"><i class="' . $icon . '"></i>' . $text . '</button>';
        }
        return implode(' ', $html);
    }

    /**
     * 生成表格操作按钮栏搜索面板
     *
     * @param string $name  input的name值
     * @param string $placeholder   input的placeholder值
     * @return string
     */
    public function build_searchBar(string $name = 'title', string $placeholder = '搜索...'): string
    {
        return '<div class="layui-input-inline">
                    <div class="layui-input-group">
                        <input type="text" name="' . $name . '" placeholder="' . $placeholder . '" class="layui-input">
                        <div class="layui-input-split layui-input-suffix mon-search-bar-btn" lay-event="searchBar">
                            <i class="layui-icon layui-icon-search"></i>
                        </div>
                    </div>
                </div>';
    }

    /**
     * 生成layui-select
     *
     * @param string $name      name值
     * @param array $data       option列表
     * @param array $selected   选中的option
     * @param array $attrs      附加属性
     * @param boolean $keyVal   data是否为key-value数据, 否则使用 $k => $v 的二维数组形式处理数据
     * @param boolean $null 是否增加默认的空选项
     * @param string $k 非key-value数据，对应二维数组key值
     * @param string $v 非key-value数据，对应二维数组value值
     * @return string
     */
    public function build_select(string $name, array $data = [], array $selecteds = [], array $attrs = [], bool $keyVal = false, bool $null = false, string $k = 'id', string $v = 'title'): string
    {
        $attr = $this->parseAttr($attrs);
        $options = [];
        if ($null) {
            $options[] = '<option value=""></option>';
        }
        foreach ($data as $key => $value) {
            $val = $keyVal ? $key : $value[$k];
            $title = $keyVal ? $value : $value[$v];
            $selected = in_array($val, $selecteds) ? 'selected' : '';
            $options[] = '<option value="' . $val . '" ' . $selected . ' >' . $title . '</option>';
        }
        $html = '<select name="' . $name . '" ' . $attr . ' lay-filter="' . $name . '">' . implode(' ', $options) . '</select>';
        return $html;
    }

    /**
     * 生成layui-radio组
     *
     * @param string $name 		name值
     * @param array $data 		列表数据
     * @param mixed $selected	选中的redio
     * @param array $attrs      附加属性
     * @param boolean $keyVal   data是否为key-value数据, 否则使用 $k => $v 的二维数组形式处理数据
     * @param string $k 非key-value数据，对应二维数组key值
     * @param string $v 非key-value数据，对应二维数组value值
     * @return string
     */
    public function build_radios(string $name, array $data = [], $selected = null, array $attrs = [], bool $keyVal = false, string $k = 'id', string $v = 'title'): string
    {
        $attr = $this->parseAttr($attrs);
        $redios = [];
        foreach ($data as $key => $value) {
            $val = $keyVal ? $key : $value[$k];
            $title = $keyVal ? $value : $value[$v];
            $checked = $val == $selected ? 'checked' : '';
            $redios[] = '<label><input type="radio" name="' . $name . '" value="' . $val . '" title="' . $title . '" ' . $attr . ' ' . $checked . ' /></label>';
        }

        return implode(' ', $redios);
    }

    /**
     * 生成单个checkbox复选框
     *
     * @param string $name      name值
     * @param string $value     value值
     * @param string $title     title值
     * @param boolean $check    是否选中
     * @param array $attrs      附加属性
     * @return string
     */
    public function build_checkbox(string $name, string $value, string $title, bool $check = false, array $attrs = []): string
    {
        $attr = $this->parseAttr($attrs);
        $checked = $check ? 'checked' : '';
        return '<input type="checkbox" name="' . $name . '" value="' . $value . '" title="' . $title . '" ' . $attr . ' lay-skin="primary" ' . $checked . ' />';
    }

    /**
     * 生成checkbox复选框静态模板
     *
     * @param boolean $checked
     * @param string $text
     * @return string
     */
    public function build_checkbox_tmp(bool $checked, string $text): string
    {
        $checkedClass = $checked ? 'layui-form-checked' : '';
        return '<div class="layui-unselect layui-form-checkbox ' . $checkedClass . '" lay-skin="primary">
                    <div>' . $text . '</div><i class="layui-icon layui-icon-ok"></i>
                </div>';
    }

    /**
     * 生成layui-checkbox复选按钮组
     *
     * @param string $name      name值
     * @param array $data       列表数据
     * @param array $selected   选中列表
     * @param array $attrs      附加属性
     * @param boolean $keyVal   data是否为key-value数据, 否则使用 $k => $v 的二维数组形式处理数据
     * @param string $k 非key-value数据，对应二维数组key值
     * @param string $v 非key-value数据，对应二维数组value值
     * @return string
     */
    public function build_checkboxs(string $name, array $data = [], array $selected = [], array $attrs = [], bool $keyVal = false, string $k = 'id', string $v = 'title'): string
    {
        $attr = $this->parseAttr($attrs);
        $html = [];
        foreach ($data as $key => $value) {
            $val = $keyVal ? $key : $value[$k];
            $title = $keyVal ? $value : $value[$v];
            $checked = in_array($val, $selected) ? 'checked' : '';
            $html[] = '<input type="checkbox" name="' . $name . '" value="' . $val . '" title="' . $title . '" ' . $attr . ' lay-skin="primary" ' . $checked . ' />';
        }
        return implode(' ', $html);
    }

    /**
     * 生成layui-switch开关
     * 
     * @param string $name      name值
     * @param boolean $checked  是否选中
     * @param string $value     选中值
     * @param array $text       开关提示
     * @param array $attrs      附加属性
     * @return string
     */
    public function build_switch(string $name, bool $checked = false, string $value = '1', array $text = ['开启', '关闭'], array $attrs = []): string
    {
        $attr = $this->parseAttr($attrs);
        $laychecked = $checked ? 'checked' : '';
        $laytext = implode('|', $text);
        $html = "<input type='checkbox' name='{$name}' value='{$value}' lay-skin='switch' lay-text='{$laytext}' {$attr} {$laychecked}>";
        return $html;
    }

    /**
     * 生成静态的layui-switch开关
     *
     * @param boolean $checked  是否选中
     * @param string $text  内容
     * @return string
     */
    public function build_switch_tmp(bool $checked, string $text = ''): string
    {
        $defaultText = ['开启', '关闭'];
        $checkedClass = $checked ? 'layui-form-onswitch' : '';
        if (!$text) {
            $text = $checked ? $defaultText[0] : $defaultText[1];
        }
        return '<div class="layui-unselect layui-form-switch ' . $checkedClass . '" lay-skin="switch">
                    <div>' . $text . '</div><i></i>
                </div>';
    }

    /**
     * 生成input输入框
     *
     * @param string $name  name值
     * @param string $type  type值
     * @param string $value 默认值
     * @param array $attrs  附加属性
     * @param boolean $lay  启用layui
     * @return string
     */
    public function build_input(string $name, string $type, string $value = '', array $attrs = [], bool $lay = true): string
    {
        if ($lay) {
            // 兼容attrs定义class
            $attrs['class'] = isset($attrs['class']) ? ($attrs['class'] . ' layui-input') : 'layui-input';
        }
        $attr = $this->parseAttr($attrs);
        $html = "<input type='{$type}' name='{$name}' value='{$value}' {$attr} />";
        return $html;
    }

    /**
     * 解析附加属性
     *
     * @param array $attrs 属性
     * @return string
     */
    protected function parseAttr(array $attrs = []): string
    {
        $attr = [];
        foreach ($attrs as $tag => $value) {
            if (is_int($tag)) {
                $attr[] = $value;
            } else {
                $attr[] =  $tag . '="' . $value . '"';
            }
        }
        return implode(' ', $attr);
    }
}
