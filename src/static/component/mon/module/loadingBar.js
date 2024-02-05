layui.define(['common'], function (exports) {
    'use strict';

    const MODULE_NAME = 'loadingBar'
    const common = layui.common

    const config = {
        // 版本号
        version: '1.0.0',
        // 递增速度
        speed: 5,
        // 递增速率
        percentNum: 0,
    }

    const loadingBar = {
        // 递增计数器
        _timer: null,
        // 结束递增定时器
        _removeTimer: null,
        // 滚动条长度
        _totalProgress: 0,

        // 开始
        start: function () {
            loadingBar._timer || loadingBar._init();
            loadingBar._timer = setInterval(() => {
                if (loadingBar._totalProgress < 90) {
                    loadingBar._totalProgress += (config.percentNum || Math.random()) * config.speed;
                    document.querySelector('#mon-loading-bar .mon-loading-bar-main').style.transform = 'translate3d(-' + (100 - this._totalProgress) + '%, 0, 0)'
                }
            }, 100);
        },

        // 完成
        finish: function () {
            loadingBar._timer || loadingBar._init();
            clearTimeout(loadingBar._removeTimer);
            loadingBar._removeTimer = setTimeout(() => {
                clearInterval(loadingBar._timer);
                loadingBar._timer = null;
                document.querySelector('#mon-loading-bar .mon-loading-bar-main').style.transform = 'translate3d(0%, 0, 0)'
                let hideTimer = setTimeout(() => {
                    document.querySelector('#mon-loading-bar').style.display = 'none'
                    clearTimeout(hideTimer)
                }, 500);
            }, 200)
        },

        // 错误
        error() {
            loadingBar._timer || loadingBar._init();
            clearInterval(loadingBar._timer);
            clearTimeout(loadingBar._removeTimer);
            document.querySelector('#mon-loading-bar .mon-loading-bar-main').classList.add('mon-loading-bar-error')
            document.querySelector('#mon-loading-bar .mon-loading-bar-main').style.transform = 'translate3d(-20%, 0, 0)'
        },

        // 初始化
        _init: function () {
            // 判断是否已插入HTML
            if (!document.querySelector('#mon-loading-bar')) {
                loadingBar._buildHTML();
                loadingBar._buildCSS();
            }

            clearInterval(loadingBar._timer);
            loadingBar._totalProgress = 0;
            document.querySelector('#mon-loading-bar').style = ''
            document.querySelector('#mon-loading-bar').style.display = 'block'
            document.querySelector('#mon-loading-bar .mon-loading-bar-main').style.transform = 'translate3d(-100%, 0, 0)'
            document.querySelector('#mon-loading-bar .mon-loading-bar-main').classList.remove('mon-loading-bar-error')
        },

        // 插入HTML
        _buildHTML: function () {
            const html = `<div id="mon-loading-bar"><div class="mon-loading-bar-main" role="bar"><div class="mon-loading-bar-peg"></div></div></div>`
            document.querySelector('body').insertAdjacentHTML('beforeend', html)
        },

        // 插入style样式
        _buildCSS: function () {
            const css = `#mon-loading-bar .mon-loading-bar-main{position:fixed;top:0;left:0;width:100%;height:2px;z-index:1999;transition:all .2s ease;transform:translate3d(-100%,0,0);background:#3faaf5}
            #mon-loading-bar .mon-loading-bar-error{background:#ff4949}
            #mon-loading-bar .mon-loading-bar-peg{display:block;position:absolute;right:0;width:100px;height:100%;box-shadow:0 0 10px #ffdc00,0 0 5px #ffdc00;opacity:1;-ms-transform:rotate(3deg) translate(0,-4px);transform:rotate(3deg) translate(0,-4px)}`

            common.addStyle(css, 'mon-loading-bar-style')
        }
    }

    exports(MODULE_NAME, loadingBar)
})



