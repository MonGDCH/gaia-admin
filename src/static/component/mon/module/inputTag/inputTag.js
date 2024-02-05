layui.define(['jquery'], function (exports) {
    "use strict";
    const $ = layui.jquery

    // 模块名
    const MODULE_NAME = 'inputTag'
    // 加载模块资源
    const modFile = layui.cache.modules[MODULE_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    layui.link(modPath + '/inputTag.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))


    class InputTag {

        options = {
            elem: '.fairy-tag-input',
            theme: ['fairy-bg-red', 'fairy-bg-orange', 'fairy-bg-green', 'fairy-bg-cyan', 'fairy-bg-blue', 'fairy-bg-black'],
            data: [],
            removeKeyNum: 8,
            createKeyNum: 13,
            permanentData: [],
            placeholder: '添加标签，回车确认',
        };

        get elem() {
            return $(this.options.elem);
        }

        get copyData() {
            return [...this.options.data];
        }

        constructor(options) {
            this.render(options);
        }

        // 渲染
        render(options) {
            this.init(options);
            this.listen();
        }

        // 初始化
        init(options) {
            let spans = '', that = this;
            this.options = $.extend(this.options, options);
            // 渲染组件
            $.each(this.options.data, function (index, item) {
                if (item.trim() != '') {
                    spans += that.spanHtml(item);
                }
            });
            let placeholder = this.options.placeholder
            let temp = `<div class="fairy-tag-container">${spans}<input type="text" placeholder="${placeholder}" class="fairy-tag-input"></input></div>`
            this.elem.html(temp)
        }

        // 监听事件
        listen() {
            let that = this;
            // Enter添加，Backspace删除
            $(this.elem).on('keydown', '.fairy-tag-input', function (event) {
                let keyNum = (event.keyCode ? event.keyCode : event.which);
                if (keyNum === that.options.removeKeyNum) {
                    // 删除标签
                    if (!$(this).val().trim()) {
                        let closeItems = $(this).parent().find('a.remove-tag');
                        if (closeItems.length) {
                            that.removeItem($(closeItems[closeItems.length - 1]).parent('span'));
                            event.preventDefault();
                        }
                    }
                } else if (keyNum === that.options.createKeyNum) {
                    // 创建标签
                    let val = $(this).val().trim()
                    that.createItem(val, $(this));
                    event.preventDefault();
                }
            })

            // 快速添加
            $(this.elem).on('click', function () {
                $(this).find('input.fairy-tag-input').focus()
            })

            // 删除标签
            $(this.elem).on('click', 'a.remove-tag', function () {
                that.removeItem($(this).parent('span'));
            })
        }

        // 创建标签
        createItem(value, elem) {
            if (this.options.beforeCreate && typeof this.options.beforeCreate === 'function') {
                // 创建前回调
                let modifiedValue = this.options.beforeCreate(this.copyData, value);
                if (typeof modifiedValue == 'string' && modifiedValue) {
                    value = modifiedValue;
                } else {
                    value = '';
                }
            }

            if (value) {
                if (!this.options.data.includes(value)) {
                    this.options.data.push(value);
                    elem.before(this.spanHtml(value));
                    this.onChange(value, 'create');
                }
            }

            elem.val('');
        }

        // 删除标签
        removeItem(target) {
            let that = this;
            let closeSpan = target.remove(),
                closeSpanText = $(closeSpan).children('span').text();
            let value = that.options.data.splice($.inArray(closeSpanText, that.options.data), 1);
            value.length === 1 && that.onChange(value[0], 'remove');
        }

        // 随机验收
        randomColor() {
            return this.options.theme[Math.floor(Math.random() * this.options.theme.length)];
        }

        // 渲染内容
        spanHtml(value) {
            return '<span class="fairy-tag fairy-anim-fadein ' + this.randomColor() + '">' +
                '<span>' + value + '</span>' +
                (this.options.permanentData.includes(value) ? '' : '<a href="javascript:;" class="remove-tag" title="删除标签"><i class="layui-icon layui-icon-close"></i></a>') +
                '</span>';
        }

        // 标签修改事件
        onChange(value, type) {
            this.options.onChange && typeof this.options.onChange === 'function' && this.options.onChange(this.copyData, value, type);
        }

        getData() {
            return this.copyData;
        }

        clearData() {
            this.options.data = [];
            this.elem.find('span.fairy-tag').remove();
        }
    }

    // 导出
    exports(MODULE_NAME, {
        // 渲染
        render(option) {
            return new InputTag(option);
        }
    });
});
