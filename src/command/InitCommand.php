<?php

declare(strict_types=1);

namespace gaia\admin\command;

use mon\util\Sql;
use mon\env\Config;
use think\facade\Db;
use mon\console\Input;
use mon\console\Output;
use mon\console\Command;

/**
 * 数据库初始化
 *
 * @author Mon <98555883@qq.com>
 * @version 1.0.0
 */
class InitCommand extends Command
{
    /**
     * 指令名
     *
     * @var string
     */
    protected static $defaultName = 'admin:init';

    /**
     * 指令描述
     *
     * @var string
     */
    protected static $defaultDescription = 'Initialization admin database';

    /**
     * 指令分组
     *
     * @var string
     */
    protected static $defaultGroup = 'Admin';

    /**
     * 执行指令
     *
     * @param  Input  $in  输入实例
     * @param  Output $out 输出实例
     * @return integer  exit状态码
     */
    public function execute(Input $in, Output $out)
    {
        // 读取sql文件
        $file = __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'admin.sql';
        $sqls = Sql::instance()->parseFile($file);
        // 执行sql
        Db::setConfig(Config::instance()->get('database', []));
        foreach ($sqls as $sql) {
            Db::execute($sql);
            $out->block('Exec sql: ' . $sql, 'SUCCESS');
        }
    }
}
