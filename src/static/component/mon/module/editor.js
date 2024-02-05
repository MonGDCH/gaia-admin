layui.define(['tinymce', 'http'], function (exports) {
    "use strict";

    // 插件名
    const MODULE_NAME = 'editor'
    const tinymce = layui.tinymce
    const http = layui.http

    const editor = {
        // 图片上传URL，因为要在config的上传回调方法中使用URL，而URL需要重载，所以上传的URL外置出来做属性，特异化处理
        images_upload_url: '',
        // 默认配置信息
        config: {
            // 禁止转换URL
            convert_urls: false,
            // 禁止转换相对URL
            relative_urls: false,
            // 禁止删除URL域名
            remove_script_host: false,
            // 是否自动保存到textarea中
            saveTextarea: false,
            // 资源路径
            base_url: '',
            // 扩展文件加载后缀名
            suffix: '.min',
            // 使用语言
            language: 'zh_CN',
            // 格式字体从pt改为px
            fontsize_formats: '8px 10px 12px 14px 16px 18px 24px 36px',
            // 自动获取焦点
            auto_focus: false,
            // 显示右下角官方信息
            branding: false,
            // 最小高度
            min_height: 540,
            // 允许修改大小
            resize: true,
            // 皮肤，样式存放于skins/ui目录
            skin: 'oxide',
            // 加载插件列表
            plugins: [
                'lists', 'advlist', 'code', 'table', 'link', 'image', 'print', 'preview', 'searchreplace', 'fullscreen', 'media',
                'imagetools', 'anchor', 'autolink', 'autosave', 'hr', 'pagebreak', 'wordcount', 'indent2em', 'kityformula-editor',
                'codesample', 'quickbars'
            ],
            // 工具栏列表
            toolbar: 'undo redo | styleselect | bold italic forecolor backcolor | bullist numlist | alignleft aligncenter alignright alignjustify | outdent indent | hr kityformula-editor',
            // 开启图片高级选项
            image_advtab: true,
            // 自定义图片上传
            images_upload_handler: function (blobInfo, success, fail) {
                let formData = new FormData();
                formData.append('file', blobInfo.blob());
                if (typeof form_data == 'object') {
                    for (let key in form_data) {
                        formData.append(key, form_data[key]);
                    }
                }
                http.ajax({
                    url: editor.images_upload_url,
                    method: 'POST',
                    data: formData,
                    headers: { 'Content-type': 'multipart/form-data' },
                    loading: false,
                }).then(res => {
                    if (res.code != '1') {
                        return fail(res.msg)
                    }
                    success(res.data[0].url)
                }).catch(err => {
                    console.error(err)
                    fail("网络错误");
                })
            },
            // 初始化前
            setup: function (ed) {
                // 自动保存内容到textarea
                if (editor.config.saveTextarea) {
                    ed.on('change', function () {
                        Tinymce.triggerSave()
                    })
                }
            },
            // 创建实例后
            init_instance_callback: function (ed) {
                // console.log(ed)
            }
        },
        // 渲染
        render: function (id, config) {
            if (!document.querySelector('#' + id)) {
                layer.msg(`编辑器容器ID不存在[${id}]`, { title: '错误', icon: 2 })
                return false
            }

            let option = Object.assign({}, this.config, config)
            // 特异化设置图片上传URL
            if (option.images_upload_url) {
                this.images_upload_url = option.images_upload_url
            }
            option.selector = '#' + id
            return tinymce.init(option)
        },
        // 获取tinymce
        getEditor: function () {
            return tinymce
        },
        // 获取内容
        getContent(id) {
            return tinymce.editors[id].getContent();
        },
        // 设置内容
        setContent(id, content) {
            tinymce.editors[id].setContent(content);
        },
        // 删除tinymce
        remove: function (id) {
            tinymce.editors[id] && tinymce.editors[id].remove()
        }
    }

    exports(MODULE_NAME, editor)
})