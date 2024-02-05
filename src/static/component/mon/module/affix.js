layui.define(['jquery'], function (exports) {
    "use strict";

    // 模块名
    const MODULE_NAME = 'affix'

    const $ = layui.jquery

    // 固定块
    function affix(options) {
        let defaultOptions = {
            // 选择的要固定的元素
            elem: '.affix',
            // 滑到这个位置顶部时开始浮动，默认为空
            startTop: null,
            // 滑到这个位置末端开始浮动，默认为空
            startBottom: null,
            // 固定在顶部的高度
            distanceTop: 0,
            // 停靠在底部的位置，可以为jquery对象
            endPos: 0,
            // 底部位置
            bottom: -1,
            // z-index值
            zIndex: 998,
            // 开始固定时添加的类
            baseClassName: 'scrollfixed'
        }

        let opts = $.extend({}, defaultOptions, options);
        let obj = $(opts.elem),
            selfTop = 0,
            selfLeft = 0,
            toTop = 0,
            parentOffsetLeft = 0,
            parentOffsetTop = 0,
            outerHeight,
            outerWidth,
            objWidth = 0,
            // 创建一个jquery对象
            placeholder = $('<div>'),
            // 定义到顶部的高度
            optsTop = opts.distanceTop,
            // 开始停止固定的位置
            endfix = 0;

        let originalPosition;
        let originalOffsetTop;
        let originalZIndex;
        let position;
        let lastOffsetLeft = -1;
        let isUnfixed = true;
        // 如果没有找到节点，不进行处理
        if (obj.length <= 0) {
            return;
        }
        if (lastOffsetLeft == -1) {
            originalZIndex = obj.css('z-index');
            position = obj.css('position');
            originalPosition = obj.css('position');
            originalOffsetTop = obj.css('top');
        }

        let zIndex = obj.css('zIndex');
        if (opts.zIndex != 0) {
            zIndex = opts.zIndex;
        }
        // 获取相对定位或者绝对定位的父类
        let parents = obj.parent();
        let Position = parents.css('position');
        // 检测浮动元素的父类元素定位为'relative'或者'absolute',是的话退出，否则的话，执行循环，继续寻找它的父类
        while (!/^relative|absolute$/i.test(Position)) {
            parents = parents.parent();
            Position = parents.css('position');
            // 假如父类元素的标签为body或者HTML，说明没有找到父类为以上的定位，退出循环
            if (/^body|html$/i.test(parents[0].tagName)) {
                break;
            }
        }

        function resetScroll() {
            setUnfixed();
            // 对象距离顶部高度
            selfTop = obj.offset().top;
            // 对象距离左边宽度
            selfLeft = obj.offset().left;
            // 对象高度
            outerHeight = obj.outerHeight();
            outerHeight = parseFloat(outerHeight) + parseFloat(obj.css('marginBottom').replace(/auto/, 0));
            // 对象外宽度
            outerWidth = obj.outerWidth();
            objWidth = obj.width();
            // 文档高度
            let documentHeight = $(document).height();
            // 开始浮动固定对象
            let startTop = $(opts.startTop),
                startBottom = $(opts.startBottom),
                // 停止滚动位置距离底部的高度
                toBottom,
                // 对象滚动的高度
                ScrollHeight;

            // 计算父类偏移值
            if (/^body|html$/i.test(parents[0].tagName)) {
                // 当父类元素非body或者HTML时，说明找到了一个父类为'relative'或者'absolute'的元素，得出它的偏移高度
                parentOffsetTop = 0, parentOffsetLeft = 0;
            } else {
                parentOffsetLeft = parents.offset().left, parentOffsetTop = parents.offset().top;
            }

            // 计算父节点的上边到顶部距离
            // 如果 body 有 top 属性, 消除这些位移
            let bodyToTop = parseInt($('body').css('top'), 10);
            if (!isNaN(bodyToTop)) {
                optsTop += bodyToTop;
            }
            // 计算停在底部的距离
            if (!isNaN(opts.endPos)) {
                toBottom = opts.endPos;
            } else {
                toBottom = parseFloat(documentHeight - $(opts.endPos).offset().top);
            }
            // 计算需要滚动的高度以及停止滚动的高度
            ScrollHeight = parseFloat(documentHeight - toBottom - optsTop), endfix = parseFloat(ScrollHeight - outerHeight);
            // 计算顶部的距离值
            if (startTop[0]) {
                let startTopOffset = startTop.offset(),
                    startTopPos = startTopOffset.top;
                selfTop = startTopPos;
            }
            if (startBottom[0]) {
                let startBottomOffset = startBottom.offset(),
                    startBottomPos = startBottomOffset.top,
                    startBottomHeight = startBottom.outerHeight();
                selfTop = parseFloat(startBottomPos + startBottomHeight);
            }

            toTop = selfTop - optsTop;
            toTop = (toTop > 0) ? toTop : 0;

            let selfBottom = documentHeight - selfTop - outerHeight;
            // 如果滚动停在底部的值不为0，并且自身到底部的高度小于上面这个值，不执行浮动固定
            if ((toBottom != 0) && (selfBottom <= toBottom)) {
                return;
            }

        }
        function setUnfixed() {
            if (!isUnfixed) {
                lastOffsetLeft = -1;
                placeholder.css("display", "none");
                obj.css({
                    'z-index': originalZIndex,
                    'width': '',
                    'position': originalPosition,
                    'left': '',
                    'top': originalOffsetTop,
                    'margin-left': ''
                });
                obj.removeClass('scrollfixed');
                isUnfixed = true;
            }
        }

        function onScroll() {
            lastOffsetLeft = 1;
            let ScrollTop = $(window).scrollTop();
            if (opts.bottom != -1) {
                ScrollTop = ScrollTop + $(window).height() - outerHeight - opts.bottom;
            }

            if (ScrollTop > toTop && (ScrollTop < endfix)) {
                obj.addClass(opts.baseClassName).css({
                    "z-index": zIndex,
                    "position": "fixed",
                    "top": opts.bottom == -1 ? optsTop : '',
                    "bottom": opts.bottom == -1 ? '' : opts.bottom,
                    "left": selfLeft,
                    "width": objWidth
                });
                placeholder.css({
                    'height': outerHeight,
                    'width': outerWidth,
                    'display': 'block'
                }).insertBefore(obj);
            } else if (ScrollTop >= endfix) {
                obj.addClass(opts.baseClassName).css({
                    "z-index": zIndex,
                    "position": "absolute",
                    "top": endfix - parentOffsetTop + optsTop,
                    'bottom': '',
                    "left": selfLeft - parentOffsetLeft,
                    "width": objWidth
                });
                placeholder.css({
                    'height': outerHeight,
                    'width': outerWidth,
                    'display': 'block'
                }).insertBefore(obj)
            } else {
                obj.removeClass(opts.baseClassName).css({
                    "z-index": originalZIndex,
                    "position": "static",
                    "top": "",
                    "bottom": "",
                    "left": ""
                });
                placeholder.remove()
            }
        }
        let Timer = 0;
        const dithering = 10;
        // if (isUnfixed) {
        resetScroll();
        // }
        $(window).on("scroll", function () {
            if (Timer) {
                clearTimeout(Timer);
            }
            Timer = setTimeout(onScroll, dithering);
        });
        // 当发现调整屏幕大小时，重新执行代码
        $(window).on("resize", function () {
            if (Timer) {
                clearTimeout(Timer);
            }
            Timer = setTimeout(function () {
                isUnfixed = false;
                resetScroll();
                onScroll();
            }, dithering)
        });
    }

    exports(MODULE_NAME, {
        render: function (opts) {
            return affix(opts)
        }
    })
})