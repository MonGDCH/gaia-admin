<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\thinkOrm\Dao;
use mon\util\Instance;
use plugins\admin\comm\view\Template;

/**
 * 上传文件Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class FilesDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'files';

    /**
     * 查询后字段自动完成
     *
     * @var array
     */
    protected $append = ['url'];

    /**
     * 记录上传文件信息
     *
     * @param array $data
     * @return integer
     */
    public function add(array $data): int
    {
        $check = $this->validate()->rule([
            'filename'  => ['required', 'str'],
            'savename'  => ['required', 'str'],
            'path'      => ['required', 'str'],
            'md5'       => ['required', 'str'],
            'mine_type' => ['str'],
            'ext'       => ['str'],
            'size'      => ['int'],
        ])->data($data)->check();
        if (!$check) {
            $this->error = $this->validate()->getError();
            return 0;
        }
        $data['create_time'] = time();
        $file_id = $this->allowField(['filename', 'savename', 'path', 'md5', 'mine_type', 'ext', 'size', 'create_time'])->save($data, true, true);
        if (!$file_id) {
            $this->error = '记录上传文件信息失败';
            return 0;
        }

        return $file_id;
    }

    /**
     * 查询列表
     *
     * @param array $data
     * @return array
     */
    public function getList(array $data): array
    {
        $limit = isset($data['limit']) ? intval($data['limit']) : 10;
        $page = isset($data['page']) && is_numeric($data['page']) ? intval($data['page']) : 1;

        // 查询
        $list = $this->scope('list', $data)->page($page, $limit)->all(true);
        $total = $this->scope('list', $data)->count();

        return [
            'list'      => $list,
            'count'     => $total,
            'pageSize'  => $limit,
            'page'      => $page
        ];
    }

    /**
     * 查询场景
     *
     * @param \mon\thinkOrm\extend\Query $query
     * @param array $option
     * @return mixed
     */
    public function scopeList($query, $option)
    {
        // ID搜索
        if (isset($option['idx']) &&  $this->validate()->id($option['idx'])) {
            $query->where('id', intval($option['idx']));
        }
        // 按所属模块
        if (isset($option['module']) && is_string($option['module']) && !empty($option['module'])) {
            $query->where('module', $option['module']);
        }
        // 按后缀名
        if (isset($option['ext']) && is_string($option['ext']) && !empty($option['ext'])) {
            $query->where('ext', $option['ext']);
        }
        if (isset($option['extList']) && !empty($option['extList']) && is_array($option['extList'])) {
            $query->whereIn('ext', $option['extList']);
        }
        // 按名称
        if (isset($option['filename']) && is_string($option['filename']) && !empty($option['filename'])) {
            $query->whereLike('filename', '%' . trim($option['filename']) . '%');
        }
        // 按状态
        if (isset($option['status']) && $this->validate()->int($option['status'])) {
            $query->where('status', intval($option['status']));
        }
        // 按上传时间搜索
        if (isset($option['start_time']) && $this->validate()->int($option['start_time'])) {
            $query->where('create_time', '>=', intval($option['start_time']));
        }
        if (isset($option['end_time']) && $this->validate()->int($option['end_time'])) {
            $query->where('create_time', '<=', intval($option['end_time']));
        }

        // 排序字段，默认id
        $order = 'id';
        if (isset($option['order']) && in_array($option['order'], ['id', 'create_time'])) {
            $order = $option['order'];
        }
        // 排序类型，默认 DESC
        $sort = 'DESC';
        if (isset($option['sort']) && in_array(strtoupper($option['sort']), ['ASC', 'DESC'])) {
            $sort = $option['sort'];
        }

        return $query->order($order, $sort);
    }

    /**
     * 获取自动完成的url参数
     *
     * @param mixed $value
     * @param array $data
     * @return string
     */
    protected function getUrlAttr($value, $data): string
    {
        return Template::buildAssets($data['path']);
    }
}
