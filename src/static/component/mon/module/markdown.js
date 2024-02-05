layui.define(['jquery', 'layer', 'http'], function (exports) {
    "use strict";

    const $ = layui.jquery
    const layer = layui.layer
    const http = layui.http

    // 模块名
    const MODULE_NAME = 'markdown';
    // 加载模块资源
    const modFile = layui.cache.modules[MODULE_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/')) + '/cherry-markdown'
    layui.link(modPath + '/cherry-markdown.min.css');

    class Markdown {
        // 构造方法
        constructor() {
            this.obj = null;
            this.config = {
                toolbars: {
                    theme: 'light',
                    showToolbar: true,
                    toolbar: [
                        'undo', 'redo', 'bold', 'italic', 'underline', 'strikethrough', '|', 'sub', 'sup', '|', 'size', 'color',
                        { header: ['h4', 'h5'] }, '|', 'panel', 'justify', 'detail', '|', 'list',
                        { insert: ['image', 'audio', 'video', 'pdf', 'word', 'link', 'hr', 'br', 'code', 'toc', 'table'] },
                        'export', 'settings'
                    ],
                    toolbarRight: ["fullScreen"],
                    sidebar: ['mobilePreview', 'theme'],
                },
                editor: {
                    name: 'content',
                    autoSave2Textarea: true,
                    height: '100%'
                },
            }

        }

        // 设置markdown内容
        setMarkdown(content) {
            if (this.obj == null) {
                return null
            }

            return this.obj.setMarkdown(content)
        }

        // 渲染
        render(id, uploadApi, content = '', options = {}) {
            let config = Object.assign({}, this.config, options, { id: id, value: content })
            if (uploadApi) {
                // 存在文件上传路径
                config.fileUpload = (file, callback) => {
                    // 生成请求数据
                    const data = new FormData()
                    data.append('file', file)
                    http.ajax({
                        url: uploadApi,
                        method: 'POST',
                        data: data,
                        headers: { 'Content-type': 'multipart/form-data' },
                    }).then(res => {
                        if (res.code != '1') {
                            layer.msg(res.msg, { icon: 2 })
                            return false
                        }
                        callback(res.data[0].url, {
                            isShadow: true,
                            width: '100%',
                            height: 'auto',
                        })
                    })
                }

            }
            $.getScript(modPath + '/cherry-markdown.min.js', (rep, status) => {
                this.obj = new Cherry(config)
            })
        }

        // 预览模式渲染
        renderPreview(id, content) {
            let config = {
                id: id,
                value: content,
                toolbars: { toolbar: false },
                editor: { defaultModel: 'previewOnly' },
                callback: {
                    onClickPreview: function (e) {
                        const { target } = e;
                        if (target.tagName === 'IMG') {
                            let url = target.src
                            let alt = target.alt
                            top.layer.photos({
                                photos: {
                                    title: "图片预览",
                                    data: [{ alt: alt, src: url }]
                                },
                                // 是否显示底部栏
                                footer: true,
                                shade: 0.75
                            });
                        }
                    }
                }
            }
            $.getScript(modPath + '/cherry-markdown.core.js', (rep, status) => {
                this.obj = new Cherry(config)
            })
        }

        // 获取markdown对象
        getObj() {
            return this.obj
        }

        // 获取HTML
        getHTML() {
            if (this.obj == null) {
                return null
            }

            return this.obj.getHTML()
        }

        // 获取MarkDown
        getMarkdown() {
            if (this.obj == null) {
                return null
            }

            return this.obj.getMarkdown()
        }

        // 导出图片
        exportImg() {
            if (this.obj == null) {
                return null
            }

            return this.obj.export('img')
        }

        // 导出PDF
        exportPDF() {
            if (this.obj == null) {
                return null
            }

            return this.obj.export()
        }
    }

    exports(MODULE_NAME, new Markdown)
})