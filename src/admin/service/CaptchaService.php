<?php

declare(strict_types=1);

namespace plugins\admin\service;

use mon\util\Instance;

/**
 * 重载验证码服务
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class CaptchaService extends \support\captcha\CaptchaService
{
    use Instance;

    /**
     * 配置信息
     *
     * @var array
     */
    protected $config = [
        // 验证器驱动
        'drive'     => [
            // 驱动对象名，实现 CaptchaDrive 接口
            'class'     => \mon\captcha\drive\Image::class,
            // 驱动配置信息
            'config'    => [],
        ],
        // 存储驱动实例，实现 CaptchaStore 接口
        'store'     => \mon\captcha\store\GaiaCache::class,
        // 验证码过期时间（s）
        'expire'    => 60,
        // 验证成功后是否重置验证码
        'reset'     => true,
    ];
}
