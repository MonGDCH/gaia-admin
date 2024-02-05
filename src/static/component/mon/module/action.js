layui.define(['jquery', 'layer'], function (exports) {
    'use strict';

    const MODULE_NAME = 'action'
    const $ = layui.jquery
    const layer = layui.layer

    const action = {
        // 打开抽屉操作
        drawer: function (url, title, options, full) {
            // 移动端则打开弹窗
            if ($(window).width() <= 768) {
                return action.dialog(url, title, options)
            }
            // layer参数
            options = options || {}
            // 标题
            title = options && options.title ? options.title : (title ? title : "");
            let areaWidth = $(window).width() > 1400 ? '60%' : '720px'

            // 生成参数
            let config = $.extend({
                id: 'mon-action-drawer',
                title: title,
                type: 2,
                content: url,
                area: [areaWidth, '100%'],
                offset: 'r',
                anim: 'slideLeft',
                closeBtn: 1,
                maxmin: true,
                shadeClose: true,
                resize: false,
                move: false,
                fixed: true,
                moveOut: false,
                scrollbar: false,
                skin: 'mon-drawer',
                btnAlign: 'c'
            }, options, {
                success: function (layero, index) {
                    // 移除最小化按钮
                    layero.find('.layui-layer-setwin .layui-layer-min').remove()
                    // 优化底部按钮
                    action.util.layerfooter(layero, index)
                    // js操作内容超出隐藏
                    document.querySelector('.mon-drawer .layui-layer-content').style.overflow = 'hidden'
                    // 全屏
                    if (full && full === true) {
                        layer.full(index)
                    }
                }
            })

            return layer.open(config)
        },
        // 打开弹窗操作
        dialog: function (url, title, options, full) {
            // layer参数
            options = options || {}
            // 标题
            title = options && options.title ? options.title : (title ? title : "");
            // 弹窗尺寸
            let area = [$(window).width() > 800 ? '768px' : '90%', $(window).height() > 700 ? '668px' : '90%'];
            // 生成参数
            let config = $.extend({
                id: 'mon-action-dialog',
                type: 2,
                title: title,
                shadeClose: true,
                maxmin: true,
                moveOut: true,
                scrollbar: false,
                resize: false,
                fixed: true,
                area: area,
                content: url,
                skin: 'mon-dialog'
            }, options, {
                success: function (layero, index) {
                    // 移除最小化按钮
                    layero.find('.layui-layer-setwin .layui-layer-min').remove()
                    // 优化底部按钮
                    action.util.layerfooter(layero, index)
                    // dialog按钮右对齐
                    let btnEl = document.querySelector('.layui-layer-footer .layui-input-block.text-left');
                    btnEl && btnEl.classList.remove('text-left')
                    // 全屏
                    if (full && full === true) {
                        layer.full(index)
                    }
                }
            })

            return layer.open(config)
        },
        util: {
            // 弹窗底部处理
            layerfooter: function (layero, index) {
                layer.setTop(layero)
                // 植入提交重置按钮
                let frame = layer.getChildFrame('html', index);
                let layerfooter = frame.find(".layer-footer");
                if (layerfooter.length > 0) {
                    // 重绘底部layer-footer
                    $(".layui-layer-footer", layero).remove();
                    let footer = $("<div />").addClass('layui-layer-btn layui-layer-footer');
                    footer.html(layerfooter.html());
                    footer.insertAfter(layero.find('.layui-layer-content'));

                    // 绑定按钮事件
                    footer.on("click", "button", function (e) {
                        e.stopPropagation()
                        // 兼容处理样式的 disabled 禁用
                        if ($(this).hasClass("disabled") || $(this).parent().hasClass("disabled")) {
                            return;
                        }
                        let index = footer.find('button').index(this);
                        $("button:eq(" + index + ")", layerfooter).trigger("click");
                        return false
                    });

                    // 重设高度
                    let titHeight = layero.find('.layui-layer-title').outerHeight() || 0;
                    let btnHeight = layero.find('.layui-layer-btn').outerHeight() || 0;
                    $(".layui-layer-content", layero).height(layero.height() - titHeight - btnHeight);
                }

                // 修复iOS下弹出窗口的高度和iOS下iframe无法滚动的BUG
                if (/iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream) {
                    let titHeight = layero.find('.layui-layer-title').outerHeight() || 0;
                    let btnHeight = layero.find('.layui-layer-btn').outerHeight() || 0;
                    $("iframe", layero).parent().css("height", layero.height() - titHeight - btnHeight);
                    $("iframe", layero).css("height", "100%");
                }

                return layerfooter
            }
        }
    }

    exports(MODULE_NAME, action)
});

