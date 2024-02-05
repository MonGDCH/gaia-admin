layui.define(['jquery', 'util', 'form', 'mUpload'], function (exports) {
    'use strict';

    // 模块名
    const MODULE_NAME = 'comment'
    // 加载依赖模块
    const $ = layui.$
    const util = layui.util
    const form = layui.form
    const upload = layui.mUpload
    // 加载模块资源
    const modFile = layui.cache.modules[MODULE_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    layui.link(modPath + '/' + MODULE_NAME + '.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))

    // 表情列表
    const faceList = {
        "[微笑]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/e3/2018new_weixioa02_org.png",
        "[可爱]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/09/2018new_keai_org.png",
        "[太开心]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/1e/2018new_taikaixin_org.png",
        "[鼓掌]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/6e/2018new_guzhang_org.png",
        "[嘻嘻]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/33/2018new_xixi_org.png",
        "[哈哈]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/8f/2018new_haha_org.png",
        "[笑cry]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/4a/2018new_xiaoku_thumb.png",
        "[挤眼]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/43/2018new_jiyan_org.png",
        "[馋嘴]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/fa/2018new_chanzui_org.png",
        "[黑线]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a3/2018new_heixian_org.png",
        "[汗]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/28/2018new_han_org.png",
        "[挖鼻]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/9a/2018new_wabi_thumb.png",
        "[哼]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/7c/2018new_heng_org.png",
        "[怒]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/f6/2018new_nu_org.png",
        "[委屈]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a5/2018new_weiqu_org.png",
        "[可怜]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/96/2018new_kelian_org.png",
        "[失望]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/aa/2018new_shiwang_org.png",
        "[悲伤]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/ee/2018new_beishang_org.png",
        "[泪]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/6e/2018new_leimu_org.png",
        "[允悲]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/83/2018new_kuxiao_org.png",
        "[苦涩]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/7e/2021_bitter_org.png",
        "[害羞]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/c1/2018new_haixiu_org.png",
        "[污]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/10/2018new_wu_org.png",
        "[爱你]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/f6/2018new_aini_org.png",
        "[亲亲]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/2c/2018new_qinqin_org.png",
        "[抱一抱]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/af/2020_hug_org.png",
        "[色]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/9d/2018new_huaxin_org.png",
        "[憧憬]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/c9/2018new_chongjing_org.png",
        "[舔屏]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/3e/2018new_tianping_org.png",
        "[哇]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/3d/2022_wow_org.png",
        "[坏笑]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/4d/2018new_huaixiao_org.png",
        "[阴险]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/9e/2018new_yinxian_org.png",
        "[笑而不语]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/2d/2018new_xiaoerbuyu_org.png",
        "[偷笑]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/71/2018new_touxiao_org.png",
        "[666]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/6c/2022_666_org.png",
        "[酷]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/c4/2018new_ku_org.png",
        "[并不简单]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/aa/2018new_bingbujiandan_org.png",
        "[思考]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/30/2018new_sikao_org.png",
        "[疑问]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/b8/2018new_ningwen_org.png",
        "[费解]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/2a/2018new_wenhao_org.png",
        "[晕]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/07/2018new_yun_org.png",
        "[衰]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a2/2018new_shuai_org.png",
        "[骷髅]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a1/2018new_kulou_org.png",
        "[嘘]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/b0/2018new_xu_org.png",
        "[闭嘴]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/62/2018new_bizui_org.png",
        "[傻眼]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/dd/2018new_shayan_org.png",
        "[裂开]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/1b/202011_liekai_org.png",
        "[感冒]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/8c/2022_cold_org.png",
        "[吃惊]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/49/2018new_chijing_org.png",
        "[吐]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/08/2018new_tu_org.png",
        "[生病]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/3b/2018new_shengbing_org.png",
        "[拜拜]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/fd/2018new_baibai_org.png",
        "[鄙视]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/da/2018new_bishi_org.png",
        "[白眼]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/ef/2018new_landelini_org.png",
        "[左哼哼]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/43/2018new_zuohengheng_org.png",
        "[右哼哼]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/c1/2018new_youhengheng_org.png",
        "[抓狂]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/17/2018new_zhuakuang_org.png",
        "[怒骂]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/87/2018new_zhouma_org.png",
        "[打脸]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/cb/2018new_dalian_org.png",
        "[顶]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/ae/2018new_ding_org.png",
        "[钱]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a2/2018new_qian_org.png",
        "[哈欠]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/55/2018new_dahaqian_org.png",
        "[困]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/3c/2018new_kun_org.png",
        "[睡]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/e2/2018new_shuijiao_thumb.png",
        "[求饶]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/aa/moren_qiurao02_org.png",
        "[吃瓜]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/01/2018new_chigua_org.png",
        "[doge]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a1/2018new_doge02_org.png",
        "[比耶]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/dc/2023_yeahyeah_org.png",
        "[努力]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/7c/2022_Keepgoing_org.png",
        "[送花花]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/cb/2022_Flowers_org.png",
        "[心]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/8a/2018new_xin_org.png",
        "[伤心]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/6c/2018new_xinsui_org.png",
        "[握手]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/e9/2018new_woshou_org.png",
        "[赞]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/e6/2018new_zan_org.png",
        "[good]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/8a/2018new_good_org.png",
        "[弱]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/3d/2018new_ruo_org.png",
        "[NO]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/1e/2018new_no_org.png",
        "[耶]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/29/2018new_ye_org.png",
        "[拳头]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/86/2018new_quantou_org.png",
        "[ok]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/45/2018new_ok_org.png",
        "[加油]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/9f/2018new_jiayou_org.png",
        "[来]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/42/2018new_guolai_org.png",
        "[作揖]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/e7/2018new_zuoyi_org.png",
        "[haha]": "https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/1d/2018new_hahashoushi_org.png"
    }

    const App = {
        // 配置信息
        config: {
            // 绑定元素
            elem: '.mon-comment',
            // 文件上传路径
            upload: {
                url: '',
                handler: (response) => {
                    return response.data.url
                }
            },
            // 支持的操作
            actions: ['face', 'pic', 'href', 'preview'],
            // 插入评论内容回调
            insert: function (value, el) { }
        },

        // 模板
        tmp: {
            face: `<span type="face" title="插入表情"><i class="layui-icon layui-icon-face-smile"></i></span>`,
            pic: `<span type="pic" title="插入图片"><i class="layui-icon layui-icon-picture"></i></span>`,
            href: `<span type="href" title="插入超链接"><i class="layui-icon layui-icon-link"></i></span>`,
            code: `<span type="code" title="插入代码或引用"><i class="layui-icon layui-icon-fonts-code" style="top: 1px;"></i></span>`,
            hr: `<span type="hr" title="插入水平线">hr</span>`,
            preview: `<span type="preview" title="预览"><i class="layui-icon layui-icon-eye"></i></span>`,
        },

        // 方法
        method: {
            // 插入表情
            face: function (config, editor, self) {
                let str = ''
                for (let name in faceList) {
                    str += `<li data-title="${name}"><img src="${faceList[name]}" /></li>`;
                }

                str = '<ul id="mon-comment-faces" class="layui-clear">' + str + '</ul>';
                layer.tips(str, self, { tips: 3, time: 0, skin: 'layui-edit-face' });
                $(document).on('click', function (e) {
                    layer.closeAll('tips');
                });
                $('#mon-comment-faces li').on('click', function () {
                    let title = this.dataset.title
                    App.focusInsert(editor[0], ` face:${title} `);
                });
            },
            // 插入图片
            pic: function (config, editor) {
                let uploadURL = config.upload.url
                let handler = config.upload.handler

                layer.open({
                    type: 1,
                    id: 'mon-comment-upload',
                    title: '插入图片',
                    shade: false,
                    fixed: false,
                    resize: false,
                    area: '465px',
                    offset: [editor.offset().top - $(window).scrollTop() + 'px', editor.offset().left + 'px'],
                    content: `
                        <div class="layui-form layui-form-pane mon-comment-upload">
                            <div class="layui-form-item">
                                <div class="layui-input-group">
                                    <input type="text" name="image" lay-verify="required" lay-verType="tips" lay-reqtext="请填写合法的图片地址" style="width:320px" placeholder="支持直接粘贴远程图片地址" class="layui-input">
                                    <div class="layui-input-suffix">
                                        <button class="layui-btn layui-btn-primary" id="comment-upload-img">上传图片</button>
                                    </div>
                                </div>
                            </div>
                            <div class="layui-form-item" style="text-align: center;">
                                <button type="button" lay-submit lay-filter="upload-comment-images" class="layui-btn">插入图片</button>
                            </div>
                        </div>
                    `,
                    success: function (layero, index) {
                        let image = layero.find('input[name="image"]');
                        // 执行上传实例
                        if (uploadURL) {
                            upload.render({
                                elem: '#comment-upload-img',
                                url: uploadURL,
                                done: function (res) {
                                    // 处理响应的结果，解析获取图片URL
                                    let ret = handler(res)
                                    if (ret !== false) {
                                        image.val(ret);
                                    }
                                }
                            });
                        } else {
                            $('#comment-upload-img').on('click', function () {
                                layer.msg('暂不支持图片上传', { icon: 5 });
                            })
                        }

                        form.on('submit(upload-comment-images)', function (data) {
                            let field = data.field;
                            if (!field.image) return image.focus();
                            App.focusInsert(editor[0], ` img:[${field.image}] `)

                            layer.close(index);
                        });
                    }
                });
            },
            // 超链接
            href: function (config, editor) {
                layer.open({
                    type: 1,
                    area: '300px',
                    resize: false,
                    shade: false,
                    fixed: false,
                    id: 'mon-comment-href',
                    offset: [editor.offset().top - $(window).scrollTop() + 'px', editor.offset().left + 'px'],
                    title: '插入超链接',
                    content: `
                        <div class="layui-form mon-comment-href">
                            <div class="layui-form-item">
                                <input type="text" name="href" value="" lay-verify="required|url" placeholder="链接地址" lay-verType="tips"
                                    lay-reqtext="请填写合法的链接地址" autocomplete="off" class="layui-input" lay-affix="clear">
                            </div>
                            <div class="layui-form-item">
                                <input type="text" name="name" value="" placeholder="链接名" class="layui-input">
                            </div>
                            <div class="layui-form-item">
                                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="comment-href">插入超链接</button>
                            </div>
                        </div>
                    `,
                    success: function (layero, index, that) {
                        // 对弹层中的表单进行初始化渲染
                        form.render();
                        // 表单提交事件
                        form.on('submit(comment-href)', function (data) {
                            // 获取表单字段值
                            let field = data.field;
                            let url = field.href
                            let name = field.name || url
                            // 插入内容
                            App.focusInsert(editor[0], ` href:(${url})[${name}] `);
                            layer.close(index)
                            return false;
                        });
                    }
                });
            },
            // 插入代码
            code: function (config, editor) {
                layer.prompt({
                    title: '请贴入代码或任意文本',
                    formType: 2,
                    maxlength: 10000,
                    shade: false,
                    id: 'mon-comment-code',
                    area: ['800px', '360px']
                }, function (val, index, elem) {
                    App.focusInsert(editor[0], `\n[pre]\n ${val} \n[/pre]\n`);
                    layer.close(index);
                });
            },
            // 插入水平分割线
            hr: function (config, editor) {
                App.focusInsert(editor[0], '\n [hr] \n');
            },
            // 预览
            preview: function (config, editor) {
                let content = editor.val();
                content = /^\{html\}/.test(content) ? content.replace(/^\{html\}/, '') : App.parseContent(content);
                layer.open({
                    id: 'mon-comment-container',
                    type: 1,
                    title: '预览',
                    shade: false,
                    shadeClose: false,
                    area: ['600px', '600px'],
                    scrollbar: false,
                    content: '<div class="mon-comment-container comment-content-main">' + content + '</div>'
                });
            }
        },

        // 渲染
        render: function (options) {
            // 定义配置
            this.config = $.extend({}, this.config, options || {});

            // 回调方法
            let method = this.method

            // 模板
            let temp = [];
            this.config.actions.forEach((type) => {
                if (this.tmp[type]) {
                    temp.push(this.tmp[type])
                }
            })
            let html = `<div class="layui-unselect mon-comment-editor">` + temp.join('') + `</div>`

            // 配置信息
            let config = this.config

            // 生成编辑器
            $(this.config.elem).each(function (index) {
                let that = this, othis = $(that), parent = othis.parent();
                parent.prepend(html);
                parent.find('.mon-comment-editor span').on('click', function (event) {
                    let type = $(this).attr('type');
                    method[type].call(that, config, othis, this);
                    if (type === 'face') {
                        event.stopPropagation()
                    }
                });
            });
        },

        // 解析评论内容
        parseContent: function (content) {
            // 支持的html标签
            let html = function (end) {
                // return new RegExp('\\n*\\[' + (end || '') + '(pre|hr|div|span|p|table|thead|th|tbody|tr|td|ul|li|ol|li|dl|dt|dd|h2|h3|h4|h5)([\\s\\S]*?)\\]\\n*', 'g');
                return new RegExp('\\n*\\[' + (end || '') + '(pre|hr)([\\s\\S]*?)\\]\\n*', 'g');
            };
            content = util.escape(content || '')
                // 转义图片
                .replace(/img:\[([^\s]+?)\]/g, function (img) {
                    let src = img.replace(/(^img:\[)|(\]$)/g, '')
                    return `<img alt="images" src="${src}">`;
                })
                // 转义@
                .replace(/@(\S+)(\s+?|$)/g, '@<a href="javascript:;" class="icon-aite">$1</a>$2')
                // 转义表情
                .replace(/face:\[([^\s\[\]]+?)\]/g, function (face) {
                    let alt = face.replace(/^face:/g, '');
                    return `<img alt="${alt}" title="${alt}" src="${faceList[alt]}" width="24" height="24">`;
                })
                // 转义链接
                .replace(/href:\([\s\S]+?\)\[[\s\S]*?\]/g, function (str) {
                    let href = (str.match(/href:\(([\s\S]+?)\)\[/) || [])[1];
                    let text = (str.match(/\)\[([\s\S]*?)\]/) || [])[1];
                    if (!href) {
                        return str;
                    }

                    return `<a href="${href}" target="_blank" rel="nofollow">${(text || href)}</a>`
                })
                // 转移HTML代码
                .replace(html(), '\<$1 $2\>').replace(html('/'), '\</$1\>')
                // 转义换行
                .replace(/\n/g, '<br>')
            return content;
        },

        // 插入textarea
        focusInsert: function (obj, str) {
            let result, val = obj.value;
            result = [val.substring(0, obj.selectionStart), str, val.substr(obj.selectionEnd)];
            var value = result.join('');
            obj.value = value
            App.config.insert(value, obj)
            obj.focus();
        }
    }

    // // 插入textarea
    // function App.focusInsert(obj, str) {
    //     let result, val = obj.value;
    //     obj.focus();
    //     if (document.selection) {
    //         // ie
    //         result = document.selection.createRange();
    //         document.selection.empty();
    //         result.text = str;
    //     } else {
    //         result = [val.substring(0, obj.selectionStart), str, val.substr(obj.selectionEnd)];
    //         obj.focus();
    //         obj.value = result.join('');
    //     }
    // };

    // XSS过滤
    // function escape(html) {
    //     return String(html || '').replace(/&(?!#?[a-zA-Z0-9]+;)/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/"/g, '&quot;');
    // }


    exports(MODULE_NAME, App)
})