layui.define([], function (exports) {
    "use strict";

    const util = {
        // 获取get参数
        get: function (key, def) {
            let param = document.location.href.split("?");
            let get = {};
            if ("string" == typeof (param[1])) {
                let pair = param[1].split("&");
                for (let i in pair) {
                    let j = pair[i].split("=");
                    get[j[0]] = j[1] ? j[1] : "";
                }
            }
            return key ? (get[key] ? get[key] : def) : get;
        },
        // 实现php urlencode 方法
        urlencode: function (str) {
            let output = '';
            let x = 0;
            str = str.toString();
            let regex = /(^[a-zA-Z0-9-_.\-]*)/;
            while (x < str.length) {
                let match = regex.exec(str.substr(x));
                if (match != null && match.length > 1 && match[1] != '') {
                    output += match[1];
                    x += match[1].length;
                } else {
                    if (str.substr(x, 1) == ' ') {
                        output += '+';
                    }
                    else {
                        let charCode = str.charCodeAt(x);
                        let hexVal = charCode.toString(16);
                        output += '%' + (hexVal.length < 2 ? '0' : '') + hexVal.toUpperCase();
                    }
                    x++;
                }
            }
            return output;
        },
        // 获取当前时间戳，和PHP实现一致
        time: function () {
            let time = (new Date()).valueOf();
            return Math.floor(time / 1000);
        },
        // 格式化时间戳，和PHP实现一致
        date: function (format, timestamp) {
            format = format ? format : 'Y-m-d H:i:s';
            timestamp = timestamp ? parseInt(timestamp, 10) : util.time();

            let a, jsdate = ((timestamp) ? new Date(timestamp * 1000) : new Date());
            let pad = function (n, c) {
                if ((n = n + "").length < c) {
                    return new Array(++c - n.length).join("0") + n;
                } else {
                    return n;
                }
            };
            let txt_weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            let txt_ordin = { 1: "st", 2: "nd", 3: "rd", 21: "st", 22: "nd", 23: "rd", 31: "st" };
            let txt_months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            let f = {
                // Day
                d: function () { return pad(f.j(), 2) },
                D: function () { return f.l().substr(0, 3) },
                j: function () { return jsdate.getDate() },
                l: function () { return txt_weekdays[f.w()] },
                N: function () { return f.w() + 1 },
                S: function () { return txt_ordin[f.j()] ? txt_ordin[f.j()] : 'th' },
                w: function () { return jsdate.getDay() },
                z: function () { return (jsdate - new Date(jsdate.getFullYear() + "/1/1")) / 864e5 >> 0 },

                // Week
                W: function () {
                    let a = f.z(), b = 364 + f.L() - a;
                    let nd2, nd = (new Date(jsdate.getFullYear() + "/1/1").getDay() || 7) - 1;
                    if (b <= 2 && ((jsdate.getDay() || 7) - 1) <= 2 - b) {
                        return 1;
                    } else {
                        if (a <= 2 && nd >= 4 && a >= (6 - nd)) {
                            nd2 = new Date(jsdate.getFullYear() - 1 + "/12/31");
                            return date("W", Math.round(nd2.getTime() / 1000));
                        } else {
                            return (1 + (nd <= 3 ? ((a + nd) / 7) : (a - (7 - nd)) / 7) >> 0);
                        }
                    }
                },

                // Month
                F: function () { return txt_months[f.n()] },
                m: function () { return pad(f.n(), 2) },
                M: function () { return f.F().substr(0, 3) },
                n: function () { return jsdate.getMonth() + 1 },
                t: function () {
                    let n;
                    if ((n = jsdate.getMonth() + 1) == 2) {
                        return 28 + f.L();
                    } else {
                        if (n & 1 && n < 8 || !(n & 1) && n > 7) {
                            return 31;
                        } else {
                            return 30;
                        }
                    }
                },

                // Year
                L: function () { let y = f.Y(); return (!(y & 3) && (y % 1e2 || !(y % 4e2))) ? 1 : 0 },
                Y: function () { return jsdate.getFullYear() },
                y: function () { return (jsdate.getFullYear() + "").slice(2) },

                // Time
                a: function () { return jsdate.getHours() > 11 ? "pm" : "am" },
                A: function () { return f.a().toUpperCase() },
                B: function () {
                    let off = (jsdate.getTimezoneOffset() + 60) * 60;
                    let theSeconds = (jsdate.getHours() * 3600) + (jsdate.getMinutes() * 60) + jsdate.getSeconds() + off;
                    let beat = Math.floor(theSeconds / 86.4);
                    if (beat > 1000) beat -= 1000;
                    if (beat < 0) beat += 1000;
                    if ((String(beat)).length == 1) beat = "00" + beat;
                    if ((String(beat)).length == 2) beat = "0" + beat;
                    return beat;
                },
                g: function () { return jsdate.getHours() % 12 || 12 },
                G: function () { return jsdate.getHours() },
                h: function () { return pad(f.g(), 2) },
                H: function () { return pad(jsdate.getHours(), 2) },
                i: function () { return pad(jsdate.getMinutes(), 2) },
                s: function () { return pad(jsdate.getSeconds(), 2) },

                O: function () {
                    let t = pad(Math.abs(jsdate.getTimezoneOffset() / 60 * 100), 4);
                    if (jsdate.getTimezoneOffset() > 0) t = "-" + t; else t = "+" + t;
                    return t;
                },
                P: function () { let O = f.O(); return (O.substr(0, 3) + ":" + O.substr(3, 2)) },
                c: function () { return f.Y() + "-" + f.m() + "-" + f.d() + "T" + f.h() + ":" + f.i() + ":" + f.s() + f.P() },
                U: function () { return Math.round(jsdate.getTime() / 1000) }
            };
            return format.replace(/[\\]?([a-zA-Z])/g, function (t, s) {
                let ret = null;
                if (t != s) {
                    ret = s;
                } else if (f[s]) {
                    ret = f[s]();
                } else {
                    ret = s;
                }
                return ret;
            });
        },
        // 日期转时间戳
        strtotime: function (datetime) {
            let tmp_datetime = datetime.replace(/:/g, '-');
            tmp_datetime = tmp_datetime.replace(/\//g, '-');
            tmp_datetime = tmp_datetime.replace(/ /g, '-');
            let arr = tmp_datetime.split("-");
            let y = arr[0];
            let m = arr[1] - 1;
            let d = arr[2];
            let h = arr[3] - 8; ///兼容八小时时差问题  
            let i = arr[4];
            let s = arr[5];
            //兼容无"时:分:秒"模式  
            if (arr[3] == 'undefined' || isNaN(h)) {
                h = 0;
            }
            if (arr[4] == 'undefined' || isNaN(i)) {
                i = 0;
            }
            if (arr[5] == 'undefined' || isNaN(s)) {
                s = 0;
            }
            let now = new Date(Date.UTC(y, m, d, h, i, s));
            return now.getTime() / 1000;
        },
        // 随机字符串
        randomString: function (length) {
            let str = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            let result = '';
            for (let i = length; i > 0; i--) {
                result += str[Math.floor(Math.random() * str.length)];
            }
            return result;
        },
        // 生成uuid
        uuid: function () {
            return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                let r = Math.random() * 16 | 0,
                    v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        },
        // image 转 base64
        imageToBase64: function (img) {
            let canvas = document.createElement("canvas");
            canvas.width = img.width;
            canvas.height = img.height;
            let ctx = canvas.getContext("2d");
            ctx.drawImage(img, 0, 0, img.width, img.height);
            let ext = img.src.substring(img.src.lastIndexOf(".") + 1).toLowerCase();
            let dataURL = canvas.toDataURL("image/" + ext);
            return dataURL;
        },
        // js异步引入js脚本
        addScript: function (url) {
            return new Promise(function (resolve, reject) {
                let _script = document.createElement("script");
                _script.type = "text/javascript";
                _script.src = url;
                _script.onload = function () {
                    resolve(url);
                };
                _script.onerror = function (err) {
                    reject(err)
                }
                document.body.appendChild(_script);
            });
        },
        // js异步写入style样式
        addStyle: function (cssText, id) {
            return new Promise((resolve, reject) => {
                // 存在指定id的style，则不重复写入
                if (id && document.querySelector('#' + id)) {
                    return resolve()
                }
                // 创建一个style元素
                const style = document.createElement('style')
                if (id) {
                    style.id = id
                }

                // 获取head元素
                const head = document.head || document.querySelector('head');
                // 这里必须显示设置style元素的type属性为text/css，否则在ie中不起作用
                style.type = 'text/css';
                // w3c浏览器中只要创建文本节点插入到style元素中就行了
                let textNode = document.createTextNode(cssText);
                style.appendChild(textNode);
                // 把创建的style元素插入到head中 
                head.appendChild(style);

                return resolve()
            })
        }
    }

    exports('common', util);
})