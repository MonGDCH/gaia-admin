<?php

declare(strict_types=1);

namespace plugins\admin\controller\sys\ops;

use mon\util\File;
use mon\env\Config;
use think\facade\Db;
use mon\util\Common;
use mon\util\Migrate;
use mon\http\Request;
use mon\http\Response;
use mon\util\Dictionary;
use plugins\admin\comm\Controller;
use mon\util\exception\MigrateException;

/**
 * 数据迁移备份控制器
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MigrateController extends Controller
{
    /**
     * 数据迁移
     *
     * @param Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        $type = $request->get('type');
        switch ($type) {
            case 'dictionary':
                // type为dictionary, 查看数据库字典
                $config = $this->getMigrateConfig();
                $sdk = new Dictionary($config['db']);
                $html = $sdk->getHTML();
                unset($sdk);
                return $this->view($html);
            case 'field':
                // fieid，查看表详情
                $table = $request->get('table');
                if (!$table) {
                    return $this->error('错误请求');
                }
                $sdk = new Migrate($this->getMigrateConfig());
                $data = $sdk->tableStruct($table);
                unset($sdk);
                return $this->fetch('sys/ops/migrate/field', ['data' => $data]);
            case 'backup':
                // backup, 查看备份数据列表
                $page = $request->get('page', 1);
                $page = intval($page);
                $limit = $request->get('limit', 3);
                $limit = intval($limit);
                $sdk = new Migrate($this->getMigrateConfig());
                $files = $sdk->fileList();
                unset($sdk);
                $data = [];
                foreach ($files as $v) {
                    $data[] = [
                        'filename'  => $v['filename'],
                        'part'      => $v['part'],
                        'size'      => $v['size'],
                        'compress'  => $v['compress'],
                        'time'      => $v['time'],
                    ];
                }
                $data = Common::instance()->array_2D_Sort($data, 'time');
                // 分页
                $count = count($data);
                $offset = $page - 1 > 0 ? (($page - 1) * $limit) : 0;
                $limit = $limit < 3 ? 3 : $limit;
                $data = array_slice($data, $offset, $limit);
                return $this->success('ok', $data, ['count' => $count]);
            default:
                // ajax 获取数据库表列表
                if ($request->get('isApi')) {
                    $sdk = new Migrate($this->getMigrateConfig());
                    $tables = $sdk->tableList();
                    unset($sdk);
                    return $this->success('ok', $tables);
                }

                // 数据迁移页面
                return $this->fetch('sys/ops/migrate/index', ['uid' => $request->uid]);
        }
    }

    /**
     * 备份数据
     *
     * @param Request $request
     * @return mixed
     */
    public function backup(Request $request)
    {
        $tables = $request->post('tables');
        if (!$tables) {
            return $this->error('params invalid!');
        }
        $tables = explode(',', $tables);
        foreach ($tables as &$table) {
            $table = trim($table);
            if (empty($table)) {
                return $this->error('Params faild');
            }
        }

        try {
            $error = [];
            $config = $this->getMigrateConfig();
            File::instance()->createDir($config['path']);
            $sdk = new Migrate($config);
            for ($i = 0, $l = count($tables); $i < $l; $i++) {
                $table = $tables[$i];
                $backup = $sdk->backup($table, 0, true, ($i + 1 == $l));
                if ($backup === false) {
                    $error[] = $table;
                }
            }
            unset($sdk);
            if (!empty($error)) {
                return $this->error('备份失败：' . implode(', ', $error));
            }
            return $this->success('备份成功');
        } catch (MigrateException $e) {
            return $this->error($e->getMessage());
        }
    }

    /**
     * 优化表
     *
     * @param Request $request
     * @return mixed
     */
    public function optimize(Request $request)
    {
        $tables = $request->post('tables');
        if (!$tables) {
            return $this->error('params invalid!');
        }
        $tables = explode(',', $tables);
        foreach ($tables as &$table) {
            $table = trim($table);
            if (empty($table)) {
                return $this->error('Params faild');
            }
        }
        $tables = implode('`,`', $tables);
        $optimize = Db::execute("OPTIMIZE TABLE `{$tables}`");
        if (!$optimize) {
            return $this->error('优化表失败');
        }

        return $this->success('优化成功');
    }

    /**
     * 修复表
     *
     * @param Request $request
     * @return mixed
     */
    public function repair(Request $request)
    {
        $tables = $request->post('tables');
        if (!$tables) {
            return $this->error('params invalid!');
        }
        $tables = explode(',', $tables);
        foreach ($tables as &$table) {
            $table = trim($table);
            if (empty($table)) {
                return $this->error('Params faild');
            }
        }
        $tables = implode('`,`', $tables);
        $repair = Db::execute("REPAIR TABLE `{$tables}`");
        if (!$repair) {
            return $this->error('修复表失败');
        }

        return $this->success('修复成功');
    }

    /**
     * 下载备份文件
     *
     * @param Request $request
     * @return mixed
     */
    public function download(Request $request)
    {
        $filename = $request->get('filename');
        if (!$filename) {
            return $this->error('Query faild');
        }
        $sdk = new Migrate($this->getMigrateConfig());
        $file = $sdk->fileInfo('time', $filename);
        unset($sdk);
        if (!isset($file[0])) {
            return $this->error("{$filename} Part is abnormal");
        }
        $fileName = $file[0];
        if (!file_exists($fileName)) {
            return $this->error("{$filename} File is abnormal");
        }

        return (new Response())->download($fileName);
    }

    /**
     * 获取数据迁移配置信息
     *
     * @return array
     */
    protected function getMigrateConfig(): array
    {
        $config = Config::instance()->get('admin.app.migrate');
        return $config;
    }
}
