<?php

declare(strict_types=1);

namespace plugins\admin\comm\view\concern;

use ReflectionClass;
use mon\http\Response;
use support\http\Controller;
use plugins\admin\comm\view\Template;

/**
 * 视图控制器Trait
 * 
 * @author Mon <985558837@qq.com>
 * @version 1.0.0
 */
trait ViewController
{
    /**
     * 视图实例
     *
     * @var Template
     */
    protected $view = null;

    /**
     * 获取视图实例
     * 基础实例可重载该方法，实现自定义视图引擎
     *
     * @return Template
     */
    public function getView(): Template
    {
        if (is_null($this->view)) {
            $this->view = new Template();
            $ref = new ReflectionClass($this);
            $fileName = $ref->getFileName();
            $path = mb_substr($fileName, 0, mb_strpos($fileName, '\\controller'));
            $viewPaht = str_replace('\\', DIRECTORY_SEPARATOR, $path) . DIRECTORY_SEPARATOR . 'view' . DIRECTORY_SEPARATOR;
            $this->view->setPath($viewPaht);
        }

        return $this->view;
    }

    /**
     * 设置视图变量
     *
     * @param mixed $key
     * @param mixed $value
     * @return Controller
     */
    public function assign($key, $value = null): Controller
    {
        $this->getView()->assign($key, $value);
        return $this;
    }

    /**
     * 输出视图
     *
     * @param string $view
     * @param array $data
     * @return Response
     */
    public function fetch(string $view, array $data = []): Response
    {
        $view = $this->getView()->fetch($view, $data);
        $this->view = null;
        return $this->view($view);
    }

    /**
     * 返回视图内容(不补全视图路径)
     *
     * @param string $view  完整的视图路径
     * @param array $data   视图数据
     * @return Response
     */
    public function display(string $view, array $data = []): Response
    {
        $view = $this->getView()->display($view, $data);
        $this->view = null;
        return $this->view($view);
    }
}
