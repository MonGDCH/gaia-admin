layui.define(['jquery', 'common'], function (exports) {
    'use strict';

    const MODULE_NAME = 'nav'
    const $ = layui.jquery
    const common = layui.common

    const defaultConfig = {
        // 导航列表
        list: [],
        // 是否为跳转链接
        isLink: false,
        // 当为跳转链接时，是否为新开页面
        newPage: false,
        // 关闭的按钮内容
        close: '<svg t="1607309435566" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3083" width="12" height="12"><path d="M544 522.666667c0-8.533333-4.266667-17.066667-10.666667-23.466667L192 189.866667c-12.8-12.8-34.133333-10.666667-44.8 2.133333-12.8 12.8-10.666667 34.133333 2.133333 44.8l315.733334 285.866667L149.333333 808.533333c-12.8 12.8-14.933333 32-2.133333 44.8 6.4 6.4 14.933333 10.666667 23.466667 10.666667 8.533333 0 14.933333-2.133333 21.333333-8.533333l341.333333-309.333334c6.4-6.4 10.666667-14.933333 10.666667-23.466666z" p-id="3084"></path><path d="M864 499.2l-341.333333-309.333333c-12.8-12.8-34.133333-10.666667-44.8 2.133333-12.8 12.8-10.666667 34.133333 2.133333 44.8l315.733333 285.866667-315.733333 285.866666c-12.8 12.8-14.933333 32-2.133333 44.8 6.4 6.4 14.933333 10.666667 23.466666 10.666667 8.533333 0 14.933333-2.133333 21.333334-8.533333l341.333333-309.333334c6.4-6.4 10.666667-14.933333 10.666667-23.466666 0-8.533333-4.266667-17.066667-10.666667-23.466667z" p-id="3085"></path></svg>',
        // 打开的按钮内容
        open: '<svg t="1607309342612" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2933" width="12" height="12"><path d="M842.666667 864c-8.533333 0-14.933333-2.133333-21.333334-8.533333l-341.333333-309.333334c-6.4-6.4-10.666667-14.933333-10.666667-23.466666 0-8.533333 4.266667-17.066667 10.666667-23.466667l341.333333-309.333333c12.8-12.8 34.133333-10.666667 44.8 2.133333 12.8 12.8 10.666667 34.133333-2.133333 44.8L548.266667 522.666667l315.733333 285.866666c12.8 10.666667 14.933333 32 2.133333 44.8-6.4 6.4-14.933333 10.666667-23.466666 10.666667z" p-id="2934"></path><path d="M512 864c-8.533333 0-14.933333-2.133333-21.333333-8.533333L149.333333 546.133333c-6.4-6.4-10.666667-14.933333-10.666666-23.466666 0-8.533333 4.266667-17.066667 10.666666-23.466667L490.666667 189.866667c12.8-12.8 34.133333-10.666667 44.8 2.133333 12.8 12.8 10.666667 34.133333-2.133334 44.8L217.6 522.666667 533.333333 808.533333c12.8 12.8 14.933333 32 2.133334 44.8-6.4 6.4-14.933333 10.666667-23.466667 10.666667z" p-id="2935"></path></svg>',
        // 动画时间
        animate: 360,
    }

    const nav = {
        // 渲染
        render: function (option) {
            option = option || {}
            this.config = $.extend({}, defaultConfig, option);

            this._initStyle()
            this._initHTML()
            this._initEvent();
        },
        // 渲染css
        _initStyle: function () {
            const style = `.mon-target-nav{position:fixed;top:160px;right:0;z-index:1000;width:96px;background:#f5f5f5;text-align:center;font-size:12px;border: 0;}
            .mon-target-nav ul{margin:0;padding:0;width:100%;list-style:none;}
            .mon-target-nav li{display:inline-block;width:100%;border-bottom:1px solid #eee;}
            .mon-target-nav li:last-child{border-bottom:0;}
            .mon-target-nav li a{display:inline-block;padding:10px 0;width:100%;color:#666;text-decoration:none;}
            .mon-target-nav li a.mon-target-nav-active,.mon-target-nav li a:hover{background:#eee;color:#333;}
            .mon-target-nav li.nav-shrink-submit{padding:2px 0;width:100%;background:#dadada;font-size:20px;cursor:pointer;}
            .mon-target-nav-retract li.nav-shrink-submit{position:absolute;padding:2px 20px;width:auto;}`

            common.addStyle(style, 'mon-nav-style');
        },
        // 渲染html
        _initHTML: function () {
            // [{ title: '标题', value: '#linkID' }, { title: '标题2', value: '#linkID2' },]
            let temp = [];
            for (let i = 0, l = this.config.list.length; i < l; i++) {
                let item = this.config.list[i];
                temp.push('<li><a href="javascript:void(0);" data-value="' + item.value + '">' + item.title + '</a></li>')
            }

            let html = '<nav class="mon-target-nav"><ul>\
                            '+ temp.join("\n") + '\
                            <li class="nav-shrink-submit nav-shrink">\
                                <i class="nav-shrink">'+ this.config.close + '</i>\
                            </li>\
                        </ul></nav>'

            // console.log(html)
            $('body').append(html)
        },
        // 绑定事件
        _initEvent: function () {
            let self = this;
            // 商品导航
            $('.mon-target-nav li a').on('click', function () {
                let target = $(this).data('value')
                if (self.config.isLink) {
                    // 页面跳转, 判断是否为新开页面
                    if (self.config.newPage) {
                        window.open(target)
                    } else {
                        // 当前页面跳转
                        window.location.href = target
                    }
                } else {
                    // 使用锚点滚动切换
                    if ($(target).offset()) {
                        $('.mon-target-nav li a').removeClass('mon-target-nav-active');
                        $(this).addClass('mon-target-nav-active');
                        // 滚动
                        $('html,body').animate({ scrollTop: ($(target).offset().top - 20) }, 400);
                    }
                }
            });

            // 商品导航收缩
            $('.mon-target-nav li.nav-shrink-submit').on('click', function () {
                let that = $(this)
                if (that.hasClass('nav-shrink')) {
                    that.removeClass('nav-shrink')
                    $('.mon-target-nav').animate({ right: '-110px' }, self.config.animate, function () {
                        that.html(self.config.open)
                        that.parents('.mon-target-nav').addClass('mon-target-nav-retract');
                        $('.mon-target-nav-retract li.nav-shrink-submit').animate({ left: '-64px' });
                    });
                } else {
                    that.addClass('nav-shrink')
                    $('.mon-target-nav li.nav-shrink-submit').animate({ left: '0px' }, function () {
                        that.html(self.config.close)
                        that.parents('.mon-target-nav').removeClass('mon-target-nav-retract');
                        $('.mon-target-nav').animate({ right: '0px' })
                    });
                }
            });
        }
    }

    exports(MODULE_NAME, nav)
});