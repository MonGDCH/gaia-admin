layui.define(['jquery', 'upload'], function (exports) {
    'use strict';

    const MODULE_NAME = 'mUpload'
    const $ = layui.jquery
    const upload = layui.upload

    let mUpload = {
        // 默认配置
        config: {
            // 额外上传参数
            data: {},
            // 请求头信息
            headers: {},
            // 指定允许上传时校验的文件类型，可选值有：images（图片）、file（所有文件）、video（视频）、audio（音频）
            accept: 'file',
            // 规定打开文件选择框时，筛选出的文件类型，值为用逗号隔开的 MIME 类型列表
            acceptMime: '',
            // 指定允许上传的文件后缀名，|分割，如：jpg|png|gif|jpeg
            exts: '',
            // 是否选择完文件自动上传
            auto: true,
            // 指向一个按钮触发上传，一般配合 auto: false 来使用。值为选择器或DOM对象，如：bindAction: '#btn'
            bindAction: null,
            // 文件域字段名
            field: 'file',
            // 文件最大允许上传的大小
            size: 0,
            // 是否开启多文件上传
            multiple: false,
            // 设置同时可上传的文件数量，一般配合 multiple 参数出现
            number: 0,
            // 是否接受拖拽的文件上传
            drag: true,
            // 上传图片，自动压缩
            picCompress: false,
            // 压缩比例
            compressQuality: '0.7',
            // 启用压缩的图片大小
            compressSize: 0,
        },
        // 图片压缩配置信息
        compressConfig: {},
        // 事件处理
        events: {
            // 选择文件的回调
            onChoose: function (obj, choose) {
                // 判断是否开启图片上传压缩
                if (mUpload.compressConfig.picCompress) {
                    mUpload.compress.onChoose(obj)
                }

                // 可用于预览，或做一些其他的文件相关的操作
                if (typeof choose === 'function') {
                    let result = choose.call(this, obj);
                    if (result === false) {
                        return;
                    }
                }
            },
            // 文件上传前的回调
            onBefore: function (obj, before) {
                if (typeof before === 'function') {
                    let result = before.call(this, obj);
                    if (result === false) {
                        return;
                    }
                }
                // 渲染loading
                layer.load(2);
            },
            // 文件上传成功回调，res（服务端响应信息）、index（当前文件的索引）、upload（重新上传的方法，一般在文件上传失败后使用）
            onDone: function (res, index, upload, done, obj) {
                if (typeof done === 'function') {
                    let result = done.call(this, res, index, upload, obj);
                    if (result === false) {
                        return;
                    }
                }
                // 关闭渲染loading
                layer.closeAll('loading');
            },
            // 文件上传失败回调，index（当前文件的索引）、upload（重新上传的方法，一般在文件上传失败后使用）
            onError: function (index, upload, error) {
                if (typeof error === 'function') {
                    let result = error.call(this, index, upload);
                    if (result === false) {
                        return;
                    }
                }
                // 关闭渲染loading
                layer.closeAll('loading');
            },
            // 进度条回调，n（上传进度百分比）、elem（触发上传元素的dom对象）
            onProgress: function (n, elem, progress) {
                if (typeof progress === 'function') {
                    let result = progress.call(this, n, elem);
                    if (result === false) {
                        return;
                    }
                }
            }
        },
        // 获取实例, 执行回调
        callback: function (callback) {
            callback.call(this, upload)
        },
        // 渲染
        render: function (option) {
            if (typeof (option.elem) == 'undefined' || typeof (option.url) == 'undefined') {
                console.error('mon-upload hint: elem及url参数必须！');
                return null;
            }
            // 合并获取upload渲染配置
            let base = $.extend({}, mUpload.config, option, {
                choose: function (obj) {
                    mUpload.events.onChoose(obj, option.choose)
                },
                before: function (obj) {
                    mUpload.events.onBefore(obj, option.before)
                },
                done: function (res, index, upload) {
                    mUpload.events.onDone(res, index, upload, option.done, this)
                },
                error: function (index, upload) {
                    mUpload.events.onError(index, upload, option.error)
                },
                progress: function (n, elem) {
                    mUpload.events.onProgress(n, elem, option.progress)
                }
            });

            // 判断是否开启图片压缩
            if (base.picCompress) {
                // 开启压缩，关闭自动提交，增加隐藏的提交按钮
                base.auto = false
                $(base.elem).after('<button hidden event="compressUpload">提交</button');
                base.bindAction = $(base.elem).next('button[event="compressUpload"][hidden]')
                // 压缩配置信息
                mUpload.compressConfig = {
                    picCompress: base.picCompress,
                    // 压缩比例，默认0.7，越小越模糊
                    compressQuality: base.compressQuality,
                    // 触发上传按钮
                    bindAction: base.bindAction,
                    // 触发压缩的图片大小
                    compressSize: base.compressSize || 0
                }
            }

            // 渲染
            upload.render(base)
        },
        // 图片压缩相关方法
        compress: {
            // 图片上传回调
            onChoose: function (obj) {
                // this.files方便上传成功后删除队列，否则下次上传会重复上传
                let files = this.files = obj.pushFile();
                let oindex,
                    indexArr = [];
                for (oindex in files) {
                    let item = files[oindex]
                    if (item.type.indexOf('image') == 0 && item.size > mUpload.compressConfig.compressSize) {
                        indexArr.push(oindex);
                    }
                };
                // 不存在需要压缩的图片，直接提交
                if (indexArr.length < 1) {
                    mUpload.compressConfig.bindAction.trigger('click')
                    return;
                }

                let ltips = layer.msg('图片压缩中...', {
                    icon: 16,
                    shade: 0.1,
                    time: false
                });

                eindex = 0;
                star = 0;
                let len = indexArr.length;
                obj.preview(function (index, file, result) {
                    try {
                        if (indexArr.indexOf(index) > -1) {
                            mUpload.compress.photoCompress(file, {
                                quality: mUpload.compressConfig.compressQuality,
                            }, function (base64Codes) {
                                delete files[index];
                                obj.resetFile(index, mUpload.compress.convertBase64UrlToBlob(base64Codes), file.name);
                                eindex++;
                                if (eindex == len) {
                                    // 所有需要压缩的图片转换成功后触发”自动上传“
                                    layer.close(ltips)
                                    mUpload.compressConfig.bindAction.trigger('click')
                                }
                            });
                        }
                    } catch (e) {
                        console.error(e)
                        layer.close(ltips)
                        mUpload.compressConfig.bindAction.trigger('click')
                    }
                })
            },
            // 图片压缩
            photoCompress: function (file, w, objDiv) {
                let ready = new FileReader();
                // 开始读取指定的Blob对象或File对象中的内容. 
                // 当读取操作完成时,readyState属性的值会成为DONE,如果设置了onloadend事件处理程序,则调用之.
                // 同时,result属性中将包含一个data: URL格式的字符串以表示所读取文件的内容.
                ready.readAsDataURL(file);
                ready.onload = function () {
                    let re = this.result;
                    mUpload.compress.canvasDataURL(re, w, objDiv);
                }
            },
            // 压缩方法
            canvasDataURL: function (path, obj, callback) {
                let img = new Image();
                img.src = path;
                img.onload = function () {
                    let that = this;
                    // 默认按比例压缩
                    let w = that.width,
                        h = that.height,
                        scale = w / h;
                    // w = obj.width || w;
                    // h = obj.height || (w / scale);
                    let quality = 0.7; // 默认图片质量为0.7
                    // 图像质量
                    if (obj.quality && obj.quality <= 1 && obj.quality > 0) {
                        quality = obj.quality;
                    }

                    // 缩小图片比例
                    w = w * quality
                    h = h * quality

                    //生成canvas
                    let canvas = document.createElement('canvas');
                    let ctx = canvas.getContext('2d');
                    // 创建属性节点
                    let anw = document.createAttribute("width");
                    anw.nodeValue = w;
                    let anh = document.createAttribute("height");
                    anh.nodeValue = h;
                    canvas.setAttributeNode(anw);
                    canvas.setAttributeNode(anh);
                    ctx.drawImage(that, 0, 0, w, h);

                    // quality值越小，所绘制出的图像越模糊
                    let base64 = canvas.toDataURL('image/jpeg', quality);
                    // 回调函数返回base64的值
                    callback(base64);
                }
            },
            // base64转blob对象
            convertBase64UrlToBlob: function (urlData) {
                let arr = urlData.split(','),
                    mime = arr[0].match(/:(.*?);/)[1],
                    bstr = atob(arr[1]),
                    n = bstr.length,
                    u8arr = new Uint8Array(n);
                while (n--) {
                    u8arr[n] = bstr.charCodeAt(n);
                }
                return new Blob([u8arr], {
                    type: mime
                });
            }
        }
    }

    exports(MODULE_NAME, mUpload)
})