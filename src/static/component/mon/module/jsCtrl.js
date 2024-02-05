!(function (global) {
    'use strict'
    function jsCtrl(options) {
        // 默认禁止调试
        this.config = Object.assign({
            // 关闭网站
            closeSite: 0,
            closeTips: '系统维护中',
            // 禁止iframe
            notIframe: false,
            // 禁用右键菜单
            notContextMenu: true,
            // 禁用选中
            notSelected: false,
            // 禁止F5刷新
            notF5: false,
            // 禁止F12调试
            notF12: true,
            // 禁止ctrl+shift+i调试
            notF12b: true,
            // 查看源代码
            notCtrlU: true,
            // 禁止复制
            notCopy: false,
            // 禁止debug调试
            notDevTools: true,
            // 系统灰色黑白化
            greyApp: false,
            // 复制内容保留原站信息
            copyTips: ''
        }, options || {})

        this._init()
    }

    jsCtrl.prototype = {
        constructor: jsCtrl,
        _init: function () {
            // 关闭网站
            const closeSite = this.config.closeSite;
            const closeTips = this.config.closeTips || '系统维护中'
            if (closeSite == true) {
                document.body.innerHTML = `<div style="position:fixed;top:0;left:0;width:100%;height:100%;text-align:center;background:#fff;padding-top:150px;z-index:99999;">${closeTips}</div>`
            }

            // 禁止iframe
            const notIframe = this.config.notIframe
            if (notIframe == true && self != top) {
                parent.window.location.replace(window.location.href);
            }

            // 禁用右键菜单
            const notContextMenu = this.config.notContextMenu;
            if (notContextMenu == true) {
                document.oncontextmenu = function () {
                    event.returnValue = false;
                }
                document.oncontextmenu = function (e) {
                    return false;
                }
            }

            // 禁用选中
            const notSelected = this.config.notSelected;
            if (notSelected == true) {
                document.onselectstart = function () {
                    return false;
                }
            }

            // 禁用特殊按键
            const notF5 = this.config.notF5
            const notF12 = this.config.notF12
            const notF12b = this.config.notF12b
            const notCtrlU = this.config.notCtrlU
            const notCopy = this.config.notCopy
            document.addEventListener("keydown", function (event) {
                const e = event || window.event || arguments.callee.caller.arguments[0]
                const k = e.keyCode || e.which || e.charCode;
                if ((k == 116 && notF5 == true) || (e.ctrlKey && k == 82 && notF5 == true) || (k == 123 && notF12 == true) || (e.ctrlKey && e.shiftKey && k == 73 && notF12b == true) || (e.ctrlKey && k == 67 && notCopy == true) || (e.ctrlKey && k == 85 && notCtrlU == true)) {
                    e.preventDefault();
                    e.returnValue = false;
                    e.cancelBubble = true;
                    return false;
                }
            });

            // 禁止调试
            const notDevTools = this.config.notDevTools
            if (notDevTools == true) {
                let tips = '<div style="\x63\x6f\x6c\x6f\x72\x3a\x23\x66\x33\x33\x3b\x74\x65\x78\x74\x2d\x61\x6c\x69\x67\x6e\x3a\x63\x65\x6e\x74\x65\x72\x3b\x66\x6f\x6e\x74\x2d\x73\x69\x7a\x65\x3a\x31\x32\x70\x78\x3b\x74\x65\x78\x74\x2d\x73\x68\x61\x64\x6f\x77\x3a\x31\x70\x78\x20\x31\x70\x78\x20\x30\x20\x23\x66\x66\x66\x2c\x20\x2d\x31\x70\x78\x20\x2d\x31\x70\x78\x20\x30\x20\x23\x66\x66\x66\x3b\x70\x61\x64\x64\x69\x6e\x67\x3a\x32\x30\x76\x68\x20\x30\x3b" onclick="javascript:location.reload();">\u4e0d\u652f\u6301\u8c03\u8bd5\uff0c\u8bf7\u5173\u95ed\u5f00\u53d1\u8005\u5de5\u5177\(\u5237\u65b0\u7f51\u9875\)</div>';
                ConsoleBan.init({
                    debugTime: 1500,
                    write: tips,
                    callback: () => {
                        document.body.innerHTML = tips
                        window.close();
                    }
                });
            }

            // 系统黑白化
            const greyApp = this.config.greyApp
            if (greyApp == true) {
                const cssText = `body{-webkit-filter: grayscale(100%);-moz-filter: grayscale(100%);-ms-filter: grayscale(100%);-o-filter: grayscale(100%);filter: grayscale(100%);}`
                // 创建一个style元素
                const style = document.createElement('style')
                // 获取head元素
                const head = document.head || document.querySelector('head');
                // 这里必须显示设置style元素的type属性为text/css，否则在ie中不起作用
                style.type = 'text/css';
                // w3c浏览器中只要创建文本节点插入到style元素中就行了
                let textNode = document.createTextNode(cssText);
                style.appendChild(textNode);
                // 把创建的style元素插入到head中 
                head.appendChild(style);
            }

            // 复制内容保留原站信息
            const copyTips = ''
            if (copyTips != '') {
                document.addEventListener('copy', function (event) {
                    if (typeof window.getSelection == "undefined") return;
                    var body_element = document.getElementsByTagName('body')[0];
                    var selection = window.getSelection();
                    if (("" + selection).length < 10) return;
                    var newdiv = document.createElement('div');
                    newdiv.style.position = 'absolute';
                    newdiv.style.left = '-99999px';
                    body_element.appendChild(newdiv);
                    newdiv.appendChild(selection.getRangeAt(0).cloneContents());
                    if (selection.getRangeAt(0).commonAncestorContainer.nodeName == "PRE") {
                        newdiv.innerHTML = "<pre>" + newdiv.innerHTML + "</pre>";
                    }
                    newdiv.innerHTML += "<br><br>--------------------<br>" + copyTips + "<br>原文地址：" + document.location.href;
                    selection.selectAllChildren(newdiv);
                    window.setTimeout(function () { body_element.removeChild(newdiv); }, 200);
                });
            }

        }
    }

    // 支持cmd及amd，方便后续的可能需要的工程化
    if (typeof module !== "undefined" && module.exports) {
        module.exports = jsCtrl;
    } else if (typeof define === "function" && define.amd) {
        define(function () { return jsCtrl; });
    } else if (typeof layui != 'undefined' && layui.define) {
        layui.define(function (exports) { exports('jsCtrl', jsCtrl) });
    } else {
        !('jsCtrl' in global) && (global.jsCtrl = jsCtrl);
    }
})(window);

/*!
 * console-ban v5.0.0
 * (c) 2020-2023 fz6m
 * Released under the MIT License.
 */
!function (e, t) { "object" == typeof exports && "undefined" != typeof module ? t(exports) : "function" == typeof define && define.amd ? define(["exports"], t) : t((e = "undefined" != typeof globalThis ? globalThis : e || self).ConsoleBan = {}) }(this, (function (e) { "use strict"; var t = function () { return t = Object.assign || function (e) { for (var t, n = 1, i = arguments.length; n < i; n++)for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]); return e }, t.apply(this, arguments) }, n = { clear: !0, debug: !0, debugTime: 3e3, bfcache: !0 }, i = 2, o = function (e) { return ~navigator.userAgent.toLowerCase().indexOf(e) }, r = function (e, t) { t !== i ? location.href = e : location.replace(e) }, c = 0, a = 0, f = function (e) { var t = 0, n = 1 << c++; return function () { (!a || a & n) && 2 === ++t && (a |= n, e(), t = 1) } }, s = function (e) { var t = /./; t.toString = f(e); var n = function () { return t }; n.toString = f(e); var i = new Date; i.toString = f(e), console.log("%c", n, n(), i); var o, r, c = f(e); o = c, r = new Error, Object.defineProperty(r, "message", { get: function () { o() } }), console.log(r) }, u = function () { function e(e) { var i = t(t({}, n), e), o = i.clear, r = i.debug, c = i.debugTime, a = i.callback, f = i.redirect, s = i.write, u = i.bfcache; this._debug = r, this._debugTime = c, this._clear = o, this._bfcache = u, this._callback = a, this._redirect = f, this._write = s } return e.prototype.clear = function () { this._clear && (console.clear = function () { }) }, e.prototype.bfcache = function () { this._bfcache && (window.addEventListener("unload", (function () { })), window.addEventListener("beforeunload", (function () { }))) }, e.prototype.debug = function () { if (this._debug) { var e = new Function("debugger"); setInterval(e, this._debugTime) } }, e.prototype.redirect = function (e) { var t = this._redirect; if (t) if (0 !== t.indexOf("http")) { var n, i = location.pathname + location.search; if (((n = t) ? "/" !== n[0] ? "/".concat(n) : n : "/") !== i) r(t, e) } else location.href !== t && r(t, e) }, e.prototype.callback = function () { if ((this._callback || this._redirect || this._write) && window) { var e, t = this.fire.bind(this), n = window.chrome || o("chrome"), r = o("firefox"); if (!n) return r ? ((e = /./).toString = t, void console.log(e)) : void function (e) { var t = new Image; Object.defineProperty(t, "id", { get: function () { e(i) } }), console.log(t) }(t); s(t) } }, e.prototype.write = function () { var e = this._write; e && (document.body.innerHTML = "string" == typeof e ? e : e.innerHTML) }, e.prototype.fire = function (e) { this._callback ? this._callback.call(null) : (this.redirect(e), this._redirect || this.write()) }, e.prototype.prepare = function () { this.clear(), this.bfcache(), this.debug() }, e.prototype.ban = function () { this.prepare(), this.callback() }, e }(); e.init = function (e) { new u(e).ban() } }));
