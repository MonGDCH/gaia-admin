<?php

declare(strict_types=1);

namespace plugins\admin\service;

use Throwable;
use mon\util\File;
use mon\log\Logger;
use think\facade\Db;
use mon\util\Instance;
use mon\http\libs\UploadFile;
use plugins\admin\dao\FilesDao;

/**
 * 文件上传服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class UploadService
{
    use Instance;

    /**
     * 配置信息
     *
     * @var array
     */
    protected $config = [
        // 保存路径
        'root'      => ROOT_PATH . '/public',
        // 保存目录
        'save'      => 'upload',
        // 允许上传最大尺寸, 20M
        'maxSize'   => 20000000,
        // 允许上传文件类型
        'exts'      => ['jpg', 'jpeg', 'png', 'gif', 'mp3', 'mp4', 'avi', 'mkv', 'flv', 'rmvb', 'pdf', 'ppt', 'pptx', 'doc', 'docx', 'xls', 'xlsx', 'csv', 'md', 'txt', 'zip'],
    ];

    /**
     * 错误信息
     *
     * @var string
     */
    protected $error = '';

    /**
     * 文件名标志
     *
     * @var string
     */
    protected $mark = 'gaia';

    /**
     * 保存上传文件
     *
     * @param UploadFile $file  上传文件
     * @param string $module    上传文件所属模块
     * @param array $config     上传配置
     * @param boolean $record   是否记录上传文件信息
     * @return array    上传文件信息
     */
    public function save(UploadFile $file, string $module = '', array $config = [], bool $record = true): array
    {
        if (!$file || !$file->isValid()) {
            $this->error = '上传文件不合法';
            return [];
        }

        // 上传配置信息
        $config = array_merge($this->config, $config);
        // 验证文件类型
        $mineType = explode('/', $file->getUploadMineType(), 2);
        $ext = $file->getUploadExtension() ?: ($mineType[1] ?? '');
        if (!in_array($ext, $config['exts'])) {
            $this->error = '文件类型不合法';
            return [];
        }
        // 验证文件大小
        if ($file->getSize() > $config['maxSize']) {
            $this->error = '文件大小不能超过' . floor($config['maxSize'] / 1000) . 'KB';
            return [];
        }

        // 文件md5
        $md5 = md5_file($file->getPathname());
        if (!$md5) {
            $this->error = '文件校验信息失败';
            return [];
        }

        // 判断是否已上传
        $info = FilesDao::instance()->where('md5', $md5)->get();
        if ($info) {
            // 存在已上传文件信息, 直接返回
            return [
                'filename' => $info['filename'],
                'savename' => $info['savename'],
                'path' => $info['path'],
                'md5' => $info['md5'],
                'mine_type' => $info['mine_type'],
                'ext' => $info['ext'],
                'size' => $info['size'],
            ];
        }

        // 保存路径
        $rootPath = $config['root'];
        $savePath = $config['save'];
        $date = date('Ym');
        $saveDir = $rootPath . DIRECTORY_SEPARATOR . $savePath . DIRECTORY_SEPARATOR;
        if ($module) {
            $saveDir .= $module . DIRECTORY_SEPARATOR;
        }
        $saveDir .= $date;
        if (!is_dir($saveDir)) {
            $createDir = File::instance()->createDir($saveDir);
            if (!$createDir) {
                $this->error = '创建存储目录失败，请检查写入权限：' . $saveDir;
                return [];
            }
        }

        // 保存文件
        $fileName = uniqid(mt_rand() . $this->mark) . '.' . $ext;
        $saveFile = $saveDir . DIRECTORY_SEPARATOR . $fileName;
        $path = '/' . $savePath . '/' . $date . '/' . $fileName;
        $fileInfo = [
            'module' => $module,
            'filename' => $file->getUploadName(),
            'savename' => $fileName,
            'path' => $path,
            'md5' => $md5,
            'mine_type' => $file->getUploadMineType(),
            'ext' => $ext,
            'size' => $file->getSize(),
        ];

        // 不保存记录，则直接返回文件信息
        if (!$record) {
            return $fileInfo;
        }

        // 保存文件记录
        Db::startTrans();
        try {
            $saveFileInfo = FilesDao::instance()->add($fileInfo);
            if (!$saveFileInfo) {
                Db::rollback();
                $this->error = '保存文件信息失败';
                Logger::instance()->channel()->warning('Save upload file faild: ' . FilesDao::instance()->getError());
                return [];
            }

            $file->move($saveFile);
            Db::commit();
            return $fileInfo;
        } catch (Throwable $e) {
            Db::rollback();
            $this->error = '保存文件信息异常';
            Logger::instance()->channel()->warning('Save upload file exception: ' . $e->getMessage());
            return [];
        }
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
