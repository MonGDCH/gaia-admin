<?php

declare(strict_types=1);

namespace plugins\admin\dao;

use mon\thinkORM\Dao;
use mon\util\Instance;

/**
 * 站内信内容Dao操作
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class MessageContentDao extends Dao
{
    use Instance;

    /**
     * 操作表
     *
     * @var string
     */
    protected $table = 'message_content';

    /**
     * 自动写入时间戳
     *
     * @var boolean
     */
    protected $autoWriteTimestamp = true;

    /**
     * 新增站内信内容
     *
     * @param integer $message_id
     * @param string $content
     * @return boolean
     */
    public function add(int $message_id, string $content): bool
    {
        $save = $this->save([
            'message_id' => $message_id,
            'content' => $content
        ], true);
        if (!$save) {
            $this->error = '保存站内信内容失败';
            return false;
        }

        return true;
    }

    /**
     * 编辑站内信内容
     *
     * @param integer $message_id
     * @param string $content
     * @return boolean
     */
    public function edit(int $message_id, string $content): bool
    {
        $save = $this->where('message_id', $message_id)->save(['content' => $content]);
        if (!$save) {
            $this->error = '保存站内信内容失败';
            return false;
        }

        return true;
    }
}
