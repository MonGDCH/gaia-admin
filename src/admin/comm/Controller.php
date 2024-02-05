<?php

declare(strict_types=1);

namespace plugins\admin\comm;

use plugins\admin\comm\view\concern\ViewController;
use support\http\Controller as HttpController;

/**
 * 管理端控制器基类
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
class Controller extends HttpController
{
    use ViewController;
}
