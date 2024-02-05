layui.define(['jquery', 'form', 'laydate', 'http', 'button'], function (exports) {
    'use strict';

    let $ = layui.jquery
    let form = layui.form
    let laydate = layui.laydate
    let http = layui.http
    let button = layui.button

    const mForm = {
        // 渲染
        render: function (type, filter) {
            // 初始化
            mForm.init();
            // 关闭表单自动输入
            form.set({
                autocomplete: 'off'
            });
            // 注册验证器
            form.verify(mForm.verify)
            // 样式渲染
            form.render(type || null, filter || null);
        },
        // 获取实例, 执行回调
        callback: function (callback) {
            return callback.call(this, form)
        },
        // 重载on
        on: function (event, callback) {
            form.on(event, callback);
        },
        // 获取表单值
        val: function (filter, values) {
            return form.val(filter, values)
        },
        // 表单提交
        submit: function (filter, success, error, option, before) {
            // 提交表单
            form.on('submit(' + filter + ')', function (data) {
                // 数据提交
                mForm.util.submitData(data, success, error, option, before)

                return false
            })
        },
        // 初始化渲染
        init: function () {
            // 日期区间
            if ($('.date-range').length > 0) {
                $('.date-range').each(function (index, e) {
                    let type = $(e).data('type') || 'date'
                    let format = $(e).data('format') || 'yyyy-MM-dd'
                    laydate.render({
                        elem: e,
                        type: type,
                        range: true,
                        rangeLinked: true,
                        fullPanel: true,
                        format: format,
                        value: $(e).val(),
                    })
                })
            }
            // 日期
            if ($('.date').length > 0) {
                $('.date').each(function (index, e) {
                    let type = $(e).data('type') || 'date'
                    let format = $(e).data('format') || 'yyyy-MM-dd'
                    laydate.render({
                        elem: e,
                        type: type,
                        format: format,
                        value: $(e).val(),
                    })
                })
            }

            if ($('.date-time').length > 0) {
                $('.date').each(function (index, e) {
                    let type = $(e).data('type') || 'datetime'
                    let format = $(e).data('format') || 'yyyy-MM-dd HH:mm:ss'
                    laydate.render({
                        elem: e,
                        type: type,
                        format: format,
                        fullPanel: true,
                        value: $(e).val(),
                    })
                })
            }
        },
        // 内置的验证条件
        verify: {
            // 用户名
            username: function (value, item) {
                if (!new RegExp('^[a-zA-Z0-9_-]{3,16}$').test(value)) {
                    return '用户名必须为合法的3-16位';
                }
            },
            // 密码
            password: function (value, item) {
                if (!new RegExp('^^[a-zA-Z0-9_\.]{6,16}$').test(value)) {
                    return '密码必须6-16位';
                }
            },
            // 验证输入一致
            consistent: function (value) {
                if (value !== $('#consistent_value').val()) {
                    return '输入内容不一致';
                }
            },
            // 邮箱或手机号
            account: function (value) {
                if (!new RegExp('^[1][3456789][0-9]{9}$').test(value) && !new RegExp('^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$').test(value)) {
                    return '请输入手机号码或邮箱地址';
                }
            },
            // 整数
            int: function (value) {
                if (/^-?\d+$/.test(value) !== true) {
                    return '请输入整数'
                }
            }
        },
        util: {
            // 提交数据
            submitData(data, success, error, option, before) {
                // 前置操作
                if (typeof before === 'function' && !before.call(this, data, form)) {
                    return false;
                }

                // 按钮禁用
                let btn = button.load({ elem: data.elem })
                // 表单数据
                let formElement = data.form
                let field = data.field
                // 请求方式
                let type = formElement.method || 'GET'
                let url = formElement.action || location.href
                // 合并ajax请求参数，option如果为函数则回调函数，获取参数实现提交时操作
                let extendData = (typeof option == 'object') ? option : (typeof option == 'function') ? option.call(this, data) : {}
                let dataOption = $.extend(field, extendData || {});

                // 表单提交
                http.ajax({
                    url: url,
                    method: type,
                    data: dataOption,
                }).then(response => {
                    let ret = mForm.util.onAjaxResponse(response)
                    if (ret.code === 1) {
                        mForm.util.onAjaxSuccess(ret, success);
                    } else {
                        mForm.util.onAjaxError(ret, error);
                    }
                }).finally(() => {
                    // 防刷
                    setTimeout(() => {
                        btn.stop();
                    }, 200);
                })
            },
            // 服务器响应数据后
            onAjaxResponse: function (response) {
                try {
                    let ret = typeof response === 'object' ? response : JSON.parse(response);
                    if (!ret.hasOwnProperty('code')) {
                        $.extend(ret, { code: -2, msg: response, data: null });
                    }
                    return ret
                } catch (e) {
                    return { code: -1, msg: e.message, data: null };
                }
            },
            // 请求成功的回调
            onAjaxSuccess: function (ret, onAjaxSuccess) {
                let data = typeof ret.data !== 'undefined' ? ret.data : null;
                let msg = typeof ret.msg !== 'undefined' && ret.msg ? ret.msg : '操作成功';

                if (typeof onAjaxSuccess === 'function') {
                    let result = onAjaxSuccess.call(this, data, ret);
                    if (result === false) {
                        return;
                    }
                }
                // 存在iframe，操作iframe
                if (parent !== self) {
                    // 存在刷新按钮，且已绑定事件，则刷新上级table
                    parent.document.querySelectorAll('.layui-table-tool [lay-event="refresh"]').forEach(el => {
                        el.click()
                    })

                    // 关闭弹层
                    let index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                }

                // parent.toast.success(msg);
                parent.layer.msg(msg, { icon: 1 })
            },
            // 请求错误的回调
            onAjaxError: function (ret, onAjaxError) {
                let data = typeof ret.data !== 'undefined' ? ret.data : null;
                if (typeof onAjaxError === 'function') {
                    let result = onAjaxError.call(this, data, ret);
                    if (result === false) {
                        return;
                    }
                }
                // parent.toast.error(ret.msg);
                // toast.error(ret.msg);
                layer.msg(ret.msg, { icon: 2 });
            },
        }
    }

    exports('mForm', mForm);
});