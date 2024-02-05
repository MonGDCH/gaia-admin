layui.define([], function (exports) {
    'use strict';

    const MODULE_NAME = 'cookie'

    const mCookie = {
        // 设置cookie
        set: function (name, value) {
            let Days = 30;
            let exp = new Date();
            exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
            document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
        },
        // 获取cookie
        get: function (name) {
            let arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
            return (arr = document.cookie.match(reg)) ? unescape(arr[2]) : null;
        },
        // 删除cookie
        del: function (name) {
            let exp = new Date();
            exp.setTime(exp.getTime() - 1);
            let cval = mCookie.get(name);
            if (cval != null) {
                document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
            }
        }
    }

    exports(MODULE_NAME, mCookie)
})